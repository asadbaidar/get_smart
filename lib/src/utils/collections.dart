import 'dart:collection';
import 'dart:convert';

class StackList<T> {
  final Queue<T> _underlyingQueue;

  StackList() : _underlyingQueue = Queue<T>();

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

  void push(final T element) => _underlyingQueue.addLast(element);
}

extension MapX<K, V> on Map<K, V> {
  String get jsonString => jsonEncode(this);
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
  E? reduceOrNull(E combine(E value, E element)) {
    try {
      return isEmpty ? null : reduce(combine);
    } catch (e) {
      return null;
    }
  }
}
