import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_smart/src/res/texts.dart';
import 'package:get_stacked/get_stacked.dart';
import 'package:intl/intl.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

extension UrlExt on String {
  void launchUrl({bool inApp = false}) async {
    var url = startsWith(RegExp("^(http|https)://")) ? this : "http://$this";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: inApp,
        forceWebView: inApp,
      );
    }
  }
}

extension MediaQueryX on MediaQueryData {
  /// Return true if the screen has tall mobile view size
  bool get isScreenMini => size.width < 300;

  /// Return true if the screen has mobile view size
  bool get isScreenSmall => size.width < 600;

  /// Return true if the screen has tablet view size
  bool get isScreenMedium => size.width > 600 && size.width < 990;

  /// Return true if the screen has desktop view size
  bool get isScreenLarge => size.width > 990;
}

extension TextStyleX on TextStyle {
  TextStyle get underlined => apply(decoration: TextDecoration.underline);

  TextStyle get italic => apply(fontStyle: FontStyle.italic);

  TextStyle get bold => apply(fontWeightDelta: 1);
}

extension ListX<E> on List<E> {
  E get takeFirst {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }
}

extension ObjectX on Object {
  T applyIf<T>(bool condition, T Function(T) apply) {
    return (condition == true) ? apply(this) : this;
  }

  T let<T>(T Function(dynamic) apply) {
    return apply(this);
  }

  T applyFor<T>(int times, T Function(T) apply) {
    var value = this;
    (times ?? 0).repeatsFor(() {
      value = apply(value);
    });
    return value;
  }

  Future get future => Future.value(this);

  String get keyName => toString().split('.').last;

  String get keyNAME => keyName.toUpperCase();

  String get rawName => toString();

  String get rawNAME => rawName.toUpperCase();

  String get typeName => nameOf(runtimeType);

  T toWebObject<T>([List<Object Function()> builders]) {
    return MapperX.fromData(this).toWebObject<T>(builders);
  }
}

extension Int on int {
  void repeatsFor<T>(Function apply) {
    if (this > 0)
      for (int i = 0; i < this; i++) {
        apply();
      }
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(this);

  String get formatted => GET.formatter.formatDecimal(this);
}

extension StringX on String {
  String pre(String pre, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && pre != null ? doFor : 0,
      (s) => pre + s,
    );
  }

  String post(String post, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && post != null ? doFor : 0,
      (s) => s + post,
    );
  }

  String surround(String surround, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && surround != null ? doFor : 0,
      (s) => s.pre(surround).post(surround),
    );
  }

  String get notEmpty => isEmpty ? null : this;

  bool get isNotBlank => !isBlank;

  bool equalsIgnoreCase(String s) => toLowerCase() == s?.toLowerCase();

  String take(int count) => characters.take(count).toString();

  String takeWhile(bool Function(String) predicate) =>
      characters.takeWhile(predicate).toString();

  String takeLast(int count) => characters.takeLast(count).toString();

  String takeLastWhile(bool Function(String) predicate) =>
      characters.takeLastWhile(predicate).toString();

  Color get materialPrimary => Colors.primaries[Random(hashCode).nextInt(17)];

  Color get materialAccent => Colors.accents[Random(hashCode).nextInt(15)];

  bool isPasswordStrong({int min = 8}) {
    if (isBlank) return false;

    bool hasUppercase = contains(RegExp(r'[A-Z]'));
    bool hasLowercase = contains(RegExp(r'[a-z]'));
    bool hasDigits = contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasNoWhitespace = !contains(RegExp(r'[\s]'));
    bool hasMinLength = length >= min;

    return hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialCharacters &&
        hasNoWhitespace &&
        hasMinLength;
  }

  /// Capitalize each word inside string
  /// Example: your name => Your Name, your name => Your name
  String get capitalized {
    return isBlank
        ? ""
        : length == 1
            ? toUpperCase()
            : split(' ').map((s) => s.capitalizedFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  String get capitalizedFirst {
    return isBlank
        ? ""
        : length == 1
            ? toUpperCase()
            : this[0].toUpperCase() + substring(1).toLowerCase();
  }

  bool get boolYN => toUpperCase() == "Y";

  Future<String> get encrypted async => await Cipher.encrypt(this);

  Future<String> get decrypted async => await Cipher.decrypt(this);

  get json => jsonDecode(this);
}

extension Bool on bool {
  String get stringYN => this ? "Y" : "N";
}

class BoolTransform implements Transformable<bool, String> {
  BoolTransform({this.fallback = false});

  final fallback;

  @override
  bool fromJson(value) {
    try {
      if (value == null) return fallback;
      if (value is bool) return value;
      if (value is String) return value.boolYN;
      return fallback;
    } catch (e) {
      return fallback;
    }
  }

  @override
  String toJson(bool value) {
    if (value == null) return fallback.stringYN;
    return value.stringYN;
  }
}

extension Date on DateTime {
  static DateTime from({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
    TimeOfDay timeOfDay,
  }) {
    final now = Date.now;
    return DateTime(
      year ?? now.year,
      month ?? now.month,
      day ?? now.day,
      hour ?? timeOfDay?.hour ?? now.hour,
      minute ?? timeOfDay?.minute ?? now.minute,
      second ?? now.second,
      millisecond ?? now.millisecond,
      microsecond ?? now.microsecond,
    );
  }

  DateTime setting({
    int year,
    int month,
    int day,
    int hour,
    int minute,
    int second,
    int millisecond,
    int microsecond,
    TimeOfDay timeOfDay,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? timeOfDay?.hour ?? this.hour,
      minute ?? timeOfDay?.minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  static DateTime get now => DateTime.now();

  String get formatDMMMy => DateFormat("dd-MMM-yyyy").format(this);

  String get formatEMMMdy => DateFormat.yMMMEd().format(this);

  String get formatEEEEMMMMdy => DateFormat.yMMMMEEEEd().format(this);

  String get formatEMMMdyHma => "$formatEMMMdy, $formatHma";

  String get formatEEEEMMMMdyHma => "$formatEEEEMMMMdy, $formatHma";

  String get formatMMMMdy => DateFormat.yMMMMd().format(this);

  String get formatMMMMd => DateFormat.MMMMd().format(this);

  String get formatMMMd => DateFormat.MMMd().format(this);

  String get formatMMMdy => DateFormat.yMMMd().format(this);

  String get formatHma => DateFormat("h:mm a").format(this);

  int get inMilliseconds => millisecondsSinceEpoch;

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(this);

  DateTime get endOfDay => setting(
        hour: 23,
        minute: 59,
        millisecond: 0,
        microsecond: 0,
      );

  String get webTimeStamp => WebAPI.timeStamp + inMilliseconds.toString();
}

Future<void> openTimePicker(
  BuildContext context, {
  DateTime withTime,
  TimePickerEntryMode entryMode,
  String cancelText,
  String confirmText,
  String helpText,
  Function(DateTime time) onPick,
}) async {
  var time = await showTimePicker(
    context: context,
    initialEntryMode: entryMode ?? TimePickerEntryMode.input,
    cancelText: cancelText,
    confirmText: confirmText,
    helpText: helpText,
    initialTime: withTime?.timeOfDay ?? TimeOfDay.now(),
  );
  onPick(withTime?.setting(timeOfDay: time) ?? Date.from(timeOfDay: time));
}

String nameOf(Type type) => type.toString();

String routeOf(Type type) => "/" + nameOf(type);

extension TextInputTypeX on TextInputType {
  static TextInputType get numberFirst => Platform.isIOS
      ? TextInputType.numberWithOptions(
          signed: true,
        )
      : TextInputType.visiblePassword;
}

extension TextInputFilter on TextInputFormatter {
  static List<TextInputFormatter> get phone => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r"^(\+?)[0-9]*"),
        )
      ];

  static List<TextInputFormatter> get numberOnly => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9]'),
        )
      ];

  static TextInputFormatter get notEmpty =>
      FilteringTextInputFormatter.deny(RegExp(r"^(\s)"));

  static TextInputFormatter get noWhitespace =>
      FilteringTextInputFormatter.deny(RegExp(r'[\s]'));

  static List<TextInputFormatter> get numberAndDash => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r"^[0-9]*?\d{1}-|[0-9]*"),
        )
      ];

  static List<TextInputFormatter> get mrNumber => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r'[WANwan-]|[0-9]'),
        )
      ];
}

extension Double on double {
  double get half => this * 0.5;

  double get oneHalf => this * 1.5;

  double get twice => this * 2;

  double get radius => this * 0.2237;

  BorderRadius get circular => BorderRadius.circular(radius);

  BoxDecoration circularDecoration({Color color}) => BoxDecoration(
        borderRadius: circular,
        color: color,
      );

  String get formatted => GET.formatter.formatDecimal(toInt());
}

Future<T> scheduleTask<T>(T Function() task) {
  return SchedulerBinding.instance.scheduleTask(task, Priority.animation);
}

Future<T> profileTask<T>(Future<T> Function() task) async {
  var time = Date.now.inMilliseconds;
  print("${T.toString()}: Started task");
  var result = await task();
  print("${T.toString()}: Finished task "
      "in ${Date.now.inMilliseconds - time}ms.");
  return result;
}

class AppPlatform {
  static const channel = const MethodChannel("org.skm.app_flutter");

  static void setup() {
    channel.setMethodCallHandler((call) async {
      switch (call.method) {
        case "navigateTo":
          var route = call.arguments.toString();
          if (Get.currentRoute != route)
            Get.offAllNamed(call.arguments.toString());
          break;
      }
      return null;
    });
  }

  static Future<T> invokeMethod<T>(
    String method, {
    dynamic arguments,
    dynamic fallback,
  }) async {
    try {
      return await channel.invokeMethod(method, arguments);
    } on Exception {
      return fallback;
    }
  }
}

class Cipher {
  static Future<String> decrypt(String data) async {
    return await AppPlatform.invokeMethod(
      "decrypt",
      arguments: data ?? "",
      fallback: data ?? "",
    );
  }

  static Future<String> encrypt(String data) async {
    return await AppPlatform.invokeMethod(
      "encrypt",
      arguments: data ?? "",
      fallback: data ?? "",
    );
  }

  static Future<String> get authToken async {
    return await AppPlatform.invokeMethod("authToken", fallback: "");
  }
}

extension MapperX on Mapper {
  dynamic all<T>(
    List<String> fields,
    dynamic value,
    MappingSetter setter, [
    Transformable transform,
  ]) {
    this<T>(
      fields.firstWhere(
        (it) => this.json[it] != null,
        orElse: () => fields.takeFirst ?? "",
      ),
      value,
      setter,
      transform,
    );
  }

  dynamic to<T>(
    WebMappable object,
    dynamic value,
    MappingSetter setter,
  ) {
    var newValue = (value ?? object)..mapping(this);
    if (value == null) setter(newValue);
  }

  static Mapper fromData(data) => Mapper.fromJson(
        data is String
            ? data.json
            : data is Map<dynamic, dynamic>
                ? data.map((key, value) => MapEntry(key, value))
                : data,
      );

  T toWebObject<T>([List<Object Function()> builders]) {
    builders?.forEach((builder) {
      Mappable.factories.putIfAbsent(builder().runtimeType, () => builder);
    });
    print(Mappable.factories);
    final object = toObject<T>();
    print(object);
    builders?.forEach((builder) {
      Mappable.factories.remove(builder().runtimeType);
    });
    return object;
  }
}

abstract class WebMappable with Mappable {
  DateTime currentTime;
  String _id;
  String _description;

  String get id => _id ?? idFallback ?? "";

  set id(String id) => _id = id;

  String get description => _description ?? descriptionFallback ?? "";

  set description(String description) => _description = description;

  String get idFallback => null;

  String get descriptionFallback => null;

  List<String> get idKeys => ["ID"];

  List<String> get descriptionKeys => ["DESCRIPTION"];

  bool get capitalized => false;

  @override
  void mapping(Mapper map) {
    map("CURRENT_TIME", currentTime, (v) => currentTime = v ?? Date.now,
        DateTransform());
    map.all(idKeys, _id, (v) => _id = v?.toString());
    map.all(
      descriptionKeys,
      _description,
      (v) => _description =
          v?.toString()?.applyIf(capitalized, (s) => s.capitalized),
    );
  }

  Future get decrypted async {
    id = await id.decrypted;
    description = await description.decrypted;
    return this;
  }

  get builders => [];

  @override
  String toString() => description;
}

class AppTileData extends WebMappable {
  AppTileData({
    this.icon,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.subTiles,
    this.color,
    this.isDetailed,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailingTop;
  final String trailingBottom;
  final List<AppTileData> subTiles;
  final Color color;
  final bool isDetailed;
  final Function onTap;
}

class WebResponse<T> extends WebMappable {
  WebResponse({this.errorType});

  final DioErrorType errorType;

  String tag = "Connection";
  bool success = false;
  String message = "Connection failed.";
  T _result;
  List<T> results;

  T get result => _result ?? (T.toString() == "dynamic" ? isSucceeded : null);

  set result(value) => _result = value;

  get data => results ?? result;

  String get error => isSucceeded ? null : message;

  WebStatus get status => isCanceled
      ? WebStatus.canceled
      : isSucceeded
          ? WebStatus.succeeded
          : WebStatus.failed;

  /// Returns if succeeded or not
  bool get isSucceeded => success == true;

  /// Returns if canceled or not
  bool get isCanceled => errorType == DioErrorType.CANCEL;

  /// Returns if failed or not
  bool get isFailed => !isSucceeded;

  @override
  get builders => [() => WebResponse<T>()];

  @override
  void mapping(Mapper map) {
    map("tag", tag, (v) => tag = v ?? "Connection");
    map.all(["status", "success"], success, (v) => success = v ?? false);
    map.all(["msg", "message"], message,
        (v) => message = v ?? "Connection failed.");
    map<T>("result", results ?? _result, (v) {
      if (v is List) {
        return results = v;
      } else {
        return _result = v;
      }
    });
  }

  @override
  String toString() => toJsonString();
}

enum WebMethod { get, post, delete }

enum WebStatus {
  none,
  processing,
  succeeded,
  failed,
  canceled,
}

class WebAPI {
  Future<WebResponse<T>> get<T>({
    T Function() builder,
    List<Object Function()> builders,
    String path,
    Map<String, dynamic> parameters,
  }) {
    return request<T>(
      builder: builder,
      builders: builders,
      path: path,
      method: WebMethod.get,
      parameters: parameters,
    );
  }

  Future<WebResponse<T>> post<T>({
    T Function() builder,
    List<Object Function()> builders,
    bool encrypted = false,
    String path,
    Map<String, dynamic> parameters,
  }) {
    return request<T>(
      builder: builder,
      builders: builders,
      encrypted: encrypted,
      path: path,
      method: WebMethod.post,
      parameters: parameters,
    );
  }

  Future<WebResponse<T>> delete<T>({
    T Function() builder,
    List<Object Function()> builders,
    String path,
    Map<String, dynamic> parameters,
  }) {
    return request<T>(
      builder: builder,
      builders: builders,
      path: path,
      method: WebMethod.delete,
      parameters: parameters,
    );
  }

  void download<T>({
    String path,
    String name,
    Map<String, dynamic> parameters,
  }) {
    AppPlatform.invokeMethod(
      "webDownloadFile",
      arguments: parameters
        ..putIfAbsent("path", () => path?.pre(this.path?.post("/")))
        ..putIfAbsent("name", () => name ?? ""),
    );
  }

  static const currentTime = "CURRENT_TIME";
  static const timeStamp = "DATE_TIME_";

  static const addressABPC =
      "http://192.168.0.111:7001/skm_app_restapi/webres/v3/";

  static Future<String> get address async {
    return await AppPlatform.invokeMethod(
      "webApiAddress",
      fallback: addressABPC,
    );
  }

  String get path => null;

  var _cancelToken = CancelToken();

  void cancel() => _cancelToken.cancel();

  Future<WebResponse<T>> request<T>({
    T Function() builder,
    List<Object Function()> builders,
    bool encrypted = false,
    String path,
    WebMethod method,
    Map<String, dynamic> parameters,
  }) async {
    return await scheduleTask<Future<WebResponse<T>>>(() async {
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
          ..method = method.keyNAME
          ..headers = {
            "auth": await Cipher.authToken,
          }
          ..validateStatus = (status) => status == 200;
        _cancelToken = CancelToken();
        if (encrypted)
          await Future.forEach(
            parameters.keys,
            (key) async =>
                parameters[key] = await parameters[key]?.toString()?.encrypted,
          );
        DIO.Response response = await dio.request(
          path.pre(this.path?.post("/")),
          queryParameters: method == WebMethod.post ? null : parameters,
          data: parameters,
          cancelToken: _cancelToken,
        );
        return (response.data as Object).toWebObject<WebResponse<T>>(
          [
            if (builder != null) builder,
            () => WebResponse<T>(),
            ...(builders ?? [])
          ],
        );
      } on DioError catch (e) {
        return WebResponse<T>(errorType: e.type);
      } finally {
        dio.close();
      }
    });
  }
}

class GET {
  static S find<S>({String tag}) {
    try {
      return Get.find<S>(tag: tag);
    } catch (e) {
      print(e);
      return null;
    }
  }

  static MaterialLocalizations get formatter =>
      MaterialLocalizations.of(Get.context);
}

abstract class AppGetController extends MultipleFutureGetController {
  final action = "action";
  Future Function() actionToRun = () => Future.value();
  WebResponse actionResponse;

  void actionToCancel() {
    _cancelWebApis();
    resetAction();
  }

  void resetAction() {
    actionResponse = null;
    clearErrors();
    update();
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

  List<WebAPI> get webAPIs => [];

  @override
  Map<String, Future Function()> get futuresMap => {
        nameOf(AppPrefs): appPrefs.reload,
        typeName: futureToRun,
        ...futuresToRun,
      };

  Map<String, Future Function()> get futuresToRun => {};

  Future futureToRun() => Future.value();

  bool get isDataReady => dataReady(typeName);

  /// Returns the ready status of an Object
  bool ready(String key) => dataMap[key] != null;

  /// Returns the ready status of the ViewModel
  bool get isReady => ready(typeName);

  /// Returns the busy status of the ViewModel
  @override
  bool get isBusy => busy(typeName);

  /// Returns the status of action if operating or not
  bool get isAction =>
      actionStatus != null && actionStatus != WebStatus.canceled;

  /// Returns the status of action if succeeded or not
  bool get isActionSucceeded => actionStatus == WebStatus.succeeded;

  /// Returns the status of action if processing or not
  bool get isActionProcessing => actionStatus == WebStatus.processing;

  /// Returns the status of action if failed or not
  bool get isActionFailed => actionStatus == WebStatus.failed;

  /// Returns the error status of action
  bool get hasActionError => actionError != null;

  /// Returns the [WebStatus] of the ViewModel
  WebStatus status(Object object, WebResponse response) =>
      busy(object) ? WebStatus.processing : response?.status;

  /// Returns the error status of the ViewModel and checks if data are empty
  bool hasErrorOrEmpty([bool isEmpty]) =>
      !isBusy && (hasError || ((isEmpty ?? true) && isReady));

  /// Returns the [WebStatus] of action
  WebStatus get actionStatus => status(action, actionResponse);

  /// Returns the error status of the ViewModel
  @override
  bool get hasError => error(typeName) != null;

  /// Returns the error status of the ViewModel
  @override
  dynamic get modelError => error(typeName);

  /// Sets the error for the ViewModel
  set modelError(value) => setError(value);

  /// Returns the error status of an action
  dynamic get actionError => error(action);

  /// sets the error status of an action
  set actionError(value) => setErrorForObject(action, value);

  /// Marks the ViewModel as busy and calls notify listeners
  @override
  void setBusy(bool value) => setBusyForObject(typeName, value);

  /// Sets the error for the ViewModel
  @override
  void setError(dynamic error) => setErrorForObject(typeName, error);

  /// Sets the action to busy, runs the future and then sets it to not busy when complete.
  ///
  /// rethrows [Exception] after setting busy to false for object or class
  Future runBusyAction(
    Future Function() busyAction, {
    bool throwException = false,
  }) async {
    actionToRun = () async {
      actionResponse = null;
      return actionResponse = await runBusyFuture(
        busyAction(),
        busyObject: action,
        throwException: throwException,
      );
    };
    return actionToRun();
  }

  /// Sets the ViewModel to busy, runs the future and then sets it to not busy when complete.
  ///
  /// rethrows [Exception] after setting busy to false for object or class
  @override
  Future runBusyFuture(
    Future busyFuture, {
    Object busyObject,
    bool throwException = false,
  }) async {
    clearErrors();
    _setBusyForModelOrObject(true, key: busyObject);
    try {
      var value = await runErrorFuture(busyFuture,
          key: busyObject, throwException: throwException);
      _setBusyForModelOrObject(false, key: busyObject);
      return value;
    } catch (e) {
      _setBusyForModelOrObject(false, key: busyObject);
      if (throwException) rethrow;
      return WebResponse();
    }
  }

  @override
  Future runErrorFuture(Future future,
      {Object key, bool throwException = false}) async {
    try {
      final response = await future;
      if (response is WebResponse && !(response?.success == true))
        _setErrorForModelOrObject(
          response?.message ?? GetText.failed(),
          key: key,
        );
      return response;
    } catch (e) {
      _setErrorForModelOrObject(e, key: key);
      onFutureError(e, key);
      if (throwException) rethrow;
      return WebResponse();
    }
  }

  void _setBusyForModelOrObject(bool value, {Object key}) {
    if (key != null) {
      setBusyForObject(key, value);
    } else {
      setBusyForObject(typeName, value);
    }
  }

  void _setErrorForModelOrObject(dynamic value, {Object key}) {
    if (key != null) {
      setErrorForObject(key, value);
    } else {
      setErrorForObject(typeName, value);
    }
  }
}

/// Asset directories mapping for easy access.
/// <p>
/// ### Usage
/// ```
/// IconAsset.my_icon_name.png
/// ```
/// <p>
/// ### How it works
/// If you want to add new file type extension for assets, then just make a
/// copy of [png] or any defined type in [AssetX] and add it in the
/// desired extension for Object class.
///
/// To use it, make an enum named Asset at the end and put the same asset
/// name in that as in the asset directory
/// i.e for [icon] directory, enum name must be as IconAsset
/// <p>
/// ### Some key practices
///
/// - Don't add file type extensions in the object of enums meaning no png or
/// jpg at the end.
///
/// - Use the underscore naming convention for all files in asset directory.
///
/// - If you want to add new directory in assets, then make a similar enum
/// with specific name and maps its directory name in [AssetX].
///
/// - Also map that directory in [pubspec.yaml] under the assets property.
extension AssetX on Object {
  String get svg => "$_name.svg";

  String get png => "$_name.png";

  String get gif => "$_name.gif";

  String get jpg => "$_name.jpg";

  String get jpeg => "$_name.jpeg";

  String _asset([String name]) =>
      "assets/" +
      typeName.replaceAll("Asset", "").toLowerCase() +
      "/${name ?? keyName}";

  String get _name => this is String ? this : _asset();

  String asset(String name) => _asset(name);
}

AppPrefs appPrefs = AppPrefs();

class AppPrefs {
  Future<void> reload() async {
    if (prefs == null)
      prefs = await SharedPreferences.getInstance();
    else
      await prefs.reload();
  }

  SharedPreferences prefs;
}
