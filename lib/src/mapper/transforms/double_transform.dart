import 'package:get_smart/get_smart.dart';

class DoubleTransform implements Transformable<double, double> {
  DoubleTransform({this.fallback = 0.0});

  final double fallback;

  @override
  double fromJson(value) => _doubleFromJson(value, fallback);

  @override
  double toJson(double? value) => _doubleToJson(value, fallback);
}

class RxDoubleTransform implements Transformable<RxDouble, double> {
  RxDoubleTransform({this.fallback = 0.0});

  final double fallback;

  @override
  RxDouble fromJson(value) => _doubleFromJson(value, fallback).obs;

  @override
  double toJson(RxDouble? value) => _doubleToJson(value?.value, fallback);
}

double _doubleFromJson(value, fallback) {
  try {
    if (value == null) return fallback;
    if (value is num) return value.toDouble();
    final parsed = double.tryParse(value.toString());
    if (parsed != null) return parsed;
    return fallback;
  } catch (e) {
    return fallback;
  }
}

double _doubleToJson(double? value, fallback) {
  if (value == null) return fallback;
  return value;
}
