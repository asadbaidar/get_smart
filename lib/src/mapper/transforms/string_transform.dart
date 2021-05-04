import 'package:get_smart/get_smart.dart';

class StringTransform implements Transformable<String, String> {
  StringTransform({this.fallback = ""});

  final String fallback;

  @override
  String fromJson(value) => _stringFromJson(value, fallback);

  @override
  String toJson(String? value) => _stringToJson(value, fallback);
}

class RxStringTransform implements Transformable<RxString, String?> {
  RxStringTransform({this.fallback = ""});

  final String fallback;

  @override
  RxString fromJson(value) => _stringFromJson(value, fallback).obs;

  @override
  String toJson(RxString? value) => _stringToJson(value?.value, fallback);
}

String _stringFromJson(value, fallback) {
  try {
    if (value == null) return fallback;
    if (value is String) return value;
    return fallback;
  } catch (e) {
    return fallback;
  }
}

String _stringToJson(String? value, fallback) {
  if (value == null) return fallback;
  return value;
}
