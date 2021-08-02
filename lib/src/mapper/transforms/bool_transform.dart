import 'package:get_smart/get_smart.dart';

class BoolTransform implements Transformable<bool, String> {
  BoolTransform({this.fallback = false});

  final bool fallback;

  @override
  bool fromJson(value) => _boolFromJson(value, fallback);

  @override
  String toJson(bool? value) => _boolToJson(value, fallback);
}

class RxBoolTransform implements Transformable<RxBool, String> {
  RxBoolTransform({this.fallback = false});

  final bool fallback;

  @override
  RxBool fromJson(value) => _boolFromJson(value, fallback).obs;

  @override
  String toJson(RxBool? value) => _boolToJson(value?.value, fallback);
}

bool _boolFromJson(value, fallback) {
  try {
    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is String) return value.boolYN;
    return fallback;
  } catch (e) {
    return fallback;
  }
}

String _boolToJson(bool? value, fallback) {
  if (value == null) return fallback.stringYN;
  return value.stringYN;
}

extension Bool on bool {
  String get stringYN => this ? "Y" : "N";
}
