import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// Basic Controller functionality for busy state management
abstract class BaseGetController extends GetxController {
  Map<Object, bool> get busyStates => _busyStates;
  final Map<Object, bool> _busyStates = {};

  Map<Object, dynamic> get errorStates => _errorStates;
  final Map<Object, dynamic> _errorStates = {};

  /// Returns the initialisation status of the Controller when all futures are completed
  bool get isInitialised => _initialised;
  bool _initialised = false;

  bool onReadyCalled = false;

  bool get disposed => _disposed;
  bool _disposed = false;

  /// Returns the busy status for a key if it exists.
  /// Returns false if not present
  bool busyFor(Object key) => _busyStates[key] ?? false;

  /// Returns the error by key
  String? errorFor(Object key) => _errorStates[key]?.toString();

  /// Returns the error status by key
  bool hasErrorFor(Object key) => errorFor(key) != null;

  /// Returns the busy status of the Controller
  bool get isBusy => busyFor(typeName);

  /// Returns the error status of the Controller
  bool get hasError => hasErrorFor(typeName);

  /// Returns the error status of the Controller
  String? get error => errorFor(typeName);

  /// Sets the error for the Controller
  set error(value) => setError(value);

  /// Returns true if any objects still have a busy status that is true.
  bool get isAnyBusy => _busyStates.values.any((busy) => busy);

  /// Returns true if any objects still have a error status.
  bool get hasAnyError => anyError != null;

  /// Returns error of any object that still have a error status.
  dynamic get anyError =>
      _errorStates.values.firstWhereOrNull((error) => error != null);

  /// Sets the busy status for the Controller and calls notify listeners
  void setBusy(bool value) => setBusyFor(typeName, value);

  /// Sets the error for the Controller
  void setError(error) => setErrorFor(typeName, error);

  /// Clears all the errors
  void clearErrors() => _errorStates.clear();

  /// Clears all the busy states
  void clearBusy() => _busyStates.clear();

  /// Clears all states and data by key
  bool clearAllStateData([Object? key]) {
    if (errorStates.isNotEmpty || busyStates.isNotEmpty) {
      clearErrors();
      clearBusy();
      update();
      return true;
    }
    return false;
  }

  /// Clears states and data by key
  bool clearStateData([Object? key]) {
    final _key = key ?? typeName;
    if (errorStates.containsKey(_key) || busyStates.containsKey(_key)) {
      _errorStates.remove(_key);
      _busyStates.remove(_key);
      update();
      return true;
    }
    return false;
  }

  /// Clears the data by key
  bool clearData([Object? key]) => false;

  /// Clears all data and states
  bool clearAllData() {
    if (errorStates.isNotEmpty || busyStates.isNotEmpty) {
      clearErrors();
      clearBusy();
      update();
      return true;
    }
    return false;
  }

  /// Sets the busy status by key and calls notify listeners
  void setBusyFor(Object key, bool value) {
    _busyStates[key] = value;
    update();
  }

  /// Sets the error state for the key equal to the value passed in and notifies Listeners
  void setErrorFor(Object key, value) {
    _errorStates[key] = value;
    update();
  }

  /// Sets the data by key
  void setDataFor(Object key, value) {}

  /// Function that is called when a future throws an error
  void onError(Object? key, error) {}

  Map<Object, FutureCallback> get runnerMap => _runnerMap;
  final Map<Object, FutureCallback> _runnerMap = {};

  /// Returns the runner of the Controller
  FutureCallback? get runner => runnerFor(typeName);

  /// Sets the runner for the Controller
  set runner(value) => setRunner(value);

  /// Sets the runner for the Controller
  void setRunner(FutureCallback runner) => setRunnerFor(typeName, runner);

  /// Sets the runner by key
  void setRunnerFor(Object key, FutureCallback value) => runnerMap[key] = value;

  /// Returns the runner by key
  FutureCallback? runnerFor(Object key) => runnerMap[key];

  final StackList _futureQueue = StackList.from([Future.value()]);

  /// Sets the key for error logs, runs the future in queue which means next
  /// future will not run unless the previous gets completed.
  ///
  /// key: by default `typeName`, if null, status will be update in default key
  Future<T?> runFutureQueue<T>(
    Callback<Future<T?>> callback, {
    Object? key,
    bool throwException = false,
  }) =>
      (_futureQueue.pop() ?? Future.value())
          .whenComplete(() => runErrorFuture<T>(
                _futureQueue.push(callback()),
                key: key,
                throwException: throwException,
              ));

  Future<T?> runRunner<T>(
    Callback<Future<T?>> runner, {
    Object? key,
    bool throwException = false,
  }) =>
      runBusyFuture<T>(runBusyRunner<T>(
        runner,
        key: key,
        throwException: throwException,
      ));

  Future<T?> runFuture<T>(
    Future<T?> future, {
    Object? key,
    bool throwException = false,
  }) =>
      runBusyFuture<T>(runBusyFuture<T>(
        future,
        key: key,
        throwException: throwException,
      ));

  /// Sets the key to busy, runs the runner and then sets it to not busy
  /// when completed.
  ///
  /// key: by default `typeName`, if null, status will be update in default key
  ///
  /// rethrows [Exception] after setting busy to false by key
  Future<T?> runBusyRunner<T>(
    Callback<Future<T?>> runner, {
    Object? key,
    bool throwException = false,
  }) {
    var _key = key ?? typeName;
    _runner() async {
      setDataFor(_key, null);
      return runBusyFuture<T>(
        runner(),
        key: _key,
        throwException: throwException,
      );
    }

    setRunnerFor(_key, _runner);
    return _runner();
  }

  /// Sets the Controller to busy, runs the future and then sets it
  /// to not busy when complete.
  ///
  /// rethrows [Exception] after setting busy to false for object or class
  Future<T?> runBusyFuture<T>(
    Future<T?> future, {
    Object? key,
    bool throwException = false,
  }) async {
    final _key = key ?? typeName;
    setBusyFor(_key, true);
    try {
      final value = await runErrorFuture<T>(
        future,
        key: key,
        throwException: throwException,
      );
      setBusyFor(_key, false);
      return value;
    } catch (e) {
      setBusyFor(_key, false);
      if (throwException) rethrow;
      return Future.value();
    }
  }

  /// Sets the Controller to busy, runs the futures and then sets it
  /// to not busy when complete.
  ///
  /// return false if error occurred, otherwise true.
  Future<bool> runBusyFutures(
    List<Future> futures, {
    Object? key,
  }) async {
    final _key = key ?? typeName;
    setBusyFor(_key, true);
    final value = await Future.forEach<Future>(
      futures,
      (future) => runErrorFuture(
        future,
        key: key,
        throwException: true,
      ),
    );
    setBusyFor(_key, false);
    return value == null;
  }

  Future<T?> runErrorFuture<T>(
    Future<T?> future, {
    Object? key,
    bool throwException = false,
  }) async {
    try {
      return await future;
    } catch (e) {
      var _key = key ?? typeName;
      setErrorFor(_key, e);
      onError(_key, e);
      if (throwException) rethrow;
      return Future.value();
    }
  }

  // Sets up streamData property to hold data, busy, and lifecycle events
  @protected
  StreamData setupStream<T>(
    Stream<T> stream, {
    onData,
    onSubscribed,
    onError,
    onCancel,
    transformData,
  }) {
    StreamData<T> streamData = StreamData<T>(
      stream,
      onData: onData,
      onSubscribed: onSubscribed,
      onError: onError,
      onCancel: onCancel,
      transformData: transformData,
    );
    streamData.initialise();

    return streamData;
  }

  @override
  void update([List<Object>? ids, bool condition = true]) {
    if (!disposed) {
      super.update();
    } else {
      super.update(ids, disposed);
    }
  }

  @override
  void onInit() {
    super.onInit();
    _handleStartupTasks();
  }

  void _handleStartupTasks() {
    if (!onReadyCalled) {
      onReadyCalled = true;
    }
    _initialiseSpecialControllers();
  }

  void _initialiseSpecialControllers() {
    if (this is Initializer) {
      if (!isInitialised) {
        var controller = this as Initializer;
        controller.initialise();
      }
    }
  }

  @override
  void onReady() {
    super.onReady();
    if (this is DynamicSourceGetController) {
      var controller = this as DynamicSourceGetController;
      if (controller.changeSource) {
        _initialiseSpecialControllers();
      }
    }
  }

  @override
  onClose() {
    _disposed = true;
    super.onClose();
  }
}

@protected
class DynamicSourceGetController<T> extends BaseGetController {
  bool changeSource = false;

  void notifySourceChanged({bool clearOldData = false}) {
    changeSource = true;
  }
}

class _SingleDataSourceGetController<T> extends DynamicSourceGetController {
  T? _data;

  T? get data => _data;

  dynamic _error;

  @override
  String? errorFor([Object? object]) => _error?.toString();

  bool get dataReady => _data != null && !hasError;
}

class _MultiDataSourceGetController extends DynamicSourceGetController {
  Map<Object, dynamic> get dataMap => _dataMap;
  final Map<Object, dynamic> _dataMap = {};

  /// Sets the data by key
  @override
  void setDataFor(Object key, value) => dataMap[key] = value;

  /// Returns the data by key
  T? dataFor<T>(Object key) => $cast<T>(dataMap[key]);

  /// Returns the data ready status by key even if error occurred
  bool ready(Object key) => dataFor(key) != null || errorFor(key) != null;

  /// Returns the data ready status by key if no error occurred
  bool dataReady(Object key) => ready(key) && !hasErrorFor(key);

  /// Clears all states but data by key
  @override
  bool clearAllStateData([Object? key]) {
    final _key = key ?? typeName;
    if (dataMap.containsKey(_key)) {
      dataMap.remove(_key);
      super.clearAllStateData(_key);
      return true;
    }
    return super.clearAllStateData(_key);
  }

  /// Clears states and data by key
  @override
  bool clearStateData([Object? key]) {
    final _key = key ?? typeName;
    if (dataMap.containsKey(_key)) {
      dataMap.remove(_key);
      super.clearStateData(_key);
      return true;
    }
    return super.clearStateData(_key);
  }

  /// Clears the data by key
  @override
  bool clearData([Object? key]) {
    final _key = key ?? typeName;
    if (dataMap.containsKey(_key)) {
      dataMap.remove(_key);
      super.clearData(_key);
      return true;
    }
    return super.clearData(_key);
  }

  /// Clears all data and states
  @override
  bool clearAllData() {
    if (dataMap.isNotEmpty) {
      dataMap.clear();
      super.clearAllData();
      return true;
    }
    return super.clearAllData();
  }
}

/// Provides functionality for a Controller to run and fetch data using multiple future
abstract class MultipleFutureGetController extends _MultiDataSourceGetController
    implements Initializer {
  Map<Object, FutureCallback> get futuresMap => {
        typeName: futureToRun,
        ...futuresToRun,
      };

  /// Multiple futures to run at the startup
  Map<Object, FutureCallback> get futuresToRun => {};

  /// Single future to run at the startup
  Future futureToRun() => Future.value();

  late Completer _futuresCompleter;
  int _futuresCompleted = 0;

  void _initialiseData() {
    _futuresCompleted = 0;
    _initialised = false;
  }

  @override
  Future beforeInit() => Future.value();

  @override
  Future initialise() async {
    _futuresCompleter = Completer();
    _initialiseData();
    // We set busy manually as well because when notify listeners is called
    // to clear error messages, ui is rebuilt and busy is not true.
    clearErrors();
    setBusy(true);
    update();
    await beforeInit();
    final _futuresMap = futuresMap;
    for (final key in _futuresMap.keys) {
      runErrorFuture(
        _futuresMap[key]!(),
        key: key,
        throwException: true,
      ).then((result) {
        setDataFor(key, result);
        if (key != typeName) setBusyFor(key, false);
        update();
        onData(key);
        _incrementAndCheckFuturesCompleted(_futuresMap);
      }).catchError((error) {
        if (key != typeName) setBusyFor(key, false);
        update();
        _incrementAndCheckFuturesCompleted(_futuresMap);
      });
    }
    changeSource = false;
    return _futuresCompleter.future;
  }

  void _incrementAndCheckFuturesCompleted(Map futuresMap) {
    _futuresCompleted++;
    if (_futuresCompleted == futuresMap.length &&
        !_futuresCompleter.isCompleted) {
      _futuresCompleter.complete();
      setBusy(false);
      _initialised = true;
      onDataReady();
      setBusy(false);
    }
  }

  /// Called when any future gets completed
  void onData(Object key) {}

  /// Called when all initialization futures are completed
  void onDataReady() {}

  /// Run the futures again and refresh
  Future refreshData() => initialise();

  /// Returns the data of the Controller
  T? data<T>() => dataFor<T>(typeName);

  /// Sets the data for the Controller
  void setData(data) => setDataFor(typeName, data);

  /// Returns the data ready status of the Controller if no error occurred
  bool get isDataReady => dataReady(typeName);

  /// Returns the ready status of the Controller even if error occurred
  bool get isReady => ready(typeName);

  /// Returns the error status of the Controller and checks if condition valid
  bool hasErrorOr([bool? condition]) =>
      !isBusy &&
      (hasError || ((condition ?? true) && (isReady || isInitialised)));
}

/// Provides functionality for a Controller to run and fetch data using multiple streams
abstract class MultipleStreamGetController extends _MultiDataSourceGetController
    implements Initializer {
  // Every MultipleStreamController must override streamDataMap
  // StreamData requires a stream, but lifecycle events are optional
  // if a lifecycle event isn't defined we use the default ones here
  Map<Object, StreamData> get streamsMap;

  Map<Object, StreamSubscription>? _streamsSubscriptions;

  @visibleForTesting
  Map<Object, StreamSubscription>? get streamsSubscriptions =>
      _streamsSubscriptions;

  /// Returns the stream subscription associated with the key
  StreamSubscription? getSubscriptionForKey(Object key) =>
      _streamsSubscriptions![key];

  @override
  Future beforeInit() => Future.value();

  @override
  Future initialise() async {
    clearErrors();
    _streamsSubscriptions = {};

    if (!changeSource) {
      update();
    }

    for (var key in streamsMap.keys) {
      // If a lifecycle function isn't supplied, we fallback to default
      _streamsSubscriptions![key] = streamsMap[key]!.stream.listen(
        (incomingData) {
          setErrorFor(key, null);
          update();
          // Extra security in case transformData isnt sent
          var interceptedData = streamsMap[key]!.transformData == null
              ? transformData(key, incomingData)
              : streamsMap[key]!.transformData!(incomingData);

          if (interceptedData != null) {
            dataMap[key] = interceptedData;
          } else {
            dataMap[key] = incomingData;
          }

          update();
          streamsMap[key]!.onData != null
              ? streamsMap[key]!.onData!(dataMap[key])
              : onData(key, dataMap[key]);
        },
        onError: (error) {
          setErrorFor(key, error);
          dataMap[key] = null;

          streamsMap[key]?._onError != null
              ? streamsMap[key]!._onError!(error)
              : onError(key, error);
          update();
        },
      );
      streamsMap[key]!.onSubscribed != null
          ? streamsMap[key]!.onSubscribed!()
          : onSubscribed(key);
      changeSource = false;
    }
  }

  @override
  void notifySourceChanged({bool clearOldData = false}) {
    changeSource = true;
    _disposeAllSubscriptions();

    if (clearOldData) {
      dataMap.clear();
      clearErrors();
    }

    update();
  }

  void onData(Object key, dynamic data) {}

  void onSubscribed(Object key) {}

  void onCancel(Object key) {}

  dynamic transformData(Object key, data) {
    return data;
  }

  @override
  @mustCallSuper
  onClose() {
    _disposeAllSubscriptions();
    super.onClose();
  }

  void _disposeAllSubscriptions() {
    if (_streamsSubscriptions != null) {
      for (var key in _streamsSubscriptions!.keys) {
        _streamsSubscriptions![key]!.cancel();
        onCancel(key);
      }

      _streamsSubscriptions!.clear();
    }
  }
}

abstract class StreamGetController<T> extends _SingleDataSourceGetController<T>
    implements DynamicSourceGetController, Initializer {
  /// Stream to listen to
  Stream<T> get stream;

  StreamSubscription? get streamSubscription => _streamSubscription;

  StreamSubscription? _streamSubscription;

  @override
  void notifySourceChanged({bool clearOldData = false}) {
    changeSource = true;
    _streamSubscription?.cancel();
    _streamSubscription = null;

    if (clearOldData) {
      _data = null;
    }

    update();
  }

  @override
  Future beforeInit() => Future.value();

  @override
  Future initialise() async {
    _streamSubscription = stream.listen(
      (incomingData) {
        setError(null);
        _error = null;
        update();
        // Extra security in case transformData isnt sent
        var interceptedData = transformData(incomingData) ?? incomingData;

        if (interceptedData != null) {
          _data = interceptedData;
        } else {
          _data = incomingData;
        }

        onData(_data);
        update();
      },
      onError: (error) {
        setError(error);
        _error = error;
        _data = null;
        onError(null, error);
        update();
      },
    );

    onSubscribed();
    changeSource = false;
  }

  /// Called before the notifyListeners is called when data has been set
  void onData(T? data) {}

  /// Called when the stream is listened too
  void onSubscribed() {}

  void onCancel() {}

  /// Called before the data is set for the Controller
  T transformData(T data) {
    return data;
  }

  @override
  onClose() {
    _streamSubscription!.cancel();
    onCancel();

    super.onClose();
  }
}

class StreamData<T> extends _SingleDataSourceGetController<T> {
  Stream<T> stream;

  /// Called when the new data arrives
  ///
  /// notifyListeners is called before this so no need to call in here unless you're
  /// running additional logic and setting a separate value.
  Function? onData;

  /// Called after the stream has been listened too
  Function? onSubscribed;

  /// Called when an error is placed on the stream
  final Function? _onError;

  /// Called when the stream is cancelled
  Function? onCancel;

  /// Allows you to modify the data before it's set as the new data for the model
  ///
  /// This can be used to modify the data if required. If nothhing is returned the data
  /// won't be set.
  Function? transformData;

  StreamData(
    this.stream, {
    this.onData,
    this.onSubscribed,
    Function? onError,
    this.onCancel,
    this.transformData,
  }) : _onError = onError;

  late StreamSubscription _streamSubscription;

  void initialise() {
    _streamSubscription = stream.listen(
      (incomingData) {
        setError(null);
        _error = null;
        update();
        // Extra security in case transformData isnt sent
        var interceptedData =
            transformData == null ? incomingData : transformData!(incomingData);

        if (interceptedData != null) {
          _data = interceptedData;
        } else {
          _data = incomingData;
        }

        update();
        onData!(_data);
      },
      onError: (error) {
        setError(error);
        _data = null;
        _onError!(error);
        update();
      },
    );

    onSubscribed!();
  }

  @override
  onClose() {
    _streamSubscription.cancel();
    onCancel!();

    super.onClose();
  }
}

/// Interface: Additional actions that should be implemented by specialised Controllers
abstract class Initializer {
  Future initialise();

  Future beforeInit();
}

class IndexTrackingGetController extends BaseGetController {
  final RxInt _currentIndex = 0.obs;

  int get currentIndex => _currentIndex.value;

  final RxBool _reverse = false.obs;

  /// Indicates whether we're going forward or backward in terms of the index we're changing.
  /// This is very helpful for the page transition directions.
  bool get reverse => _reverse.value;

  void setIndex(int value) {
    if (value < _currentIndex.value) {
      _reverse.value = true;
    } else {
      _reverse.value = false;
    }
    _currentIndex.value = value;
    update();
  }

  bool isIndexSelected(int index) => _currentIndex.value == index;
}
