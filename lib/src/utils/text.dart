import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

extension TextInputTypeX on TextInputType {
  static TextInputType get numberFirst => Get.isIOS
      ? TextInputType.numberWithOptions(signed: true)
      : TextInputType.visiblePassword;

  static TextInputType get numberOnly =>
      TextInputType.numberWithOptions(signed: true);
}

extension TextInputFilter on TextInputFormatter {
  static List<TextInputFormatter> get phone => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r"^(\+?)[0-9]*"),
        )
      ];

  static List<TextInputFormatter> get numberOnly => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r'[0-9]'),
        )
      ];

  static TextInputFormatter get notEmpty =>
      FilteringTextInputFormatter.deny(RegExp(r"^(\s)"));

  static TextInputFormatter get noWhitespace =>
      FilteringTextInputFormatter.deny(RegExp(r'[\s]'));

  static List<TextInputFormatter> get numberAndDash => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r"^[0-9]*?\d{1}-|[0-9]*"),
        )
      ];

  static List<TextInputFormatter> get mrNumber => [
        noWhitespace,
        FilteringTextInputFormatter.allow(
          RegExp(r'[WINwin-]|[0-9]'),
        )
      ];
}
