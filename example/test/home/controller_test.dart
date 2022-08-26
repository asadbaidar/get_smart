import 'package:example/src/home/api.dart';
import 'package:example/src/home/controller.dart';
import 'package:example/src/home/model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_smart/get_smart.dart';

void main() {
  HomeController controller = HomeController();
  final data = alphabetData.json["result"] as List;

  test('alphabet test', () async {
    await controller.getAlphabets();
    final alphabets = controller.alphabets;
    final alphabetsMap = alphabets.map((e) => e.json).toList();
    $logEvent(alphabetsMap, "alphabets");
    $logEvent(alphabets.first.factories, "alphabets.factories");
    $logEvent(alphabets.first.runtimeType, "alphabets");
    $logEvent(alphabets.first.simpleObjects?.first.runtimeType,
        "alphabets.simpleObjects");
    $logEvent(
        alphabets.first.simpleList?.first.runtimeType, "alphabets.simpleList");
    expect(
        alphabetsMap.first.jsonString, equals((data.first as Map).jsonString));
  });

  test('extra alphabet test', () async {
    await controller.getExtraAlphabets();
    final extraAlphabets = controller.extraAlphabets;
    final alphabetMap = extraAlphabets.map((e) => e.json).toList();
    $logEvent(alphabetMap, "extraAlphabets");
    $logEvent(extraAlphabets.first.factories, "extraAlphabets.factories");
    $logEvent(extraAlphabets.first.runtimeType, "extraAlphabet");
    $logEvent(extraAlphabets.first.simpleObjects?.first.runtimeType,
        "extraAlphabets.simpleObjects");
    $logEvent(extraAlphabets.first.pairObjects?.first.runtimeType,
        "extraAlphabets.pairObjects");
    expect(alphabetMap.jsonString, equals((data).jsonString));
  });

  test("AlphabetModel test", () {
    final alphabetModel = AlphabetModel(simpleList: ["hello"])
      ..simpleList = ["bye"];
    expect(alphabetModel.json, {
      "simpleList": ["bye"]
    });
  });

  test("AlphabetExtraModel test", () {
    final alphabetModel = AlphabetExtraModel(simpleList: ["hello"])
      ..simpleList = ["bye"];
    expect(alphabetModel.json, {
      "simpleList": ["bye"]
    });
  });
}
