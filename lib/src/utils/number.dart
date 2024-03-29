import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

extension Num on num {
  double get half => this * 0.5;

  double get oneHalf => this * 1.5;

  double get twice => this * 2;

  double get roundCorner => this * 0.2237;

  BorderRadius get roundRadius => BorderRadius.circular(roundCorner);

  BoxDecoration roundBox({Color? color}) => BoxDecoration(
        borderRadius: roundRadius,
        border: color != null && !color.isDark
            ? Border.all(color: color.darker, width: 0.2)
            : null,
        color: color,
      );

  Radius get radius => Radius.circular(toDouble());

  BorderRadius get circularRadius => BorderRadius.circular(toDouble());

  BoxDecoration circularBox({Color? color}) => BoxDecoration(
        borderRadius: circularRadius,
        border: color != null && !color.isDark
            ? Border.all(color: color.darker, width: 0.2)
            : null,
        color: color,
      );

  void repeatsFor<T>(Function apply) {
    if (this > 0) {
      for (int i = 0; i < this; i++) {
        apply();
      }
    }
  }

  void repeatsForIndexed<T>(Function(int i) apply) {
    if (this > 0) {
      for (int i = 0; i < this; i++) {
        apply(i);
      }
    }
  }

  DateTime get dateTime => DateTime.fromMillisecondsSinceEpoch(toInt());

  String get formatted => Get.localization.formatDecimal(toInt());

  String formatDecimal([int? fractionDigits]) =>
      Get.localization.formatDecimal(toInt()).post(
          fractionDigits != null
              ? toStringAsFixed(fractionDigits).afterDot
              : this is double
                  ? toString().afterDot
                  : null,
          between: GetLocalizations.current?.symbols.DECIMAL_SEP);

  String formatCurrency([int? fractionDigits]) => formatDecimal(
        fractionDigits ?? GetLocalizations.current?.currencyFraction,
      );

  String? formatWith({
    String? zero,
    String? zeroReplace,
    String? one,
    String? oneReplace,
    String? many,
    String? manyReplace,
    String? other,
    String? otherReplace,
    String? all,
    String? allReplace,
  }) =>
      toInt().mapTo(
        (int it) => it == 0
            ? allReplace ??
                zeroReplace ??
                (zero ?? other ?? all)?.pre(formatted, between: " ") ??
                otherReplace
            : it == 1
                ? allReplace ??
                    oneReplace ??
                    (one ?? other ?? all)?.pre(formatted, between: " ") ??
                    otherReplace
                : it > 1
                    ? allReplace ??
                        manyReplace ??
                        (many ?? other ?? all)?.pre(formatted, between: " ") ??
                        otherReplace
                    : allReplace ??
                        otherReplace ??
                        (other ?? all)?.pre(formatted, between: " "),
      );

  bool inRange(int start, int end) => this >= start && this < end;

  List<int> toRange(int end) =>
      this < end ? [for (int i = toInt(); i < end; i++) i] : [];

  String padLeft(
    int width, {
    String withPadding = "0",
    bool doIf = true,
  }) =>
      width <= 0
          ? ""
          : doIf == true
              ? toString().padLeft(width, withPadding)
              : toString();

  /// Returns random integer less than number
  int get random => Random().nextInt(toInt());
}

extension DurationX on Duration {
  String formatted({
    int hoursWidth = 2,
    int minutesWidth = 2,
    int secondsWidth = 2,
    bool hoursAlways = true,
  }) {
    var _hoursWidth = hoursAlways == true || inHours > 0 ? hoursWidth : 0;
    var _secondsWidth = minutesWidth > 0 ? secondsWidth : 0;
    String hours = inHours
        .padLeft(_hoursWidth)
        .post(":", doIf: _hoursWidth > 0 && minutesWidth > 0);
    String minutes = inMinutes
        .remainder(60)
        .padLeft(minutesWidth)
        .post(":", doIf: minutesWidth > 0 && _secondsWidth > 0);
    String seconds = inSeconds.remainder(60).padLeft(_secondsWidth);
    return hours + minutes + seconds;
  }

  String get formatted0mSS => formatted(hoursWidth: 0, minutesWidth: 1);

  String get formatted0mmSS => formatted(hoursWidth: 0);

  String get formattedHmm => formatted(hoursWidth: 1, secondsWidth: 0);

  String get formattedHmmSS => formatted(hoursWidth: 1);

  String get formattedHHmm => formatted(secondsWidth: 0);

  String get formattedHHmmSS => formatted();
}

extension CurrencyNum on num {
  String get inPKR => "$this PKR";
}

extension CurrencyString on String {
  String get inPKR => "$this PKR";
}
