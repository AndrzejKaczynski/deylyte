import 'dart:convert';

import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/license_repository.dart';

class ServerpodLicenseRepository implements LicenseRepository {
  ServerpodLicenseRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> validate(String licenseKey) async {
    final json = await _client.license.validate(licenseKey);
    return jsonDecode(json) as Map<String, dynamic>;
  }
}
