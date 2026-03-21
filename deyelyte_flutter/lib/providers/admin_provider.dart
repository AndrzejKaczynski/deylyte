import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

/// True if the signed-in user is an admin. Cached for the session lifetime.
final isAdminProvider = FutureProvider<bool>((ref) async {
  try {
    return await ref.read(clientProvider).admin.checkAccess();
  } catch (_) {
    return false;
  }
});

final adminLicenseKeysProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(clientProvider).admin.listLicenseKeys();
});

final adminUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(clientProvider).admin.listUsers();
});

final adminDevicesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(clientProvider).admin.listDevices();
});
