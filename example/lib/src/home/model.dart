import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class Alphabet extends GetObject {
  @override
  List<Function> get builders => [() => Alphabet()];

  GetFile? file;

  IconData? get attachment => file == null
      ? null
      : file?.isImage == true
          ? Icons.photo_library_outlined
          : Icons.video_collection_outlined;
}
