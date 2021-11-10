import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    this.left,
    this.right,
    this.center,
    this.children,
    this.top,
    this.alignment = CrossAxisAlignment.center,
    this.visible = true,
    Key? key,
  }) : super(key: key);

  final List<Widget>? left;
  final List<Widget>? right;
  final List<Widget>? center;
  final List<Widget>? children;
  final Widget? top;
  final CrossAxisAlignment alignment;
  final bool visible;

  @override
  Widget build(BuildContext context) {
    var _left = left ?? [];
    var _right = right ?? [];
    var _center = center ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CrossFade(firstChild: top),
        if (top == null) const GetDivider.full(),
        if (visible)
          BottomAppBar(
            elevation: top == null ? null : 0,
            child: SafeArea(
              minimum: EdgeInsets.only(
                bottom: context.viewInsets.bottom,
              ),
              left: false,
              right: false,
              top: false,
              bottom: true,
              child: Container(
                constraints: const BoxConstraints(minHeight: 44),
                padding: const EdgeInsets.symmetric(vertical: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: alignment,
                  children: [
                    2.spaceX,
                    ...children ??
                        [
                          ..._left,
                          if (_left.length < _right.length)
                            for (int i = 0;
                                i < _right.length - _left.length;
                                i++)
                              GetButton.icon(),
                          ...(_center.isEmpty ? [const Spacer()] : _center),
                          if (_right.length < _left.length)
                            for (int i = 0;
                                i < _left.length - _right.length;
                                i++)
                              GetButton.icon(),
                          ..._right
                        ],
                    2.spaceX,
                  ],
                ),
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
    this.errorColor = Colors.red,
    this.timeout = const Duration(seconds: 6),
    this.progress,
    this.enabled,
    this.dismissible,
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
  final Color? errorColor;
  final Duration timeout;
  final double? progress;
  final bool? enabled;
  final bool? dismissible;
  final bool autoDismissible;
  final bool? autoDismissIfNotBusy;

  GetStatus get _status => status ?? GetStatus.canceled;

  @override
  Widget build(BuildContext context) => GetSnackBar(
        message: _status.isBusy
            ? GetText.busy()
            : _status.isFailed
                ? error ?? GetText.failed()
                : success ?? GetText.succeeded(),
        action: enabled ?? true
            ? (_status.isBusy
                ? (action == null ? GetText.cancel() : null)
                : action ?? (_status.isFailed ? GetText.retry() : GetText.ok()))
            : null,
        onAction: _status.isBusy
            ? onCancel
            : _status.isFailed
                ? onRetry
                : onDone,
        onDismiss: onCancel,
        showProgress: _status.isBusy,
        dismissible: !_status.isBusy &&
            (dismissible ?? autoDismissIfNotBusy ?? _status.isFailed),
        autoDismiss:
            autoDismissIfNotBusy == true ? !_status.isBusy : _status.isFailed,
        autoDismissible: autoDismissible,
        withBottomBar: withBottomBar,
        actionColor: actionColor,
        messageColor: _status.isFailed ? errorColor : null,
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
    this.messageColor,
    this.timeout = const Duration(seconds: 6),
    this.progress,
    this.showProgress = true,
    this.withBottomBar = false,
    this.dismissible = false,
    this.autoDismissible = true,
    this.autoDismiss = false,
    Key? key,
  }) : super(key: key);

  final String? message;
  final String? action;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final Color? actionColor;
  final Color? messageColor;
  final Duration timeout;
  final double? progress;
  final bool showProgress;
  final bool? withBottomBar;
  final bool dismissible;
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
            enabled: dismissible,
            autoDismissible: autoDismissible,
            autoDismiss: autoDismiss,
            direction: DismissDirection.down,
            onDismissed: (direction) => onDismiss?.call(),
            timeout: timeout,
            child: Container(
              color: context.bottomBarColor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(children: [
                    const GetDivider.full(),
                    if (showProgress) LinearProgress(value: progress),
                  ]),
                  GetBar(
                    snackPosition: withBottomBar == true
                        ? SnackPosition.TOP
                        : SnackPosition.BOTTOM,
                    animationDuration: 200.milliseconds,
                    messageText: message == null
                        ? null
                        : Text(
                            message!,
                            style: TextStyle(color: messageColor),
                          ),
                    backgroundColor: Colors.transparent,
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

  GetTimer? _timer;

  void startTimer() {
    if (!(widget.autoDismissible && widget.autoDismiss)) return;
    if (_timer == null && widget.enabled == true && !_dismissed) {
      _timer = GetTimer.countDown(
        widget.timeout,
        onCancel: (_) => dismiss(),
      )..start();
    } else if (_timer != null &&
        _timer?.isCanceled != true &&
        widget.enabled != true &&
        !_dismissed) {
      stopTimer();
    }
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }
}
