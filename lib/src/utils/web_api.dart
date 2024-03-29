import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:get_smart/get_smart.dart';

typedef GetFormData = dio.FormData;
typedef GetResponse<T> = dio.Response<T>;
typedef GetMultipartFile = dio.MultipartFile;

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

  @override
  bool get isEmpty =>
      (list?.isEmpty ?? true) &&
      value == null &&
      ($cast<GetObject>(value)?.isEmpty ?? true);

  get data => list ?? value;

  T? get firstValue => list?.firstOrNull;

  T? get successValue => isSucceeded ? value : null;

  get successData => isSucceeded ? data : null;

  T? get successFirstValue => isSucceeded ? firstValue : null;

  DateTime get time => currentTime!;

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
    map(["time"], (v) => currentTime ??= v, DateTransform(fallback: Date.now));
    map(["status", "success"], (v) => _isSucceeded ??= v);
    map(["msg", "message"], (v) => _message ??= v);
    map.$<T>(["result"], data, (v) {
      if (v is List) {
        list = v as List<T>?;
      } else {
        value = v;
      }
    });
  }

  @override
  String toString() => jsonString;
}

enum GetMethod {
  get,
  post,
  delete,
}

enum GetStatus {
  busy,
  succeeded,
  failed,
  canceled,
}

extension GetStatusX on GetStatus {
  bool get isBusy => this == GetStatus.busy;

  bool get isSucceeded => this == GetStatus.succeeded;

  bool get isFailed => this == GetStatus.failed;

  bool get isCanceled => this == GetStatus.canceled;
}

abstract class GetWebAPI {
  Future<GetResult<T>> get<T>({
    T? as,
    required String path,
    bool encrypted = false,
    bool inIsolate = true,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) =>
      request<T>(
        as: as,
        path: path,
        method: GetMethod.get,
        encrypted: encrypted,
        inIsolate: inIsolate,
        query: query,
        body: body,
      );

  Future<GetResult<T>> post<T>({
    T? as,
    required String path,
    bool encrypted = false,
    bool inIsolate = true,
    List<GetFile>? files,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) =>
      request<T>(
        as: as,
        path: path,
        method: GetMethod.post,
        encrypted: encrypted,
        inIsolate: inIsolate,
        files: files,
        query: query,
        body: body,
      );

  Future<GetResult<T>> delete<T>({
    T? as,
    required String path,
    bool encrypted = false,
    bool inIsolate = true,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) =>
      request<T>(
        as: as,
        path: path,
        method: GetMethod.delete,
        encrypted: encrypted,
        inIsolate: inIsolate,
        query: query,
        body: body,
      );

  download<T>({
    required String path,
    String? name,
    String? description,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) =>
      throw UnimplementedError();

  static const currentTime = "CURRENT_TIME";
  static const timeStamp = "DATE_TIME_";
  static const auth = "auth";

  GetWebAPI() : _id = Date.now.inMilliseconds.toString();

  final String _id;

  String get id => typeName + _id;

  FutureOr<String> get address;

  String? get path => null;

  FutureOr<String> get authToken => GetCipher.instance.authToken;

  FutureOr<Map<String, String>> get headers async => {auth: await authToken};

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
    List<GetFile>? files,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) async =>
      scheduleTask(() async {
        try {
          if (encrypted) {
            await Future.forEach(
              query.keys,
              (dynamic key) async =>
                  query[key] = await query[key]?.toString().encrypted,
            );
            await Future.forEach(
              body.keys,
              (dynamic key) async =>
                  body[key] = await body[key]?.toString().encrypted,
            );
          }
          var parcel = GetRequestParcel<T, GetResult<T>>(
            id: id,
            address: await address,
            path: path.pre(this.path, between: "/"),
            method: method,
            result: GetResult<T>(),
            builder: as,
            authToken: await authToken,
            files: files,
            query: query,
            body: body,
          );
          return inIsolate && isolate != null
              ? isolate!.httpRequest(parcel)
              : _parcelRequest(parcel);
        } catch (e) {
          return GetResult<T>.error(e.toString());
        }
      });

  static Future<R> _parcelRequest<T, R>(GetRequestParcel<T, R> parcel) =>
      _httpRequest<R>(
        result: parcel.result,
        id: parcel.id,
        address: parcel.address,
        path: parcel.path,
        method: parcel.method,
        authToken: parcel.authToken,
        builder: parcel.builder,
        files: parcel.files,
        query: parcel.query,
        body: parcel.body,
      );

  static final Map<String, CancelToken> _cancelTokens = {};

  static Future<T> _httpRequest<T>({
    required String id,
    required String address,
    required String path,
    required GetMethod method,
    required String authToken,
    required T result,
    Object? builder,
    List<GetFile>? files,
    Map<String, dynamic> query = const {},
    Map<String, dynamic> body = const {},
  }) async {
    Dio? dio;
    final getResult = $cast<Mappable>(result)!.builders.first;
    try {
      dio = Dio();
      dio.interceptors.add(LogInterceptor(
        requestBody: true,
        responseBody: true,
      ));
      final isMultipart = files != null;
      dio.options
        ..baseUrl = address
        ..connectTimeout = 30000
        ..receiveTimeout = 60000
        ..validateStatus = (status) => status == 200;
      final cancelToken = _cancelTokens[id] = CancelToken();
      query = query.replaceNullWithEmpty;
      body = body.replaceNullWithEmpty;
      $logDebug(id, "Request ID", GetWebAPI);
      GetResponse response = await dio.request(
        path,
        queryParameters: query,
        data: isMultipart
            ? GetFormData.fromMap({
                "data": body.jsonString,
                "files": await GetFile.toMultipart(files),
              })
            : body,
        options: Options(
          method: method.nameCAP,
          contentType: isMultipart ? "multipart/form-data" : null,
          headers: {auth: authToken},
        ),
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

class GetRequestCancel {
  GetRequestCancel(this.id);

  final String id;

  @override
  String toString() => "$typeName: ${{"id": id}}";
}

class GetRequestParcel<T, R> {
  GetRequestParcel({
    required this.id,
    required this.address,
    required this.path,
    required this.method,
    required this.authToken,
    required this.result,
    this.builder,
    this.files,
    this.query = const {},
    this.body = const {},
  });

  final String id;
  final String address;
  final String path;
  final GetMethod method;
  final String authToken;
  R result;
  final T? builder;
  final List<GetFile>? files;
  final Map<String, dynamic> query;
  final Map<String, dynamic> body;

  String get key => id + path + authToken;

  @override
  String toString() => "$typeName: ${{
        "id": id,
        "address": address,
        "path": path,
        "method": method,
        "authToken": authToken,
        "files": files,
        "query": query,
        "body": body,
        "builder": builder?.typeName,
        "result": result.toString(),
      }}";
}

class GetIsolateEntry {
  GetIsolateEntry(this.sendPort);

  final dynamic sendPort;

  @override
  String toString() => "$typeName: ${{"sendPort": sendPort}}";
}

GetIsolate? get isolate => GetIsolate.instance;

class GetIsolate {
  static GetIsolate? instance;

  static Future<void> spawn(GetIsolate isolate) async {
    instance = isolate;
    await instance?.init();
    if (instance?.mIsolate == null) {
      instance?.dispose();
      instance = null;
    }
  }

  dynamic mIsolate;
  dynamic sendPort;
  dynamic receivePort;
  Map<String?, Completer> completer = {};

  Future<R> httpRequest<T, R>(GetRequestParcel<T, R> parcel) async {
    final _completer = completer[parcel.key] = Completer<R>();
    sendPort?.send(parcel);
    return _completer.future.then((result) {
      $debugPrint("RequestParcel: $result");
      completer.remove(parcel.key);
      return result;
    }).catchError((e) {
      completer.remove(parcel.key);
      $debugPrint("RequestError: $e");
      return GetResult<T>.error(e.toString()) as R;
    });
  }

  void cancelRequest(String id) => sendPort?.send(GetRequestCancel(id));

  void onMain(data, Completer _completer) {
    try {
      if (data is GetIsolateEntry) {
        $debugPrint("init: $data", "MainPort");
        final isolatePort = data.sendPort;
        _completer.complete(isolatePort);
      } else if (data is GetRequestParcel) {
        $debugPrint(data.typeName, "MainPort");
        completer[data.key]?.complete(data.result);
      }
    } catch (e) {
      $debugPrint("Error: $e", "MainPort");
    }
  }

  Future<void> init() async {}

  static Future<void> onIsolate(data, sendPort) async {
    try {
      $logDebug("$sendPort: $data", "IsolatePort", GetIsolate);
      if (data is GetRequestParcel) {
        sendPort?.send(
          data..result = await GetWebAPI._parcelRequest(data),
        );
      } else if (data is GetRequestCancel) {
        GetWebAPI._cancelTokens.remove(data.id)?.cancel();
      }
    } catch (e) {
      $logDebug("Error: $e", "IsolatePort", GetIsolate);
    }
  }

  void dispose() {
    receivePort?.close();
    mIsolate?.kill();
    mIsolate = null;
    sendPort = null;
    receivePort = null;
  }
}
