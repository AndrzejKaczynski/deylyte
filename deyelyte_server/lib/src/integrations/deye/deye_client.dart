import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class DeyeCloudClient {
  final String username;
  final String _password;
  final String appId;
  final String appSecret;
  final String deviceSn;

  static const String _baseUrl = 'https://eu1-developer.deyecloud.com/v1.0';

  String? _accessToken;

  DeyeCloudClient({
    required this.username,
    required String password,
    required this.appId,
    required this.appSecret,
    required this.deviceSn,
  }) : _password = password;

  // ---------------------------------------------------------------------------
  // Auth
  // ---------------------------------------------------------------------------

  /// Authenticate using a plaintext password (hashed internally before sending).
  Future<void> authenticate(Session session) async {
    final passwordHash = sha256.convert(utf8.encode(_password)).toString();
    await _doAuthenticate(session, passwordHash);
  }

  /// Authenticate using a pre-computed SHA256 hex password hash (as stored in DB).
  /// Use this when the plaintext password is unavailable.
  Future<void> authenticateWithHash(Session session) async {
    await _doAuthenticate(session, _password);
  }

  Future<void> _doAuthenticate(Session session, String passwordHash) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/account/token?appId=$appId'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'appSecret': appSecret,
        'email': username,
        'password': passwordHash,
      }),
    );

    if (response.statusCode != 200) {
      session.log(
        'Deye auth failed: ${response.statusCode} ${response.body}',
        level: LogLevel.error,
      );
      throw Exception('Deye authentication failed (${response.statusCode})');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    _accessToken = body['access_token'] as String?;
    if (_accessToken == null) {
      throw Exception('Deye auth response missing access_token: ${response.body}');
    }
    session.log('Deye authenticated successfully');
  }

  // ---------------------------------------------------------------------------
  // Device discovery
  // ---------------------------------------------------------------------------

  /// Fetches the first device serial number associated with this account.
  /// Call this once on init and store the result in IntegrationCredentials.
  Future<String> fetchDeviceSn(Session session) async {
    await _ensureAuthenticated(session);
    final response = await http.post(
      Uri.parse('$_baseUrl/device/list'),
      headers: _authHeaders(),
      body: jsonEncode({'page': 1, 'size': 20}),
    );

    if (response.statusCode != 200) {
      throw Exception('Deye device/list failed (${response.statusCode}): ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['deviceList'] as List<dynamic>?;
    if (list == null || list.isEmpty) {
      throw Exception('No Deye devices found for this account');
    }
    final sn = (list.first as Map<String, dynamic>)['deviceSn'] as String?;
    if (sn == null) throw Exception('Device entry missing deviceSn field');
    session.log('Deye device SN fetched: $sn');
    return sn;
  }

  // ---------------------------------------------------------------------------
  // Data polling
  // ---------------------------------------------------------------------------

  /// Fetches the latest inverter readings and inserts an InverterData row.
  ///
  /// TODO: The field names below are common Deye hybrid inverter measure point
  /// names. Verify the exact names for this device via POST /device/measurePoints
  /// with {"deviceSn": "<sn>"} and adjust the mapping if needed.
  Future<void> fetchAndStoreInverterData(Session session, int userInfoId) async {
    await _ensureAuthenticated(session);
    final response = await http.post(
      Uri.parse('$_baseUrl/device/latest'),
      headers: _authHeaders(),
      body: jsonEncode({'deviceList': [deviceSn]}),
    );

    if (response.statusCode != 200) {
      throw Exception('Deye device/latest failed (${response.statusCode}): ${response.body}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    // Response is a list of device data objects; grab the first (our device).
    final deviceList = body['deviceList'] as List<dynamic>?;
    if (deviceList == null || deviceList.isEmpty) {
      session.log('Deye device/latest returned empty list', level: LogLevel.warning);
      return;
    }
    final data = deviceList.first as Map<String, dynamic>;

    // Measure point values are typically nested under a 'dataList' or returned
    // as top-level keys — handle both layouts.
    final points = _extractPoints(data);

    final pvPower = (_num(points, 'p_pv1') ?? 0) + (_num(points, 'p_pv2') ?? 0);
    // Fallback: some devices report total PV as 'p_pv' directly.
    final pvPowerFinal = pvPower > 0 ? pvPower : (_num(points, 'p_pv') ?? 0.0);

    final batteryLevel = _num(points, 'b_soc') ?? 0.0;
    // gridPower: positive = export to grid, negative = import from grid.
    final gridPower = _num(points, 'p_grid_apparent') ?? _num(points, 'p_grid') ?? 0.0;
    final loadPower = _num(points, 'p_load') ?? 0.0;

    await InverterData.db.insertRow(
      session,
      InverterData(
        userInfoId: userInfoId,
        timestamp: DateTime.now().toUtc(),
        pvPower: pvPowerFinal,
        batteryLevel: batteryLevel,
        gridPower: gridPower,
        loadPower: loadPower,
      ),
    );

    session.log(
      'InverterData stored — pv:${pvPowerFinal}W soc:$batteryLevel% '
      'grid:${gridPower}W load:${loadPower}W',
    );
  }

  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  Map<String, String> _authHeaders() => {
        'Authorization': 'Bearer $_accessToken',
        'Content-Type': 'application/json',
      };

  Future<void> _ensureAuthenticated(Session session) async {
    if (_accessToken == null) await authenticate(session);
  }

  /// Normalises the two possible response layouts from /device/latest:
  /// - flat map: {"p_pv1": 1234, ...}
  /// - dataList: [{"key": "p_pv1", "value": 1234}, ...]
  Map<String, dynamic> _extractPoints(Map<String, dynamic> data) {
    final dataList = data['dataList'];
    if (dataList is List) {
      return {
        for (final item in dataList.cast<Map<String, dynamic>>())
          if (item['key'] != null) item['key'] as String: item['value'],
      };
    }
    return data;
  }

  double? _num(Map<String, dynamic> points, String key) {
    final v = points[key];
    if (v == null) return null;
    if (v is num) return v.toDouble();
    if (v is String) return double.tryParse(v);
    return null;
  }
}
