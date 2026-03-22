import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as auth;

import 'src/config/app_values.dart';
import 'src/generated/endpoints.dart';
import 'src/generated/protocol.dart';

void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
    authenticationHandler: auth.authenticationHandler,
  );

  await AppValues.load(runMode: pod.runMode);

  // Read SMTP credentials from passwords.yaml — available after the
  // Serverpod() constructor, before pod.start().
  final smtpHost = pod.getPassword('smtpHost') ?? '';
  final smtpPort = int.tryParse(pod.getPassword('smtpPort') ?? '587') ?? 587;
  final smtpUsername = pod.getPassword('smtpUsername') ?? '';
  final smtpPassword = pod.getPassword('smtpPassword') ?? '';
  // The 'from' address in SES must be verified in the AWS console.
  // For local testing, using the username if it looks like an email.
  final senderEmail = smtpUsername.contains('@') ? smtpUsername : 'noreply@deyelyte.com';

  // AuthConfig MUST be set before pod.start() so that auth endpoints
  // (e.g. serverpod_auth.status) never see an un-configured AuthConfig.
  auth.AuthConfig.set(auth.AuthConfig(
    sendValidationEmail: (session, email, validationCode) async {
      if (smtpHost.isEmpty || smtpUsername.isEmpty) {
        print('>>> VALIDATION CODE for $email: $validationCode <<<');
        return true; // fallback: log code only (dev without credentials)
      }
      try {
        final smtpServer = SmtpServer(smtpHost, port: smtpPort, username: smtpUsername, password: smtpPassword);
        final message = mailer.Message()
          ..from = mailer.Address(senderEmail, 'DeyLyte')
          ..recipients.add(email)
          ..subject = 'Your DeyLyte verification code'
          ..html = '''
<div style="font-family:sans-serif;max-width:480px;margin:auto">
  <h2 style="color:#4f8ef7">DeyLyte ⚡</h2>
  <p>Welcome! Use the code below to activate your account:</p>
  <div style="font-size:32px;font-weight:700;letter-spacing:8px;color:#1a1a2e;
              background:#f0f4ff;padding:16px 24px;border-radius:8px;
              text-align:center;margin:24px 0">$validationCode</div>
  <p style="color:#666">This code expires in 24 hours. If you didn't request this, ignore this email.</p>
</div>''';
        await mailer.send(message, smtpServer);
        session.log('Verification email sent to $email');
        return true;
      } catch (e) {
        session.log('Failed to send verification email: $e', level: LogLevel.error);
        return false;
      }
    },
    sendPasswordResetEmail: (session, userInfo, validationCode) async {
      if (smtpHost.isEmpty || smtpUsername.isEmpty) {
        session.log(
          'No SMTP credentials. Reset code for ${userInfo.email}: $validationCode',
          level: LogLevel.info,
        );
        return true;
      }
      try {
        final smtpServer = SmtpServer(smtpHost, port: smtpPort, username: smtpUsername, password: smtpPassword);
        final message = mailer.Message()
          ..from = mailer.Address(senderEmail, 'DeyLyte')
          ..recipients.add(userInfo.email!)
          ..subject = 'Reset your DeyLyte password'
          ..html = '''
<div style="font-family:sans-serif;max-width:480px;margin:auto">
  <h2 style="color:#4f8ef7">DeyLyte ⚡</h2>
  <p>Use this code to reset your password:</p>
  <div style="font-size:32px;font-weight:700;letter-spacing:8px;color:#1a1a2e;
              background:#f0f4ff;padding:16px 24px;border-radius:8px;
              text-align:center;margin:24px 0">$validationCode</div>
  <p style="color:#666">Expires in 24 hours. Didn't request this? Ignore it.</p>
</div>''';
        await mailer.send(message, smtpServer);
        return true;
      } catch (e) {
        session.log('Failed to send reset email: $e', level: LogLevel.error);
        return false;
      }
    },
  ));


  await pod.start();

  // Seed static reference data (idempotent — skipped if already present).
  await _seedInverterModels(pod);

  // Bootstrap recurring calls after start so the DB session is available.
  // Ensures polls resume if the server restarts while users are configured.
  await _bootstrapRecurringCalls(pod);
}

/// Inverter model catalogue — add new models here as they are verified.
/// registerMapJson uses Modbus holding-register (FC3) addresses.
/// chargeCmd/sellCmd marked ⚠ are from the same protocol family but not yet
/// confirmed on that specific hardware — update once verified.
const _inverterModels = [
  // ── Three-phase LP/HP family (SG0xLP3 / SG0xHP3) ─────────────────────────
  // Register base: batterySoc=588, pv1=672. chargeCmd/sellCmd verified on SG04LP3.
  (
    modelId: 'deye_sg04lp3',
    displayName: 'Deye SG04LP3',
    registerMapJson: '{'
        '"batterySoc":588,'
        '"batteryPower":590,'
        '"gridPower":625,'
        '"loadPower":653,'
        '"pv1Power":672,'
        '"pv2Power":673,'
        '"pv3Power":674,'
        '"chargeCmd":240,'
        '"sellCmd":243'
        '}',
    // Deye Cloud measurePoint keys confirmed on real SG04LP3 hardware.
    measurePointsFingerprintJson: '['
        '"p_pv1","p_pv2","p_pv3",'
        '"b_soc","b_volt","b_current","b_power",'
        '"p_grid","p_grid_apparent","p_load",'
        '"e_pv_day","e_load_day","e_grid_buy_day","e_grid_sell_day"'
        ']' as String?,
  ),
  (
    modelId: 'deye_sg01hp3',
    displayName: 'Deye SG01HP3',
    // Same register map as SG04LP3 (both 3-phase LP/HP family).
    // chargeCmd/sellCmd ⚠ unverified — same family as SG04LP3.
    registerMapJson: '{'
        '"batterySoc":588,'
        '"batteryPower":590,'
        '"gridPower":625,'
        '"loadPower":653,'
        '"pv1Power":672,'
        '"pv2Power":673,'
        '"pv3Power":674,'
        '"chargeCmd":240,'
        '"sellCmd":243'
        '}',
    measurePointsFingerprintJson: null,
  ),
  // ── Single-phase LP family (SG0xLP1 / legacy Hybrid) ─────────────────────
  // Register base: batterySoc=184, pv1=186. Different address space to 3-phase.
  (
    modelId: 'deye_hybrid',
    displayName: 'Deye Hybrid',
    // Older single-phase hybrid (2-string, no pv3). chargeCmd/sellCmd unknown.
    registerMapJson: '{'
        '"batterySoc":184,'
        '"batteryPower":190,'
        '"gridPower":169,'
        '"loadPower":178,'
        '"pv1Power":186,'
        '"pv2Power":187,'
        '"pv3Power":0'
        '}',
    measurePointsFingerprintJson: null,
  ),
  (
    modelId: 'deye_sg02lp1',
    displayName: 'Deye SG02LP1',
    // Single-phase LP, 3-string (pv3Power=188). chargeCmd/sellCmd ⚠ unverified.
    // Sources: kbialek/deye-inverter-mqtt, kellerza/sunsynk.
    registerMapJson: '{'
        '"batterySoc":184,'
        '"batteryPower":190,'
        '"gridPower":169,'
        '"loadPower":175,'
        '"pv1Power":186,'
        '"pv2Power":187,'
        '"pv3Power":188,'
        '"chargeCmd":240,'
        '"sellCmd":243'
        '}',
    measurePointsFingerprintJson: null,
  ),
];

/// Inserts any missing inverter model rows. Safe to call on every startup —
/// existing rows are left untouched; only absent ones are inserted.
Future<void> _seedInverterModels(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    for (final m in _inverterModels) {
      final exists = await InverterModel.db.findFirstRow(
        session,
        where: (t) => t.modelId.equals(m.modelId),
      );
      if (exists == null) {
        await InverterModel.db.insertRow(
          session,
          InverterModel(
            modelId: m.modelId,
            displayName: m.displayName,
            registerMapJson: m.registerMapJson,
            measurePointsFingerprintJson: m.measurePointsFingerprintJson,
          ),
        );
        print('Seeded inverter model: ${m.displayName}');
      } else if (exists.measurePointsFingerprintJson == null &&
          m.measurePointsFingerprintJson != null) {
        // Backfill fingerprint added to seed after initial row was created.
        await InverterModel.db.updateRow(
          session,
          exists.copyWith(
            measurePointsFingerprintJson: m.measurePointsFingerprintJson,
          ),
        );
        print('Updated inverter model fingerprint: ${m.displayName}');
      }
    }
  } catch (e) {
    print('Seed inverter models error: $e');
  } finally {
    await session.close();
  }
}

Future<void> _bootstrapRecurringCalls(Serverpod pod) async {
  final session = await pod.createSession();
  try {
    // Price polling runs for any user with an AppConfig, regardless of Deye.
    final anyConfig = await AppConfig.db.findFirstRow(session);
    if (anyConfig != null) {
      await pod.futureCalls.callWithDelay(Duration.zero).pollEnergyPricesCall.invoke(null);
    }

    // Inverter polling and optimizer only run once Deye is set up.
    final anyDeye = await IntegrationCredentials.db.findFirstRow(
      session,
      where: (t) => t.deyeDeviceSn.notEquals(null),
    );
    if (anyDeye != null) {
      await pod.futureCalls.callWithDelay(Duration.zero).pollInverterCall.invoke(null);
      await pod.futureCalls.callWithDelay(const Duration(minutes: 5)).runOptimizerCall.invoke(null);
    }
  } catch (e) {
    print('Bootstrap FutureCalls error: $e');
  } finally {
    await session.close();
  }
}

