/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'dart:async' as _i2;
import '../future_calls/init_user_call.dart' as _i3;
import '../future_calls/poll_energy_prices_call.dart' as _i4;
import '../future_calls/poll_inverter_call.dart' as _i5;
import '../future_calls/run_optimizer_call.dart' as _i6;

/// Invokes a future call.
typedef _InvokeFutureCall =
    Future<void> Function(String name, _i1.SerializableModel? object);

extension ServerpodFutureCallsGetter on _i1.Serverpod {
  /// Generated future calls.
  FutureCalls get futureCalls => FutureCalls();
}

class FutureCalls extends _i1.FutureCallDispatch<_FutureCallRef> {
  FutureCalls._();

  factory FutureCalls() {
    return _instance;
  }

  static final FutureCalls _instance = FutureCalls._();

  _i1.FutureCallManager? _futureCallManager;

  String? _serverId;

  String get _effectiveServerId {
    if (_serverId == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _serverId!;
  }

  _i1.FutureCallManager get _effectiveFutureCallManager {
    if (_futureCallManager == null) {
      throw StateError('FutureCalls is not initialized.');
    }
    return _futureCallManager!;
  }

  @override
  void initialize(
    _i1.FutureCallManager futureCallManager,
    String serverId,
  ) {
    var registeredFutureCalls = <String, _i1.FutureCall>{
      'InitUserCallInvokeFutureCall': InitUserCallInvokeFutureCall(),
      'PollEnergyPricesCallInvokeFutureCall':
          PollEnergyPricesCallInvokeFutureCall(),
      'PollInverterCallInvokeFutureCall': PollInverterCallInvokeFutureCall(),
      'RunOptimizerCallInvokeFutureCall': RunOptimizerCallInvokeFutureCall(),
    };
    _futureCallManager = futureCallManager;
    _serverId = serverId;
    for (final entry in registeredFutureCalls.entries) {
      _futureCallManager?.registerFutureCall(entry.value, entry.key);
    }
  }

  @override
  _FutureCallRef callAtTime(
    DateTime time, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          time,
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  _FutureCallRef callWithDelay(
    Duration delay, {
    String? identifier,
  }) {
    return _FutureCallRef(
      (name, object) {
        return _effectiveFutureCallManager.scheduleFutureCall(
          name,
          object,
          DateTime.now().toUtc().add(delay),
          _effectiveServerId,
          identifier,
        );
      },
    );
  }

  @override
  Future<void> cancel(String identifier) async {
    await _effectiveFutureCallManager.cancelFutureCall(identifier);
  }
}

class _FutureCallRef {
  _FutureCallRef(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  late final initUserCall = _InitUserCallFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final pollEnergyPricesCall = _PollEnergyPricesCallFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final pollInverterCall = _PollInverterCallFutureCallDispatcher(
    _invokeFutureCall,
  );

  late final runOptimizerCall = _RunOptimizerCallFutureCallDispatcher(
    _invokeFutureCall,
  );
}

class _InitUserCallFutureCallDispatcher {
  _InitUserCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? object) {
    return _invokeFutureCall(
      'InitUserCallInvokeFutureCall',
      object,
    );
  }
}

class _PollEnergyPricesCallFutureCallDispatcher {
  _PollEnergyPricesCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? object) {
    return _invokeFutureCall(
      'PollEnergyPricesCallInvokeFutureCall',
      object,
    );
  }
}

class _PollInverterCallFutureCallDispatcher {
  _PollInverterCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? object) {
    return _invokeFutureCall(
      'PollInverterCallInvokeFutureCall',
      object,
    );
  }
}

class _RunOptimizerCallFutureCallDispatcher {
  _RunOptimizerCallFutureCallDispatcher(this._invokeFutureCall);

  final _InvokeFutureCall _invokeFutureCall;

  Future<void> invoke(_i1.SerializableModel? object) {
    return _invokeFutureCall(
      'RunOptimizerCallInvokeFutureCall',
      object,
    );
  }
}

class InitUserCallInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i3.InitUserCall().invoke(
      session,
      object,
    );
  }
}

class PollEnergyPricesCallInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i4.PollEnergyPricesCall().invoke(
      session,
      object,
    );
  }
}

class PollInverterCallInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i5.PollInverterCall().invoke(
      session,
      object,
    );
  }
}

class RunOptimizerCallInvokeFutureCall
    extends _i1.FutureCall<_i1.SerializableModel> {
  @override
  _i2.Future<void> invoke(
    _i1.Session session,
    _i1.SerializableModel? object,
  ) async {
    await _i6.RunOptimizerCall().invoke(
      session,
      object,
    );
  }
}
