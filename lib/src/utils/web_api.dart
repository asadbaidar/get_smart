import 'dart:async';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:get_smart/get_smart.dart';

class GetResult<T> extends GetObject {
  GetResult();

  GetResult.dio([this.dioError]);

  GetResult.error([String? message]) : message = message;

  GetResult.success([String? message])
      : message = message,
        isSucceeded = true;

  DioErrorType? dioError;

  String tag = "Connection";
  bool isSucceeded = false;
  String? message = "Connection failed.";
  T? value;
  List<T>? list;

  // ?? (T.toString() == "dynamic" ? isSucceeded : null);

  get data => list ?? value;

  T? get firstValue => list?.$first;

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
    map(["tag"], tag, (v) => tag = v ?? "Connection");
    map(["status", "success"], isSucceeded, (v) => isSucceeded = v ?? false);
    map(["msg", "message"], message,
        (v) => message = v ?? "Connection failed.");
    map<T>(["result"], data, (v) {
      if (v is List) {
        list = v as List<T>?;
      } else {
        value = v;
      }
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
    List<Object Function()>? builders,
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
    List<Object Function()>? builders,
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
    List<Object Function()>? builders,
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
    List<Object Function()>? builders,
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
