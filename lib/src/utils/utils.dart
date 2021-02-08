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
import 'package:get_smart/get_smart.dart';
import 'package:intl/intl.dart';
import 'package:object_mapper/object_mapper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';
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

  String get hash => hashCode.toString();

  String get keyName => toString().split('.').last;

  String get keyNAME => keyName.uppercase;

  String get rawName => toString();

  String get rawNAME => rawName.uppercase;

  String get typeName => nameOf(runtimeType);

  T toWebObject<T>([List<Object Function()> builders]) {
    return MapperX.fromData(this).toWebObject<T>(builders);
  }

  /// Return the text from a text map with arguments based on current locale
  String localized(Map<Locale, Map<dynamic, String>> textMap,
      [List<dynamic> arguments]) {
    return this == null
        ? null
        : textMap[GetLocalizations.current.locale][this]?.applyIf(
            arguments?.isNotEmpty,
            (s) => sprintf(s, arguments.map((e) => e ?? "").toList()),
          );
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

  String get fileType => takeLastWhile((s) => s != ".");

  bool equalsIgnoreCase(String s) => lowercase == s?.lowercase;

  bool containsIgnoreCase(String s) =>
      s == null ? false : lowercase.contains(s.lowercase);

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

  /// Uppercase each word inside string
  /// Example: your name => YOUR NAME
  String get uppercase => toUpperCase();

  /// Lowercase each word inside string
  /// Example: Your Name => your name
  String get lowercase => toLowerCase();

  /// Capitalize each word inside string
  /// Example: your name => Your Name
  String get capitalized {
    return isBlank
        ? ""
        : length == 1
            ? uppercase
            : split(' ').map((s) => s.capitalizedFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  String get capitalizedFirst {
    return isBlank
        ? ""
        : length == 1
            ? uppercase
            : this[0].uppercase + substring(1).lowercase;
  }

  bool get boolYN => equalsIgnoreCase("Y");

  Future<String> get encrypted async => await GetCipher.instance.encrypt(this);

  Future<String> get decrypted async => await GetCipher.instance.decrypt(this);

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

  String get webTimeStamp => GetWebAPI.timeStamp + inMilliseconds.toString();
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
      ? TextInputType.numberWithOptions(signed: true)
      : TextInputType.visiblePassword;

  static TextInputType get numberOnly =>
      TextInputType.numberWithOptions(signed: true);
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
          RegExp(r'[WINwin-]|[0-9]'),
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
  bool isSucceeded = false;
  String message = "Connection failed.";
  T _result;
  List<T> results;

  T get result => _result ?? (T.toString() == "dynamic" ? isSucceeded : null);

  set result(value) => _result = value;

  get data => results ?? result;

  String get error => isSucceeded ? null : message;

  String get success => isSucceeded ? message : null;

  WebStatus get status => isCanceled
      ? WebStatus.canceled
      : isSucceeded
          ? WebStatus.succeeded
          : WebStatus.failed;

  /// Returns if canceled or not
  bool get isCanceled => errorType == DioErrorType.CANCEL;

  /// Returns if failed or not
  bool get isFailed => !isSucceeded;

  @override
  get builders => [() => WebResponse<T>()];

  @override
  void mapping(Mapper map) {
    map("tag", tag, (v) => tag = v ?? "Connection");
    map.all(
        ["status", "success"], isSucceeded, (v) => isSucceeded = v ?? false);
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
  busy,
  succeeded,
  failed,
  canceled,
}

abstract class GetWebAPI {
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
  }) =>
      throw UnimplementedError();

  static const currentTime = "CURRENT_TIME";
  static const timeStamp = "DATE_TIME_";

  FutureOr<String> get address;

  String get path => null;

  FutureOr<String> get authToken => GetCipher.instance.authToken;

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
            "auth": await authToken,
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

  static bool get canPop => Navigator.canPop(Get.context);

  static MaterialLocalizations get formatter =>
      MaterialLocalizations.of(Get.context);
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

  String get pdf => "$_name.pdf";

  String _asset([String name]) =>
      "assets/" +
      typeName.replaceAll("Asset", "").lowercase +
      "/${name ?? keyName}";

  String get _name => this is String ? this : _asset();

  String asset(String name) => _asset(name);
}

extension ContextX on BuildContext {
  void endEditing() {
    FocusManager.instance?.primaryFocus?.unfocus();
    FocusScope.of(this)?.unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class GetPlatformChannel {
  static GetPlatformChannel instance = GetPlatformChannel();

  GetPlatformChannel() {
    init();
    print("GetPlatformChannel: init");
  }

  void init() {}

  MethodChannel get channel => null;

  Future<T> invokeMethod<T>(
    String method, {
    dynamic arguments,
    dynamic fallback,
  }) async {
    try {
      return await channel?.invokeMethod(method, arguments);
    } on Exception {
      return fallback;
    }
  }
}

class GetCipher {
  static GetCipher instance = GetCipher();

  FutureOr<String> decrypt(String data) => data;

  FutureOr<String> encrypt(String data) => data;

  FutureOr<String> get authToken => "";
}

class GetPrefs {
  static GetPrefs instance = GetPrefs();

  Future<void> reload() async {
    if (prefs == null)
      prefs = await SharedPreferences.getInstance();
    else
      await prefs.reload();
  }

  SharedPreferences prefs;
}
