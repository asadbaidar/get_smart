import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

part 'entity.dart';
part 'extra_model.dart';

class AlphabetModel extends Alphabet {
  @override
  List<Function> get builders => [() => AlphabetModel()];

  @override
  MapperFactory get factories => {
        ...super.factories,
        PairObject: () => PairObjectModel(),
      };

  AlphabetModel({
    this.simpleList,
    this.simpleObjects,
  });

  @override
  void init() {
    _simpleList = simpleList;
    _simpleObjects = simpleObjects;
  }

  @override
  void fromEntity() {
    simpleList = _simpleList;
    simpleObjects = _simpleObjects?.cast();
  }

  List<String>? simpleList;
  List<PairObjectModel>? simpleObjects;

  //extra fields
  GetFile? file;
  IconData? get attachment => file == null
      ? null
      : file?.isImage == true
          ? Icons.photo_library_outlined
          : Icons.video_collection_outlined;
}

class PairObjectModel extends PairObject {
  @override
  List<Function> get builders => [() => PairObjectModel()];

  PairObjectModel({
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
