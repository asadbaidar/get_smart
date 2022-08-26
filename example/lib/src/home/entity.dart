part of 'model.dart';

abstract class Alphabet extends GetObject {
  List<String>? _simpleList;
  List<PairObject>? _simpleObjects;

  @override
  void mapping(Mapper map) {
    super.mapping(map);
    map<String>(["simpleList"], (v) => _simpleList ??= v);
    map<PairObject>(["simpleObjects"], (v) => _simpleObjects ??= v);
  }
}

abstract class PairObject extends GetObject {
  String? _key;

  @override
  void mapping(Mapper map) {
    super.mapping(map);
    map(["key"], (v) => _key ??= v);
  }
}
