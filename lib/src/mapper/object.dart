import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

abstract class GetObject extends Mappable {
  DateTime? currentTime;
  String? _id;
  String? _description;

  String get id => _id ?? idFallback ?? "";

  set id(id) => _id = id;

  String get description => _description ?? descriptionFallback ?? "";

  set description(description) => _description = description;

  String? get idFallback => null;

  String? get descriptionFallback => null;

  List<String> get idKeys => ["ID", "id"];

  List<String> get descriptionKeys => ["DESCRIPTION", "description"];

  bool get capitalized => false;

  @override
  void mapping(Mapper map) {
    map(["CURRENT_TIME"], (v) => currentTime ??= v, DateTransform());
    map(idKeys, (v) => _id ??= v?.toString());
    map(descriptionKeys, (v) => _description ??= v,
        StringTransform(capitalize: capitalized));
  }

  Future get decrypted async {
    id = await id.decrypted;
    description = await description.decrypted;
    return this;
  }

  bool get isEmpty => id.isEmpty && description.isEmpty;

  bool get isNotEmpty => id.isNotEmpty && description.isNotEmpty;

  @override
  String toString() => description;

  @override
  String? get equatable => id;

  @override
  String? get containable => id + description;

  Color get color => materialAccent;

  Color get materialAccent => description.materialAccent;

  Color get materialPrimary => description.materialPrimary;

  var isExpanded = false;

  bool toggleExpand() => isExpanded = !isExpanded;

  IconData get expandedIcon =>
      isExpanded ? CupertinoIcons.chevron_up : CupertinoIcons.chevron_down;

  Matrix4 get expandedAngle => Matrix4.rotationZ(isExpanded ? pi : 0);

  var isChecked = false;

  bool toggleChecked() => isChecked = !isChecked;
}
