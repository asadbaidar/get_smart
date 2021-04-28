import 'package:example/src/home/model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_smart/get_smart.dart';

class Api {
  Future<GetResult<Alphabet>> getAlphabets() {
    return compute(parseData, Alphabet());
  }

  static GetResult<T> parseData<T extends GetObject>(T mappable) {
    return GetResult<T>.success()
      ..list = data.map((e) => e.getObject<T>(as: mappable)).toList();
  }
}

const data = [
  {
    "id": "A",
    "description": "Apple",
  },
  {
    "id": "B",
    "description": "Ball",
  },
  {
    "id": "C",
    "description": "Cat",
  },
  {
    "id": "D",
    "description": "Doll",
  },
  {
    "id": "E",
    "description": "Elephant",
  },
];
