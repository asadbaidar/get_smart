import 'package:get_smart/get_smart.dart';

class DateUnit extends Enumerable<int> {
  static const seconds = DateUnit(rawValue: 1000);
  static const milliseconds = DateUnit(rawValue: 1);

  const DateUnit({required this.rawValue});

  @override
  final int rawValue;

  int addScale(int interval) => interval * rawValue;

  int removeScale(int interval) => interval ~/ rawValue;
}

class DateTransform implements Transformable<DateTime?, int?> {
  DateTransform({
    this.unit = DateUnit.milliseconds,
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
      if (value < 0) return fallback;
      return DateTime.fromMillisecondsSinceEpoch(unit.addScale(value));
    } catch (e) {
      return fallback;
    }
  }

  @override
  int? toJson(DateTime? value) {
    if (value == null) return null;
    return unit.removeScale(value.inMilliseconds);
  }
}
