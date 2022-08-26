import 'package:get_smart/get_smart.dart';

abstract class Mappable with Comparable<Mappable> {
  Mappable() {
    init();
  }

  Mapper get mapper => Mapper()..toJson(this);

  Map<String, dynamic> get json => mapper.json;

  String get jsonString => json.jsonString;

  Map<String, dynamic> toJson() => json;

  void fromJson(Map<String, dynamic> json) =>
      mapping(Mapper.fromJson(json, factories));

  void fromEntity() {}

  void init() {}

  void mapping(Mapper map);

  /// For new objects, use this to initialize empty values.
  void reset() => mapping(Mapper(factories));

  /// Remap this object's null properties with [other] object ones.
  void remap([Mappable? other]) => mapping(Mapper.fromJson({
        ...json,
        ...?other?.json,
      }, factories));

  /// Copies this and [other] object's properties to new one.
  T? copy<T>([Mappable? other]) => {
        ...json,
        ...?other?.json,
      }.getObject<T>(as: this as T);

  List<Function> get builders;

  MapperFactory get factories {
    final MapperFactory vFactories = {};
    for (final builder in builders) {
      vFactories.putIfAbsent(builder().runtimeType, () => builder);
    }
    return vFactories;
  }

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
