import 'dart:convert';

import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/history_repository.dart';

class ServerpodHistoryRepository implements HistoryRepository {
  ServerpodHistoryRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> getSummary(int rangeDays) async {
    final json = await _client.history.getSummary(rangeDays);
    return jsonDecode(json) as Map<String, dynamic>;
  }

  @override
  Future<List<Map<String, dynamic>>> getEvents(int rangeDays) async {
    final json = await _client.history.getEvents(rangeDays);
    return (jsonDecode(json) as List).cast<Map<String, dynamic>>();
  }
}
