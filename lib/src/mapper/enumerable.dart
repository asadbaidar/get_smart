import 'raw_representable.dart';

abstract class Enumerable<T> implements RawRepresentable<T> {
  const Enumerable();

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is RawRepresentable && rawValue == other.rawValue;
  }

  @override
  int get hashCode => rawValue.hashCode;
}
