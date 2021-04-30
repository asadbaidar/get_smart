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

  bool get isSucceeded => _isSucceeded ?? false;

  String get message => _message ?? "Connection failed.";

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
  List<Function> get builders => [() => GetResult<T>()];

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
  Future<GetResult<T>?> get<T>({
    T Function()? builder,
    List<Function>? builders,
    String? path,
    Map<String, dynamic>? parameters,
  }) {
    return request<T>(
      builder: builder,
      builders: builders,
      path: path,
      method: GetMethod.get,
      parameters: parameters,
    );
  }

  Future<GetResult<T>?> post<T>({
    T Function()? builder,
    List<Function>? builders,
    bool encrypted = false,
    String? path,
    Map<String, dynamic>? parameters,
  }) {
    return request<T>(
      builder: builder,
      builders: builders,
      encrypted: encrypted,
      path: path,
      method: GetMethod.post,
      parameters: parameters,
    );
  }

  Future<GetResult<T>?> delete<T>({
    T Function()? builder,
    List<Function>? builders,
    String? path,
    Map<String, dynamic>? parameters,
  }) {
    return request<T>(
      builder: builder,
      builders: builders,
      path: path,
      method: GetMethod.delete,
      parameters: parameters,
    );
  }

  void download<T>({
    String? path,
    String? name,
    Map<String, dynamic>? parameters,
  }) =>
      throw UnimplementedError();

  static const currentTime = "CURRENT_TIME";
  static const timeStamp = "DATE_TIME_";

  FutureOr<String> get address;

  String? get path => null;

  FutureOr<String> get authToken => GetCipher.instance.authToken;

  var _cancelToken = CancelToken();

  void cancel() => _cancelToken.cancel();

  Future<GetResult<T>?> request<T>({
    T Function()? builder,
    List<Function>? builders,
    bool encrypted = false,
    String? path,
    GetMethod? method,
    Map<String, dynamic>? parameters,
  }) async =>
      scheduleTask(() async {
        var dio = Dio();
        try {
          dio.interceptors.add(LogInterceptor(
            requestBody: true,
            responseBody: true,
          ));
          dio.options
            ..baseUrl = await address
            ..connectTimeout = 30000
            ..receiveTimeout = 60000
            ..method = method!.keyNAME
            ..headers = {
              "auth": await authToken,
            }
            ..validateStatus = (status) => status == 200;
          _cancelToken = CancelToken();
          if (encrypted)
            await Future.forEach(
              parameters!.keys,
              (dynamic key) async =>
                  parameters[key] = await parameters[key]?.toString().encrypted,
            );
          DIO.Response response = await dio.request(
            path!.pre(this.path?.post("/"))!,
            queryParameters: method == GetMethod.post ? null : parameters,
            data: parameters,
            cancelToken: _cancelToken,
          );
          return $object(response.data)?.getObject<GetResult<T>>(
            builders: [
              if (builder != null) builder,
              () => GetResult<T>(),
              ...(builders ?? [])
            ],
          );
        } on DioError catch (e) {
          return GetResult<T>.dio(e.type);
        } catch (e) {
          return GetResult<T>.error(e.toString());
        } finally {
          dio.close();
        }
      });
}

class GetIsolate {
  GetIsolate._();

  static late GetIsolate instance;

  static Future<void> spawn() async {
    instance = GetIsolate._();
    await instance.init();
  }

  late Isolate _isolate;
  late SendPort _sendPort;
  late ReceivePort _receivePort;
  Map<String?, Completer> completer = {};

  Future<GetResult<T>> parseJson<T>({String? key, T? as}) async {
    final _completer = completer[key] = Completer<GetResult<T>>();
    _sendPort.send(IsolateParcel<T>(key: key, mappable: as));
    return _completer.future.then((result) {
      print("parseJson $result");
      completer.remove(key);
      return result;
    }).catchError((e) {
      print(e);
      return GetResult<T>.error(e.toString());
    });
  }

  Future<void> init() async {
    Completer _completer = Completer<SendPort>();
    _receivePort = ReceivePort();
    _receivePort.listen((data) {
      if (data is SendPort) {
        print('[init] $data');
        SendPort mainToIsolatePort = data;
        _completer.complete(mainToIsolatePort);
      } else if (data is IsolateParcel) {
        print('[isolateToMainPort] $data');
        completer[data.key]?.complete(data.result);
      }
    });
    _isolate = await Isolate.spawn(_isolateEntry, _receivePort.sendPort);
    _sendPort = await _completer.future;
  }

  static void _isolateEntry(SendPort sendPort) {
    ReceivePort receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);

    receivePort.listen((data) {
      print('[receivePort] $data');
      if (data is IsolateParcel) {
        final result = parseData(data.result, data.mappable);
        if (result != null) data.result = result;
        sendPort.send(data);
      }
    });
  }

  void kill() {
    _receivePort.close();
    _isolate.kill();
  }
}

class IsolateParcel<T> {
  IsolateParcel({this.key, this.mappable});

  final String? key;
  final T? mappable;
  GetResult<T> result = GetResult<T>();

  @override
  String toString() {
    return (key ?? "") +
        "\n" +
        (mappable?.toString() ?? "") +
        "\n" +
        result.toString();
  }
}

T? parseData<T>(T as, Mappable mappable) {
  return "".getObject<T>(as: as, builders: mappable.builders);
}
