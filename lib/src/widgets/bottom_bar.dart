import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    this.leftItems,
    this.rightItems,
    this.centerItems,
    this.topChild,
    this.visible = true,
    Key? key,
  }) : super(key: key);

  final List<Widget>? leftItems;
  final List<Widget>? rightItems;
  final List<Widget>? centerItems;
  final Widget? topChild;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    var _leftItems = leftItems ?? [];
    var _rightItems = rightItems ?? [];
    var _centerItems = centerItems ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CrossFade(firstChild: topChild),
        if (topChild == null) GetLineSeparator(style: SeparatorStyle.full),
        if (visible)
          BottomAppBar(
            child: SafeArea(
              minimum:
                  EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
              left: false,
              right: false,
              top: false,
              bottom: true,
              child: Container(
                height: 44,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(width: 6),
                  ..._leftItems,
                  if (_leftItems.length < _rightItems.length)
                    for (int i = 0;
                        i < _rightItems.length - _leftItems.length;
                        i++)
                      GetButton.icon(),
                  ...(_centerItems.isEmpty ? [Spacer()] : _centerItems),
                  if (_rightItems.length < _leftItems.length)
                    for (int i = 0;
                        i < _leftItems.length - _rightItems.length;
                        i++)
                      GetButton.icon(),
                  ..._rightItems,
                  SizedBox(width: 6),
                ]),
              ),
            ),
          ),
      ],
    );
  }
}

class ProgressSnackBar extends StatelessWidget {
  const ProgressSnackBar({
    this.success,
    this.error,
    this.action,
    this.status,
    this.onCancel,
    this.onRetry,
    this.onDone,
    this.withBottomBar,
    this.actionColor,
    this.timeout = const Duration(seconds: 6),
    this.progress,
    this.isDismissible,
    this.autoDismissible = true,
    this.autoDismissIfNotBusy,
    Key? key,
  }) : super(key: key);

  final String? success;
  final String? error;
  final String? action;
  final GetStatus? status;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDone;
  final bool? withBottomBar;
  final Color? actionColor;
  final Duration timeout;
  final double? progress;
  final bool? isDismissible;
  final bool autoDismissible;
  final bool? autoDismissIfNotBusy;

  @override
  Widget build(BuildContext context) => GetSnackBar(
        message: status == GetStatus.busy
            ? GetText.busy()
            : status == GetStatus.failed
                ? error ?? GetText.failed()
                : success ?? GetText.succeeded(),
        action: action ??
            (status == GetStatus.busy
                ? GetText.cancel()
                : status == GetStatus.failed
                    ? GetText.retry()
                    : GetText.ok()),
        onAction: status == GetStatus.busy
            ? onCancel
            : status == GetStatus.failed
                ? onRetry
                : onDone,
        onDismiss: onCancel,
        showProgress: status == GetStatus.busy,
        isDismissible: status != GetStatus.busy &&
            (isDismissible ??
                autoDismissIfNotBusy ??
                status == GetStatus.failed),
        autoDismiss: autoDismissIfNotBusy == true
            ? status != GetStatus.busy
            : status == GetStatus.failed,
        autoDismissible: autoDismissible,
        withBottomBar: withBottomBar,
        actionColor: actionColor,
        timeout: timeout,
        progress: progress,
      );
}

class GetSnackBar extends StatelessWidget {
  const GetSnackBar({
    this.message,
    this.action,
    this.onAction,
    this.onDismiss,
    this.actionColor,
    this.timeout = const Duration(seconds: 6),
    this.progress,
    this.showProgress = true,
    this.withBottomBar = false,
    this.isDismissible = false,
    this.autoDismissible = true,
    this.autoDismiss = false,
    Key? key,
  }) : super(key: key);

  final String? message;
  final String? action;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final Color? actionColor;
  final Duration timeout;
  final double? progress;
  final bool showProgress;
  final bool? withBottomBar;
  final bool isDismissible;
  final bool autoDismissible;
  final bool autoDismiss;

  GlobalKey<GetDismissibleState> get _dismissible =>
      use(GlobalKey<GetDismissibleState>());

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GetDismissible(
            key: _dismissible,
            enabled: isDismissible,
            autoDismissible: autoDismissible,
            autoDismiss: autoDismiss,
            direction: DismissDirection.down,
            onDismissed: (direction) => onDismiss?.call(),
            timeout: timeout,
            child: Container(
              color: Get.theme.bottomAppBarTheme.color,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    GetLineSeparator(style: SeparatorStyle.full),
                    if (showProgress) LinearProgress(value: progress),
                  ]),
                  GetBar(
                    snackPosition: withBottomBar == true
                        ? SnackPosition.TOP
                        : SnackPosition.BOTTOM,
                    animationDuration: Duration(milliseconds: 200),
                    messageText: message == null ? null : Text(message!),
                    backgroundColor: Get.theme.bottomAppBarTheme.color!,
                    mainButton: action == null
                        ? null
                        : GetButton.text(
                            child: Text(action!.uppercase),
                            primary: actionColor,
                            onPressed:
                                onAction ?? () => _dismissible.state?.dismiss(),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

class GetDismissible extends StatefulWidget {
  const GetDismissible({
    this.enabled,
    this.autoDismissible = false,
    this.autoDismiss = false,
    this.timeout = const Duration(seconds: 6),
    this.direction = DismissDirection.down,
    this.onDismissed,
    required this.child,
    Key? key,
  }) : super(key: key);

  final bool? enabled;
  final Duration timeout;
  final bool autoDismissible;
  final bool autoDismiss;
  final DismissDirection direction;
  final void Function(DismissDirection)? onDismissed;
  final Widget child;

  @override
  GetDismissibleState createState() => GetDismissibleState();
}

class GetDismissibleState extends State<GetDismissible> {
  var _dismissed = false;

  @override
  Widget build(BuildContext context) {
    startTimer();
    return _dismissed
        ? Container(height: 0)
        : widget.enabled == true
            ? Dismissible(
                key: const Key('dismissible'),
                direction: widget.direction,
                onDismissed: dismiss,
                background: Container(height: 0),
                secondaryBackground: Container(height: 0),
                child: widget.child,
              )
            : widget.child;
  }

  void dismiss([DismissDirection? direction]) {
    stopTimer();
    widget.onDismissed?.call(direction ?? widget.direction);
    if (mounted) setState(() => _dismissed = true);
  }

  Timer? _timer;
  var _time = 6;

  void startTimer() {
    if (!(widget.autoDismissible && widget.autoDismiss)) return;
    if (_timer == null && widget.enabled == true && !_dismissed) {
      print("startTimer");
      _time = widget.timeout.inSeconds;
      _timer = Timer.periodic(1.seconds, (_) {
        print("time $_time");
        if (_time == 0) {
          dismiss();
        } else
          _time--;
      });
    } else if (_timer != null && widget.enabled != true && !_dismissed) {
      stopTimer();
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
