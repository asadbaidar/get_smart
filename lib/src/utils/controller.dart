import 'dart:async';

import 'package:get_smart/get_smart.dart';

/// Multi purpose ViewModel implementation of [GetxController]
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
    } catch (_) {}
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
      result(dataMap.keys.firstWhereOrNull((k) => !succeeded(k)) ?? "") ??
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
  bool get isActionBusy => busy(actionName);

  /// Returns the status of action if busy/succeeded or not
  bool get isActionBusyOrSucceeded => busyOrSucceeded(actionName);

  /// Returns the status of action if failed or not
  bool get isActionFailed => failed(actionName);

  /// Returns the error status of action
  bool get hasActionError => hasErrorFor(actionName);

  /// Returns the [GetStatus] of action
  GetStatus? get actionStatus => status(actionName);

  /// Returns the success status of an action
  String? get actionSuccess => success(actionName);

  /// Returns the error status of an action
  String? get actionError => error(actionName);

  /// sets the error status of an action
  set actionError(value) => setErrorFor(actionName, value);

  /// Sets or Returns the data of the action
  GetResult<T>? actionData<T>([value]) {
    if (value == null) {
      return result<T>(actionName);
    } else {
      setDataFor(actionName, value);
      return value;
    }
  }

  /// Returns the runner of the action
  Future Function() get actionRunner => runner(actionName);

  /// Sets the runner of the action
  set actionRunner(value) => setRunnerFor(actionName, value);

  /// Cancels the action and clear the associated data
  void cancelAction() => cancelFuture(actionName);

  /// Clears the action data
  void clearAction() => clearData(actionName);

  /// Sets the action to busy, runs the action and then sets it to not busy
  /// when completed.
  ///
  /// rethrows [Exception] after setting action busy to false
  Future runBusyAction(
    Future Function() busyAction, {
    bool throwException = false,
  }) =>
      runBusyRunner(
        busyAction,
        key: actionName,
        throwException: throwException,
      );

  /// Sets or Returns the data of the ViewModel
  GetResult<T>? modelResult<T>([value]) {
    if (value == null) {
      return result<T>(typeName);
    } else {
      setData(value);
      return value;
    }
  }

  /// Returns the status of the ViewModel if started or not
  bool get isStarted => started(typeName);

  /// Returns the status of ViewModel if succeeded or not
  bool get isSucceeded => succeeded(typeName);

  /// Returns the status of ViewModel if busy/succeeded or not
  bool get isBusyOrSucceeded => busyOrSucceeded(typeName);

  /// Returns the status of ViewModel if failed or not
  bool get isFailed => failed(typeName);

  /// Returns the [GetStatus] of the ViewModel
  GetStatus? get modelStatus => status(typeName);

  /// Returns the success message of the ViewModel
  String? get modelSuccess => success(typeName);

  /// Returns the result data by key
  GetResult<T>? result<T>(Object key) => data<GetResult<T>>(key);

  /// Returns the success message by key
  String? success(Object key) => result(key)?.success;

  /// Returns the data ready status by key even if error occurred
  @override
  bool ready(Object key) => result(key) != null;

  /// Returns the [GetStatus] by key
  GetStatus? status(key) => busy(key) ? GetStatus.busy : result(key)?.status;

  /// Returns the status by key if started or not
  bool started(key) => status(key) != null && status(key) != GetStatus.canceled;

  /// Returns the status by key if succeeded or not
  bool succeeded(key) => status(key) == GetStatus.succeeded;

  /// Returns the status by key if busy/succeeded or not
  bool busyOrSucceeded(key) => busy(key) || succeeded(key);

  /// Returns the status by key if failed or not
  bool failed(key) => status(key) == GetStatus.failed;

  /// Cancels the future by key and clear the associated data
  void cancelFuture([key]) {
    _cancelWebApis();
    clearData(key ?? typeName);
  }

  /// Sets the ViewModel to busy, runs the future and then sets it to not busy when complete.
  ///
  /// rethrows [Exception] after setting busy to false for object or class
  @override
  Future runBusyFuture(
    Future busyFuture, {
    Object? key,
    bool throwException = false,
  }) async {
    clearErrors();
    final _key = key ?? typeName;
    setBusyFor(_key, true);
    try {
      var value = await runErrorFuture(
        busyFuture,
        key: key,
        throwException: throwException,
      );
      setDataFor(_key, value);
      setBusyFor(_key, false);
      return value;
    } catch (e) {
      setBusyFor(_key, false);
      if (throwException) rethrow;
      return GetResult.error(e.toString());
    }
  }

  @override
  Future runErrorFuture(
    Future future, {
    Object? key,
    bool throwException = false,
  }) async {
    final _key = key ?? typeName;
    try {
      final result = await future;
      if (result is GetResult && result.error != null) {
        setErrorFor(_key, result.error);
        onError(_key, result.error);
      }
      return result;
    } catch (e) {
      setErrorFor(_key, e);
      onError(e, _key);
      if (throwException) rethrow;
      return GetResult.error(e.toString());
    }
  }
}
