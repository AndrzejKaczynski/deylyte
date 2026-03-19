import 'dart:async';
import 'package:serverpod/serverpod.dart';

class RouteRoot extends Route {
  @override
  FutureOr<Result> handleCall(Session session, Request request) =>
      Response.ok(
        body: Body.fromString(
          '<html><body><h1>Deyelightful API</h1></body></html>',
          mimeType: MimeType.html,
        ),
      );
}
