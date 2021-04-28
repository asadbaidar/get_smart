import 'package:get_smart/get_smart.dart';

class BoolTransform implements Transformable<bool, String> {
  BoolTransform({this.fallback = false});

  final bool fallback;

  @override
  bool fromJson(value) {
    try {
      if (value == null) return fallback;
      if (value is bool) return value;
      if (value is String) return value.boolYN;
      return fallback;
    } catch (e) {
      return fallback;
    }
  }

  @override
  String toJson(bool? value) {
    if (value == null) return fallback.stringYN;
    return value.stringYN;
  }
}

extension Bool on bool {
  String get stringYN => this ? "Y" : "N";
}
