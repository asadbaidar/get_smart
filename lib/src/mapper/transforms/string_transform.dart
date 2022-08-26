import 'package:get_smart/get_smart.dart';

class StringTransform implements Transformable<String, String?> {
  StringTransform({
    this.capitalize = false,
    this.capitalizeFirst = false,
    this.withoutGarbage = false,
    this.removeSpace = false,
    this.fallback = "",
  });

  final bool capitalize;
  final bool capitalizeFirst;
  final bool withoutGarbage;
  final bool removeSpace;
  final String fallback;

  @override
  String fromJson(value) => _stringFromJson(
        value,
        capitalize,
        capitalizeFirst,
        withoutGarbage,
        removeSpace,
        fallback,
      );

  @override
  String? toJson(String? value) => _stringToJson(value, fallback);
}

class RxStringTransform implements Transformable<RxString, String?> {
  RxStringTransform({
    this.capitalize = false,
    this.capitalizeFirst = false,
    this.withoutGarbage = false,
    this.removeSpace = false,
    this.fallback = "",
  });

  final bool capitalize;
  final bool capitalizeFirst;
  final bool withoutGarbage;
  final bool removeSpace;
  final String fallback;

  @override
  RxString fromJson(value) => _stringFromJson(
        value,
        capitalize,
        capitalizeFirst,
        withoutGarbage,
        removeSpace,
        fallback,
      ).obs;

  @override
  String? toJson(RxString? value) => _stringToJson(value?.value, fallback);
}

String _stringFromJson(
  value,
  bool capitalize,
  bool capitalizeFirst,
  bool withoutGarbage,
  bool removeSpace,
  fallback,
) {
  var string = _$stringFromJson(value, fallback);
  string =
      withoutGarbage && StringX.garbage.any((g) => g == string) ? "" : string;
  string = removeSpace ? string.replaceAll(RegExp(r"\s+"), " ") : string;
  return capitalize
      ? string.capitalized
      : capitalizeFirst
          ? string.capitalizedFirst
          : string;
}

String _$stringFromJson(value, fallback) {
  try {
    if (value == null) return fallback;
    return value.toString().trim();
  } catch (e) {
    return fallback;
  }
}

String? _stringToJson(String? value, fallback) {
  if (value == null) return fallback;
  if (value.isEmpty) return null;
  return value;
}
