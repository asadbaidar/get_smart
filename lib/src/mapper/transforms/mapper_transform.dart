import 'package:get_smart/get_smart.dart';

class MapperTransform<T extends Mappable>
    implements Transformable<T?, Map<String, dynamic>?> {
  @override
  T? fromJson(value) {
    try {
      if (value == null) return null;
      if (value is Map<String, dynamic>)
        return Mapper.fromJson(value).toObject<T>();
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(T? value) {
    if (value == null) return null;
    return value.toJson();
  }
}
