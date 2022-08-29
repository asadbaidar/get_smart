import 'package:get_smart/get_smart.dart';

class EnumTransform<Object extends Enumerable, JSON>
    with FactoryTransformable<Object?, JSON?> {
  @override
  Object? fromJson(value, MapperFactory? factories) {
    if (value == null || value is! JSON) return null;
    return RawRepresentable.getInstance(Object, value, factories) as Object?;
  }

  @override
  JSON? toJson(Object? value) {
    if (value == null) return null;
    return value.rawValue;
  }
}
