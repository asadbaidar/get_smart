import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:get_smart/get_smart.dart';

typedef MapperSetter = dynamic Function(dynamic v);

enum MapperType { fromJson, toJson }

enum ValueType { unknown, typedList, list, map, numeric, string, bool }

class Mapper {
  MapperType _mappingType = MapperType.fromJson;
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

  T? toObject<T>([Type? type]) {
    _mappingType = MapperType.fromJson;

    // Initialize an instance of T
    final instance = Mappable.getInstance(type ?? T);
    if (instance == null) return null;

    // Call mapping for assigning value
    instance.mapping(this);

    return instance as T;
  }

  T? toMappable<T>({T? as, List<Function>? builders}) {
    final $builders = [
      ...($cast<Mappable>(as)?.builders ?? []),
      ...(builders ?? [])
    ];
    for (final builder in $builders) {
      Mappable.factories.putIfAbsent(builder().runtimeType, () => builder);
    }
    $debugPrint(Mappable.factories);
    final object = toObject<T>(as?.runtimeType);
    if (kDebugMode) $debugPrint(object?.toString());
    for (final builder in $builders) {
      Mappable.factories.remove(builder().runtimeType);
    }
    return object;
  }

  Map<String, dynamic> toJson(Mappable object) {
    json = {};
    _mappingType = MapperType.toJson;

    // Call mapping for assigning value to json
    object.mapping(this);

    return json;
  }

  /// Map json fields to objects and vice versa.
  /// It uses [setter] as a getter when mapping from object to json.
  void call<T>(
    List<String> fields,
    MapperSetter setter, [
    Transformable? transform,
  ]) =>
      _map<T>(fields, null, setter, false, transform);

  /// Map json fields to objects and vice versa.
  /// It uses [value] as a getter when mapping from object to json.
  void $<T>(
    List<String> fields,
    dynamic value,
    MapperSetter setter, [
    Transformable? transform,
  ]) =>
      _map<T>(fields, value, setter, true, transform);

  /// Map json fields to objects and vice versa.
  void _map<T>(
    List<String> fields,
    dynamic value,
    MapperSetter setter,
    bool withGetter, [
    Transformable? transform,
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
    Transformable? transform,
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
          for (int i = 0; i < v.length; i++) {
            final item = transform.fromJson(v[i]);
            if (item != null) list.add(item);
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
    Transformable? transform,
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
    // Should be numeric, bool, string.. some kind of single value
    if (T.toString() == "dynamic") {
      return value;
    }

    // Attempt to map it
    return mappingType == MapperType.fromJson
        ? Mapper.fromJson(value).toObject<T>()
        : Mapper().toJson(value);
  }
}
