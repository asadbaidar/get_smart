import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as DIO;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

extension UrlExt on String {
  void launchUrl({bool inApp = false, bool httpOnly = false}) async {
    var url = !httpOnly || startsWith(RegExp("^(http|https)://"))
        ? this
        : "http://$this";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: inApp,
        forceWebView: inApp,
        statusBarBrightness:
            GetTheme.isDarkMode ? Brightness.dark : Brightness.light,
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
  E? get(int index) {
    if (index < length) {
      return this[index];
    }
    return null;
  }

  E? get takeFirst {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }

  E? takeFirstWhere(bool test(E element)) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension ObjectX on Object {
  R let<T, R>(R Function(T) apply) => apply(this as T);

  R apply<R>(R Function() apply) => apply();

  void lets(void Function() apply) => apply();

  T? applyIf<T>(bool? condition, T Function(T) apply) {
    return (condition == true) ? apply(this as T) : this as T?;
  }

  T? applyFor<T>(int times, T Function(T?) apply) {
    Object? value = this;
    (times ?? 0).repeatsFor(() {
      value = apply(value as T?);
    });
    return value as T?;
  }

  Future get future => Future.value(this);

  String get hash => hashCode.toString();

  String get keyName => toString().split('.').last;

  String get keyNAME => keyName.uppercase;

  String get rawName => toString();

  String get rawNAME => rawName.uppercase;

  String get typeName => nameOf(runtimeType);

  T mapObject<T>([List<Object? Function()>? builders]) {
    return MapperX.fromData(this).toWebObject<T>(builders);
  }

  /// Return the text from a text map with arguments based on current locale
  String localized(
    Map<Locale, Map<dynamic, String>> textMap, [
    List<dynamic>? arguments,
  ]) =>
      textMap[GetLocalizations.current?.locale ?? GetLocalizations.english]
          ?.let((Map<dynamic, String> _) => _[this])
          ?.applyIf(
            arguments?.isNotEmpty,
            (s) => sprintf(s, arguments!.map((e) => e ?? "").toList()),
          ) ??
      "";
}

extension Num on num {
  void repeatsFor<T>(Function apply) {
    if (this > 0)
      for (int i = 0; i < this; i++) {
        apply();
      }
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(this as int);

  String get formatted => Get.formatter.formatDecimal(this as int);

  bool inRange(int start, int end) => this >= start && this < end;

  String padLeft(
    int width, {
    String withPadding = "0",
    bool doIf = true,
  }) =>
      width <= 0
          ? ""
          : doIf == true
              ? toString().padLeft(width, withPadding)
              : toString();
}

extension DurationX on Duration {
  String formatted({
    int hoursWidth = 2,
    int minutesWidth = 2,
    int secondsWidth = 2,
    bool hoursAlways = true,
  }) {
    var _hoursWidth = hoursAlways == true || inHours > 0 ? hoursWidth : 0;
    var _secondsWidth = minutesWidth > 0 ? secondsWidth : 0;
    String hours = inHours
        .padLeft(_hoursWidth)
        .post(":", doIf: _hoursWidth > 0 && minutesWidth > 0)!;
    String minutes = inMinutes
        .remainder(60)
        .padLeft(minutesWidth)
        .post(":", doIf: minutesWidth > 0 && _secondsWidth > 0)!;
    String seconds = inSeconds.remainder(60).padLeft(_secondsWidth);
    return hours + minutes + seconds;
  }

  String get formatted0mSS => formatted(hoursWidth: 0, minutesWidth: 1);

  String get formatted0mmSS => formatted(hoursWidth: 0);

  String get formattedHmm => formatted(hoursWidth: 1, secondsWidth: 0);

  String get formattedHmmSS => formatted(hoursWidth: 1);

  String get formattedHHmm => formatted(secondsWidth: 0);

  String get formattedHHmmSS => formatted();
}

extension StringX on String {
  String? pre(String? pre, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && pre != null ? doFor : 0,
      (s) => pre! + s!,
    );
  }

  String? post(String post, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && post != null ? doFor : 0,
      (s) => s! + post,
    );
  }

  String? surround(String surround, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && surround != null ? doFor : 0,
      ((s) => s!.pre(surround)!.post(surround)!) as String Function(String?),
    );
  }

  String take([int count = 1]) => characters.take(count).toString();

  String takeWhile(bool Function(String) predicate) =>
      characters.takeWhile(predicate).toString();

  String takeLast([int count = 1]) => characters.takeLast(count).toString();

  String takeLastWhile(bool Function(String) predicate) =>
      characters.takeLastWhile(predicate).toString();

  String skip([int count = 1]) => characters.skip(count).toString();

  String skipWhile(bool Function(String) predicate) =>
      characters.skipWhile(predicate).toString();

  String skipLast([int count = 1]) => characters.skipLast(count).toString();

  String skipLastWhile(bool Function(String) predicate) =>
      characters.skipLastWhile(predicate).toString();

  String? get notEmpty => isEmpty ? null : this;

  bool get isNotBlank => !isBlank!;

  String get fileType => takeLastWhile((s) => s != ".");

  bool equalsIgnoreCase(String s) => lowercase == s?.lowercase;

  bool containsIgnoreCase(String s) =>
      s == null ? false : lowercase.contains(s.lowercase);

  Color get materialPrimary =>
      Colors.primaries[Random(hashCode).nextInt(Colors.primaries.length)];

  Color get materialAccent =>
      Colors.accents[Random(hashCode).nextInt(Colors.accents.length)];

  bool isPasswordStrong({int min = 8}) {
    if (isBlank!) return false;

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
    return isBlank!
        ? ""
        : length == 1
            ? uppercase
            : split(' ').map((s) => s.capitalizedFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  String get capitalizedFirst {
    return isBlank!
        ? ""
        : length == 1
            ? uppercase
            : this[0].uppercase + substring(1).lowercase;
  }

  bool get boolYN => trim().equalsIgnoreCase("Y");

  Future<String> get encrypted async => await GetCipher.instance.encrypt(this);

  Future<String> get decrypted async => await GetCipher.instance.decrypt(this);

  get json => jsonDecode(this);

  int get asInt => int.tryParse(this) ?? 0;

  double get asDouble => double.tryParse(this) ?? 0.0;

  List<int> get asUTF8 => utf8.encode(this);
}

extension RandomX on Random {
  /// Generates a cryptographically secure random nonce
  String nonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    return List.generate(length, (_) => charset[nextInt(charset.length)])
        .join();
  }
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
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    TimeOfDay? timeOfDay,
    DateTime? date,
    DateTime? time,
  }) {
    final now = Date.now;
    return DateTime(
      year ?? date?.year ?? now.year,
      month ?? date?.month ?? now.month,
      day ?? date?.day ?? now.day,
      hour ?? time?.hour ?? timeOfDay?.hour ?? now.hour,
      minute ?? time?.minute ?? timeOfDay?.minute ?? now.minute,
      second ?? time?.second ?? now.second,
      millisecond ?? time?.millisecond ?? now.millisecond,
      microsecond ?? time?.microsecond ?? now.microsecond,
    );
  }

  DateTime setting({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
    TimeOfDay? timeOfDay,
    DateTime? date,
    DateTime? time,
  }) =>
      DateTime(
        year ?? date?.year ?? this.year,
        month ?? date?.month ?? this.month,
        day ?? date?.day ?? this.day,
        hour ?? time?.hour ?? timeOfDay?.hour ?? this.hour,
        minute ?? time?.minute ?? timeOfDay?.minute ?? this.minute,
        second ?? time?.second ?? this.second,
        millisecond ?? time?.millisecond ?? this.millisecond,
        microsecond ?? time?.microsecond ?? this.microsecond,
      );

  static DateTime get now => DateTime.now();

  String get formatEMMMdy => GetDateFormat.inEMMMdy.format(this);

  String get formatEEEEMMMMdy => GetDateFormat.inEEEEMMMMdy.format(this);

  String get formatEMMMdyHma => GetDateFormat.inEMMMdyHma.format(this);

  String get formatEEEEMMMMdyHma => GetDateFormat.inEEEEMMMMdyHma.format(this);

  String get formatMMMMdy => GetDateFormat.inMMMMdy.format(this);

  String get formatMMMMd => GetDateFormat.inMMMMd.format(this);

  String get formatMMMd => GetDateFormat.inMMMd.format(this);

  String get formatMMMdy => GetDateFormat.inMMMdy.format(this);

  String get formatMMMdyHma => GetDateFormat.inMMMdyHma.format(this);

  String get formatMdy => GetDateFormat.inMdy.format(this);

  String get formatMdyHma => GetDateFormat.inMdyHma.format(this);

  String get formatDMMMy => GetDateFormat.inDMMMy.format(this);

  String get formatHma => GetDateFormat.inHma.format(this);

  String get formatDMMy => GetDateFormat.inDMMy.format(this);

  String get formatHm => GetDateFormat.inHm.format(this);

  String get formatDMMyHm => GetDateFormat.inDMMyHm.format(this);

  int get inMilliseconds => millisecondsSinceEpoch;

  TimeOfDay get timeOfDay => TimeOfDay.fromDateTime(this);

  DateTime get endOfDay => setting(
        hour: 23,
        minute: 59,
        millisecond: 0,
        microsecond: 0,
      );

  String get webTimeStamp => GetWebAPI.timeStamp + inMilliseconds.toString();

  bool operator >(DateTime other) =>
      other != null && this != null ? isAfter(other) : false;

  bool operator <(DateTime other) =>
      other != null && this != null ? other.isAfter(this) : false;
}

extension GetDateFormat on DateFormat {
  static DateFormat get inEMMMdy => DateFormat.yMMMEd();

  static DateFormat get inEEEEMMMMdy => DateFormat.yMMMMEEEEd();

  static DateFormat get inEMMMdyHma => inEMMMdy.add(inHma, ", ");

  static DateFormat get inEEEEMMMMdyHma => inEEEEMMMMdy.add(inHma, ", ");

  static DateFormat get inMMMMdy => DateFormat.yMMMMd();

  static DateFormat get inMMMMd => DateFormat.MMMMd();

  static DateFormat get inMMMd => DateFormat.MMMd();

  static DateFormat get inMMMdy => DateFormat.yMMMd();

  static DateFormat get inMMMdyHma => inMMMdy.add(inHma, ", ");

  static DateFormat get inMdy => DateFormat.yMd();

  static DateFormat get inMdyHma => inMdy.add(inHma, ", ");

  static DateFormat get inDMMMy => DateFormat("dd-MMM-yyyy");

  static DateFormat get inHma => DateFormat("h:mm a");

  static DateFormat get inDMMy => DateFormat("dd-MM-yyyy");

  static DateFormat get inHm => DateFormat.Hm();

  static DateFormat get inDMMyHm => inDMMy.add_Hm();

  /// Add [format] to this instance as a pattern.
  ///
  /// If there was a previous pattern, then this appends to it, separating the
  /// two by [separator].  [format] is first looked up in our list of
  /// known skeletons.  If it's found there, then use the corresponding pattern
  /// for this locale.  If it's not, then treat [format] as an explicit
  /// pattern.
  DateFormat add(DateFormat format, [String separator = ' ']) =>
      addPattern(format.pattern, separator);
}

extension GetDateTimePickerX on GetInterface {
  Future<void> timePicker({
    DateTime? withTime,
    String? cancelText,
    String? confirmText,
    String? helpText,
    TimePickerEntryMode entryMode = TimePickerEntryMode.input,
    TransitionBuilder? builder,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    required Function(DateTime? time) onPick,
  }) async {
    var time = await showTimePicker(
      context: context!,
      initialTime: withTime?.timeOfDay ?? TimeOfDay.now(),
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      initialEntryMode: entryMode ?? TimePickerEntryMode.input,
      builder: builder,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
    onPick(time == null && withTime == null
        ? null
        : (withTime?.setting(timeOfDay: time) ?? Date.from(timeOfDay: time)));
  }

  Future<void> datePicker({
    DateTime? withDate,
    DateTime? minDate,
    DateTime? maxDate,
    DateTime? currentDate,
    String? cancelText,
    String? confirmText,
    String? helpText,
    String? errorFormatText,
    String? errorInvalidText,
    String? fieldHintText,
    String? fieldLabelText,
    DatePickerEntryMode entryMode = DatePickerEntryMode.calendar,
    DatePickerMode calenderMode = DatePickerMode.day,
    SelectableDayPredicate? selectableDayPredicate,
    Locale? locale,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
    TransitionBuilder? builder,
    required Function(DateTime? date) onPick,
  }) async {
    var date = await showDatePicker(
      context: context!,
      initialDate: withDate ?? Date.now,
      firstDate: minDate ?? Date.from(year: 2000),
      lastDate: maxDate ?? Date.now,
      currentDate: currentDate,
      cancelText: cancelText,
      confirmText: confirmText,
      helpText: helpText,
      errorFormatText: errorFormatText,
      errorInvalidText: errorInvalidText,
      fieldHintText: fieldHintText,
      fieldLabelText: fieldLabelText,
      initialEntryMode: entryMode ?? DatePickerEntryMode.calendar,
      initialDatePickerMode: calenderMode ?? DatePickerMode.day,
      selectableDayPredicate: selectableDayPredicate,
      locale: locale,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
      builder: builder,
    );
    onPick(date == null && withDate == null
        ? null
        : (withDate?.setting(date: date) ?? date));
  }
}

T? castIf<T>(value) => value is T ? value : null;

String nameOf(Type type) => type.toString();

String routeOf(Type type) => "/" + nameOf(type);

extension TextInputTypeX on TextInputType {
  static TextInputType get numberFirst => Get.isIOS
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

  BoxDecoration circularDecoration({Color? color}) => BoxDecoration(
        borderRadius: circular,
        color: color,
      );

  String get formatted => Get.formatter.formatDecimal(toInt());
}

Future<T> scheduleTask<T>(FutureOr<T> Function() task) async {
  return await (SchedulerBinding.instance!
      .scheduleTask<FutureOr<T>>(task, Priority.animation) as FutureOr<T>);
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
    Transformable? transform,
  ]) {
    this<T>(
      fields.firstWhere(
        (it) => this.json![it] != null,
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
                : data is Map<String, dynamic>
                    ? data
                    : {},
      );

  T toWebObject<T>([List<Object? Function()>? builders]) {
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

abstract class WebMappable with Mappable, Comparable<WebMappable> {
  DateTime? currentTime;
  String? _id;
  String? _description;

  String get id => _id ?? idFallback ?? "";

  set id(String id) => _id = id;

  String get description => _description ?? descriptionFallback ?? "";

  set description(String description) => _description = description;

  String? get idFallback => null;

  String? get descriptionFallback => null;

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

  get builders => [];

  Future get decrypted async {
    id = await id.decrypted;
    description = await description.decrypted;
    return this;
  }

  bool get isEmpty => id.isEmpty && description.isEmpty;

  bool get isNotEmpty => id.isNotEmpty && description.isNotEmpty;

  @override
  String toString() => description;

  @override
  int compareTo(WebMappable other) => other?.comparable == null
      ? 0
      : comparable?.compareTo(other.comparable) ?? 0;

  int operator >(WebMappable other) => this == null ? 0 : compareTo(other);

  int operator <(WebMappable other) => other?.compareTo(this) ?? 0;

  @override
  bool operator ==(Object other) {
    if (other == null) return false;
    if (other.runtimeType != runtimeType) return false;
    return other is WebMappable &&
        (identical(other, this) ||
            equatable?.equalsIgnoreCase(other.equatable) == true);
  }

  @override
  int get hashCode => identityHashCode(equatable?.lowercase);

  String get equatable => id;

  String get containable => id + description;

  Comparable get comparable => toString();

  bool contains(object) => containable?.contains(object?.toString()) ?? false;

  bool containsIgnoreCase(object) =>
      containable?.containsIgnoreCase(object?.toString()) ?? false;

  var isExpanded = false;

  bool toggleExpand() => isExpanded = !isExpanded;

  IconData get expandedIcon =>
      isExpanded ? Icons.expand_less : Icons.expand_more;

  var isChecked = false;

  bool toggleChecked() => isChecked = !isChecked;

  Color get color => description.materialAccent;
}

class StackList<T> {
  final Queue<T> _underlyingQueue;

  StackList() : _underlyingQueue = Queue<T>();

  int get length => _underlyingQueue.length;

  bool get isEmpty => _underlyingQueue.isEmpty;

  bool get isNotEmpty => _underlyingQueue.isNotEmpty;

  void clear() => _underlyingQueue.clear();

  T? peek() {
    if (isEmpty) return null;
    return _underlyingQueue.last;
  }

  T? pop() {
    if (isEmpty) return null;
    final T lastElement = _underlyingQueue.last;
    _underlyingQueue.removeLast();
    return lastElement;
  }

  void push(final T element) => _underlyingQueue.addLast(element);
}

class AppTileData extends WebMappable {
  AppTileData({
    this.icon,
    this.accessory,
    this.header,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.subTiles = const [],
    Color? color,
    this.isDetailed = false,
    this.isHeader = false,
    this.padAccessory,
    this.onTap,
  }) : _color = color;

  IconData? icon;
  IconData? accessory;
  dynamic header;
  String? title;
  String? subtitle;
  String? trailingTop;
  String? trailingBottom;
  List<AppTileData> subTiles;
  Color? _color;
  bool isDetailed;
  bool isHeader;
  bool? padAccessory;
  Function? onTap;

  bool get hasSubTiles => subTiles.isNotEmpty == true;

  @override
  Color get color => _color ?? title?.materialAccent ?? super.color;
}

class WebResponse<T> extends WebMappable {
  WebResponse();

  WebResponse.dio([this.dioError]);

  WebResponse.error([String? message]) : message = message;

  WebResponse.success([String? message])
      : message = message,
        isSucceeded = true;

  DioErrorType? dioError;

  String tag = "Connection";
  bool isSucceeded = false;
  String? message = "Connection failed.";
  T? result;
  List<T>? results;

  // ?? (T.toString() == "dynamic" ? isSucceeded : null);

  get data => results ?? result;

  String? get error => isSucceeded ? null : message;

  String? get success => isSucceeded ? message : null;

  WebStatus get status => isCanceled
      ? WebStatus.canceled
      : isSucceeded
          ? WebStatus.succeeded
          : WebStatus.failed;

  /// Returns if canceled or not
  bool get isCanceled => dioError == DioErrorType.cancel;

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
    map<T>("result", results ?? result, (v) {
      if (v is List) {
        return results = v as List<T>?;
      } else {
        return result = v;
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
    T Function()? builder,
    List<Object Function()>? builders,
    String? path,
    Map<String, dynamic>? parameters,
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
      method: WebMethod.post,
      parameters: parameters,
    );
  }

  Future<WebResponse<T>> delete<T>({
    T Function()? builder,
    List<Object Function()>? builders,
    String? path,
    Map<String, dynamic>? parameters,
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

  Future<WebResponse<T>> request<T>({
    T Function()? builder,
    List<Object Function()>? builders,
    bool encrypted = false,
    String? path,
    WebMethod? method,
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
              (dynamic key) async => parameters[key] =
                  await parameters[key]?.toString()?.encrypted,
            );
          DIO.Response response = await dio.request(
            path!.pre(this.path?.post("/"))!,
            queryParameters: method == WebMethod.post ? null : parameters,
            data: parameters,
            cancelToken: _cancelToken,
          );
          return (response.data as Object).mapObject<WebResponse<T>>(
            [
              if (builder != null) builder,
              () => WebResponse<T>(),
              ...(builders ?? [])
            ],
          );
        } on DioError catch (e) {
          return WebResponse<T>.dio(e.type);
        } finally {
          dio.close();
        }
      });
}

extension GetInterfaceX on GetInterface {
  TargetPlatform get platform => theme.platform;

  bool get isIOS => platform == TargetPlatform.iOS;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isWeb => kIsWeb;

  bool get canPop => Navigator.canPop(context!);

  Future<void> popSystem({bool animated = true}) =>
      SystemNavigator.pop(animated: animated);

  Future<bool> maybePop<T extends Object>([T? result]) =>
      Navigator.maybePop<T>(context!, result);

  void backUntil(String route) => until((r) => r.settings.name == route);

  MaterialLocalizations get formatter => MaterialLocalizations.of(context!);

  /// give current arguments
  Object? get $arguments => arguments;

  T? mapArguments<T>([List<Object Function()>? builders]) =>
      $arguments?.mapObject<T>(builders);

  /// Finds an Instance of the required Class <[S]>(or [tag])
  /// Returns null if not found.
  S? findIt<S>({String? tag}) {
    try {
      return GetInstance().find<S>(tag: tag);
    } catch (e) {
      return null;
    }
  }

  /// Deprecated method. Please use [findIt] instead.
  @Deprecated("Please use `Get.findIt` instead.")
  S? find<S>({String? tag}) => null;
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
/// i.e for icon directory, enum name must be as IconAsset
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
/// - Also map that directory in `pubspec.yaml` under the assets property.
extension AssetX on Object {
  String get svg => "$_name.svg";

  String get png => "$_name.png";

  String get gif => "$_name.gif";

  String get jpg => "$_name.jpg";

  String get jpeg => "$_name.jpeg";

  String get pdf => "$_name.pdf";

  String _asset([String? name]) =>
      "assets/" +
      typeName.replaceAll("Asset", "").lowercase +
      "/${name ?? keyName}";

  String get _name => this is String ? this as String : _asset();

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

  MethodChannel? get channel => null;

  Future<T?> invokeMethod<T>(
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

  /// Override it to reload prefs.
  ///
  /// For example:
  ///```
  /// if (prefs == null)
  ///   prefs = await SharedPreferences.getInstance();
  /// else
  ///   await prefs.reload();
  /// ```
  Future<void> reload() async {}
}
