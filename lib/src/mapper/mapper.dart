import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get_smart/get_smart.dart';

typedef MapperSetter = dynamic Function(dynamic v);
typedef MapperFactory = Map<Type, Function>;

enum MapperType { fromJson, toJson }

enum ValueType { unknown, typedList, list, map, numeric, string, bool }

class Mapper {
  final MapperFactory factories;
  MapperType _mappingType = MapperType.fromJson;
  Map<String, dynamic> json = {};

  // Constructor
  Mapper([MapperFactory? factories]) : factories = factories ?? {};

  Mapper.fromJson(this.json, [MapperFactory? factories])
      : factories = factories ?? {};

  factory Mapper.fromData(data, [MapperFactory? factories]) => Mapper.fromJson(
        data is String
            ? data.json
            : data is Map<dynamic, dynamic>
                ? data.map((key, value) => MapEntry(key, value))
                : data is Map<String, dynamic>
                    ? data
                    : {},
        factories,
      );

  T? toMappable<T>({T? as, List<Function>? builders}) {
    factories.addAll($cast<Mappable>(as)?.factories ?? {});
    for (final builder in builders ?? []) {
      factories.putIfAbsent(builder().runtimeType, () => builder);
    }
    $debugPrint(factories);
    final object = toObject<T>(as?.runtimeType);
    if (kDebugMode) $debugPrint(object?.toString());
    return object;
  }

  Mappable? newMappable(Type type) {
    final constructor = factories[type];
    assert(constructor != null,
        "${type.toString()} is not defined in Mapper.factories");
    return constructor?.call();
  }

  T? toObject<T>([Type? type]) {
    _mappingType = MapperType.fromJson;
    // Initialize an instance of T
    final instance = newMappable(type ?? T);
    if (instance == null) return null;

    // Calling mapping for assigning values
    instance.mapping(this);
    // Calling from Entity for initializing model values
    instance.fromEntity();
    return instance as T;
  }

  Map<String, dynamic> toJson(Mappable object) {
    json = {};
    _mappingType = MapperType.toJson;

    // Calling init for reseting entity values
    object.init();
    // Call mapping for assigning value to json
    object.mapping(this);
    return json;
  }

  /// Map json fields to objects and vice versa.
  /// It uses [setter] as a getter when mapping from object to json.
  void call<T>(
    List<String> fields,
    MapperSetter setter, [
    BaseTransformable? transform,
  ]) =>
      _map<T>(fields, null, setter, false, transform);

  /// Map json fields to objects and vice versa.
  /// It uses [value] as a getter when mapping from object to json.
  void $<T>(
    List<String> fields,
    dynamic value,
    MapperSetter setter, [
    BaseTransformable? transform,
  ]) =>
      _map<T>(fields, value, setter, true, transform);

  /// Map json fields to objects and vice versa.
  void _map<T>(
    List<String> fields,
    dynamic value,
    MapperSetter setter,
    bool withGetter, [
    BaseTransformable? transform,
  ]) {
    final field = fields.firstWhere(
      (f) => json[f]?.toString().notEmpty != null,
      orElse: () => fields.firstOrNull ?? "",
    );
    switch (_mappingType) {
      case MapperType.fromJson:
        _fromJson<T>(field, setter, transform);
        break;

      case MapperType.toJson:
        _toJson<T>(field, value, withGetter ? null : setter, transform);
        break;
      default:
        break;
    }
  }

  void _fromJson<T>(
    String field,
    MapperSetter setter, [
    BaseTransformable? transform,
  ]) {
    try {
      var v = json[field];
      final type = _getValueType(v);

      // Transform
      if (transform != null) {
        if (transform is GetTransform) {
          setter(transform.fromJson(v ?? json));
        } else if (type == ValueType.list) {
          assert(T.toString() != "dynamic",
              "Missing type at mapping for `$field`");
          final List<T> list = [];
          if (transform is Transformable) {
            for (int i = 0; i < v.length; i++) {
              final item = transform.fromJson(v[i]);
              if (item != null) list.add(item);
            }
          } else if (transform is FactoryTransformable) {
            for (int i = 0; i < v.length; i++) {
              final item = transform.fromJson(v[i], factories);
              if (item != null) list.add(item);
            }
          }
          setter(list);
        } else {
          if (transform is Transformable) {
            v = transform.fromJson(v);
          } else if (transform is FactoryTransformable) {
            v = transform.fromJson(v, factories);
          }
          setter(v);
        }
        return;
      }

      switch (type) {
        // List
        case ValueType.list:
          // Return it-self, if T is not set
          if (T.toString() == "dynamic") {
            setter(v);
            return;
          }
          final List<T> list = [];

          for (int i = 0; i < v.length; i++) {
            final item = _itemBuilder<T>(v[i], MapperType.fromJson);
            if (item != null) list.add(item);
          }

          setter(list);
          break;

        // Map
        case ValueType.map:
          setter(_itemBuilder<T>(v, MapperType.fromJson));
          break;

        default:
          setter(v);
      }
    } catch (e) {
      $debugPrint(e, "MappingError.fromJson");
    }
  }

  void _toJson<T>(
    String field,
    value,
    MapperSetter? setter, [
    BaseTransformable? transform,
  ]) {
    try {
      if (setter != null) value = setter(null);
      if (value == null) return;

      final type = _getValueType(value);

      // Transform
      if (transform != null) {
        if (type == ValueType.list) {
          final list = [];
          for (int i = 0; i < value.length; i++) {
            final item = transform.toJson(value[i]);
            if (item != null) list.add(item);
          }
          json[field] = list;
        } else {
          value = transform.toJson(value);
          if (value == null) return;
          json[field] = value;
        }
        return;
      }

      switch (type) {
        // List
        case ValueType.list:
          final list = [];

          for (int i = 0; i < value.length; i++) {
            final item = _itemBuilder<T>(value[i], MapperType.toJson);
            if (item != null) list.add(item);
          }

          json[field] = list;
          break;

        // Map
        case ValueType.map:
          json[field] = value;
          break;

        default:
          if (value is Mappable) {
            json[field] = value.json;
            return;
          }
          json[field] = value;
      }
    } catch (e) {
      final _value = value ?? setter?.call(null);
      final _type = _getValueType(_value);
      $debugPrint(e, "MappingError.toJson: $_type: $_value}");
    }
  }

  ValueType _getValueType(object) {
    // Map
    if (object is Map) {
      return ValueType.map;
    }
    // TypedData List
    else if (object is TypedData) {
      return ValueType.typedList;
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
    return ValueType.unknown;
  }

  _itemBuilder<T>(value, MapperType mappingType) {
    if (value is Map || value is Mappable) {
      // Attempt to map it
      return mappingType == MapperType.fromJson
          ? Mapper.fromJson(value, factories).toObject<T>()
          : Mapper().toJson(value);
    } else {
      // Should be numeric, bool, string.. some kind of single value
      return value;
    }
  }
}
