import 'package:example/src/home/api.dart';
import 'package:example/src/home/model.dart';
import 'package:get_smart/get_smart.dart';

class HomeController extends GetController {
  final api = Api();

  @override
  Future futureToRun() => getAlphabets();

  List<AlphabetModel> get alphabets => result()?.data ?? [];

  Future getAlphabets() => runBusyFuture(api.getAlphabets());

  List<AlphabetExtraModel> get extraAlphabets =>
      resultFor(AlphabetExtraModel)?.data ?? [];

  Future getExtraAlphabets() =>
      runBusyFuture(api.getExtraAlphabets(), key: AlphabetExtraModel);
}
