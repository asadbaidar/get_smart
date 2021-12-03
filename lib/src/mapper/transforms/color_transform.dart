import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

class ColorTransform implements Transformable<Color?, int?> {
  ColorTransform({this.fallback});

  final Color? fallback;

  @override
  Color? fromJson(value) {
    try {
      if (value == null) return fallback;
      if (value is num) return Color(value.toInt());
      final parsed = int.tryParse(value.toString());
      if (parsed != null) return Color(parsed);
      return fallback;
    } catch (e) {
      return fallback;
    }
  }

  @override
  int? toJson(Color? value) {
    if (value == null) return null;
    return value.value;
  }
}
