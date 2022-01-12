import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:flutter/material.dart';
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
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    return List.generate(length, (_) => charset[nextInt(charset.length)])
        .join();
  }
}

extension Uint8ListX on Uint8List {
  /// Convert bytes to memory image
  MemoryImage? memoryImage({double scale = 1.0}) =>
      isEmpty ? null : MemoryImage(this, scale: scale);
}

extension CompleterX<T> on Completer<T> {
  /// Completes [future] with the supplied values if not already completed.
  void completeIfCan([FutureOr<T>? value]) {
    if (!isCompleted) complete();
  }
}

extension MaterialStatePropertyX<T> on MaterialStateProperty<T> {
  T? get normal => resolve({});

  T? get hovered => resolve({MaterialState.hovered});

  T? get focused => resolve({MaterialState.focused});

  T? get pressed => resolve({MaterialState.pressed});

  T? get dragged => resolve({MaterialState.dragged});

  T? get selected => resolve({MaterialState.selected});

  T? get scrolledUnder => resolve({MaterialState.scrolledUnder});

  T? get disabled => resolve({MaterialState.disabled});

  T? get error => resolve({MaterialState.error});
}

class GetException implements Exception {
  GetException([this.message]);

  final dynamic message;

  @override
  String toString() => message ?? GetText.failed();
}

typedef GetTimerCallback = void Function(Duration elapsed);

class GetTimer {
  GetTimer({
    Duration duration = Duration.zero,
    this.period = const Duration(seconds: 1),
    this.extendable = false,
    this.onCancel,
    this.onTick,
  })  : countDown = false,
        duration = duration - period,
        tag = "Timer" {
    elapsed = this.duration;
  }

  GetTimer.countDown(
    Duration? duration, {
    this.period = const Duration(seconds: 1),
    this.extendable = true,
    this.onCancel,
    this.onTick,
  })  : countDown = true,
        duration = duration?.let((it) => it! - period) ?? Duration.zero,
        tag = "CountDown" {
    elapsed = this.duration;
  }

  final String tag;
  final Duration duration;
  final Duration period;
  final bool extendable;
  final bool countDown;
  final GetTimerCallback? onCancel;
  final GetTimerCallback? onTick;

  Timer? _timer;
  final _elapsed = Duration.zero.obs;

  set elapsed(v) => _elapsed.value = v;

  Duration get elapsed => _elapsed.value;

  Duration get elapsedPeriod => elapsed + period;

  void start() {
    if (extendable) reset();
    if (_timer == null) {
      reset();
      _onTick();
      _timer = Timer.periodic(period, (_) {
        if (countDown && _elapsed.value <= Duration.zero ||
            !countDown &&
                duration != Duration.zero &&
                _elapsed.value >= duration) {
          _onCancel();
        } else {
          _onTick();
        }
      });
    }
  }

  void _onCancel() {
    $debugPrint("elapsed $elapsed", tag);
    cancel();
    onCancel?.call(elapsed);
  }

  void _onTick() {
    $debugPrint("elapsed $elapsed", tag);
    if (countDown) {
      _elapsed.value -= period;
    } else {
      _elapsed.value += period;
    }
    onTick?.call(elapsed);
  }

  void reset() => elapsed = countDown ? duration : Duration.zero;

  void cancel() {
    _timer?.cancel();
    _timer = null;
    if (countDown) elapsed = Duration.zero;
  }

  bool get isCanceled => _timer == null;
}
