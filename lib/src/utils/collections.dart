import 'dart:collection';
import 'dart:convert';

class StackList<T> {
  final Queue<T> _underlyingQueue;

  StackList() : _underlyingQueue = Queue<T>();

  StackList.from(Iterable elements)
      : _underlyingQueue = Queue<T>.from(elements);

  int get length => _underlyingQueue.length;

  bool get isEmpty => _underlyingQueue.isEmpty;

  bool get isNotEmpty => _underlyingQueue.isNotEmpty;

  void clear() => _underlyingQueue.clear();

  T? peek() {
    if (isEmpty) return null;
    return _underlyingQueue.last;
  }

  T? pop() {
    if (isEmpty) return null;
    final T lastElement = _underlyingQueue.last;
    _underlyingQueue.removeLast();
    return lastElement;
  }

  T push(T element) {
    _underlyingQueue.addLast(element);
    return element;
  }
}

extension MapX<K, V> on Map<K, V> {
  String get jsonString => jsonEncode(this);
}

extension MapDynamic<K> on Map<K, dynamic> {
  Map<K, dynamic> get replaceNullWithEmpty => isEmpty
      ? this
      : entries.map((e) => MapEntry(e.key, e.value ?? "")).toMap();
}

extension IterableMapEntry<K, V> on Iterable<MapEntry<K, V>> {
  Map<K, V> toMap() => Map<K, V>.fromEntries(this);
}

extension ListX<E> on List<E> {
  E? get(int? index) {
    if (index != null && index < length) {
      return this[index];
    }
    return null;
  }
}

extension IterableX<E> on Iterable<E> {
  E? reduceOrNull(E Function(E value, E element) combine) {
    try {
      return isEmpty ? null : reduce(combine);
    } catch (e) {
      return null;
    }
  }

  Iterable<E> exclude(bool Function(E element) where) =>
      expand((e) => where(e) ? [] : [e]);

  Iterable<E> get notEmpty => exclude((e) => e.toString().isEmpty);
}

extension EnumIterableX<T extends Enum> on Iterable<T> {
  /// Finds the enum value in this list with name [name].
  ///
  /// Goes through this collection looking for an enum with
  /// name [name], as reported by [EnumName.name].
  /// Returns the first value with the given name or null if none found.
  T? byNameOrNull(String name) {
    for (var value in this) {
      if (value.name == name) return value;
    }
    return null;
  }
}
