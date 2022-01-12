import 'package:get_smart/get_smart.dart';

abstract class Mappable with Comparable<Mappable> {
  static Map<Type, Function> factories = {};

  static Mappable? getInstance(Type type) {
    final constructor = Mappable.factories[type];
    assert(constructor != null,
        "${type.toString()} is not defined in Mappable.factories");
    return constructor?.call();
  }

  Mapper get mapper => Mapper()..toJson(this);

  Map<String, dynamic> get json => mapper.json;

  String get jsonString => json.jsonString;

  void mapping(Mapper map);

  void reset() => mapping(Mapper());

  void remap([Mappable? other]) => mapping(Mapper.fromJson({
        ...json,
        ...?other?.json,
      }));

  T? copy<T>([Mappable? other]) => {
        ...json,
        ...?other?.json,
      }.getObject<T>(builders: builders);

  List<Function> get builders;

  String? get equatable => null;

  String? get containable => null;

  Comparable? get comparable => toString();

  @override
  int compareTo(Mappable other) => other.comparable == null
      ? 0
      : comparable?.compareTo(other.comparable) ?? 0;

  int operator >(Mappable other) => greaterThan(other);

  int greaterThan(Mappable other) => compareTo(other);

  int operator <(Mappable other) => lessThan(other);

  int lessThan(Mappable other) => other.compareTo(this);

  @override
  bool operator ==(Object other) => equals(other);

  bool equals(Object other) {
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
