import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

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
      borderRadius: _size?.roundRadius,
      highlightColor: splash?.activated,
      splashColor: splash,
      child: Ink(
        height: _size,
        width: _size,
        decoration: _size?.roundBox(color: color),
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

class Clickable extends MouseRegion {
  Clickable({
    bool enable = true,
    VoidCallback? onTap,
    Widget? child,
  }) : super(
          cursor: enable == true && onTap != null
              ? MaterialStateMouseCursor.clickable
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: enable == true ? onTap : null,
            child: child ?? Container(height: 0),
          ),
        );
}

extension ClickableX on Widget {
  Widget clickable({
    bool enable = true,
    VoidCallback? onTap,
  }) =>
      Clickable(
        enable: enable,
        onTap: onTap,
        child: this,
      );
}

class TextBadge extends StatelessWidget {
  const TextBadge({
    this.text,
    this.size = 9,
    this.textColor,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius = 5,
    this.inverted = false,
    this.padding = 3,
    this.margin = const EdgeInsets.symmetric(horizontal: 2),
    Key? key,
  }) : super(key: key);

  final String? text;
  final double size;
  final Color? textColor;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final double? borderRadius;
  final bool inverted;
  final EdgeInsetsGeometry? margin;
  final double padding;

  Color get _textColor => textColor ?? Get.theme.accentColor;

  Color get _backgroundColor => backgroundColor ?? Colors.transparent;

  Color get _borderColor => borderColor ?? Get.theme.accentColor;

  @override
  Widget build(BuildContext context) => text == null
      ? Container(height: 0)
      : Row(
          children: [
            Container(
              margin: margin,
              padding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: padding.half,
              ),
              child: Text(
                text!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: _textColor.applyIf(inverted, (it) => it.contrast),
                  fontSize: size,
                ),
              ),
              decoration: GetBoxDecoration.all(
                1,
                color: inverted ? _textColor : _backgroundColor,
                borderColor:
                    inverted ? borderColor ?? _textColor : _borderColor,
                borderWidth: borderWidth,
                borderRadius: borderRadius,
              ),
            ),
          ],
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
        child:
            query.trim().isEmpty ? Container(height: 0) : getResults(context),
      );

  void clear() => query = "";

  Widget getResults(BuildContext context) => Container(height: 0);
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
