import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

class AppTile extends StatelessWidget {
  const AppTile({
    this.icon,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isIconBoxed = true,
    this.isDetailed = true,
    this.padAccessory,
    this.tintAble,
    this.destructive,
    this.density,
    this.onPressed,
    Key key,
  }) : super(key: key);

  const AppTile.simple({
    this.icon,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isIconBoxed = true,
    this.padAccessory,
    this.tintAble,
    this.destructive,
    this.density,
    this.onPressed,
    Key key,
  })  : isDetailed = false,
        super(key: key);

  const AppTile.simpleDense({
    this.icon,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isIconBoxed = true,
    this.padAccessory,
    this.tintAble,
    this.destructive,
    this.onPressed,
    Key key,
  })  : isDetailed = false,
        density = Density.min,
        super(key: key);

  final IconData icon;
  final String title;
  final String subtitle;
  final String trailingTop;
  final String trailingBottom;
  final Widget accessory;
  final List<Widget> rows;
  final Color color;
  final Color background;
  final bool isIconBoxed;
  final bool isDetailed;
  final bool padAccessory;
  final bool tintAble;
  final bool destructive;
  final VisualDensity density;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final _tintAble = destructive == true ? true : tintAble ?? false;
    final tintColor =
        color ?? (destructive == true ? Colors.red : Get.theme.accentColor);
    final isTrailingTop = trailingTop?.notEmpty != null;
    final isTrailingBottom = trailingBottom?.notEmpty != null;
    final accessory = this.accessory ??
        (isDetailed == true ? const Icon(Icons.chevron_right) : null);
    return InkWell(
      highlightColor: tintColor?.activated,
      splashColor: tintColor?.translucent,
      onTap: onPressed,
      child: Ink(
        color: background ?? Get.theme.backgroundColor,
        child: Column(
          children: [
            ListTile(
              visualDensity: density,
              contentPadding: EdgeInsets.only(
                left: 16,
                right: padAccessory == true ? 16 : 2,
              ),
              leading: icon == null
                  ? null
                  : IconBox(
                      icon: icon,
                      color: tintColor,
                      withinBox: isIconBoxed,
                    ).adjustForTile,
              title: title?.notEmpty?.let((it) => Text(
                    it,
                    style: TextStyle(
                      color: _tintAble ? tintColor : null,
                    ),
                  )),
              subtitle: subtitle?.notEmpty?.let((it) => Text(it)),
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
                          Text(trailingTop, style: Get.textTheme.caption),
                        if (isTrailingTop && isTrailingBottom)
                          SizedBox(height: 4),
                        if (isTrailingBottom)
                          Text(trailingBottom, style: Get.textTheme.caption),
                      ],
                    ),
                  if (accessory != null)
                    IconTheme(
                      data: IconThemeData(color: Get.theme.hintColor),
                      child: accessory,
                    ),
                  if (accessory == null) SizedBox(width: 14),
                ],
              ),
            ),
            ...rows ?? []
          ],
        ),
      ),
    );
  }
}

class AppTileRow extends StatelessWidget {
  const AppTileRow({
    this.icon,
    this.text,
    this.hint,
    Key key,
  }) : super(key: key);

  final IconData icon;
  final String text;
  final String hint;

  @override
  Widget build(BuildContext context) {
    var textData = text ?? hint;
    return textData == null
        ? Container()
        : Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: Row(children: [
              if (icon != null)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Icon(
                    icon,
                    color: Get.theme.primaryIconTheme.color,
                  ),
                ),
              if (icon != null) SizedBox(width: 16),
              Flexible(
                child: Text(
                  text ?? hint,
                  style: Get.textTheme.caption.apply(
                    color: text == null ? Get.theme.hintColor : null,
                  ),
                ),
              ),
            ]),
          );
  }
}

enum SeparatorStyle { full, padIcon, noIcon }

class AppTileSeparator extends StatelessWidget {
  const AppTileSeparator({
    this.margin,
    this.style = SeparatorStyle.padIcon,
    Key key,
  }) : super(key: key);

  const AppTileSeparator.full({Key key}) : this(style: SeparatorStyle.full);

  const AppTileSeparator.noIcon({Key key}) : this(style: SeparatorStyle.noIcon);

  const AppTileSeparator.padIcon({Key key})
      : this(style: SeparatorStyle.padIcon);

  final double margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Get.theme.backgroundColor,
      child: AppLineSeparator(
        margin: margin,
        style: style,
      ),
    );
  }
}

class AppLineSeparator extends StatelessWidget {
  const AppLineSeparator({
    this.margin,
    this.style = SeparatorStyle.padIcon,
    Key key,
  }) : super(key: key);

  final double margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: margin ?? style == SeparatorStyle.full
              ? 0
              : style == SeparatorStyle.noIcon
                  ? 18
                  : 72),
      color: Get.theme.hintColor.translucent,
      height: 0.5,
    );
  }
}

class AppTileHeader extends StatelessWidget {
  const AppTileHeader({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon,
    Key key,
  }) : super(key: key);

  const AppTileHeader.dense({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.noIcon = true,
    Key key,
  })  : padding = 16,
        super(key: key);

  const AppTileHeader.noTop({
    this.text,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon = true,
    Key key,
  })  : topSeparator = false,
        super(key: key);

  final String text;
  final bool topSeparator;
  final bool bottomSeparator;
  final bool noIcon;
  final double padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (topSeparator) AppTileSeparator(style: SeparatorStyle.full),
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
        if (bottomSeparator) AppTileSeparator(style: SeparatorStyle.full),
      ],
    );
  }
}

class IconBox extends StatelessWidget {
  static const double height = 40;
  static const double width = 40;
  static const double size = 30;
  static const double iconSize = 18;

  const IconBox({
    this.color,
    this.icon,
    this.withinBox = true,
    Key key,
  }) : super(key: key);

  final Color color;
  final IconData icon;
  final bool withinBox;

  @override
  Widget build(BuildContext context) {
    return withinBox == true
        ? Container(
            height: size,
            width: size,
            decoration: size.circularDecoration(color: color),
            child: Icon(
              icon,
              size: iconSize,
              color: color.contrast,
            ),
          )
        : Icon(
            icon,
            size: size,
            color: color,
          );
  }

  Widget get adjustForTile => Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        child: this,
      );
}

class CircularProgress extends StatelessWidget {
  const CircularProgress({
    this.size = 14,
    this.margin = 0,
  });

  final double size;
  final double margin;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: size,
            width: size,
            margin: EdgeInsets.all(margin ?? 0),
            child: CircularProgressIndicator(strokeWidth: 1.4),
          ),
        ],
      );
}

class LinearProgress extends StatelessWidget {
  const LinearProgress({this.visible = true});

  final bool visible;

  @override
  Widget build(BuildContext context) => visible ?? true
      ? LinearProgressIndicator(
          minHeight: 1,
          backgroundColor: Colors.transparent,
        )
      : Container(height: 1);
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

  final Widget icon;
  final Widget errorIcon;
  final String action;
  final void Function() onAction;
  final String message;
  final String emptyTitle;
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
                style: Get.textTheme.subtitle1.apply(fontSizeDelta: 1),
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

class DismissibleX extends StatelessWidget {
  const DismissibleX({
    this.enabled,
    this.direction,
    this.onDismissed,
    this.child,
    Key key,
  }) : super(key: key);

  final bool enabled;
  final DismissDirection direction;
  final void Function(DismissDirection) onDismissed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return enabled
        ? Dismissible(
            key: const Key('dismissible'),
            direction: direction,
            onDismissed: onDismissed,
            background: Container(),
            secondaryBackground: Container(),
            child: child,
          )
        : child;
  }
}

class SwipeRefresh extends RefreshIndicator {
  SwipeRefresh({
    Widget child,
    Future<void> Function() onRefresh,
    Key key,
  }) : super(
          key: key,
          child: child,
          onRefresh: onRefresh,
          backgroundColor: Get.theme.appBarTheme.color,
        );

  static GlobalKey<RefreshIndicatorState> get newKey =>
      GlobalKey<RefreshIndicatorState>();
}

class CrossFade extends AnimatedCrossFade {
  CrossFade({
    bool showFirst,
    Widget firstChild,
    Widget secondChild,
    Key key,
  }) : super(
          key: key,
          alignment: showFirst ?? firstChild != null
              ? Alignment.topCenter
              : Alignment.bottomCenter,
          duration: Duration(milliseconds: 200),
          secondCurve: Curves.fastLinearToSlowEaseIn,
          crossFadeState: showFirst ?? firstChild != null
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          firstChild: firstChild ?? Container(height: 0),
          secondChild: secondChild ?? Container(height: 0),
        );
}

class TextFormFieldX extends StatelessWidget {
  const TextFormFieldX({
    this.initialValue,
    this.label,
    this.hint,
    this.error,
    this.helper,
    this.prefix,
    this.suffix,
    this.autovalidateMode,
    this.keyboardType,
    this.inputFilters,
    this.textInputAction,
    this.focusNode,
    this.controller,
    this.onTap,
    this.onSubmitted,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.readOnly,
    this.validateLength,
    this.validateEmpty = true,
    this.showCounter,
    this.isDense,
    this.filled,
    this.obscureText,
    this.enableSuggestions,
    this.maxLength,
    this.minLines,
    this.maxLines = 1,
    this.margin,
    this.padding,
    this.background,
    Key key,
  }) : super(key: key);

  final String initialValue;
  final String label;
  final String hint;
  final String error;
  final String helper;
  final Widget prefix;
  final Widget suffix;
  final TextInputType keyboardType;
  final AutovalidateMode autovalidateMode;
  final List<TextInputFormatter> inputFilters;
  final TextInputAction textInputAction;
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function onTap;
  final void Function(String v) onSubmitted;
  final void Function(String v) onSaved;
  final void Function(String v) onChanged;
  final String Function(String v) validator;
  final bool readOnly;
  final bool validateLength;
  final bool validateEmpty;
  final bool showCounter;
  final bool isDense;
  final bool filled;
  final bool obscureText;
  final bool enableSuggestions;
  final int maxLength;
  final int minLines;
  final int maxLines;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final Color background;

  @override
  Widget build(BuildContext context) {
    final _hint = hint ?? label.lowercase;
    final _validator = validator != null ? validator : (v) => null;
    final _readOnly = readOnly == true || onTap != null;
    final _obscureText = obscureText == true;
    return Container(
      padding: padding ?? EdgeInsets.zero,
      margin: margin ?? EdgeInsets.zero,
      color: background ?? Colors.transparent,
      child: TextFormField(
        initialValue: initialValue,
        focusNode: focusNode,
        controller: controller,
        autovalidateMode: autovalidateMode ??
            (_validator(controller?.text ?? "") != null
                ? AutovalidateMode.always
                : AutovalidateMode.onUserInteraction),
        readOnly: _readOnly ?? false,
        decoration: InputDecoration(
          prefix: prefix != null
              ? Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: IconTheme(
                    data: Get.theme.iconTheme.copyWith(
                      size: 16,
                      color: Get.theme.hintColor,
                    ),
                    child: prefix,
                  ),
                )
              : null,
          isDense: isDense,
          filled: filled,
          labelText: label,
          hintText: hint,
          helperText: helper ?? " ",
          helperMaxLines: 10,
          errorMaxLines: 10,
          errorText: error,
          suffix: suffix,
          counterText: showCounter ?? true ? null : "",
        ),
        keyboardType: keyboardType,
        obscureText: _obscureText,
        enableSuggestions: enableSuggestions ?? !_obscureText,
        autocorrect: enableSuggestions ?? !_obscureText,
        textInputAction: textInputAction,
        maxLength: maxLength,
        inputFormatters: inputFilters,
        minLines: minLines,
        maxLines: maxLines,
        onSaved: onSaved,
        validator: (v) =>
            _validator(v) ??
            (validateEmpty == true && v.isEmpty
                ? GetText.please_enter([_hint])
                : validateLength == true && v.length != maxLength
                    ? GetText.invalid([_hint])
                    : null),
        onTap: readOnly == true ? null : onTap,
        onChanged: onChanged,
        onFieldSubmitted: onSubmitted,
      ),
    );
  }
}

class ProgressButton extends StatelessWidget {
  const ProgressButton({
    this.text,
    this.error,
    this.status,
    this.onPressed,
    Key key,
  }) : super(key: key);

  final String text;
  final dynamic error;
  final WebStatus status;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      alignment: Alignment.centerLeft,
      child: status == WebStatus.busy
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
                      (status == WebStatus.failed
                              ? GetText.retry()
                              : status == WebStatus.succeeded
                                  ? GetText.ok()
                                  : text)
                          .uppercase,
                    ),
                    onPressed: () {
                      if (status == WebStatus.succeeded)
                        Get.back(result: true);
                      else
                        onPressed();
                    },
                  ),
                ),
              ),
              if (status == WebStatus.failed)
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16),
                    child: Text(
                      error ?? GetText.failed(),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              if (status == WebStatus.succeeded)
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
    Key key,
  }) : super(key: key);

  final String success;
  final String error;
  final WebStatus status;
  final Function onCancel;
  final Function onRetry;
  final Function onDone;
  final bool withBottomBar;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return SnackBarX(
      message: status == WebStatus.busy
          ? GetText.busy()
          : status == WebStatus.failed
              ? error ?? GetText.failed()
              : success ?? GetText.succeeded(),
      action: status == WebStatus.busy
          ? GetText.cancel()
          : status == WebStatus.failed
              ? GetText.retry()
              : GetText.ok(),
      onAction: status == WebStatus.busy
          ? onCancel
          : status == WebStatus.failed
              ? onRetry
              : onDone,
      onDismiss: onCancel,
      showProgress: status == WebStatus.busy,
      isDismissible: status == WebStatus.failed,
      withBottomBar: withBottomBar,
      actionColor: actionColor,
    );
  }
}

class SnackBarX extends StatelessWidget {
  const SnackBarX({
    this.message,
    this.action,
    this.onAction,
    this.onDismiss,
    this.showProgress = true,
    this.isDismissible = false,
    this.withBottomBar = false,
    this.actionColor,
    Key key,
  }) : super(key: key);

  final String message;
  final String action;
  final Function onAction;
  final Function onDismiss;
  final bool showProgress;
  final bool isDismissible;
  final bool withBottomBar;
  final Color actionColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        DismissibleX(
          enabled: isDismissible,
          direction: DismissDirection.down,
          onDismissed: (direction) => onDismiss(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(children: [
                AppLineSeparator(style: SeparatorStyle.full),
                if (showProgress) LinearProgress(),
              ]),
              GetBar(
                snackPosition: withBottomBar == true
                    ? SnackPosition.TOP
                    : SnackPosition.BOTTOM,
                animationDuration: Duration(milliseconds: 200),
                messageText: message == null ? null : Text(message),
                backgroundColor: Get.theme.bottomAppBarTheme.color,
                mainButton: action == null
                    ? null
                    : GetButton.text(
                        child: Text(action.uppercase),
                        primary: actionColor,
                        onPressed: onAction,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({
    this.leftItems,
    this.rightItems,
    this.centerItems,
    this.snackBar,
    Key key,
  }) : super(key: key);

  final List<Widget> leftItems;
  final List<Widget> rightItems;
  final List<Widget> centerItems;
  final Widget snackBar;

  @override
  Widget build(BuildContext context) {
    var _leftItems = leftItems ?? [];
    var _rightItems = rightItems ?? [];
    var _centerItems = centerItems ?? [];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CrossFade(firstChild: snackBar),
        if (snackBar == null) AppLineSeparator(style: SeparatorStyle.full),
        BottomAppBar(
          child: SafeArea(
            minimum: EdgeInsets.only(bottom: Get.mediaQuery.viewInsets.bottom),
            left: false,
            right: false,
            top: false,
            bottom: true,
            child: Container(
              height: 44,
              child: Row(mainAxisSize: MainAxisSize.min, children: [
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
    Function onTap,
    Widget child,
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
  void forward({FocusNode to}) {
    unfocus();
    to?.requestFocus();
  }
}

extension WidgetX on Widget {
  WidgetSpan get widgetSpan => WidgetSpan(child: this);
}

extension GlobalKeyX<T extends State<StatefulWidget>> on GlobalKey<T> {
  BuildContext get context => currentContext;

  Widget get widget => currentWidget;

  T get state => currentState;
}

class GetShimmer {
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
    PageController controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.itemBuilder,
    this.itemCount,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    Key key,
  })  : _key = key,
        this.controller = controller ?? PageController();

  final Color dotColor;
  final Color dotActiveColor;
  final Axis scrollDirection;
  final bool autoPlay;
  final bool reverse;
  final PageController controller;
  final ScrollPhysics physics;
  final bool pageSnapping;
  final void Function(int) onPageChanged;
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final DragStartBehavior dragStartBehavior;
  final bool allowImplicitScrolling;
  final String restorationId;
  final Clip clipBehavior;
  final Key _key;

  @override
  _DottedPageViewState createState() => _DottedPageViewState();
}

class _DottedPageViewState extends State<DottedPageView>
    with SingleTickerProviderStateMixin {
  static const double duration = 10;
  final _index = 0.obs;
  Ticker _ticker;
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
    if (widget.controller?.hasClients == true)
      widget.controller?.animateToPage(
        _index.value == widget.itemCount - 1 ? 0 : _index.value + 1,
        duration: Duration(milliseconds: 1500),
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
          itemBuilder: widget.itemBuilder,
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
            dotsCount: widget.itemCount,
            position: _index.toDouble(),
          ),
        ),
      ],
    );
  }
}

extension GetBoxDecoration on BoxDecoration {
  static BoxDecoration only({
    double top,
    double bottom,
    double left,
    double right,
    Color color,
    Color borderColor,
  }) {
    var _borderColor = borderColor ?? Get.theme.hintColor.dimmed;
    return BoxDecoration(
      color: color ?? Get.theme.backgroundColor,
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
    double vertical,
    double horizontal,
    Color color,
    Color borderColor,
    double borderWidth,
  }) {
    return only(
      top: vertical,
      bottom: vertical,
      left: horizontal,
      right: horizontal,
      color: color,
      borderColor: borderColor,
    );
  }

  static BoxDecoration all(
    double all, {
    Color color,
    Color borderColor,
    double borderWidth,
  }) {
    return symmetric(
      vertical: all,
      horizontal: all,
      color: color,
      borderColor: borderColor,
    );
  }
}

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
class AppLifecycle extends StatefulWidget {
  const AppLifecycle({
    this.onResume,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    Key key,
  }) : super(key: key);

  /// The application is visible and responding to user input.
  final void Function() onResume;

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
  /// Apps in this state should assume that they may be [paused] at any time.
  final void Function() onInactive;

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  ///
  /// When the application is in this state, the engine will not call the
  /// [PlatformDispatcher.onBeginFrame] and [PlatformDispatcher.onDrawFrame]
  /// callbacks.
  final void Function() onPaused;

  /// The application is still hosted on a flutter engine but is detached from
  /// any host views.
  ///
  /// When the application is in this state, the engine is running without
  /// a view. It can either be in the progress of attaching a view when engine
  /// was first initializes, or after the view being destroyed due to a Navigator
  /// pop.
  final void Function() onDetached;

  @override
  _AppLifecycleState createState() => _AppLifecycleState();
}

class _AppLifecycleState extends State<AppLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
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

extension Density on VisualDensity {
  static const VisualDensity min =
      VisualDensity(horizontal: -4.0, vertical: -4.0);

  static const VisualDensity max =
      VisualDensity(horizontal: 4.0, vertical: 4.0);

  static const VisualDensity dense =
      VisualDensity(horizontal: 3.0, vertical: 3.0);
}
