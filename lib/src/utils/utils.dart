import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

extension UrlX on String {
  void launchUrl({bool? inApp, bool httpOnly = false}) async {
    var url = !httpOnly || startsWith(RegExp("^(http|https)://"))
        ? this
        : "http://$this";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: inApp ?? Get.isIOS,
        forceWebView: inApp ?? Get.isIOS,
        statusBarBrightness:
            GetTheme.isDarkMode ? Brightness.dark : Brightness.light,
      );
    }
  }
}

extension MediaQueryX on MediaQueryData {
  /// Return true if the screen has tall mobile view size
  bool get isScreenMini => size.width < 300;

  /// Return true if the screen has mobile view size
  bool get isScreenSmall => size.width < 600;

  /// Return true if the screen has tablet view size
  bool get isScreenMedium => size.width > 600 && size.width < 990;

  /// Return true if the screen has desktop view size
  bool get isScreenLarge => size.width > 990;
}

extension RandomX on Random {
  /// Generates a cryptographically secure random nonce
  String nonce([int length = 32]) {
    final charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    return List.generate(length, (_) => charset[nextInt(charset.length)])
        .join();
  }
}

extension Uint8ListX on Uint8List {
  /// Convert bytes to memory image
  MemoryImage? image({double scale = 1.0}) =>
      isEmpty ? null : MemoryImage(this, scale: scale);
}

class GetException implements Exception {
  final dynamic message;

  GetException([this.message]);

  String toString() => message == null ? GetText.failed() : message;
}
