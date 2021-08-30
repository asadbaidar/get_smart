import 'dart:async';

import 'package:get_smart/get_smart.dart';

/// Multi purpose ViewModel implementation of [GetxController]
abstract class GetController extends MultipleFutureGetController {
  final actionName = "action";

  Map<String, dynamic> get dataMap => _dataMap;
  Map<String, dynamic> _dataMap = {};

  Map<dynamic, Future Function()> get runnerMap => _runnerMap;
  Map<dynamic, Future Function()> _runnerMap = {};

  late Completer _futuresCompleter;
  int _futuresCompleted = 0;
  bool _isModelReady = false;

  void _initialiseData() {
    _futuresCompleted = 0;
    _isModelReady = false;
  }

  @override
  Future initialise() {
    _futuresCompleter = Completer();
    _initialiseData();
    // We set busy manually as well because when notify listeners is called
    // to clear error messages, ui is rebuilt and busy is not true.
    clearErrors();
    setBusy(true);
    update();

    for (var key in futuresMap.keys) {
      runErrorFuture(
        futuresMap[key]!(),
        key: key,
        throwException: true,
      ).then((result) {
        setDataFor(key, result);
        if (key != typeName) setBusyFor(key, false);
        if (result is GetResult && result.error != null)
          setErrorFor(typeName, result.error);
        update();
        onData(key);
        _incrementAndCheckFuturesCompleted();
      }).catchError((error) {
        setErrorFor(key, error);
        if (key != typeName) setBusyFor(key, false);
        onError(key, error);
        update();
        _incrementAndCheckFuturesCompleted();
      });
    }
    changeSource = false;
    return _futuresCompleter.future;
  }

  void _incrementAndCheckFuturesCompleted() {
    _futuresCompleted++;
    if (_futuresCompleted == futuresMap.length &&
        !_futuresCompleter.isCompleted) {
      _futuresCompleter.complete();
      setBusy(false);
      _isModelReady = true;
      onDataReady();
    }
  }

  @override
  void onClose() {
    _cancelWebApis();
    super.onClose();
  }

  void _cancelWebApis() {
    try {
      webAPIs.forEach((e) => e.cancel());
    } catch (e) {}
  }

  /// Include all web APIs for cleanup when closed
  List<GetWebAPI> get webAPIs => [];

  @override
  Map<Object, Future Function()> get futuresMap => {
        if (loadPrefsOnInit) $name(GetPrefs): GetPrefs.instance.reload,
        typeName: futureToRun,
        ...futuresToRun,
      };

  /// Run the futures again and refresh
  Future refreshData() => initialise();

  /// Multiple futures to run at the startup
  Map<Object, Future Function()> get futuresToRun => {};

  /// Single future to run at the startup
  Future futureToRun() => Future.value();

  /// To mark, if prefs should be reloaded [onInit]. Defaults to true.
  bool get loadPrefsOnInit => true;

  /// Returns true if all objects have succeeded.
  bool get isAllSucceeded => dataMap.keys.every((k) => succeeded(k));

  /// Returns data for any object which did not succeed.
  GetResult get anyNotSucceeded =>
      data(dataMap.keys.firstWhereOrNull((k) => !succeeded(k)) ?? "") ??
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
    if (value == null)
      return data<T>(actionName);
    else {
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

  /// Returns the data ready status of the ViewModel if no error occurred
  bool get isDataReady => dataReady(typeName);

  /// Returns the ready status of the ViewModel when all futures are completed
  bool get isModelReady => _isModelReady;

  /// Returns the data ready status of the ViewModel even if error occurred
  bool get isReady => ready(typeName);

  /// Returns the busy status of the ViewModel
  @override
  bool get isBusy => busy(typeName);

  /// Returns the error status of the ViewModel and checks if condition valid
  bool hasErrorOr([bool? condition]) =>
      !isBusy &&
      (hasError || ((condition ?? true) && (isReady || isModelReady)));

  /// Returns the error status of the ViewModel
  @override
  bool get hasError => hasErrorFor(typeName);

  /// Returns the error status of the ViewModel
  @override
  String? get modelError => error(typeName);

  /// Sets the error for the ViewModel
  set modelError(value) => setError(value);

  /// Sets or Returns the data of the ViewModel
  GetResult<T>? modelData<T>([value]) {
    if (value == null)
      return data<T>(typeName);
    else {
      setData(value);
      return value;
    }
  }

  /// Returns the runner of the ViewModel
  Future Function() get modelRunner => runner(typeName);

  /// Sets the runner for the ViewModel
  set modelRunner(value) => setRunner(value);

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

  /// Sets the busy status for the ViewModel and calls notify listeners
  @override
  void setBusy(bool value) => setBusyFor(typeName, value);

  /// Sets the error for the ViewModel
  @override
  void setError(error) => setErrorFor(typeName, error);

  /// Sets the data for the ViewModel
  void setData(data) => setDataFor(typeName, data);

  /// Sets the runner for the ViewModel
  void setRunner(Future Function() runner) => setRunnerFor(typeName, runner);

  /// Sets the busy status by key and calls notify listeners
  void setBusyFor(key, bool value) => setBusyForObject(key, value);

  /// Sets the error by key
  void setErrorFor(key, value) => setErrorForObject(key, value);

  /// Sets the data by key
  void setDataFor(Object key, value) => dataMap[key.$hash] = value;

  /// Sets the runner by key
  void setRunnerFor(Object key, Future Function() value) =>
      runnerMap[key.$hash] = value;

  /// Returns the runner by key
  Future Function() runner(Object key) =>
      runnerMap[key.$hash] ?? () => Future.value();

  /// Returns the data by key
  GetResult<T>? data<T>(Object key) => $cast<GetResult<T>>(dataMap[key.$hash]);

  /// Returns the success message by key
  String? success(Object key) => data(key)?.success;

  /// Returns the data ready status by key even if error occurred
  bool ready(key) => data(key) != null;

  /// Returns the data ready status by key even if no error occurred
  @override
  bool dataReady(key) => ready(key) && !hasErrorFor(key);

  /// Returns the [GetStatus] by key
  GetStatus? status(key) => busy(key) ? GetStatus.busy : data(key)?.status;

  /// Returns the status by key if started or not
  bool started(key) => status(key) != null && status(key) != GetStatus.canceled;

  /// Returns the status by key if succeeded or not
  bool succeeded(key) => status(key) == GetStatus.succeeded;

  /// Returns the status by key if busy/succeeded or not
  bool busyOrSucceeded(key) => busy(key) || succeeded(key);

  /// Returns the status by key if failed or not
  bool failed(key) => status(key) == GetStatus.failed;

  /// Returns the error status by key
  bool hasErrorFor(key) => error(key) != null;

  /// Cancels the future by key and clear the associated data
  void cancelFuture([key]) {
    _cancelWebApis();
    clearData(key ?? typeName);
  }

  /// Clears the data by key
  void clearData([key]) {
    setDataFor(key ?? typeName, null);
    clearErrors();
    clearBusy();
    update();
  }

  /// Clears all data and errors
  void clearAllData() {
    dataMap.clear();
    clearErrors();
    clearBusy();
    update();
  }

  /// Sets the key to busy, runs the runner and then sets it to not busy
  /// when completed.
  ///
  /// key: by default `typeName`, if null, status will be update in default key
  ///
  /// rethrows [Exception] after setting busy to false by key
  Future runBusyRunner(
    Future Function() busyAction, {
    Object? key,
    bool throwException = false,
  }) {
    var _key = key ?? typeName;
    final runner = () async {
      setDataFor(_key, null);
      return await runBusyFuture(
        busyAction(),
        key: _key,
        throwException: throwException,
      );
    };
    setRunnerFor(_key, runner);
    return runner();
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
