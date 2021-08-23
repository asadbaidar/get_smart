import 'dart:async';
import 'dart:developer' as developer;
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_smart/get_smart.dart';

/// Returns [T] if instance of [T], otherwise null
T? $cast<T>(value) => value == null
    ? null
    : value is T
        ? value
        : null;

/// Returns [Object]
Object? $object(value) => value;

/// Returns the name of type
String $name(Type type) => type.toString();

/// Returns the name of type preceded with backslash `/`
///
/// i.e. "/typeName"
String $route(Type type) => "/" + $name(type);

void $debugLog([
  dynamic value,
  dynamic tag,
  String name = "",
]) {
  final _tag = tag == null ? "" : "$tag: ";
  developer.log(
    "$_tag${value ?? ""}".trim(),
    time: Date.now,
    name: name,
  );
}

void $log([
  dynamic value,
  dynamic tag,
  String? name,
]) {
  final _name = name == null ? "" : "[$name] ";
  final _tag = tag == null ? "" : "$tag: ";
  print("$_name$_tag${value ?? ""}".trim());
}

extension GetDebugUtils<T> on T {
  void $debugPrint([
    dynamic value,
    dynamic tag,
  ]) {
    $print(value, tag);
    $debugLog(
      value ?? this,
      tag,
      $name(runtimeType),
    );
  }

  void $print([
    dynamic value,
    dynamic tag,
  ]) =>
      $log(
        value ?? this,
        tag,
        $name(runtimeType),
      );
}

/// Schedules the given `task` with the [Priority.animation] and returns a
/// [Future] that completes to the `task`'s eventual return value.
Future<T> scheduleTask<T>(FutureOr<T> Function() task) async {
  return await SchedulerBinding.instance!
      .scheduleTask<FutureOr<T>>(task, Priority.animation);
}

Future<T> profileTask<T>(Future<T> Function() task) async {
  var time = Date.now.inMilliseconds;
  print("${T.toString()}: Started task");
  var result = await task();
  print("${T.toString()}: Finished task "
      "in ${Date.now.inMilliseconds - time}ms.");
  return result;
}

extension ObjectX on Object {
  /// [apply] mapping with [T] as parameter and [R] as return value
  R mapTo<T, R>(R Function(T it) apply) => apply(this as T);

  /// [apply] mapping with [T] as dynamic parameter and [R] as return value
  R mapIt<T, R>(R Function(dynamic it) apply) => apply(this);

  /// Lets [apply] with [T] as parameter
  T let<T>(T Function(T) apply) => apply(this as T);

  /// Lets [apply] with [R] as return value
  R apply<R>(R Function() apply) => apply();

  /// Lets [apply] without any condition
  void lets(void Function() apply) => apply();

  /// Apply the [operation] with [T] as parameter if [condition] is `true`
  T? applyIf<T>(bool? condition, T Function(T) operation) {
    return (condition == true) ? operation(this as T) : this as T;
  }

  /// Repeat the [task] with [T] as parameter for [n] times
  T? applyFor<T>(int n, T? Function(T?) task) {
    Object? value = this;
    n.repeatsFor(() => value = task(value as T?));
    return value as T?;
  }

  /// Wrap the value of [T] into [Future.value]
  FutureOr<T> future<T>() => Future.value(this as T);

  /// Returns [hashCode] as [String]
  String get $hash => hashCode.toString();

  /// Returns random integer seeded with [hashCode] and less than [max]
  int randomTill(int max) => Random(hashCode).nextInt(max);

  /// Returns only name of the enum value with capitalized form
  String get keyName => toString().split('.').last;

  /// Returns only name of the enum value with uppercase form
  String get keyNAME => keyName.uppercase;

  /// Returns full path name of the enum value
  String get rawName => toString();

  /// Returns full path name of the enum value with uppercase form
  String get rawNAME => rawName.uppercase;

  /// Returns the name of [runtimeType]
  String get typeName => $name(runtimeType);

  /// Create and return a Mappable object for [T] from String or Map
  T? getObject<T>({T? as, List<Function>? builders}) =>
      Mapper.fromData(this).toMappable<T>(as: as, builders: builders);

  /// Return the text from a text map with arguments based on current locale
  String $localized(
    Map<Locale, Map<dynamic, String>> textMap, [
    List<dynamic>? arguments,
  ]) =>
      textMap[GetLocalizations.current?.locale ?? GetLocalizations.english]
          ?.mapTo((Map<dynamic, String> it) => it[this])
          ?.applyIf(
            arguments?.isNotEmpty,
            (s) => sprintf(s, arguments!.map((e) => e ?? "").toList()),
          ) ??
      "";
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
/// copy of [$png] or any defined type in [AssetX] and add it in the
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
  String get $svg => "$_name.svg";

  String get $png => "$_name.png";

  String get $gif => "$_name.gif";

  String get $jpg => "$_name.jpg";

  String get $jpeg => "$_name.jpeg";

  String get $pdf => "$_name.pdf";

  String _asset([String? name]) =>
      "assets/" +
      typeName.replaceAll("Asset", "").lowercase +
      "/${name ?? keyName}";

  String get _name => this is String ? this as String : _asset();

  String $asset(String name) => _asset(name);
}
