import 'dart:async';

import 'package:example/src/home/model.dart';
import 'package:get_smart/get_smart.dart';

class Api {
  Future<GetResult<AlphabetModel>> getAlphabets() async {
    return Future.value(alphabetData.getResult(as: AlphabetModel()));
  }

  Future<GetResult<AlphabetExtraModel>> getExtraAlphabets() async {
    return Future.value(alphabetData.getResult(as: AlphabetExtraModel()));
  }
}

const alphabetData = """
{
   "tag":"test",
   "msg":"Success",
   "status":true,
   "result":[
      {
         "id":"A",
         "description":"Apple",
         "simpleList" : [
          "A", "B", "C", "D", "E", "F", "G", "H"
         ], 
         "simpleObjects" : [
          { "key" : "A" }, 
          { "key" : "B" },
          { "key" : "C" }, 
          { "key" : "D" }, 
          { "key" : "E" }, 
          { "key" : "F" }, 
          { "key" : "G" }, 
          { "key" : "H" }
         ]
      },
      {
         "id":"B",
         "description":"Ball",
         "deepList": [
           [["A", "B"], ["C", "D"]],
           [["E", "F"], ["G", "H"]]
         ],
         "pairObjects" : [
           [{ "key" : "B" }, { "key" : "A" }],
           [{ "key" : "B" }, { "key" : "B" }]
         ],
         "pairs": [
           ["B", "A"],
           ["B", "B"]
         ]
      },
      {
         "id":"C",
         "description":"Cat",
          "pairObjects" : [
           [{ "key" : "C" }, { "key" : "A" }],
           [{ "key" : "C" }, { "key" : "B" }],
           [{ "key" : "C" }, { "key" : "C" }]
         ],
         "pairs": [
           ["C", "A"],
           ["C", "B"],
           ["C", "C"]
         ]
      },
      {
         "id":"D",
         "description":"Doll",
          "pairObjects" : [
            [{ "key" : "D" }, { "key" : "A" }],
            [{ "key" : "D" }, { "key" : "B" }],
            [{ "key" : "D" }, { "key" : "C" }],
            [{ "key" : "D" }, { "key" : "D" }]
         ],
         "pairs": [
          ["D", "A"],
          ["D", "B"],
          ["D", "C"],
          ["D", "D"]
         ]
      },
      {
         "id":"E",
         "description":"Elephant",
          "pairObjects" : [
              [{ "key" : "E" }, { "key" : "A" }],
              [{ "key" : "E" }, { "key" : "B" }],
              [{ "key" : "E" }, { "key" : "C" }],
              [{ "key" : "E" }, { "key" : "D" }],
              [{ "key" : "E" }, { "key" : "E" }]
         ],
         "pairs": [
          ["E", "A"],
          ["E", "B"],
          ["E", "C"],
          ["E", "D"],
          ["E", "E"]
         ]
      },
      {
         "id":"F",
         "description":"Frog",
          "pairObjects" : [
              [{ "key" : "F" }, { "key" : "A" }],
              [{ "key" : "F" }, { "key" : "B" }],
              [{ "key" : "F" }, { "key" : "C" }],
              [{ "key" : "F" }, { "key" : "D" }],
              [{ "key" : "F" }, { "key" : "E" }],
              [{ "key" : "F" }, { "key" : "F" }]
         ],
         "pairs": [
          ["F", "A"],
          ["F", "B"],
          ["F", "C"],
          ["F", "D"],
          ["F", "E"],
          ["F", "F"]
         ]
      },
      {
         "id":"G",
         "description":"Glass",
          "pairObjects" : [
              [{ "key" : "G" }, { "key" : "A" }],
              [{ "key" : "G" }, { "key" : "B" }],
              [{ "key" : "G" }, { "key" : "C" }],
              [{ "key" : "G" }, { "key" : "D" }],
              [{ "key" : "G" }, { "key" : "E" }],
              [{ "key" : "G" }, { "key" : "F" }],
              [{ "key" : "G" }, { "key" : "G" }]
         ],
         "pairs": [
          ["G", "A"],
          ["G", "B"],
          ["G", "C"],
          ["G", "D"],
          ["G", "E"],
          ["G", "F"],
          ["G", "G"]
         ]
      },
      {
         "id":"H",
         "description":"Horse",
          "pairObjects" : [
              [{ "key" : "H" }, { "key" : "A" }],
              [{ "key" : "H" }, { "key" : "B" }],
              [{ "key" : "H" }, { "key" : "C" }],
              [{ "key" : "H" }, { "key" : "D" }],
              [{ "key" : "H" }, { "key" : "E" }],
              [{ "key" : "H" }, { "key" : "F" }],
              [{ "key" : "H" }, { "key" : "G" }],
              [{ "key" : "H" }, { "key" : "H" }]
         ],
         "pairs": [
          ["H", "A"],
          ["H", "B"],
          ["H", "C"],
          ["H", "D"],
          ["H", "E"],
          ["H", "F"],
          ["H", "G"],
          ["H", "H"]
         ]
      },
      {
         "id":"I",
         "description":"Ink",
          "pairObjects" : [
              [{ "key" : "I" }, { "key" : "A" }],
              [{ "key" : "I" }, { "key" : "B" }],
              [{ "key" : "I" }, { "key" : "C" }],
              [{ "key" : "I" }, { "key" : "D" }],
              [{ "key" : "I" }, { "key" : "E" }],
              [{ "key" : "I" }, { "key" : "F" }],
              [{ "key" : "I" }, { "key" : "G" }],
              [{ "key" : "I" }, { "key" : "H" }],
              [{ "key" : "I" }, { "key" : "I" }]
         ],
         "pairs": [
          ["I", "A"],
          ["I", "B"],
          ["I", "C"],
          ["I", "D"],
          ["I", "E"],
          ["I", "F"],
          ["I", "G"],
          ["I", "H"],
          ["I", "I"]
         ]
      },
      {
         "id":"J",
         "description":"Jug",
          "pairObjects" : [
              [{ "key" : "J" }, { "key" : "A" }],
              [{ "key" : "J" }, { "key" : "B" }],
              [{ "key" : "J" }, { "key" : "C" }],
              [{ "key" : "J" }, { "key" : "D" }],
              [{ "key" : "J" }, { "key" : "E" }],
              [{ "key" : "J" }, { "key" : "F" }],
              [{ "key" : "J" }, { "key" : "G" }],
              [{ "key" : "J" }, { "key" : "H" }],
              [{ "key" : "J" }, { "key" : "I" }],
              [{ "key" : "J" }, { "key" : "J" }]
         ],
         "pairs": [
          ["J", "A"],
          ["J", "B"],
          ["J", "C"],
          ["J", "D"],
          ["J", "E"],
          ["J", "F"],
          ["J", "G"],
          ["J", "H"],
          ["J", "I"],
          ["J", "J"]
         ]
      }
   ]
}
""";
