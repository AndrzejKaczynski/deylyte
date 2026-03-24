import 'dart:convert';

import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/history_repository.dart';

class ServerpodHistoryRepository implements HistoryRepository {
  ServerpodHistoryRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> getSummary(DateTime from, DateTime to) async {
    final json = await _client.history.getSummary(from.toUtc(), to.toUtc());
    return jsonDecode(json) as Map<String, dynamic>;
  }
}
