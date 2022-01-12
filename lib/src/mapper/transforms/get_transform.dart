import 'package:get_smart/get_smart.dart';

class GetTransform<T extends Mappable>
    implements Transformable<T?, Map<String, dynamic>?> {
  GetTransform(this.mappable);

  final T mappable;

  @override
  T? fromJson(value) {
    try {
      if (value == null) return null;
      if (value is Map<String, dynamic>) {
        return mappable..mapping(Mapper.fromData(value));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(T? value) {
    if (value == null) return null;
    return value.json;
  }
}
