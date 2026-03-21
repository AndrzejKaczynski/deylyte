import 'package:deyelyte_client/deyelyte_client.dart';

import '../repositories/history_repository.dart';

class ServerpodHistoryRepository implements HistoryRepository {
  ServerpodHistoryRepository(this._client);
  final Client _client;

  @override
  Future<Map<String, dynamic>> getSummary(int rangeDays) =>
      _client.history.getSummary(rangeDays);

  @override
  Future<List<Map<String, dynamic>>> getEvents(int rangeDays) =>
      _client.history.getEvents(rangeDays);
}
