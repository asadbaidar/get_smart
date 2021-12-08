import 'package:get_smart/get_smart.dart';

class DateUnit extends Enumerable<int> {
  static const seconds = DateUnit(rawValue: 1000);
  static const milliseconds = DateUnit(rawValue: 1);

  const DateUnit({required this.rawValue});

  @override
  final int rawValue;

  double addScale(double interval) {
    return interval * rawValue;
  }

  double removeScale(double interval) {
    return interval / rawValue;
  }
}

class DateTransform implements Transformable<DateTime?, double?> {
  DateTransform({
    this.unit = DateUnit.seconds,
    this.format,
    this.fallback,
  });

  final DateUnit unit;
  final DateFormat? format;
  final DateTime? fallback;

  @override
  DateTime? fromJson(value) {
    try {
      if (value == null) return fallback;
      if (value is String) return format?.parse(value) ?? DateTime.parse(value);
      if (value is int) value = value.toDouble();
      if (value < 0) return fallback;

      return DateTime.fromMillisecondsSinceEpoch(unit.addScale(value).toInt());
    } catch (e) {
      return fallback;
    }
  }

  @override
  double? toJson(DateTime? value) {
    if (value == null) return null;
    return unit.removeScale(value.millisecondsSinceEpoch.toDouble());
  }
}
