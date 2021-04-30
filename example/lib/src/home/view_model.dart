import 'package:example/src/home/api.dart';
import 'package:example/src/home/model.dart';
import 'package:get_smart/get_smart.dart';

class HomeModel extends GetController {
  final api = Api();

  @override
  Future futureToRun() => getAlphabets();

  List<Alphabet> get alphabets => modelData<Alphabet>()?.list ?? [];

  Future getAlphabets() => runBusyFuture(api.getAlphabets());
}
