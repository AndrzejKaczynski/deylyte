abstract class LicenseRepository {
  /// Validates [licenseKey] against the server and associates it with the user.
  /// Returns a map with keys: valid (bool), tier (String?), reason (String?).
  Future<Map<String, dynamic>> validate(String licenseKey);
}
