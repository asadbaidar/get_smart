library mappable;

import 'dart:convert';

import 'package:get_smart/get_smart.dart';

import 'mapper.dart';

abstract class Mappable with Comparable<Mappable> {
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

  List<Function> get builders => [];

  String? get equatable => null;

  String? get containable => null;

  Comparable? get comparable => toString();

  @override
  int compareTo(Mappable other) => other.comparable == null
      ? 0
      : comparable?.compareTo(other.comparable) ?? 0;

  int operator >(Mappable other) => compareTo(other);

  int operator <(Mappable other) => other.compareTo(this);

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    return other is Mappable &&
        (identical(other, this) ||
            equatable?.equalsIgnoreCase(other.equatable) == true);
  }

  @override
  int get hashCode => identityHashCode(equatable?.lowercase);

  bool contains(object) =>
      containable?.contains(object?.toString() ?? "") ?? false;

  bool containsIgnoreCase(object) =>
      containable?.containsIgnoreCase(object?.toString() ?? "") ?? false;
}
