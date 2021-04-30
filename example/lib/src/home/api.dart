import 'dart:async';

import 'package:example/src/home/model.dart';
import 'package:get_smart/get_smart.dart';

class Api {
  Future<GetResult<Alphabet>> getAlphabets() async {
    return Future.value(parseData(GetResult<Alphabet>(), Alphabet()));
  }
}

T? parseData<T>(T as, Mappable mappable) {
  return data.getObject<T>(as: as, builders: mappable.builders);
}

const data = """
{
   "tag":"test",
   "msg":"Success",
   "status":true,
   "result":[
      {
         "id":"A",
         "description":"Apple"
      },
      {
         "id":"B",
         "description":"Ball"
      },
      {
         "id":"C",
         "description":"Cat"
      },
      {
         "id":"D",
         "description":"Doll"
      },
      {
         "id":"E",
         "description":"Elephant"
      },
      {
         "id":"F",
         "description":"Frog"
      },
      {
         "id":"G",
         "description":"Glass"
      },
      {
         "id":"H",
         "description":"Horse"
      },
      {
         "id":"I",
         "description":"Ink"
      },
      {
         "id":"J",
         "description":"Jug"
      }
   ]
}
""";
