import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

extension GetInterfaceX on GetInterface {
  TargetPlatform get platform => theme.platform;

  bool get isIOS => platform == TargetPlatform.iOS;

  bool get isAndroid => platform == TargetPlatform.android;

  bool get isLinux => platform == TargetPlatform.linux;

  bool get isMacOS => platform == TargetPlatform.macOS;

  bool get isWindows => platform == TargetPlatform.windows;

  bool get isFuchsia => platform == TargetPlatform.fuchsia;

  bool get isWeb => kIsWeb;

  bool get canPop => Navigator.canPop(context!);

  Future<void> systemPop({bool animated = true}) =>
      SystemNavigator.pop(animated: animated);

  Future<bool> maybePop<T extends Object>([T? result]) =>
      Navigator.maybePop<T>(context!, result);

  void backUntil(String route) => until((r) => r.settings.name == route);

  T? $arguments<T extends Mappable>({T? as, List<Function>? builders}) =>
      $object(arguments)?.getObject<T>(as: as, builders: builders);

  /// Finds an Instance of the required Class <[S]>(or [tag])
  /// Returns null if not found.
  S? $find<S>({String? tag}) {
    try {
      return GetInstance().find<S>(tag: tag);
    } catch (e) {
      return null;
    }
  }

  /// Deprecated method. Please use [$find] instead.
  @Deprecated("Please use `Get.\$find` instead.")
  S? find<S>({String? tag}) => null;

  MaterialLocalizations get localization => MaterialLocalizations.of(context!);
}
