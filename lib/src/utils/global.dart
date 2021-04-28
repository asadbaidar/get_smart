import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_smart/get_smart.dart';

T? $cast<T>(value) => value == null
    ? null
    : value is T
        ? value
        : null;

Object? $object(value) => value;

String $name(Type type) => type.toString();

String $route(Type type) => "/" + $name(type);

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

extension ObjectX on Object {
  R mapTo<T, R>(R Function(T it) apply) => apply(this as T);

  R mapIt<T, R>(R Function(dynamic it) apply) => apply(this);

  T let<T>(T Function(T) apply) => apply(this as T);

  R apply<R>(R Function() apply) => apply();

  void lets(void Function() apply) => apply();

  T? applyIf<T>(bool? condition, T Function(T) apply) {
    return (condition == true) ? apply(this as T) : this as T?;
  }

  T? applyFor<T>(int times, T? Function(T?) apply) {
    Object? value = this;
    times.repeatsFor(() {
      value = apply(value as T?);
    });
    return value as T?;
  }

  FutureOr<T> future<T>() => Future.value(this as T);

  String get hash => hashCode.toString();

  int random(int max) => Random(hashCode).nextInt(max);

  String get keyName => toString().split('.').last;

  String get keyNAME => keyName.uppercase;

  String get rawName => toString();

  String get rawNAME => rawName.uppercase;

  String get typeName => $name(runtimeType);

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
