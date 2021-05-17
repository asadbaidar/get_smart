import 'package:get_smart/get_smart.dart';

class Alphabet extends GetObject {
  @override
  List<Function> get builders => [() => Alphabet()];
}
