import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

abstract class GetObject extends Mappable {
  DateTime? currentTime;
  String? _id;
  String? _description;

  String get id => _id ?? idFallback ?? "";

  set id(String id) => _id = id;

  String get description => _description ?? descriptionFallback ?? "";

  set description(String description) => _description = description;

  String? get idFallback => null;

  String? get descriptionFallback => null;

  List<String> get idKeys => ["ID", "id"];

  List<String> get descriptionKeys => ["DESCRIPTION", "description"];

  bool get capitalized => false;

  @override
  void mapping(Mapper map) {
    map(["CURRENT_TIME"], currentTime, (v) => currentTime = v ?? Date.now,
        DateTransform());
    map(idKeys, _id, (v) => _id = v?.toString());
    map(
      descriptionKeys,
      _description,
      (v) => _description =
          v?.toString().applyIf(capitalized, (s) => s.capitalized),
    );
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

  String? get equatable => id;

  String? get containable => id + description;

  var isExpanded = false;

  bool toggleExpand() => isExpanded = !isExpanded;

  IconData get expandedIcon =>
      isExpanded ? Icons.expand_less : Icons.expand_more;

  var isChecked = false;

  bool toggleChecked() => isChecked = !isChecked;

  Color get color => description.materialAccent;
}
