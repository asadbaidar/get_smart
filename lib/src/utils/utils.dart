import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

extension UrlX on String {
  void launchUrl({bool inApp = false, bool httpOnly = false}) async {
    var url = !httpOnly || startsWith(RegExp("^(http|https)://"))
        ? this
        : "http://$this";
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: inApp,
        forceWebView: inApp,
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

extension TextStyleX on TextStyle {
  TextStyle get underlined => apply(decoration: TextDecoration.underline);

  TextStyle get italic => apply(fontStyle: FontStyle.italic);

  TextStyle get bold => apply(fontWeightDelta: 1);
}

extension ListX<E> on List<E> {
  E? get(int index) {
    if (index < length) {
      return this[index];
    }
    return null;
  }

  E? get $first {
    Iterator<E> it = iterator;
    if (!it.moveNext()) {
      return null;
    }
    return it.current;
  }

  E? $firstWhere(bool test(E element)) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
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

class StackList<T> {
  final Queue<T> _underlyingQueue;

  StackList() : _underlyingQueue = Queue<T>();

  int get length => _underlyingQueue.length;

  bool get isEmpty => _underlyingQueue.isEmpty;

  bool get isNotEmpty => _underlyingQueue.isNotEmpty;

  void clear() => _underlyingQueue.clear();

  T? peek() {
    if (isEmpty) return null;
    return _underlyingQueue.last;
  }

  T? pop() {
    if (isEmpty) return null;
    final T lastElement = _underlyingQueue.last;
    _underlyingQueue.removeLast();
    return lastElement;
  }

  void push(final T element) => _underlyingQueue.addLast(element);
}

extension ContextX on BuildContext {
  void endEditing() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(this).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }
}

class GetPlatformChannel {
  static GetPlatformChannel instance = GetPlatformChannel();

  GetPlatformChannel() {
    init();
    print("GetPlatformChannel: init");
  }

  void init() {}

  MethodChannel? get channel => null;

  Future<T?> invokeMethod<T>(
    String method, {
    dynamic arguments,
    dynamic fallback,
  }) async {
    try {
      return (await channel?.invokeMethod(method, arguments)) ?? fallback;
    } on Exception {
      return fallback;
    }
  }
}

class GetCipher {
  static GetCipher instance = GetCipher();

  FutureOr<String> decrypt(String data) => data;

  FutureOr<String> encrypt(String data) => data;

  FutureOr<String> get authToken => "";
}

class GetPrefs {
  static GetPrefs instance = GetPrefs();

  /// Override it to reload prefs.
  ///
  /// For example:
  ///```
  /// if (prefs == null)
  ///   prefs = await SharedPreferences.getInstance();
  /// else
  ///   await prefs.reload();
  /// ```
  Future<void> reload() async {}
}
