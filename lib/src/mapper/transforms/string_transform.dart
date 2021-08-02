import 'package:get_smart/get_smart.dart';

class StringTransform implements Transformable<String, String> {
  StringTransform({
    this.capitalize = false,
    this.fallback = "",
  });

  final bool capitalize;
  final String fallback;

  @override
  String fromJson(value) => _stringFromJson(value, capitalize, fallback);

  @override
  String toJson(String? value) => _stringToJson(value, fallback);
}

class RxStringTransform implements Transformable<RxString, String?> {
  RxStringTransform({
    this.capitalize = false,
    this.fallback = "",
  });

  final bool capitalize;
  final String fallback;

  @override
  RxString fromJson(value) => _stringFromJson(value, capitalize, fallback).obs;

  @override
  String toJson(RxString? value) => _stringToJson(value?.value, fallback);
}

String _stringFromJson(value, bool capitalize, fallback) {
  final string = _$stringFromJson(value, fallback);
  return capitalize ? string.capitalized : string;
}

String _$stringFromJson(value, fallback) {
  try {
    if (value == null) return fallback;
    if (value is String) return value.trim();
    return fallback;
  } catch (e) {
    return fallback;
  }
}

String _stringToJson(String? value, fallback) {
  if (value == null) return fallback;
  return value;
}
