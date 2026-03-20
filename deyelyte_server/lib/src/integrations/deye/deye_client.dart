import 'package:serverpod/serverpod.dart';

class DeyeCloudClient {
  final String username;
  final String password;
  final String appId; // May require App ID from DeyeCloud Developer Portal
  
  static const String baseUrl = 'https://eu1-developer.deyecloud.com';
  String? _accessToken;

  DeyeCloudClient({required this.username, required this.password, this.appId = ''});

  Future<bool> authenticate(Session session) async {
    // Deye Cloud API expects SHA256 hashed password in lowercase
    // TODO: implement — hash password and POST to $baseUrl/v1.0/account/token
    // final hashedPassword = sha256.convert(utf8.encode(password)).toString();
    session.log('Authenticating with DeyeCloud using username: $username');
    
    // _accessToken = ...
    return true; 
  }

  Future<void> fetchInverterData(Session session) async {
    if (_accessToken == null) {
      await authenticate(session);
    }
    
    // GET /v1.0/device/status
    // Map response to InverterData model
    
    session.log('Successfully fetched inverter data and stored into DB.');
  }
}
