import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

import '../enumerable.dart';
import '../transformable.dart';

class DateUnit extends Enumerable<int> {
  final int rawValue;

  const DateUnit({@required this.rawValue});

  static const seconds = const DateUnit(rawValue: 1000);
  static const milliseconds = const DateUnit(rawValue: 1);

  double addScale(double interval) {
    return interval * rawValue;
  }

  double removeScale(double interval) {
    return interval / rawValue;
  }
}

class DateTransform implements Transformable<DateTime, double> {
  DateUnit unit;
  DateFormat format;

  DateTransform({
    this.unit = DateUnit.seconds,
    this.format,
  });

  @override
  DateTime fromJson(value) {
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
  double toJson(DateTime value) {
    if (value == null) return null;

    return unit.removeScale(value.millisecondsSinceEpoch.toDouble());
  }
}
