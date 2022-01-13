import 'dart:async';
import 'dart:math';

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

/// Returns the name of type
/// - preceded with backslash `/`
/// - lowercase first letter
/// - removed `Page` word
///
/// i.e. TypeNamePage -> "/typeName"
String $route(Type type) =>
    "/" + $name(type).lowercaseFirst.replaceAll("Page", "");

/// Schedules the given `task` with the [Priority.animation] and returns a
/// [Future] that completes to the `task`'s eventual return value.
Future<T> scheduleTask<T>(FutureOr<T> Function() task) async {
  return await SchedulerBinding.instance!
      .scheduleTask<FutureOr<T>>(task, Priority.animation);
}

Future<T> profileTask<T>(Future<T> Function() task) async {
  var time = Date.now.inMilliseconds;
  $logDebug("Started task", "profile", T.typeName);
  var result = await task();
  $logDebug("Finished task in ${Date.now.inMilliseconds - time}ms.", "profile",
      T.typeName);
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
  T applyIf<T>(bool? condition, T Function(T) operation) {
    return (condition == true) ? operation(this as T) : this as T;
  }

  /// Repeat the [task] with [T] as parameter for [n] times
  T applyFor<T>(int n, T Function(T) task) {
    T value = this as T;
    n.repeatsFor(() => value = task(value));
    return value;
  }

  /// Repeat the [task] with [T] as parameter for [n] times
  T applyForIndexed<T>(int n, T Function(T v, int i) task) {
    T value = this as T;
    n.repeatsForIndexed((i) => value = task(value, i));
    return value;
  }

  /// Wrap the current object into [Future.value]
  dynamic get future => Future<dynamic>.value(this);

  /// Returns [hashCode] as [String]
  String get hashString => hashCode.toString();

  /// Returns random integer seeded with [hashCode] and less than [max]
  int randomIn(int max) => Random(hashCode).nextInt(max);

  /// Returns the name of [runtimeType]
  String get typeName => $name(runtimeType);

  /// Create and return a Mappable object for [T] from String or Map
  T? getObject<T>({T? as, List<Function>? builders}) =>
      Mapper.fromData(this).toMappable<T>(as: as, builders: builders);

  /// Create and return a Mappable result for [T] from String or Map
  GetResult<T>? getResult<T>({T? as, List<Function>? builders}) =>
      Mapper.fromData(this).toMappable<GetResult<T>>(
        as: GetResult<T>(),
        builders: (builders ?? []) + ($cast<Mappable>(as)?.builders ?? []),
      );

  /// Return the text from a text map with arguments based on current locale
  String $localized(
    Map<String, Map<dynamic, String>> textMap, [
    List<dynamic>? arguments,
  ]) =>
      textMap[GetLocalizations.currentLocale ?? GetLocalizations.english]
          ?.mapTo((Map<dynamic, String> it) => it[this])
          ?.applyIf(
            arguments?.isNotEmpty,
            (s) => sprintf(s ?? "", arguments!.map((e) => e ?? "").toList()),
          ) ??
      "";
}

extension EnumX on Enum {
  /// Returns only name of the enum value with uppercase form
  String get nameCAP => name.uppercase;

  /// Returns only first letter of name of the enum value
  String get nameFirst => name.take();

  /// Returns only first letter of name of the enum value with uppercase form
  String get nameFIRST => nameFirst.uppercase;

  /// Returns full path name of the enum value
  String get rawName => toString();

  /// Returns full path name of the enum value with uppercase form
  String get rawNAME => rawName.uppercase;
}
