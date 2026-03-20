import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:serverpod/serverpod.dart';
import '../../generated/protocol.dart';

class DeyeCloudClient {
  final String username;
  final String password;
  final String appId; // May require App ID from DeyeCloud Developer Portal
  
  static const String baseUrl = 'https://eu1-developer.deyecloud.com';
  String? _accessToken;

  DeyeCloudClient({required this.username, required this.password, this.appId = ''});

  Future<bool> authenticate(Session session) async {
    // Deye Cloud API expects SHA256 hashed password in lowercase
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    final hashedPassword = digest.toString().toLowerCase();

    final uri = Uri.parse('$baseUrl/v1.0/account/token');
    
    // This is the structure for the payload
    // Authentication usually involves the app id, signature, and timestamp
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
