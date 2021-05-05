import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_smart/get_smart.dart';

class GetResult<T> extends GetObject {
  GetResult();

  GetResult.success([String? message])
      : _message = message,
        _isSucceeded = true;

  GetResult.error([String? message]) : _message = message;

  GetResult.dio([this.dioError]);

  @override
  List<Function> get builders => [() => GetResult<T>()];

  DioErrorType? dioError;
  String? _tag;
  bool? _isSucceeded;
  String? _message;
  T? value;
  List<T>? list;

  // ?? (T.toString() == "dynamic" ? isSucceeded : null);

  get data => list ?? value;

  T? get firstValue => list?.$first;

  String get tag => _tag ?? typeName;

  set tag(v) => _tag = v;

  bool get isSucceeded => _isSucceeded ?? false;

  set isSucceeded(v) => _isSucceeded = v;

  String get message => _message ?? "Connection failed.";

  set message(v) => _message = v;

  String? get error => isSucceeded ? null : message;

  String? get success => isSucceeded ? message : null;

  GetStatus get status => isCanceled
      ? GetStatus.canceled
      : isSucceeded
          ? GetStatus.succeeded
          : GetStatus.failed;

  /// Returns if canceled or not
  bool get isCanceled => dioError == DioErrorType.cancel;

  /// Returns if failed or not
  bool get isFailed => !isSucceeded;

  @override
  void mapping(Mapper map) {
    map(["tag"], (v) => _tag ??= v);
    map(["status", "success"], (v) => _isSucceeded ??= v);
    map(["msg", "message"], (v) => _message ??= v);
    map.$<T>(["result"], data, (v) {
      if (v is List)
        list = v as List<T>?;
      else
        value = v;
    });
  }

  @override
  String toString() => toJsonString();
}

enum GetMethod { get, post, delete }

enum GetStatus {
  busy,
  succeeded,
  failed,
  canceled,
}

abstract class GetWebAPI {
  Future<GetResult<T>> get<T>({
    T? as,
    required String path,
    bool encrypted = false,
    bool inIsolate = true,
    Map<String, dynamic> parameters = const {},
  }) =>
      request<T>(
        as: as,
        path: path,
        method: GetMethod.get,
        encrypted: encrypted,
        inIsolate: inIsolate,
        parameters: parameters,
      );

  Future<GetResult<T>> post<T>({
    T? as,
    required String path,
    bool encrypted = false,
    bool inIsolate = true,
    Map<String, dynamic> parameters = const {},
  }) =>
      request<T>(
        as: as,
        path: path,
        method: GetMethod.post,
        encrypted: encrypted,
        inIsolate: inIsolate,
        parameters: parameters,
      );

  Future<GetResult<T>> delete<T>({
    T? as,
    required String path,
    bool encrypted = false,
    bool inIsolate = true,
    Map<String, dynamic> parameters = const {},
  }) =>
      request<T>(
        as: as,
        path: path,
        method: GetMethod.delete,
        encrypted: encrypted,
        inIsolate: inIsolate,
        parameters: parameters,
      );

  download<T>({
    required String path,
    String? name,
    Map<String, dynamic> parameters = const {},
  }) =>
      throw UnimplementedError();

  static const currentTime = "CURRENT_TIME";
  static const timeStamp = "DATE_TIME_";

  GetWebAPI() : _id = Date.now.inMilliseconds.toString();

  final String _id;

  String get id => typeName + _id;

  FutureOr<String> get address;

  String? get path => null;

  FutureOr<String> get authToken => GetCipher.instance.authToken;

  void cancel() {
    _cancelTokens.remove(id)?.cancel();
    isolate?.cancelRequest(id);
  }

  Future<GetResult<T>> request<T>({
    T? as,
    required String path,
    required GetMethod method,
    bool encrypted = false,
    bool inIsolate = true,
    Map<String, dynamic> parameters = const {},
  }) async =>
      scheduleTask(() async {
        try {
          if (encrypted)
            await Future.forEach(
              parameters.keys,
              (dynamic key) async =>
                  parameters[key] = await parameters[key]?.toString().encrypted,
            );
          var parcel = _RequestParcel<T, GetResult<T>>(
            id: id,
            address: await address,
            path: path.pre(this.path?.post("/")) ?? "",
            method: method,
            result: GetResult<T>(),
            builder: as,
            authToken: await authToken,
            parameters: parameters,
          );
          return inIsolate && isolate != null
              ? isolate!.httpRequest(parcel)
              : _parcelRequest(parcel);
        } catch (e) {
          return GetResult<T>.error(e.toString());
        }
      });

  static Future<R> _parcelRequest<T, R>(_RequestParcel<T, R> parcel) =>
      _httpRequest<R>(
        result: parcel.result,
        id: parcel.id,
        address: parcel.address,
        path: parcel.path,
        method: parcel.method,
        authToken: parcel.authToken,
        builder: parcel.builder,
        parameters: parcel.parameters,
      );

  static Map<String, CancelToken> _cancelTokens = {};

  static Future<T> _httpRequest<T>({
    required String id,
    required String address,
    required String path,
    required GetMethod method,
    required String authToken,
    required T result,
    Object? builder,
    Map<String, dynamic> parameters = const {},
  }) async {
    Dio? dio;
    final getResult = $cast<Mappable>(result)!.builders.first;
    try {
      dio = Dio();
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
      dio.options
        ..baseUrl = address
        ..connectTimeout = 30000
        ..receiveTimeout = 60000
        ..method = method.keyNAME
        ..headers = {
          "auth": authToken,
        }
        ..validateStatus = (status) => status == 200;
      final cancelToken = _cancelTokens[id] = CancelToken();
      print("Request ID $id");
      DIO.Response response = await dio.request(
        path,
        queryParameters: method == GetMethod.post ? null : parameters,
        data: method == GetMethod.get ? null : parameters,
        cancelToken: cancelToken,
      );
      return $object(response.data)?.getObject<T>(
            as: result,
            builders: $cast<Mappable>(builder)?.builders,
          ) ??
          getResult();
    } on DioError catch (e) {
      return getResult()..dioError = e.type;
    } catch (e) {
      return getResult()..message = e.toString();
    } finally {
      dio?.close();
      _cancelTokens.remove(id);
    }
  }
}

class _RequestCancel {
  _RequestCancel(this.id);

  final String id;

  @override
  String toString() => "$typeName: " + {"id": id}.toString();
}

class _RequestParcel<T, R> {
  _RequestParcel({
    required this.id,
    required this.address,
    required this.path,
    required this.method,
    required this.authToken,
    required this.result,
    this.builder,
    this.parameters = const {},
  });

  final String id;
  final String address;
  final String path;
  final GetMethod method;
  final String authToken;
  R result;
  final T? builder;
  final Map<String, dynamic> parameters;

  String get key => authToken;

  @override
  String toString() =>
      "$typeName: " +
      {
        "id": id,
        "address": address,
        "path": path,
        "method": method,
        "authToken": authToken,
        "parameters": parameters,
        "builder": builder?.toString(),
        "result": result.toString(),
      }.toString();
}

GetIsolate? get isolate => GetIsolate.instance;

class GetIsolate {
  GetIsolate._();

  static GetIsolate? instance;

  static Future<void> spawn() async {
    instance = GetIsolate._();
    await instance?.init();
    if (instance?._isolate == null) {
      instance?.dispose();
      instance = null;
    }
  }

  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;
  Map<String?, Completer> completer = {};

  Future<R> httpRequest<T, R>(_RequestParcel<T, R> parcel) async {
    final _completer = completer[parcel.key] = Completer<R>();
    _sendPort?.send(parcel);
    return _completer.future.then((result) {
      print("RequestParcel $result");
      completer.remove(parcel.key);
      return result;
    }).catchError((e) {
      completer.remove(parcel.key);
      print(e);
      return GetResult<T>.error(e.toString()) as R;
    });
  }

  void cancelRequest(String id) => _sendPort?.send(_RequestCancel(id));

  Future<void> init() async {
    Completer _completer = Completer<SendPort>();
    _receivePort = ReceivePort();
    _receivePort?.listen((data) {
      try {
        if (data is SendPort) {
          print("[MainPort] init: $data");
          SendPort isolatePort = data;
          _completer.complete(isolatePort);
        } else if (data is _RequestParcel) {
          print("[MainPort] request: $data");
          completer[data.key]?.complete(data.result);
        }
      } catch (e) {
        print("[MainPort] Error: $e");
      }
    });
    await Isolate.spawn(
      _isolateEntry,
      _receivePort?.sendPort,
      errorsAreFatal: false,
    ).then((value) {
      _isolate = value;
      return value;
    }).catchError((e) {
      print(e);
    });
    await _completer.future.then((value) {
      _sendPort = value;
      return value;
    }).catchError((e) {
      print(e);
    });
  }

  static void _isolateEntry(SendPort? sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort?.send(receivePort.sendPort);
    receivePort.listen((parcel) async {
      try {
        print("[IsolatePort] $parcel");
        if (parcel is _RequestParcel) {
          sendPort?.send(
            parcel..result = await GetWebAPI._parcelRequest(parcel),
          );
        } else if (parcel is _RequestCancel) {
          GetWebAPI._cancelTokens.remove(parcel.id)?.cancel();
        }
      } catch (e) {
        print("[IsolatePort] Error: $e");
      }
    });
  }

  void dispose() {
    _receivePort?.close();
    _isolate?.kill();
    _isolate = null;
    _sendPort = null;
    _receivePort = null;
  }
}
