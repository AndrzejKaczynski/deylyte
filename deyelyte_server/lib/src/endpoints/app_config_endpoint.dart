import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AppConfigEndpoint extends Endpoint {
  /// Returns the AppConfig for the authenticated user, or null if not yet set.
  Future<AppConfig?> getConfig(Session session) async {
    final userInfoId = _requireUserInfoId(session);
    return AppConfig.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId));
  }

  /// Upserts the AppConfig for the authenticated user.
  /// The userInfoId field on the incoming config is ignored — it is always set
  /// to the authenticated user's ID.
  Future<void> saveConfig(Session session, AppConfig config) async {
    final userInfoId = _requireUserInfoId(session);
    final existing = await AppConfig.db.findFirstRow(session,
        where: (t) => t.userInfoId.equals(userInfoId));

    if (existing != null) {
      await AppConfig.db.updateRow(
          session,
          config.copyWith(
            id: existing.id,
            userInfoId: userInfoId,
          ));
    } else {
      await AppConfig.db.insertRow(
          session, config.copyWith(userInfoId: userInfoId));
    }
  }

  // ---------------------------------------------------------------------------

  int _requireUserInfoId(Session session) {
    final authInfo = session.authenticated;
    if (authInfo == null) throw Exception('Not authenticated');
    return int.parse(authInfo.userIdentifier);
  }
}
