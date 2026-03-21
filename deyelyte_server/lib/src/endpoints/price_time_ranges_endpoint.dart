import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class PriceTimeRangesEndpoint extends Endpoint {
  /// Returns all time ranges for the authenticated user.
  Future<List<PriceTimeRange>> getTimeRanges(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    return PriceTimeRange.db.find(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
      orderBy: (t) => t.hourStart,
    );
  }

  /// Replaces all time ranges for the authenticated user.
  Future<void> saveTimeRanges(
      Session session, List<PriceTimeRange> ranges) async {
    final userInfoId = _requireUserInfoId(session);
    await PriceTimeRange.db.deleteWhere(
      session,
      where: (t) => t.userInfoId.equals(userInfoId),
    );
    if (ranges.isNotEmpty) {
      final toInsert = ranges
          .map((r) => PriceTimeRange(
                userInfoId: userInfoId,
                hourStart: r.hourStart,
                hourEnd: r.hourEnd,
                ratePln: r.ratePln,
                sellRatePln: r.sellRatePln,
              ))
          .toList();
      await PriceTimeRange.db.insert(session, toInsert);
    }
  }

  int _requireUserInfoId(Session session) {
    final auth = session.authenticated;
    if (auth == null) throw Exception('Not authenticated');
    return int.parse(auth.userIdentifier);
  }
}
