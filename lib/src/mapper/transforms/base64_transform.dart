import 'dart:typed_data';

import 'package:get_smart/get_smart.dart';

class Base64Transform implements Transformable<Uint8List?, String?> {
  Base64Transform({this.fallback});

  final Uint8List? fallback;

  @override
  Uint8List? fromJson(value) => value?.toString().base64Decoded ?? fallback;

  @override
  String? toJson(Uint8List? value) => value?.base64Encoded;
}
