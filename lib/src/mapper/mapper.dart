import 'package:get_smart/get_smart.dart';
import 'package:get_smart/src/mapper/transforms/mapper_transform.dart';

import 'mappable.dart';
import 'transforms/transformable.dart';

typedef void MappingSetter(dynamic value);
enum MappingType { fromJson, toJson }
enum ValueType { unknown, list, map, numeric, string, bool, dynamic }

class Mapper {
  MappingType _mappingType = MappingType.fromJson;
  Map<String, dynamic> json = {};

  // Constructor
  Mapper();

  Mapper.fromJson(this.json);

  factory Mapper.fromData(data) => Mapper.fromJson(
        data is String
            ? data.json
            : data is Map<dynamic, dynamic>
                ? data.map((key, value) => MapEntry(key, value))
                : data is Map<String, dynamic>
                    ? data
                    : {},
      );

  T? toObject<T>() {
    _mappingType = MappingType.fromJson;

    // Initialize an instance of T
    final instance = Mappable.getInstance(T);
    if (instance == null) return null;

    // Call mapping for assigning value
    instance.mapping(this);

    return instance as T;
  }

  T? toMappable<T extends Mappable>({T? as, List<Function>? builders}) {
    var _builders = as?.builders ?? builders;
    _builders?.forEach((builder) {
      Mappable.factories.putIfAbsent(builder().runtimeType, () => builder);
    });
    print(Mappable.factories);
    final object = toObject<T>();
    print(object);
    _builders?.forEach((builder) {
      Mappable.factories.remove(builder().runtimeType);
    });
    return object;
  }

  Map<String, dynamic>? toJson(Mappable object) {
    json = {};
    _mappingType = MappingType.toJson;

    // Call mapping for assigning value to json
    object.mapping(this);

    return json;
  }

  /// This method will be used when a class
  /// implements the [Mappable.mapping] method
  dynamic call<T>(
    List<String> fields,
    dynamic value,
    MappingSetter setter, [
    Transformable? transform,
  ]) {
    final field = fields.firstWhere(
      (it) => json[it] != null,
      orElse: () => fields.takeFirst ?? "",
    );
    switch (_mappingType) {
      case MappingType.fromJson:
        _fromJson<T>(field, value, setter, transform);
        break;

      case MappingType.toJson:
        _toJson<T>(field, value, setter, transform);
        break;
      default:
        break;
    }
  }

  _fromJson<T>(String field, dynamic value, MappingSetter setter,
      [Transformable? transform]) {
    var v = json[field];
    final type = _getValueType(v);

    // Transform
    if (transform != null) {
      if (transform is MapperTransform) {
        setter(transform.fromJson(v != null ? v : json));
      } else if (type == ValueType.list) {
        assert(
            T.toString() != "dynamic", "Missing type at mapping for `$field`");
        final List<T?> list = [];
        for (int i = 0; i < v.length; i++) {
          final item = transform.fromJson(v[i]);
          list.add(item);
        }
        setter(list);
      } else {
        v = transform.fromJson(v);
        setter(v);
      }

      return;
    }

    switch (type) {
      // List
      case ValueType.list:
        // Return it-self, if T is not set
        if (T.toString() == "dynamic") return setter(v);
        final List<T?> list = [];

        for (int i = 0; i < v.length; i++) {
          final item = _itemBuilder<T>(v[i], MappingType.fromJson);
          list.add(item);
        }

        setter(list);
        break;

      // Map
      case ValueType.map:
        setter(_itemBuilder<T>(v, MappingType.fromJson));
        break;

      default:
        setter(v);
    }
  }

  _toJson<T>(String field, dynamic value, MappingSetter setter,
      [Transformable? transform]) {
    if (value == null) return;

    final type = _getValueType(value);

    // Transform
    if (transform != null) {
      if (type == ValueType.list) {
        final list = [];
        for (int i = 0; i < value.length; i++) {
          final item = transform.toJson(value[i]);
          list.add(item);
        }
        this.json[field] = list;
      } else {
        value = transform.toJson(value);
        this.json[field] = value;
      }
      return;
    }

    switch (type) {
      // List
      case ValueType.list:
        final list = [];

        for (int i = 0; i < value.length; i++) {
          final item = _itemBuilder<T>(value[i], MappingType.toJson);
          list.add(item);
        }

        this.json[field] = list;
        break;

      // Map
      case ValueType.map:
        this.json[field] = value;
        break;

      default:
        if (value is Mappable) {
          this.json[field] = value.toJson();
          return;
        }
        this.json[field] = value;
    }
  }

  ValueType _getValueType(object) {
    // Map
    if (object is Map) {
      return ValueType.map;
    }

    // List
    else if (object is List) {
      return ValueType.list;
    }

    // String
    else if (object is String) {
      return ValueType.string;
    }

    // Bool
    else if (object is bool) {
      return ValueType.bool;
    }

    // Numeric
    else if (object is int || object is double) {
      return ValueType.numeric;
    }

    // Dynamic
//		else if (object is dynamic) {
//			return ValueType.dynamic;
//		}

    return ValueType.unknown;
  }

  _itemBuilder<T>(value, MappingType mappingType) {
    // Should be numeric, bool, string.. some kind of single value
    if (T.toString() == "dynamic") {
      return value;
    }

    // Attempt to map it
    return mappingType == MappingType.fromJson
        ? Mapper.fromJson(value).toObject<T>()
        : Mapper().toJson(value);
  }
}
