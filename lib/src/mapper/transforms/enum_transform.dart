import 'package:get_smart/get_smart.dart';

class EnumTransform<Object extends Enumerable, JSON>
    with Transformable<Object?, JSON?> {
  Object? fromJson(value) {
    if (value == null || !(value is JSON)) return null;
    return RawRepresentable.getInstance(Object, value) as Object?;
  }

  JSON? toJson(Object? value) {
    if (value == null) return null;
    return value.rawValue;
  }
}
