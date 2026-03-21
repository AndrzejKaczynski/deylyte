import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/license_repository.dart';

class ServerpodLicenseRepository implements LicenseRepository {
  ServerpodLicenseRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> validate(String licenseKey) =>
      _client.license.validate(licenseKey);
}
