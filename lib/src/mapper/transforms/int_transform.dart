import 'package:get_smart/get_smart.dart';

class IntTransform implements Transformable<int, int> {
  IntTransform({this.fallback = 0});

  final int fallback;

  @override
  int fromJson(value) => _intFromJson(value, fallback);

  @override
  int toJson(int? value) => _intToJson(value, fallback);
}

class RxIntTransform implements Transformable<RxInt, int> {
  RxIntTransform({this.fallback = 0});

  final int fallback;

  @override
  RxInt fromJson(value) => _intFromJson(value, fallback).obs;

  @override
  int toJson(RxInt? value) => _intToJson(value?.value, fallback);
}

int _intFromJson(value, fallback) {
  try {
    if (value == null) return fallback;
    if (value is num) return value.toInt();
    final parsed = int.tryParse(value.toString());
    if (parsed != null) return parsed;
    return fallback;
  } catch (e) {
    return fallback;
  }
}

int _intToJson(int? value, fallback) {
  if (value == null) return fallback;
  return value;
}
