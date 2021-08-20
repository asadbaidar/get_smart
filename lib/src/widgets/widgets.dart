import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

class BoxedView extends StatelessWidget {
  static const double kBoxSize = 30;

  const BoxedView({
    required this.child,
    this.color,
    this.filled = true,
    this.oval = false,
    this.small,
    this.wrap = false,
    this.boxSize = kBoxSize,
    this.fontSize,
    this.iconSize,
    this.margin = const EdgeInsets.symmetric(horizontal: 5),
    this.onTap,
    Key? key,
  }) : super(key: key);

  const BoxedView.zero({
    required this.child,
    this.color,
    this.filled = true,
    this.oval = false,
    this.small,
    this.wrap = false,
    this.boxSize = kBoxSize,
    this.fontSize,
    this.iconSize,
    this.margin,
    this.onTap,
    Key? key,
  }) : super(key: key);

  const BoxedView.wrap({
    required this.child,
    this.color,
    this.filled = false,
    this.oval = false,
    this.small = true,
    this.wrap = true,
    this.boxSize = kBoxSize,
    this.fontSize,
    this.iconSize,
    this.margin,
    this.onTap,
    Key? key,
  }) : super(key: key);

  const BoxedView.oval({
    required this.child,
    this.color,
    this.filled = true,
    this.oval = true,
    this.small,
    this.wrap = false,
    this.boxSize = kBoxSize,
    this.fontSize,
    this.iconSize,
    this.margin,
    this.onTap,
    Key? key,
  }) : super(key: key);

  final dynamic child;
  final Color? color;
  final bool filled;
  final bool oval;
  final bool? small;
  final bool wrap;
  final double boxSize;
  final double? fontSize;
  final double? iconSize;
  final EdgeInsetsGeometry? margin;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final splash = filled ? color?.darker : color?.lighted;
    return Container(
      margin: margin,
      width: _boxSize,
      alignment: Alignment.center,
      child: InkWell(
        onTap: onTap,
        borderRadius: oval ? _size?.circularRadius : _size?.roundRadius,
        highlightColor: splash?.highlighted,
        splashColor: splash,
        child: Ink(
          height: _wrapSize,
          width: _wrapSize,
          decoration: oval
              ? _size?.circularBox(color: color)
              : _size?.roundBox(color: color),
          child: Container(
            alignment: Alignment.center,
            child: _text() ??
                _icon() ??
                (_image() ?? _child())?.clipOval(clip: oval),
          ),
        ),
      ),
    );
  }

  double? get _boxSize => wrap ? null : boxSize;

  double? get _wrapSize => filled ? _boxSize : null;

  double? get _size => filled ? boxSize : null;

  Widget? _text() => $cast<Text>(child)?.mapTo(
        (Text it) => Text(
          it.data?.take(boxSize > kBoxSize ? 3 : 2).uppercase ?? "",
          textAlign: TextAlign.center,
          style: GoogleFonts.voltaire(
            fontSize: fontSize ??
                (filled
                    ? ((oval ? 15 : 17) - max(0, (kBoxSize - boxSize).half))
                    : small == true
                        ? 18
                        : 24),
            color: filled ? color?.contrast : color,
            // fontWeight: FontWeight.w100,
          ),
        ),
      );

  Widget? _icon() => $cast<Icon>(child)?.mapTo(
        (Icon it) => IconTheme(
          child: it,
          data: IconThemeData(
            size: it.size ??
                iconSize ??
                (filled
                    ? 18
                    : small == true
                        ? 24
                        : 30),
            color: it.color ?? (filled ? color?.contrast : color),
          ),
        ),
      );

  Widget? _image() => $cast<ImageProvider>(child)?.mapTo(
        (ImageProvider it) => Image(
          image: it,
          height: boxSize,
          width: boxSize,
          fit: BoxFit.cover,
        ),
      );

  Widget? _child() => $cast<Widget>(child);
}

class CircularProgress extends StatelessWidget {
  const CircularProgress({
    this.size = 14,
    this.margin = 0,
    this.strokeWidth = 1.4,
    this.color,
    this.value,
  });

  const CircularProgress.small({
    this.size = 10,
    this.margin = 0,
    this.strokeWidth = 1,
    this.color,
    this.value,
  });

  final double size;
  final double margin;
  final double strokeWidth;
  final Color? color;
  final double? value;

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
              backgroundColor: Colors.transparent,
              color: color,
              value: value,
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
          color: color,
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
    this.emptyMessage,
    this.error,
  });

  final Widget? icon;
  final Widget? errorIcon;
  final String? action;
  final VoidCallback? onAction;
  final String? message;
  final String? emptyTitle;
  final String? emptyMessage;
  final error;

  @override
  Widget build(BuildContext context) {
    final _icon = error != null
        ? (errorIcon ?? Icon(Icons.cloud_off))
        : emptyTitle != null || emptyMessage != null
            ? (icon ?? Icon(CupertinoIcons.square_stack_3d_up_slash))
            : icon;
    final _message = error != null
        ? error.toString()
        : emptyTitle != null
            ? "Nothing in $emptyTitle"
            : emptyMessage != null
                ? emptyMessage
                : message;
    final _action = error != null
        ? GetText.retry()
        : emptyTitle != null || emptyMessage != null
            ? GetText.refresh()
            : action;
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
          if (_icon != null)
            IconTheme(
              data: context.iconTheme.copyWith(size: 72),
              child: _icon,
            ),
          SizedBox(height: 16),
          if (_message != null)
            Flexible(
              child: Text(
                _message.toString().trim(),
                textAlign: TextAlign.center,
                style: context.subtitle1?.apply(fontSizeDelta: 1),
              ),
            ),
          SizedBox(height: 16),
          if (_action != null)
            GetButton.outlined(
              child: Text(_action),
              onPressed: onAction,
            ),
        ],
      ),
    );
  }
}

typedef SwipeRefreshState = RefreshIndicatorState;

class SwipeRefresh extends StatelessWidget {
  const SwipeRefresh({
    required this.child,
    required this.onRefresh,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    Key? key,
  }) : _key = key;

  final child;
  final onRefresh;
  final double displacement;
  final double edgeOffset;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final RefreshIndicatorTriggerMode triggerMode;
  final Key? _key;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        key: _key,
        child: child,
        onRefresh: onRefresh,
        displacement: displacement,
        edgeOffset: edgeOffset,
        notificationPredicate: notificationPredicate,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        strokeWidth: strokeWidth,
        triggerMode: triggerMode,
        color: color ?? context.primaryIconColor,
        backgroundColor: backgroundColor ?? context.primaryColor,
      );

  static GlobalKey<SwipeRefreshState> get newKey =>
      GlobalKey<SwipeRefreshState>();
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
          firstChild: firstChild ?? Container(height: 0, width: 0),
          secondChild: secondChild ?? Container(height: 0, width: 0),
        );
}

class Clickable extends MouseRegion {
  Clickable({
    bool enabled = true,
    VoidCallback? onTap,
    Widget? child,
  }) : super(
          cursor: enabled && onTap != null
              ? MaterialStateMouseCursor.clickable
              : SystemMouseCursors.basic,
          child: GestureDetector(
            onTap: enabled ? onTap : null,
            child: child ?? Container(),
          ),
        );
}

extension ClickableX on Widget {
  Widget clickable({
    bool enabled = true,
    VoidCallback? onTap,
  }) =>
      Clickable(
        enabled: enabled,
        onTap: onTap,
        child: this,
      );
}

class TextBox extends StatelessWidget {
  const TextBox(
    this.text, {
    this.fontSize = 9,
    this.color,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 5,
    this.filled = false,
    this.primary = false,
    this.subbed = false,
    this.padding = 3,
    this.horizontalPadding,
    this.verticalPadding,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    Key? key,
  }) : super(key: key);

  const TextBox.primary(
    this.text, {
    this.fontSize = 9,
    this.color,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 5,
    this.filled = false,
    this.primary = true,
    this.subbed = true,
    this.padding = 3,
    this.horizontalPadding,
    this.verticalPadding = 0,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    Key? key,
  }) : super(key: key);

  const TextBox.plain(
    this.text, {
    this.fontSize = 9,
    this.color,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 5,
    this.filled = false,
    this.primary = false,
    this.subbed = false,
    this.padding = 3,
    this.horizontalPadding,
    this.verticalPadding = 0,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    Key? key,
  }) : super(key: key);

  const TextBox.filled(
    this.text, {
    this.fontSize = 9,
    this.color,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 5,
    this.filled = true,
    this.primary = false,
    this.subbed = false,
    this.padding = 3,
    this.horizontalPadding,
    this.verticalPadding = 0,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    Key? key,
  }) : super(key: key);

  const TextBox.round(
    this.text, {
    this.fontSize = 9,
    this.color,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 20,
    this.filled = false,
    this.primary = false,
    this.subbed = false,
    this.padding = 5,
    this.horizontalPadding = 7,
    this.verticalPadding,
    this.margin = const EdgeInsets.symmetric(horizontal: 4),
    Key? key,
  }) : super(key: key);

  const TextBox.roundZero(
    this.text, {
    this.fontSize = 9,
    this.color,
    this.fillColor,
    this.borderColor,
    this.borderWidth = 1,
    this.borderRadius = 20,
    this.filled = false,
    this.primary = false,
    this.subbed = false,
    this.padding = 5,
    this.horizontalPadding = 7,
    this.verticalPadding,
    this.margin = EdgeInsets.zero,
    Key? key,
  }) : super(key: key);

  final String? text;
  final double fontSize;
  final Color? color;
  final Color? fillColor;
  final Color? borderColor;
  final double borderWidth;
  final double? borderRadius;
  final bool filled;
  final bool primary;
  final bool subbed;
  final double padding;
  final double? horizontalPadding;
  final double? verticalPadding;
  final EdgeInsetsGeometry? margin;

  bool get _filled => filled || fillColor != null;

  @override
  Widget build(BuildContext context) {
    Color _color = (color ??
            (primary
                ? context.primaryBodyText1?.color ??
                    context.primaryColor.contrast
                : context.secondaryColor))
        .applyIf(subbed, (it) => it.subbed)!;

    Color _fillColor = (fillColor ?? (filled ? _color : null))
            ?.applyIf(subbed, (it) => it.subbed) ??
        Colors.transparent;

    Color _borderColor = (borderColor ?? (_filled ? null : fillColor ?? _color))
            ?.applyIf(subbed, (it) => it.subbed) ??
        Colors.transparent;

    return text == null
        ? Container(height: 0, width: 0)
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: margin,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(
                  horizontal: horizontalPadding ?? padding,
                  vertical: verticalPadding ?? padding.half,
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(top: 1.5, bottom: Get.isIOS ? 1.5 : 0),
                  child: Text(
                    text!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color:
                          _color.applyIf(_filled, (_) => _fillColor.contrast),
                      fontSize: fontSize,
                    ),
                  ),
                ),
                decoration: GetBoxDecoration.all(
                  context,
                  border: borderWidth,
                  color: _fillColor,
                  borderColor: _borderColor,
                  borderRadius: borderRadius,
                ),
              ),
            ],
          );
  }
}

class Blur extends StatelessWidget {
  const Blur({
    this.blur = 0.0,
    this.tileMode = TileMode.clamp,
    this.clipBehavior = Clip.hardEdge,
    this.clipper,
    this.child,
    Key? key,
  }) : super(key: key);

  final double blur;
  final TileMode tileMode;
  final Clip clipBehavior;
  final CustomClipper<Rect>? clipper;
  final Widget? child;

  @override
  Widget build(BuildContext context) => ClipRect(
        clipBehavior: clipBehavior,
        clipper: clipper,
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: blur,
            sigmaY: blur,
            tileMode: tileMode,
          ),
          child: child ?? Container(),
        ),
      );
}

class Space extends StatelessWidget {
  const Space.only({
    this.x,
    this.y,
    Key? key,
  }) : super(key: key);

  const Space.x(
    this.x, {
    Key? key,
  })  : y = null,
        super(key: key);

  const Space.y(
    this.y, {
    Key? key,
  })  : x = null,
        super(key: key);

  const Space.all(
    double? s, {
    Key? key,
  })  : x = s,
        y = s,
        super(key: key);

  final double? x;
  final double? y;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: x,
        height: y,
      );
}

/// A stateless utility widget whose [build] method uses its
/// [builder] callback to create the widget's child and apply the [theme] on
/// descendant widgets if provided.
class ThemeBuilder extends StatelessWidget {
  /// Creates a widget that delegates its build to a callback.
  const ThemeBuilder(
    this.builder, {
    this.theme,
    Key? key,
  }) : super(key: key);

  /// Called to obtain the child widget.
  final WidgetBuilder builder;

  /// Specifies the color and typography values for descendant widgets.
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) => theme != null
      ? AnimatedTheme(
          data: theme!,
          child: Builder(builder: builder),
        )
      : builder(context);
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
        appBarTheme: context.appBarTheme,
        scaffoldBackgroundColor: context.scaffoldBackgroundColor,
        inputDecorationTheme: InputDecorationTheme(
          border: InputBorder.none,
        ),
      );

  @override
  List<Widget> buildActions(BuildContext context) => [
        if (query.trim().isNotEmpty)
          GetButton.icon(
            child: Icon(CupertinoIcons.clear_circled_solid),
            onPressed: clear,
          )
      ];

  @override
  Widget buildResults(BuildContext context) => ThemeBuilder(
        (context) =>
            query.trim().isEmpty ? Container(height: 0) : getResults(context),
        theme: context.theme,
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
                    style: TextStyle(color: context.secondaryColor),
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
