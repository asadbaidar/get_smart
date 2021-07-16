import 'dart:async';

import 'package:flutter/services.dart';

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
