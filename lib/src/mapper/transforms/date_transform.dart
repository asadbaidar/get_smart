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
  });

  final DateUnit unit;
  final DateFormat? format;

  @override
  DateTime? fromJson(value) {
    try {
      if (value == null) return null;
      if (value is String) return format?.parse(value) ?? DateTime.parse(value);
      if (value is int) value = value.toDouble();
      if (value < 0) return null;

      return DateTime.fromMillisecondsSinceEpoch(unit.addScale(value).toInt());
    } catch (e) {
      return null;
    }
  }

  @override
  double? toJson(DateTime? value) {
    if (value == null) return null;

    return unit.removeScale(value.millisecondsSinceEpoch.toDouble());
  }
}
