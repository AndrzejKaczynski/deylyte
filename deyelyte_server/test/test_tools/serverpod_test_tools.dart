/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:serverpod_test/serverpod_test.dart' as st;
import 'package:serverpod/serverpod.dart' as sp;
import 'package:deyelyte_server/src/generated/protocol.dart';
import 'package:deyelyte_server/src/generated/endpoints.dart';

export 'package:serverpod_test/serverpod_test.dart';

@st.isTestGroup
void withServerpod(
  String testGroupName,
  st.TestClosure<TestEndpoints> testClosure, {
  bool? applyMigrations,
  bool? enableSessionLogging,
  st.RollbackDatabase? rollbackDatabase,
  String? runMode,
  sp.ServerpodLoggingMode? serverpodLoggingMode,
  Duration? serverpodStartTimeout,
  List<String>? testGroupTagsOverride,
  st.TestServerOutputMode? testServerOutputMode,
}) {
  st.buildWithServerpod<_InternalTestEndpoints>(
    testGroupName,
    st.TestServerpod(
      testEndpoints: _InternalTestEndpoints(),
      endpoints: Endpoints(),
      serializationManager: Protocol(),
      runMode: runMode,
      applyMigrations: applyMigrations,
      isDatabaseEnabled: true,
      serverpodLoggingMode: serverpodLoggingMode,
      testServerOutputMode: testServerOutputMode,
    ),
    maybeRollbackDatabase: rollbackDatabase,
    maybeEnableSessionLogging: enableSessionLogging,
    maybeTestGroupTagsOverride: testGroupTagsOverride,
    maybeServerpodStartTimeout: serverpodStartTimeout,
    maybeTestServerOutputMode: testServerOutputMode,
  )(testClosure);
}

class TestEndpoints {
  late final _AppConfigEndpoint appConfig;
  late final _CredentialsEndpoint credentials;
}

class _InternalTestEndpoints extends TestEndpoints
    implements st.InternalTestEndpoints {
  @override
  void initialize(
    sp.SerializationManager serializationManager,
    sp.EndpointDispatch endpoints,
  ) {
    appConfig = _AppConfigEndpoint(endpoints, serializationManager);
    credentials = _CredentialsEndpoint(endpoints, serializationManager);
  }
}

// ── AppConfig endpoint ────────────────────────────────────────────────────────

class _AppConfigEndpoint {
  _AppConfigEndpoint(this._dispatch, this._serialization);
  final sp.EndpointDispatch _dispatch;
  final sp.SerializationManager _serialization;

  Future<AppConfig?> getConfig(st.TestSessionBuilder sessionBuilder) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'appConfig', method: 'getConfig');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'appConfig',
          methodName: 'getConfig',
          parameters: st.testObjectToJson({}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<AppConfig?>;
      } finally {
        await s.close();
      }
    });
  }

  Future<void> saveConfig(
      st.TestSessionBuilder sessionBuilder, AppConfig config) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'appConfig', method: 'saveConfig');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'appConfig',
          methodName: 'saveConfig',
          parameters: st.testObjectToJson({'config': config}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }
}

// ── Credentials endpoint ──────────────────────────────────────────────────────

class _CredentialsEndpoint {
  _CredentialsEndpoint(this._dispatch, this._serialization);
  final sp.EndpointDispatch _dispatch;
  final sp.SerializationManager _serialization;

  Future<void> saveDeye(
    st.TestSessionBuilder sessionBuilder,
    String username,
    String password,
    String appId,
    String appSecret,
  ) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'saveDeye');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'saveDeye',
          parameters: st.testObjectToJson({
            'username': username,
            'password': password,
            'appId': appId,
            'appSecret': appSecret,
          }),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }

  Future<void> saveSolcast(
      st.TestSessionBuilder sessionBuilder, String apiKey, String siteId) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'saveSolcast');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'saveSolcast',
          parameters:
              st.testObjectToJson({'apiKey': apiKey, 'siteId': siteId}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }

  Future<void> savePstryk(st.TestSessionBuilder sessionBuilder, String token) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'savePstryk');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'savePstryk',
          parameters: st.testObjectToJson({'token': token}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }

  Future<void> removeDeye(st.TestSessionBuilder sessionBuilder) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'removeDeye');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'removeDeye',
          parameters: st.testObjectToJson({}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }

  Future<void> removeSolcast(st.TestSessionBuilder sessionBuilder) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'removeSolcast');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'removeSolcast',
          parameters: st.testObjectToJson({}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }

  Future<void> removePstryk(st.TestSessionBuilder sessionBuilder) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'removePstryk');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'removePstryk',
          parameters: st.testObjectToJson({}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments) as Future<void>;
      } finally {
        await s.close();
      }
    });
  }

  Future<Map<String, bool>> getStatus(st.TestSessionBuilder sessionBuilder) {
    return st.callAwaitableFunctionAndHandleExceptions(() async {
      final s = (sessionBuilder as st.InternalTestSessionBuilder)
          .internalBuild(endpoint: 'credentials', method: 'getStatus');
      try {
        final ctx = await _dispatch.getMethodCallContext(
          createSessionCallback: (_) => s,
          endpointPath: 'credentials',
          methodName: 'getStatus',
          parameters: st.testObjectToJson({}),
          serializationManager: _serialization,
        );
        return await ctx.method.call(s, ctx.arguments)
            as Future<Map<String, bool>>;
      } finally {
        await s.close();
      }
    });
  }
}
