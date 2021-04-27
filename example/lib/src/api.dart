import 'package:example/src/model.dart';
import 'package:flutter/foundation.dart';
import 'package:get_smart/get_smart.dart';

class Api {
  Future<WebResponse<Alphabet>> getAlphabets() {
    return compute(parseData, Alphabet());
  }

  static WebResponse<T> parseData<T extends WebMappable>(T builder) {
    return WebResponse<T>.success()
      ..results = data.map((e) => e.mapObject<T>(builder.builders)).toList();
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
