part of 'model.dart';

abstract class AlphabetExtra extends GetObject {
  List<String>? _simpleList;
  List<PairObjectExtra>? _simpleObjects;
  List<List<List<String>>>? _deepList;
  List<List<PairObjectExtra>>? _pairObjects;
  List<List<String>>? _pairs;

  @override
  void mapping(Mapper map) {
    super.mapping(map);
    map<String>(["simpleList"], (v) => _simpleList ??= v);
    map<PairObjectExtra>(["simpleObjects"], (v) => _simpleObjects ??= v);

    map<List<List<String>>>(
        ["deepList"],
        (v) => _deepList ??= v,
        NestedListTransform<String, List<List<String>>>(
          (v) => List.generate(
            v.length,
            (i) => List.generate(v[i].length, (j) => v[i][j]),
          ),
        ));

    map<List<PairObjectExtra>>(
        ["pairObjects"],
        (v) => _pairObjects ??= v,
        NestedListTransform<PairObjectExtra, List<PairObjectExtra>>.mappable(
          (v, factory) => List.generate(v.length, (i) => factory(v[i])),
        ));

    map<List<String>>(
        ["pairs"],
        (v) => _pairs ??= v,
        NestedListTransform<String, List<String>>(
          (v) => List.generate(v.length, (i) => v[i]),
        ));
  }
}

abstract class PairObjectExtra extends GetObject {
  String? _key;

  @override
  void mapping(Mapper map) {
    super.mapping(map);
    map(["key"], (v) => _key ??= v);
  }
}

class PairObjectExtraModel extends PairObjectExtra {
  @override
  List<Function> get builders => [() => PairObjectExtraModel()];

  PairObjectExtraModel({
    this.key,
  });

  @override
  void init() {
    _key = key;
  }

  @override
  void fromEntity() {
    key = _key;
  }

  String? key;
}

class AlphabetExtraModel extends AlphabetExtra {
  @override
  List<Function> get builders => [() => AlphabetExtraModel()];

  @override
  MapperFactory get factories => {
        ...super.factories,
        PairObjectExtra: () => PairObjectExtraModel(),
      };

  AlphabetExtraModel({
    this.simpleList,
    this.simpleObjects,
    this.deepList,
    this.pairObjects,
    this.pairs,
  });

  @override
  void init() {
    _simpleList = simpleList;
    _simpleObjects = simpleObjects;
    _deepList = deepList;
    _pairObjects = pairObjects;
    _pairs = pairs;
  }

  @override
  void fromEntity() {
    simpleList = _simpleList;
    simpleObjects = _simpleObjects?.cast();
    deepList = _deepList;
    pairObjects = _pairObjects
        ?.map((e) => e.map((e) => e as PairObjectExtraModel).toList())
        .toList();
    pairs = _pairs;
  }

  List<String>? simpleList;
  List<PairObjectExtraModel>? simpleObjects;
  List<List<List<String>>>? deepList;
  List<List<PairObjectExtraModel>>? pairObjects;
  List<List<String>>? pairs;

  GetFile? file;

  IconData? get attachment => file == null
      ? null
      : file?.isImage == true
          ? Icons.photo_library_outlined
          : Icons.video_collection_outlined;
}
