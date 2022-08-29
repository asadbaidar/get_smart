import 'package:get_smart/get_smart.dart';

abstract class RawRepresentable<RawValue> {
  const RawRepresentable({required this.rawValue});

  final RawValue rawValue;

  static RawRepresentable? getInstance(
    Type type,
    rawValue,
    MapperFactory? factories,
  ) {
    final constructor = factories?[type];
    if (constructor == null) return null;
    return constructor(rawValue);
  }
}
