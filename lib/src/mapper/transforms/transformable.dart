import 'package:get_smart/get_smart.dart';

abstract class BaseTransformable<Object, JSON> {
  JSON toJson(Object value);
}

abstract class Transformable<Object, JSON>
    implements BaseTransformable<Object, JSON> {
  Object fromJson(dynamic value);
}

abstract class FactoryTransformable<Object, JSON>
    implements BaseTransformable<Object, JSON> {
  Object fromJson(dynamic value, MapperFactory factories);
}
