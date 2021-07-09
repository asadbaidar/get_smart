import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart';

extension StringX on String {
  String? pre(String? pre, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && pre != null ? doFor : 0,
      (s) => pre! + s!,
    );
  }

  String? post(String? post, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && post != null ? doFor : 0,
      (s) => s! + post!,
    );
  }

  String? surround(String? surround, {int doFor = 1, bool doIf = true}) {
    return applyFor(
      doIf == true && surround != null ? doFor : 0,
      (s) => s?.pre(surround)?.post(surround),
    );
  }

  String take([int count = 1]) => characters.take(count).toString();

  String takeWhile(bool Function(String) predicate) =>
      characters.takeWhile(predicate).toString();

  String takeLast([int count = 1]) => characters.takeLast(count).toString();

  String takeLastWhile(bool Function(String) predicate) =>
      characters.takeLastWhile(predicate).toString();

  String skip([int count = 1]) => characters.skip(count).toString();

  String skipWhile(bool Function(String) predicate) =>
      characters.skipWhile(predicate).toString();

  String skipLast([int count = 1]) => characters.skipLast(count).toString();

  String skipLastWhile(bool Function(String) predicate) =>
      characters.skipLastWhile(predicate).toString();

  String? get notEmpty => isEmpty ? null : this;

  bool get isNotBlank => !isBlank!;

  String get fileType => takeLastWhile((s) => s != ".").lowercase;

  String? get mimeType => mime(this);

  MediaType? get mediaType => mimeType?.mapIt((it) => MediaType.parse(it));

  bool equalsIgnoreCase(String? s) => lowercase == s?.lowercase;

  bool containsIgnoreCase(String? s) =>
      s == null ? false : lowercase.contains(s.lowercase);

  Color get materialPrimary =>
      Colors.primaries[random(Colors.primaries.length)];

  Color get materialAccent => Colors.accents[random(Colors.accents.length)];

  bool isPasswordStrong({int min = 8}) {
    if (isBlank!) return false;

    bool hasUppercase = contains(RegExp(r'[A-Z]'));
    bool hasLowercase = contains(RegExp(r'[a-z]'));
    bool hasDigits = contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool hasNoWhitespace = !contains(RegExp(r'[\s]'));
    bool hasMinLength = length >= min;

    return hasUppercase &&
        hasLowercase &&
        hasDigits &&
        hasSpecialCharacters &&
        hasNoWhitespace &&
        hasMinLength;
  }

  /// Uppercase each word inside string
  /// Example: your name => YOUR NAME
  String get uppercase => toUpperCase();

  /// Lowercase each word inside string
  /// Example: Your Name => your name
  String get lowercase => toLowerCase();

  /// Capitalize each word inside string
  /// Example: your name => Your Name
  String get capitalized {
    return isBlank!
        ? ""
        : length == 1
            ? uppercase
            : split(' ').map((s) => s.capitalizedFirst).join(' ');
  }

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  String get capitalizedFirst {
    return isBlank!
        ? ""
        : length == 1
            ? uppercase
            : this[0].uppercase + substring(1).lowercase;
  }

  bool get boolYN => trim().equalsIgnoreCase("Y");

  Future<String> get encrypted async => await GetCipher.instance.encrypt(this);

  Future<String> get decrypted async => await GetCipher.instance.decrypt(this);

  get json => jsonDecode(this);

  int toInt() => int.tryParse(this) ?? 0;

  double toDouble() => double.tryParse(this) ?? 0.0;

  List<int> toUTF8() => utf8.encode(this);
}
