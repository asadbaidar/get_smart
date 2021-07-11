import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

class GetTileData extends GetObject {
  @override
  List<Function> get builders => [() => GetTileData()];

  GetTileData({
    this.icon,
    this.accessory,
    this.header,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.subTiles = const [],
    Color? color,
    this.isDetailed = false,
    this.isHeader = false,
    this.padAccessory,
    this.onTap,
  }) : _color = color;

  IconData? icon;
  IconData? accessory;
  dynamic header;
  String? title;
  String? subtitle;
  String? trailingTop;
  String? trailingBottom;
  List<GetTileData> subTiles;
  Color? _color;
  bool isDetailed;
  bool isHeader;
  bool? padAccessory;
  Function? onTap;

  bool get hasSubTiles => subTiles.isNotEmpty == true;

  @override
  String get description => title ?? "";

  @override
  Color get color => _color ?? title?.materialAccent ?? super.color;
}

class GetTile extends StatelessWidget {
  /// Tile with detailed accessory
  const GetTile.detailed({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isLeadingBoxed = true,
    this.isDetailed = true,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled,
    this.density,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory
  const GetTile.simple({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isLeadingBoxed = true,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled,
    this.density,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and dense view
  const GetTile.simpleDense({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isLeadingBoxed = true,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled,
    this.density = Density.min,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background and no boxed leading
  const GetTile.plain({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background = Colors.transparent,
    this.isLeadingBoxed = false,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled,
    this.density,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final String? trailingTop;
  final String? trailingBottom;
  final Widget? accessory;
  final List<Widget>? rows;
  final Color? color;
  final Color? background;
  final bool isLeadingBoxed;
  final bool isDetailed;
  final bool? padAccessory;
  final bool? showAccessory;
  final bool? tintAccessory;
  final bool? tintAble;
  final bool? destructive;
  final bool? enabled;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? topPadding;
  final double? bottomPadding;
  final VisualDensity? density;
  final void Function()? onTap;
  final void Function()? onTapLeading;

  @override
  Widget build(BuildContext context) {
    final _tintAble = destructive == true ? true : (tintAble ?? false);
    final tintColor =
        color ?? (destructive == true ? Colors.red : context.theme.accentColor);
    final isTrailingTop = trailingTop?.notEmpty != null;
    final isTrailingBottom = trailingBottom?.notEmpty != null;
    final accessory = this.accessory ??
        (isDetailed == true ? const Icon(Icons.chevron_right) : null);
    final showAccessory = accessory != null && (this.showAccessory ?? true);
    return InkWell(
      highlightColor: tintColor.activated,
      splashColor: tintColor.translucent,
      onTap: (enabled ?? true) ? onTap : null,
      child: Ink(
        color: background ?? context.theme.backgroundColor,
        child: Column(
          children: [
            ListTile(
              visualDensity: density,
              contentPadding: EdgeInsets.only(
                left: horizontalPadding ?? 16,
                right: padAccessory == true ? (horizontalPadding ?? 16) : 2,
                top: verticalPadding ?? topPadding ?? 0,
                bottom: verticalPadding ?? bottomPadding ?? 0,
              ),
              leading: leading == null
                  ? null
                  : BoxedView(
                      child: leading!,
                      color: tintColor,
                      withinBox: isLeadingBoxed,
                      onTap: onTapLeading,
                    ).adjustHorizontally,
              title: title?.notEmpty?.mapIt((it) => Text(
                    it,
                    style: TextStyle(
                      color: _tintAble ? tintColor : null,
                    ),
                  )),
              subtitle: subtitle?.notEmpty?.mapIt((it) => Text(it)),
              trailing: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isTrailingTop || isTrailingBottom)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTrailingTop)
                          Text(trailingTop!, style: Get.textTheme.caption),
                        if (isTrailingTop && isTrailingBottom)
                          SizedBox(height: 4),
                        if (isTrailingBottom)
                          Text(trailingBottom!, style: Get.textTheme.caption),
                      ],
                    ),
                  if (showAccessory)
                    IconTheme(
                      data: IconThemeData(
                        color: tintAccessory == true
                            ? tintColor
                            : context.theme.hintColor,
                      ),
                      child: accessory!,
                    ),
                  if (!showAccessory && padAccessory != true)
                    SizedBox(width: 14)
                ],
              ),
            ),
            ...rows ?? [],
          ],
        ),
      ),
    );
  }
}

class GetTileRow extends StatelessWidget {
  const GetTileRow({
    this.leading,
    this.text,
    this.hint,
    this.color,
    this.background,
    this.maxLines = 2,
    this.expanded = false,
    this.standalone = false,
    this.isLeadingBoxed = false,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  const GetTileRow.standalone({
    this.leading,
    this.text,
    this.hint,
    this.color,
    this.background,
    this.maxLines = 2,
    this.expanded = false,
    this.isLeadingBoxed = false,
    this.standalone = true,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
  final String? text;
  final String? hint;
  final Color? color;
  final Color? background;
  final int maxLines;
  final bool expanded;
  final bool standalone;
  final bool isLeadingBoxed;
  final void Function()? onTapLeading;

  @override
  Widget build(BuildContext context) {
    var textData = text ?? hint;
    var tintColor = color ?? context.theme.primaryIconTheme.color;
    return textData == null
        ? Container()
        : Ink(
            color: standalone == true
                ? (background ?? context.theme.backgroundColor)
                : null,
            padding: EdgeInsets.only(
              top: standalone == true ? 16 : 0,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            child: Row(children: [
              if (leading != null)
                BoxedView(
                  child: leading!,
                  color: tintColor,
                  withinBox: isLeadingBoxed,
                  small: true,
                  onTap: onTapLeading,
                ).adjustHorizontally,
              if (leading != null) SizedBox(width: 16),
              Flexible(
                child: CrossFade(
                  firstChild: Text(
                    textData,
                    style: context.textTheme.caption!.apply(
                      color: text == null ? context.theme.hintColor : null,
                    ),
                    maxLines: expanded == true ? null : maxLines,
                    overflow: expanded == true ? null : TextOverflow.ellipsis,
                  ),
                ),
              ),
            ]),
          );
  }
}

enum SeparatorStyle { full, padIcon, noIcon }

class GetTileSeparator extends StatelessWidget {
  const GetTileSeparator({
    this.margin,
    this.style = SeparatorStyle.padIcon,
    Key? key,
  }) : super(key: key);

  /// Tile separator with full edge to edge length
  const GetTileSeparator.full({Key? key}) : this(style: SeparatorStyle.full);

  /// Tile separator with `18` padding at start
  const GetTileSeparator.noIcon({Key? key})
      : this(style: SeparatorStyle.noIcon);

  /// Tile separator with `72` padding at start
  const GetTileSeparator.padIcon({Key? key})
      : this(style: SeparatorStyle.padIcon);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Get.theme.backgroundColor,
      child: GetLineSeparator(
        margin: margin,
        style: style,
      ),
    );
  }
}

class GetLineSeparator extends StatelessWidget {
  const GetLineSeparator({
    this.margin,
    this.style = SeparatorStyle.padIcon,
    Key? key,
  }) : super(key: key);

  /// Tile separator with full edge to edge length
  const GetLineSeparator.full({Key? key}) : this(style: SeparatorStyle.full);

  /// Tile separator with `18` padding at start
  const GetLineSeparator.noIcon({Key? key})
      : this(style: SeparatorStyle.noIcon);

  /// Tile separator with `72` padding at start
  const GetLineSeparator.padIcon({Key? key})
      : this(style: SeparatorStyle.padIcon);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: margin ??
            (style == SeparatorStyle.full
                ? 0
                : style == SeparatorStyle.noIcon
                    ? 18
                    : 72),
      ),
      color: Get.theme.hintColor.translucent,
      height: 0.5,
    );
  }
}

class GetTileHeader extends StatelessWidget {
  /// Tile header for icon with normal padding including top/bottom separators
  const GetTileHeader({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon,
    Key? key,
  }) : super(key: key);

  /// Tile header for no icon with dense padding including top/bottom separators
  const GetTileHeader.dense({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.padding = 16,
    this.noIcon = true,
    Key? key,
  }) : super(key: key);

  /// Tile header for icon with normal padding including bottom separators
  const GetTileHeader.noTop({
    this.text,
    this.topSeparator = false,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon,
    Key? key,
  }) : super(key: key);

  /// Tile header for no icon with normal padding including bottom separators
  const GetTileHeader.noTopIcon({
    this.text,
    this.topSeparator = false,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon = true,
    Key? key,
  }) : super(key: key);

  final String? text;
  final bool topSeparator;
  final bool bottomSeparator;
  final bool? noIcon;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (topSeparator) GetTileSeparator(style: SeparatorStyle.full),
        Container(
          padding: EdgeInsets.only(
            left: noIcon == true ? 16 : 24,
            right: 16,
            top: padding ?? 28,
            bottom: 8,
          ),
          child: Text(
            text?.uppercase ?? "",
            style: Get.textTheme.caption,
          ),
        ),
        if (bottomSeparator) GetTileSeparator(style: SeparatorStyle.full),
      ],
    );
  }
}

class BoxedView extends StatelessWidget {
  static const double boxHeight = 40;
  static const double boxWidth = 40;
  static const double boxSize = 30;

  const BoxedView({
    required this.child,
    this.color,
    this.withinBox = true,
    this.small,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Color? color;
  final bool withinBox;
  final bool? small;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final splash = withinBox ? color?.darker : color?.translucent;
    return InkWell(
      onTap: onTap,
      borderRadius: _size?.circularRadius,
      highlightColor: splash?.activated,
      splashColor: splash,
      child: Ink(
        height: _size,
        width: _size,
        decoration: _size?.circularBox(color: color),
        child: Container(
          alignment: Alignment.center,
          child: _text(boxed: withinBox) ?? _child(boxed: withinBox),
        ),
      ),
    );
  }

  double? get _size => withinBox ? boxSize : null;

  Widget? _text({bool boxed = false}) => $cast<Text>(child)?.mapTo(
        (Text it) => Text(
          it.data ?? "",
          textAlign: TextAlign.center,
          style: GoogleFonts.voltaire(
            fontSize: boxed
                ? 17
                : small == true
                    ? 18
                    : 24,
            color: boxed ? color?.contrast : color,
            // fontWeight: FontWeight.w100,
          ),
        ),
      );

  Widget _child({bool boxed = false}) => IconTheme(
        child: child,
        data: IconThemeData(
          size: boxed
              ? 18
              : small == true
                  ? 24
                  : 30,
          color: boxed ? color?.contrast : color,
        ),
      );

  Widget get adjustForTile => Container(
        alignment: Alignment.center,
        height: boxHeight,
        width: boxWidth,
        child: this,
      );

  Widget get adjustHorizontally => Container(
        alignment: Alignment.center,
        width: boxWidth,
        child: this,
      );
}

class CircularProgress extends StatelessWidget {
  const CircularProgress({
    this.size = 14,
    this.margin = 0,
    this.strokeWidth = 1.4,
    this.color,
  });

  const CircularProgress.small({
    this.size = 10,
    this.margin = 0,
    this.strokeWidth = 1,
    this.color,
  });

  final double size;
  final double margin;
  final double strokeWidth;
  final Color? color;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size,
            width: size,
            margin: EdgeInsets.all(margin),
            child: CircularProgressIndicator(
              strokeWidth: strokeWidth,
              color: color,
            ),
          ),
        ],
      );
}

class LinearProgress extends StatelessWidget {
  const LinearProgress({
    this.visible = true,
    this.height = 1,
    this.color,
    this.value,
  });

  const LinearProgress.standard({
    this.visible = true,
    this.height = 2.4,
    this.color = Colors.blue,
    this.value,
  });

  final bool visible;
  final Color? color;
  final double height;
  final double? value;

  @override
  Widget build(BuildContext context) => visible
      ? LinearProgressIndicator(
          minHeight: height,
          backgroundColor: Colors.transparent,
          valueColor: color?.mapIt((it) => AlwaysStoppedAnimation<Color>(it)),
          value: value,
        )
      : Container(height: height);
}

class MessageView extends StatelessWidget {
  const MessageView({
    this.icon,
    this.errorIcon,
    this.action,
    this.onAction,
    this.message,
    this.emptyTitle,
    this.error,
  });

  final Widget? icon;
  final Widget? errorIcon;
  final String? action;
  final void Function()? onAction;
  final String? message;
  final String? emptyTitle;
  final error;

  @override
  Widget build(BuildContext context) {
    final icon = error != null
        ? (errorIcon ?? Icon(Icons.cloud_off))
        : emptyTitle != null
            ? (this.icon ?? Icon(CupertinoIcons.square_stack_3d_up_slash))
            : this.icon;
    final message = error != null
        ? error.toString()
        : emptyTitle != null
            ? "Nothing in $emptyTitle"
            : this.message;
    final action = error != null
        ? GetText.retry()
        : emptyTitle != null
            ? GetText.refresh()
            : this.action;
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        top: 16,
        left: 32,
        right: 32,
        bottom: 80,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            IconTheme(
              data: Get.theme.iconTheme.copyWith(size: 72),
              child: icon,
            ),
          SizedBox(height: 16),
          if (message != null)
            Flexible(
              child: Text(
                message.toString().trim(),
                textAlign: TextAlign.center,
                style: Get.textTheme.subtitle1!.apply(fontSizeDelta: 1),
              ),
            ),
          SizedBox(height: 16),
          if (action != null)
            GetButton.outlined(
              child: Text(action),
              onPressed: onAction,
            ),
        ],
      ),
    );
  }
}

class GetDismissible extends StatefulWidget {
  const GetDismissible({
    this.enabled,
    this.timeout = const Duration(seconds: 6),
    this.autoDismiss = false,
    this.direction = DismissDirection.down,
    this.onDismissed,
    required this.child,
    Key? key,
  }) : super(key: key);

  final bool? enabled;
  final Duration timeout;
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
                background: Container(),
                secondaryBackground: Container(),
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
    if (!widget.autoDismiss) return;
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

class SwipeRefresh extends RefreshIndicator {
  SwipeRefresh({
    required Widget child,
    required Future<void> Function() onRefresh,
    Key? key,
  }) : super(
          key: key,
          child: child,
          onRefresh: onRefresh,
          color: Get.theme.primaryIconTheme.color,
          backgroundColor: Get.theme.appBarTheme.color,
        );

  static GlobalKey<RefreshIndicatorState> get newKey =>
      GlobalKey<RefreshIndicatorState>();
}

class CrossFade extends AnimatedCrossFade {
  CrossFade({
    bool? showFirst,
    Widget? firstChild,
    Widget? secondChild,
    Key? key,
  }) : super(
          key: key,
          alignment: showFirst ?? firstChild != null
              ? Alignment.topCenter
              : Alignment.bottomCenter,
          duration: 200.milliseconds,
          secondCurve: Curves.fastLinearToSlowEaseIn,
          crossFadeState: showFirst ?? firstChild != null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: firstChild ?? Container(height: 0),
          secondChild: secondChild ?? Container(height: 0),
        );
}

class ProgressButton extends StatelessWidget {
  const ProgressButton({
    this.text,
    this.error,
    this.status,
    this.onPressed,
    Key? key,
  }) : super(key: key);

  final String? text;
  final dynamic error;
  final GetStatus? status;
  final Function? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.centerLeft,
      child: status == GetStatus.busy
          ? Row(children: [
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: Text(
                    GetText.busy(),
                    style: TextStyle(color: Theme.of(context).accentColor),
                  ),
                ),
              )
            ])
          : Row(children: [
              Flexible(
                child: SizedBox(
                  height: 42,
                  width: 120,
                  child: GetButton.elevated(
                    child: Text(
                      (status == GetStatus.failed
                              ? GetText.retry()
                              : status == GetStatus.succeeded
                                  ? GetText.ok()
                                  : text)!
                          .uppercase,
                    ),
                    onPressed: () {
                      if (status == GetStatus.succeeded)
                        Get.back(result: true);
                      else
                        onPressed!();
                    },
                  ),
                ),
              ),
              if (status == GetStatus.failed)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      error ?? GetText.failed(),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              if (status == GetStatus.succeeded)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      GetText.succeeded(),
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ),
            ]),
    );
  }
}

class ProgressSnackBar extends StatelessWidget {
  const ProgressSnackBar({
    this.success,
    this.error,
    this.status,
    this.onCancel,
    this.onRetry,
    this.onDone,
    this.withBottomBar,
    this.actionColor,
    this.timeout = const Duration(seconds: 6),
    this.isDismissible,
    this.progress,
    this.autoDismiss = true,
    Key? key,
  }) : super(key: key);

  final String? success;
  final String? error;
  final GetStatus? status;
  final VoidCallback? onCancel;
  final VoidCallback? onRetry;
  final VoidCallback? onDone;
  final bool? withBottomBar;
  final Color? actionColor;
  final Duration timeout;
  final bool? isDismissible;
  final double? progress;
  final bool autoDismiss;

  @override
  Widget build(BuildContext context) => GetSnackBar(
        message: status == GetStatus.busy
            ? GetText.busy()
            : status == GetStatus.failed
                ? error ?? GetText.failed()
                : success ?? GetText.succeeded(),
        action: status == GetStatus.busy
            ? GetText.cancel()
            : status == GetStatus.failed
                ? GetText.retry()
                : GetText.ok(),
        onAction: status == GetStatus.busy
            ? onCancel
            : status == GetStatus.failed
                ? onRetry
                : onDone,
        onDismiss: onCancel,
        showProgress: status == GetStatus.busy,
        isDismissible: isDismissible ?? status == GetStatus.failed,
        withBottomBar: withBottomBar,
        actionColor: actionColor,
        timeout: timeout,
        progress: progress,
        autoDismiss: autoDismiss,
      );
}

class GetSnackBar extends StatelessWidget {
  const GetSnackBar({
    this.message,
    this.action,
    this.onAction,
    this.onDismiss,
    this.showProgress = true,
    this.isDismissible = false,
    this.withBottomBar = false,
    this.actionColor,
    this.timeout = const Duration(seconds: 6),
    this.progress,
    this.autoDismiss = true,
    Key? key,
  }) : super(key: key);

  final String? message;
  final String? action;
  final VoidCallback? onAction;
  final VoidCallback? onDismiss;
  final bool showProgress;
  final bool isDismissible;
  final bool? withBottomBar;
  final Color? actionColor;
  final Duration timeout;
  final double? progress;
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
            direction: DismissDirection.down,
            onDismissed: (direction) => onDismiss?.call(),
            timeout: timeout,
            autoDismiss: autoDismiss,
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

class Clickable extends MouseRegion {
  Clickable({
    bool enable = true,
    Function()? onTap,
    Widget? child,
  }) : super(
          cursor: enable == true && onTap != null
              ? MaterialStateMouseCursor.clickable
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: enable == true ? onTap : null,
            child: child ?? Container(),
          ),
        );
}

extension FocusNodeX on FocusNode {
  void forward({FocusNode? to}) {
    unfocus();
    to?.requestFocus();
  }
}

extension WidgetX on Widget {
  WidgetSpan get widgetSpan => WidgetSpan(child: this);
}

extension GetDiagnosticable on Diagnosticable {
  S use<S>(S dependency,
          {String? tag,
          bool permanent = false,
          InstanceBuilderCallback<S>? builder}) =>
      Get.put<S>(dependency, tag: typeName + (tag ?? ""), permanent: permanent);
}

extension GlobalKeyX<T extends State<StatefulWidget>> on GlobalKey<T> {
  BuildContext? get context => currentContext;

  Widget? get widget => currentWidget;

  T? get state => currentState;
}

abstract class GetShimmer {
  static Widget article() => Column(children: [
        Expanded(
          child: Container(
            color: Get.theme.canvasColor,
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Shimmer.fromColors(
                baseColor: Get.theme.highlightColor,
                highlightColor: Get.theme.canvasColor,
                child: Column(children: [
                  Container(
                    color: Colors.grey,
                    constraints: BoxConstraints.expand(height: 160),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 24)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    constraints: BoxConstraints.expand(height: 30),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 24)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    constraints: BoxConstraints.expand(height: 30),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 24)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    constraints: BoxConstraints.expand(height: 30),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 24)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 60),
                    constraints: BoxConstraints.expand(height: 30),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 50)),
                  Container(
                    color: Colors.grey,
                    constraints: BoxConstraints.expand(height: 24),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 16)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 16),
                    constraints: BoxConstraints.expand(height: 24),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 50)),
                  Container(
                    color: Colors.grey,
                    constraints: BoxConstraints.expand(height: 16),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 8)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 8),
                    constraints: BoxConstraints.expand(height: 16),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]);

  static Widget dark() => Column(children: [
        Expanded(
          child: Container(
            color: GetColors.black93,
            padding: EdgeInsets.only(top: 10),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: GetColors.black93,
                child: Column(children: [
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    constraints: BoxConstraints.expand(height: 22),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 8)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 36),
                    constraints: BoxConstraints.expand(height: 10),
                  ),
                  Container(constraints: BoxConstraints.expand(height: 8)),
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 28),
                    constraints: BoxConstraints.expand(height: 10),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]);
}

class DottedPageView extends StatefulWidget {
  DottedPageView.builder({
    this.dotColor = Colors.white38,
    this.dotActiveColor = Colors.white,
    this.scrollDirection = Axis.horizontal,
    this.autoPlay = true,
    this.reverse = false,
    PageController? controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.itemBuilder,
    this.itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    Key? key,
  })  : _key = key,
        this.controller = controller ?? PageController();

  final Color dotColor;
  final Color dotActiveColor;
  final Axis scrollDirection;
  final bool autoPlay;
  final bool reverse;
  final PageController controller;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final void Function(int)? onPageChanged;
  final IndexedWidgetBuilder? itemBuilder;
  final int? itemCount;
  final DragStartBehavior dragStartBehavior;
  final bool allowImplicitScrolling;
  final String? restorationId;
  final Clip clipBehavior;
  final Key? _key;

  @override
  _DottedPageViewState createState() => _DottedPageViewState();
}

class _DottedPageViewState extends State<DottedPageView>
    with SingleTickerProviderStateMixin {
  static const double duration = 10;
  final _index = 0.obs;
  Ticker? _ticker;
  int _elapsed = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay == true) {
      _ticker = createTicker((elapsed) {
        if (_elapsed != elapsed.inSeconds &&
            elapsed.inSeconds >= duration &&
            elapsed.inSeconds % duration == 0) {
          _elapsed = elapsed.inSeconds;
          updatePage();
        }
      });
      _ticker?.start();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }

  void updatePage() {
    if (widget.controller.hasClients)
      widget.controller.animateToPage(
        _index.value == widget.itemCount! - 1 ? 0 : _index.value + 1,
        duration: 1500.milliseconds,
        curve: Curves.easeOut,
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        PageView.builder(
          key: widget._key,
          scrollDirection: widget.scrollDirection,
          reverse: widget.reverse,
          controller: widget.controller,
          physics: widget.physics,
          pageSnapping: widget.pageSnapping,
          onPageChanged: (index) {
            this._index.value = index;
            widget.onPageChanged?.call(index);
          },
          itemBuilder: widget.itemBuilder!,
          itemCount: widget.itemCount,
          dragStartBehavior: widget.dragStartBehavior,
          allowImplicitScrolling: widget.allowImplicitScrolling,
          restorationId: widget.restorationId,
          clipBehavior: widget.clipBehavior,
        ),
        Obx(
          () => DotsIndicator(
            decorator: DotsDecorator(
              color: widget.dotColor,
              activeColor: widget.dotActiveColor,
              size: const Size.square(8),
              activeSize: const Size.square(8),
              spacing: EdgeInsets.all(4),
            ),
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            dotsCount: widget.itemCount!,
            position: _index.toDouble(),
          ),
        ),
      ],
    );
  }
}

extension GetBoxDecoration on BoxDecoration {
  static BoxDecoration only({
    double? top,
    double? bottom,
    double? left,
    double? right,
    Color? color,
    Color? borderColor,
    double? borderRadius,
  }) {
    var _borderColor = borderColor ?? Get.theme.hintColor.dimmed;
    return BoxDecoration(
      color: color ?? Get.theme.backgroundColor,
      borderRadius:
          borderRadius == null ? null : BorderRadius.circular(borderRadius),
      border: Border(
        top: top != null
            ? BorderSide(width: top, color: _borderColor)
            : BorderSide.none,
        bottom: bottom != null
            ? BorderSide(width: bottom, color: _borderColor)
            : BorderSide.none,
        left: left != null
            ? BorderSide(width: left, color: _borderColor)
            : BorderSide.none,
        right: right != null
            ? BorderSide(width: right, color: _borderColor)
            : BorderSide.none,
      ),
    );
  }

  static BoxDecoration symmetric({
    double? vertical,
    double? horizontal,
    Color? color,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
  }) {
    return only(
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal,
      color: color,
      borderColor: borderColor,
      borderRadius: borderRadius,
    );
  }

  static BoxDecoration all(
    double all, {
    Color? color,
    Color? borderColor,
    double? borderWidth,
    double? borderRadius,
  }) {
    return symmetric(
      vertical: all,
      horizontal: all,
      color: color,
      borderColor: borderColor,
      borderRadius: borderRadius,
    );
  }
}

/* TODO:
         Row(
              children: [
                Container(
                  margin: EdgeInsets.all(50),
                  padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1.5),
                  child: Text(
                    "34Y",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Get.theme.accentColor, fontSize: 9),
                  ),
                  decoration: GetBoxDecoration.all(
                    1,
                    color: Colors.transparent, //Get.theme.accentColor,
                    borderColor: Get.theme.accentColor,
                    borderRadius: 5,
                  ),
                ),
              ],
            )
*/

/// States that an application can be in.
///
/// The function below describe notifications from the operating system.
/// Applications should not expect to always receive all possible
/// notifications. For example, if the users pulls out the battery from the
/// device, no notification will be sent before the application is suddenly
/// terminated, along with the rest of the operating system.
///
/// See also:
///
///  * [WidgetsBindingObserver], for a mechanism to observe the lifecycle state
///    from the widgets layer.
class GetAppLifecycle extends StatefulWidget {
  const GetAppLifecycle({
    this.onResume,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    Key? key,
  }) : super(key: key);

  /// The application is visible and responding to user input.
  final void Function()? onResume;

  /// The application is in an inactive state and is not receiving user input.
  ///
  /// On iOS, this state corresponds to an app or the Flutter host view running
  /// in the foreground inactive state. Apps transition to this state when in
  /// a phone call, responding to a TouchID request, when entering the app
  /// switcher or the control center, or when the UIViewController hosting the
  /// Flutter app is transitioning.
  ///
  /// On Android, this corresponds to an app or the Flutter host view running
  /// in the foreground inactive state.  Apps transition to this state when
  /// another activity is focused, such as a split-screen app, a phone call,
  /// a picture-in-picture app, a system dialog, or another window.
  ///
  /// Apps in this state should assume that they may be
  /// [AppLifecycleState.paused] at any time.
  final void Function()? onInactive;

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  ///
  /// When the application is in this state, the engine will not call the
  /// [PlatformDispatcher.onBeginFrame] and [PlatformDispatcher.onDrawFrame]
  /// callbacks.
  final void Function()? onPaused;

  /// The application is still hosted on a flutter engine but is detached from
  /// any host views.
  ///
  /// When the application is in this state, the engine is running without
  /// a view. It can either be in the progress of attaching a view when engine
  /// was first initializes, or after the view being destroyed due to a Navigator
  /// pop.
  final void Function()? onDetached;

  @override
  _GetAppLifecycleState createState() => _GetAppLifecycleState();
}

class _GetAppLifecycleState extends State<GetAppLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(height: 0);

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResume?.call();
        break;
      case AppLifecycleState.paused:
        widget.onPaused?.call();
        break;
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
        break;
      case AppLifecycleState.detached:
        widget.onDetached?.call();
        break;
    }
  }
}

abstract class Density {
  static const VisualDensity min = const VisualDensity(
    horizontal: -4.0,
    vertical: -4.0,
  );

  static const VisualDensity max = const VisualDensity(
    horizontal: 4.0,
    vertical: 4.0,
  );

  static const VisualDensity dense = const VisualDensity(
    horizontal: 3.0,
    vertical: 3.0,
  );
}

class GetSearchDelegate extends SearchDelegate {
  GetSearchDelegate({
    String? hint,
  }) : super(searchFieldLabel: hint);

  @override
  Widget buildLeading(BuildContext context) => BackButton();

  @override
  Widget buildSuggestions(BuildContext context) => buildResults(context);

  @override
  ThemeData appBarTheme(BuildContext context) => GetTheme.black(
        context,
        brightness: Brightness.dark,
      ).copyWith(
        appBarTheme: context.theme.appBarTheme,
        scaffoldBackgroundColor: context.theme.scaffoldBackgroundColor,
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        ),
      );

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.trim().isNotEmpty)
          GetButton.icon(
            icon: Icon(CupertinoIcons.clear_circled_solid),
            onPressed: clear,
          )
      ];

  @override
  Widget buildResults(BuildContext context) => Theme(
        data: context.theme,
        child: query.trim().isEmpty ? Container() : getResults(context),
      );

  void clear() => query = "";

  Widget getResults(BuildContext context) => Container();
}
