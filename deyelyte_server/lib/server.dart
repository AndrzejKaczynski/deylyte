import 'package:mailer/mailer.dart' as mailer;
import 'package:mailer/smtp_server.dart';
import 'package:serverpod/serverpod.dart';
import 'package:serverpod_auth_server/module.dart' as auth;

import 'src/generated/protocol.dart';
import 'src/generated/endpoints.dart';

void run(List<String> args) async {
  final pod = Serverpod(
    args,
    Protocol(),
    Endpoints(),
  );

  await pod.start();

  // Read SMTP credentials from passwords.yaml
  final smtpHost = pod.getPassword('smtpHost') ?? '';
  final smtpPort = int.tryParse(pod.getPassword('smtpPort') ?? '587') ?? 587;
  final smtpUsername = pod.getPassword('smtpUsername') ?? '';
  final smtpPassword = pod.getPassword('smtpPassword') ?? '';
  // The 'from' address in SES must be verified in the AWS console. 
  // For local testing, using the username if it looks like an email.
  final senderEmail = smtpUsername.contains('@') ? smtpUsername : 'noreply@deyelyte.com';

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
}

