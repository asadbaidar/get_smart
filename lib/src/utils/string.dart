import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

extension StringX on String {
  String pre(
    pre, {
    int doFor = 1,
    bool doIf = true,
    between,
    post,
  }) =>
      applyFor(
        doIf == true && pre != null ? doFor : 0,
        (s) =>
            pre!.toString() +
            (between?.toString() ?? "") +
            s +
            (post?.toString() ?? ""),
      );

  String post(
    post, {
    int doFor = 1,
    bool doIf = true,
    between,
    pre,
  }) =>
      applyFor(
        doIf == true && post != null ? doFor : 0,
        (s) =>
            (pre?.toString() ?? "") +
            s +
            (between?.toString() ?? "") +
            post!.toString(),
      );

  String surround(
    surround, {
    int doFor = 1,
    bool doIf = true,
    String between = "",
  }) =>
      applyFor(
        doIf == true && surround != null ? doFor : 0,
        (s) => s
            .pre(
              surround,
              between: between,
            )
            .post(
              surround,
              between: between,
            ),
      );

  static const garbage = ["(", ")", "-", "&", "/", "."];

  String takeInitialsWithoutGarbage(
    int count, {
    bool fill = false,
    List<String> garbage = garbage,
  }) =>
      takeInitials(
        count,
        fill: fill,
        withoutGarbage: true,
        garbage: garbage,
      );

  String takeInitials(
    int count, {
    bool fill = false,
    bool withoutGarbage = false,
    List<String> garbage = garbage,
  }) {
    var source = replaceAll(RegExp(r"\s+"), " ").trim();
    if (source.isNotEmpty) {
      if (withoutGarbage) {
        source = source
            .applyForIndexed<String>(
                garbage.length,
                (s, i) => s.replaceAll(
                      RegExp(r"\s*\" + garbage[i] + r"\s*",
                          caseSensitive: false),
                      " ",
                    ))
            .trim();
      }
      if (!source.contains(" ")) {
        return source.take(fill ? count : 1).trim().uppercase;
      }
      final initials = StringBuffer("");
      final sourceParts = source.split(" ");
      for (int i = 0; i < sourceParts.length; i++) {
        if (i == count) break;
        try {
          initials.write(sourceParts[i].trim().take());
        } catch (e) {
          $debugPrint(e, source);
        }
      }
      final _initials = initials.toString();
      return (fill && _initials.length < count
              ? source.take(count).trim()
              : _initials)
          .uppercase;
    }
    return source;
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

  String? get notBlank => isBlank! ? null : this;

  bool get isNotBlank => !isBlank!;

  String get afterDot => takeLastWhile((s) => s != ".");

  bool equalsIgnoreCase(String? s) => lowercase == s?.lowercase;

  bool containsIgnoreCase(String? s) =>
      s == null ? false : lowercase.contains(s.lowercase);

  Color get color => colorMaterial;

  Color get colorPrimary => GetColors.primary(this);

  Color get colorAccent => GetColors.accent(this);

  Color get colorMaterial => GetColors.material(this);

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

  String get asterik => notEmpty?.post(" *") ?? "";

  /// Uppercase each word inside string
  /// Example: your name => YOUR NAME
  String get uppercase => toUpperCase();

  /// Lowercase each word inside string
  /// Example: Your Name => your name
  String get lowercase => toLowerCase();

  /// Lowercase first letter of string
  /// Example: Your Name => your Name
  String get lowercaseFirst => isBlank == true
      ? ""
      : length == 1
          ? lowercase
          : this[0].lowercase + substring(1);

  /// Capitalize each word inside string
  /// Example: your name => Your Name
  String get capitalized => isBlank == true
      ? ""
      : length == 1
          ? uppercase
          : split(" ").map((s) => s.capitalizedFirst).join(" ");

  /// Uppercase first letter inside string and let the others lowercase
  /// Example: your name => Your name
  String get capitalizedFirst => isBlank == true
      ? ""
      : length == 1
          ? uppercase
          : this[0].uppercase + substring(1).lowercase;

  int toInt() => int.tryParse(this) ?? 0;

  double toDouble() => double.tryParse(this) ?? 0.0;

  Future<String> get encrypted async => await GetCipher.instance.encrypt(this);

  Future<String> get decrypted async => await GetCipher.instance.decrypt(this);

  Future<String> cipher(CipherType type) async =>
      await GetCipher.instance.apply(type, this);

  get json => jsonDecode(this);

  Uint8List? get base64Decoded {
    try {
      return isEmpty ? null : base64Decode(this);
    } catch (e) {
      $debugPrint(e, "base64Decoded");
      return null;
    }
  }

  String get base64Encoded {
    try {
      final bytes = toBytes();
      return bytes == null ? this : base64Encode(bytes);
    } catch (e) {
      $debugPrint(e, "base64Encoded");
      return this;
    }
  }

  Uint8List? toBytes() {
    try {
      return utf8.encoder.convert(this);
    } catch (e) {
      $debugPrint(e, "toBytes");
      return null;
    }
  }

  List<int>? toUTF8() {
    try {
      return utf8.encode(this);
    } catch (e) {
      $debugPrint(e, "toUTF8");
      return null;
    }
  }
}

extension BytesToBase64 on Uint8List {
  String? get base64Encoded {
    try {
      return isEmpty ? null : base64Encode(this);
    } catch (e) {
      $debugPrint(e, "base64Encoded");
      return null;
    }
  }

  String? toUTF8() {
    try {
      return utf8.decoder.convert(this);
    } catch (e) {
      $debugPrint(e, "toUTF8");
      return null;
    }
  }
}
