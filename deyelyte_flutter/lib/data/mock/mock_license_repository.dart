import '../repositories/license_repository.dart';

class MockLicenseRepository implements LicenseRepository {
  @override
  Future<Map<String, dynamic>> validate(String licenseKey) async {
    // In mock mode, any non-empty key is treated as valid.
    if (licenseKey.trim().isEmpty) {
      return {'valid': false, 'reason': 'Key not found'};
    }
    return {'valid': true, 'tier': 'beta_free'};
  }
}
