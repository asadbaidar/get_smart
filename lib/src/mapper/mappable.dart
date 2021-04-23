library mappable;

import 'dart:convert';

import 'mapper.dart';

abstract class Mappable {
  static Map<Type, Function> factories = {};

  static Mappable? getInstance(Type type) {
    final constructor = Mappable.factories[type];
    assert(constructor != null,
        "${type.toString()} is not defined in Reflection.factories");
    return constructor?.call();
  }

  void mapping(Mapper map);

  Map<String, dynamic>? toJson() {
    return Mapper().toJson(this);
  }

  String toJsonString() {
    return json.encode(this.toJson());
  }
}
