import 'dart:async';

import 'package:get_smart/get_smart.dart';

/// Multi purpose Controller implementation of [GetxController]
abstract class GetController extends MultipleFutureGetController {
  final actionName = "action";

  /// To mark, if prefs should be reloaded [beforeInit]. Defaults to true.
  bool get loadPrefsOnInit => true;

  @override
  Future beforeInit() async =>
      loadPrefsOnInit ? await GetPrefs.instance.reload() : Future.value();

  /// Include all web APIs for cleanup when closed
  List<GetWebAPI> get webAPIs => [];

  void _cancelWebApis() {
    try {
      for (var e in webAPIs) {
        e.cancel();
      }
    } catch (e) {
      $debugPrint(e, "cancelWebApis");
    }
  }

  @override
  void onClose() {
    _cancelWebApis();
    super.onClose();
  }

  /// Returns true if all objects have succeeded.
  bool get isAllSucceeded => dataMap.keys.every((k) => succeeded(k));

  /// Returns result for any object which did not succeed.
  GetResult get anyNotSucceeded =>
      resultFor(dataMap.keys.firstWhereOrNull((k) => !succeeded(k)) ?? "") ??
      GetResult.success();

  /// Returns the data ready status of the action if no error occurred
  bool get isActionDataReady => dataReady(actionName);

  /// Returns the data ready status of the action even if error occurred
  bool get isActionReady => ready(actionName);

  /// Returns the status of the action if started or not
  bool get isActionStarted => started(actionName);

  /// Returns the status of action if succeeded or not
  bool get isActionSucceeded => succeeded(actionName);

  /// Returns the status of action if busy or not
  bool get isActionBusy => busyFor(actionName);

  /// Returns the status of action if busy/succeeded or not
  bool get isActionBusyOrSucceeded => busyOrSucceeded(actionName);

  /// Returns the status of action if busy/failed or not
  bool get isActionBusyOrFailed => busyOrFailed(actionName);

  /// Returns the status of action if failed or not
  bool get isActionFailed => failed(actionName);

  /// Returns the error status of action
  bool get hasActionError => hasErrorFor(actionName);

  /// Returns the [GetStatus] of action
  GetStatus? get actionStatus => statusFor(actionName);

  /// Returns the success status of an action
  String? get actionSuccess => successFor(actionName);

  /// Returns the error status of an action
  String? get actionError => errorFor(actionName);

  /// sets the error status of an action
  set actionError(value) => setErrorFor(actionName, value);

  /// Returns the data of the action
  GetResult<T>? actionResult<T>() => resultFor<T>(actionName);

  /// Sets the data of the action
  void setActionResult(value) => setDataFor(actionName, value);

  /// Returns the runner of the action
  FutureCallback? get actionRunner => runnerFor(actionName);

  /// Sets the runner of the action
  set actionRunner(value) => setRunnerFor(actionName, value);

  /// Cancels the action and clear the associated data
  void cancelAction() => cancelFuture(actionName);

  /// Clears the action data
  void clearAction() => clearAllStateData(actionName);

  /// Sets the action to busy, runs the action and then sets it to not busy
  /// when completed.
  ///
  /// rethrows [Exception] after setting action busy to false
  Future<T?> runActionRunner<T>(
    Callback<Future<T?>> runner, {
    bool throwException = false,
  }) =>
      runBusyRunner<T>(
        runner,
        key: actionName,
        throwException: throwException,
      );

  /// Sets the action to busy, runs the action and then sets it to not busy
  /// when completed.
  ///
  /// rethrows [Exception] after setting action busy to false
  Future<T?> runActionFuture<T>(
    Future<T?> future, {
    bool throwException = false,
  }) =>
      runBusyFuture<T>(
        future,
        key: actionName,
        throwException: throwException,
      );

  /// Sets the action to busy, runs all the actions and then sets it to not busy
  /// when completed.
  ///
  /// return false if error occurred, otherwise true.
  Future<bool> runActionFutures<T>(
    List<Future> futures,
  ) =>
      runBusyFutures(
        futures,
        key: actionName,
      );

  Future<T?> runAction<T>(
    Callback<Future<T?>> action, {
    bool throwException = false,
  }) =>
      runRunner<T>(
        action,
        key: actionName,
        throwException: throwException,
      );

  /// Returns the data of the Controller
  GetResult<T>? result<T>() => resultFor<T>(typeName);

  /// Sets the data of the Controller
  void setResult(value) => setData(value);

  /// Returns the status of the Controller if started or not
  bool get isStarted => started(typeName);

  /// Returns the status of Controller if succeeded or not
  bool get isSucceeded => succeeded(typeName);

  /// Returns the status of Controller if busy/succeeded or not
  bool get isBusyOrSucceeded => busyOrSucceeded(typeName);

  /// Returns the status of Controller if failed or not
  bool get isFailed => failed(typeName);

  /// Returns the [GetStatus] of the Controller
  GetStatus? get status => statusFor(typeName);

  /// Returns the success message of the Controller
  String? get success => successFor(typeName);

  /// Returns the result data by key
  GetResult<T>? resultFor<T>([Object? key]) => dataFor<GetResult<T>>(key ?? T);

  /// Returns the success message by key
  String? successFor(Object key) => resultFor(key)?.success;

  /// Returns the data ready status by key even if error occurred
  @override
  bool ready(Object key) => resultFor(key) != null || errorFor(key) != null;

  /// Returns the [GetStatus] by key
  GetStatus? statusFor(key) => busyFor(key)
      ? GetStatus.busy
      : resultFor(key)?.status ?? (hasErrorFor(key) ? GetStatus.failed : null);

  /// Returns the status by key if started or not
  bool started(key) =>
      statusFor(key) != null && statusFor(key) != GetStatus.canceled;

  /// Returns the status by key if succeeded or not
  bool succeeded(key) => statusFor(key) == GetStatus.succeeded;

  /// Returns the status by key if busy/succeeded or not
  bool busyOrSucceeded(key) => busyFor(key) || succeeded(key);

  /// Returns the status by key if busy/failed or not
  bool busyOrFailed(key) => busyFor(key) || failed(key);

  /// Returns the status by key if failed or not
  bool failed(key) => statusFor(key) == GetStatus.failed;

  /// Cancels the future by key and clear the associated data
  void cancelFuture([key]) {
    _cancelWebApis();
    clearAllStateData(key);
  }

  /// Sets the Controller to busy, runs the future and then sets it to not busy when complete.
  ///
  /// rethrows [Exception] after setting busy to false for object or class
  @override
  Future<T?> runBusyFuture<T>(
    Future<T?> future, {
    Object? key,
    bool throwException = false,
  }) async {
    clearErrors();
    final _key = key ?? typeName;
    setBusyFor(_key, true);
    try {
      var value = await runErrorFuture(
        future,
        key: key,
        throwException: throwException,
      );
      setDataFor(_key, value);
      setBusyFor(_key, false);
      return value;
    } catch (e) {
      setBusyFor(_key, false);
      if (throwException) rethrow;
      return Future.value();
    }
  }

  @override
  Future<T?> runErrorFuture<T>(
    Future<T?> future, {
    Object? key,
    bool throwException = false,
  }) async {
    final _key = key ?? typeName;
    try {
      final result = await future;
      if (result is GetResult && result.error != null) {
        setErrorFor(_key, result.error);
        onError(_key, result.error);
        if (throwException) throw result.error!;
      }
      return result;
    } catch (e) {
      setErrorFor(_key, e);
      onError(e, _key);
      if (throwException) rethrow;
      return Future.value();
    }
  }
}
