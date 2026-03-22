import 'dart:convert';

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
  final json = await ref.read(clientProvider).admin.listLicenseKeys();
  return (jsonDecode(json) as List).cast<Map<String, dynamic>>();
});

final adminUsersProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final json = await ref.read(clientProvider).admin.listUsers();
  return (jsonDecode(json) as List).cast<Map<String, dynamic>>();
});

final adminDevicesProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final json = await ref.read(clientProvider).admin.listDevices();
  return (jsonDecode(json) as List).cast<Map<String, dynamic>>();
});

final adminSyncSettingsProvider =
    FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final json = await ref.read(clientProvider).admin.listTierSyncConfigs();
  return (jsonDecode(json) as List).cast<Map<String, dynamic>>();
});
