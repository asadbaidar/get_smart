// ignore_for_file: avoid_print

import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:get_smart/get_smart.dart';

abstract class GetLogger {
  static GetLogger? instance;

  void logEvent({required String name, Map<String, Object?>? parameters});

  void _logEvent(info, tag, Object? name, {bool debug = false}) => logEvent(
        name: name?.toString().notEmpty ?? (debug ? "DebugEvent" : "Event"),
        parameters: {
          "time": Date.now.toString(),
          "tag": tag?.toString() ?? "null",
          "info": info?.toString().trim() ?? "null",
        },
      );
}

void $logDebug([info, tag, Object? name = ""]) {
  if (kDebugMode) {
    _logDebug(info, tag, name);
  } else {
    GetLogger.instance?._logEvent(info, tag, name, debug: true);
  }
}

void $logEvent([info, tag, Object? name]) {
  if (kDebugMode) {
    _logEvent(info, tag, name);
  } else {
    GetLogger.instance?._logEvent(info, tag, name);
  }
}

void _logDebug([info, tag, Object? name = ""]) {
  if (kDebugMode) {
    final _tag = tag == null ? "" : "$tag: ";
    developer.log(
      "$_tag${info ?? ""}".trim(),
      time: Date.now,
      name: name?.toString() ?? "",
    );
  }
}

void _logEvent([info, tag, Object? name]) {
  if (kDebugMode) {
    final _name = name == null ? "" : "[$name] ";
    final _tag = tag == null ? "" : "$tag: ";
    print("$_name$_tag${info ?? ""}".trim());
  }
}

extension GetLoggerX<T> on T {
  void $debugPrint([info, tag]) {
    $logDebug(
      info ?? toString(),
      tag,
      $name(runtimeType),
    );
  }

  void $print([info, tag]) => $logEvent(
        info ?? toString(),
        tag,
        $name(runtimeType),
      );
}
