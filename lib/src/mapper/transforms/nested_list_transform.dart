import 'package:get_smart/get_smart.dart';

typedef SimpleListBuilder<ITEM, LIST> = LIST Function(List v);

typedef MappableListBuilder<ITEM, LIST> = LIST Function(
    List v, ITEM Function(dynamic json) factory);

class NestedListTransform<ITEM, LIST extends List>
    implements FactoryTransformable<LIST?, List?> {
  NestedListTransform(SimpleListBuilder<ITEM, LIST> this.builder)
      : mappablebuilder = null;

  NestedListTransform.mappable(
      MappableListBuilder<ITEM, LIST> this.mappablebuilder)
      : builder = null;

  final SimpleListBuilder<ITEM, LIST>? builder;
  final MappableListBuilder<ITEM, LIST>? mappablebuilder;

  @override
  LIST? fromJson(value, MapperFactory factories) {
    try {
      if (value is List && value.isNotEmpty) {
        return builder?.call(value) ??
            mappablebuilder?.call(
              value,
              (json) => Mapper.fromJson(json, factories).toObject<ITEM>()!,
            );
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  @override
  List? toJson(LIST? value) {
    if (value == null) return null;
    return _toJson(value);
  }

  _toJson(value) {
    if (value is List && value.isNotEmpty) {
      if (value.first is List) {
        return List.generate(value.length, (i) => _toJson(value[i]));
      } else {
        return List.generate(value.length, (i) {
          final object = value[i];
          return object is Mappable ? object.json : object;
        });
      }
    } else {
      return [];
    }
  }
}
