import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// The factory class for buttons whose style are defined by a
/// [ButtonStyle] object.

/// Buttons included are:
///
///  * [TextButton], a simple ButtonStyleButton without a shadow.
///  * [ElevatedButton], a filled ButtonStyleButton whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
///  * [IconButton], A material design icon button.
abstract class GetButton {
  const GetButton._();

  static MaterialStateProperty<double> defaultElevation([
    double elevation = 2,
  ]) =>
      MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) return 0;
        if (states.contains(MaterialState.hovered)) return elevation + 1;
        if (states.contains(MaterialState.focused)) return elevation + 1;
        if (states.contains(MaterialState.pressed)) return elevation + 2;
        return elevation;
      });

  static MaterialStateProperty<OutlinedBorder> defaultShape({
    double roundRadius = 5,
  }) =>
      MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(roundRadius),
        ),
      );

  static MaterialStateProperty<BorderSide> defaultSide(Color color) =>
      MaterialStateProperty.resolveWith(
        (states) => BorderSide(color: resolveColor(color.subbed, states)),
      );

  static Color resolveColor(Color color, Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return color.dimmed;
    if (states.contains(MaterialState.hovered)) return color.focused;
    if (states.contains(MaterialState.focused)) return color.focused;
    if (states.contains(MaterialState.pressed)) return color.hinted;
    return color;
  }

  /// Create an elevated button.
  static Widget elevated({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding = 24,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    OutlinedBorder? shape,
    BorderSide? side,
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool? autofocus = false,
    bool round = false,
    bool enabled = true,
    bool busy = false,
    Clip? clipBehavior = Clip.none,
    Widget? child,
  }) =>
      Builder(
        builder: (context) => Container(
          margin: margin ??
              (horizontalMargin != null || verticalMargin != null
                  ? EdgeInsets.symmetric(
                      horizontal: horizontalMargin ?? 0,
                      vertical: verticalMargin ?? 0,
                    )
                  : null),
          child: ElevatedButton(
            key: key,
            onPressed: enabled
                ? busy
                    ? () {}
                    : () {
                        onPressed?.call();
                        if (back) Get.back();
                      }
                : null,
            onLongPress: onLongPress,
            style: ElevatedButton.styleFrom(
              minimumSize: minimumSize,
              padding: padding ??
                  (horizontalPadding != null || verticalPadding != null
                      ? EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 0,
                          vertical: verticalPadding ?? 0,
                        )
                      : null),
              shape: shape ??
                  (round == true
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      : null),
              side: side,
              primary: primary,
              onPrimary: onPrimary,
              onSurface: onSurface,
              elevation: elevation,
              textStyle: textStyle,
            ),
            focusNode: focusNode,
            autofocus: autofocus ?? false,
            clipBehavior: clipBehavior ?? Clip.none,
            child: busy
                ? CircularProgress.small(
                    color: onPrimary ?? context.elevatedButtonForegroundColor,
                  )
                : child,
          ),
        ),
      );

  /// Create an elevated button with icon.
  static Widget elevatedIcon({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding = 24,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    OutlinedBorder? shape,
    BorderSide? side,
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool? autofocus = false,
    bool round = false,
    bool enabled = true,
    bool busy = false,
    Clip? clipBehavior = Clip.none,
    required Widget icon,
    required Widget label,
  }) =>
      Builder(
        builder: (context) {
          return Container(
            margin: margin ??
                (horizontalMargin != null || verticalMargin != null
                    ? EdgeInsets.symmetric(
                        horizontal: horizontalMargin ?? 0,
                        vertical: verticalMargin ?? 0,
                      )
                    : null),
            child: ElevatedButton.icon(
              key: key,
              onPressed: enabled
                  ? busy
                      ? () {}
                      : () {
                          onPressed?.call();
                          if (back) Get.back();
                        }
                  : null,
              onLongPress: onLongPress,
              style: ElevatedButton.styleFrom(
                minimumSize: minimumSize,
                padding: padding ??
                    (horizontalPadding != null || verticalPadding != null
                        ? EdgeInsets.symmetric(
                            horizontal: horizontalPadding ?? 0,
                            vertical: verticalPadding ?? 0,
                          )
                        : null),
                shape: shape ??
                    (round == true
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )
                        : null),
                side: side,
                primary: primary,
                onPrimary: onPrimary,
                onSurface: onSurface,
                elevation: elevation,
                textStyle: textStyle,
              ),
              focusNode: focusNode,
              autofocus: autofocus ?? false,
              clipBehavior: clipBehavior ?? Clip.none,
              icon: busy
                  ? CircularProgress.small(
                      color: onPrimary ?? context.elevatedButtonForegroundColor,
                    )
                  : icon,
              label: label,
            ),
          );
        },
      );

  /// Create an elevated button with fully round corner.
  static Widget roundElevated({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
    Widget? child,
  }) =>
      elevated(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        onPrimary: onPrimary,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        round: true,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create an outlined button.
  static Widget outlined({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding = 24,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    OutlinedBorder? shape,
    BorderSide? side,
    Color? primary,
    Color? backgroundColor,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool round = false,
    bool enabled = true,
    bool busy = false,
    Clip? clipBehavior = Clip.none,
    required Widget child,
  }) =>
      Builder(
        builder: (context) {
          return Container(
            margin: margin ??
                (horizontalMargin != null || verticalMargin != null
                    ? EdgeInsets.symmetric(
                        horizontal: horizontalMargin ?? 0,
                        vertical: verticalMargin ?? 0,
                      )
                    : null),
            child: OutlinedButton(
              key: key,
              onPressed: enabled
                  ? busy
                      ? () {}
                      : () {
                          onPressed?.call();
                          if (back) Get.back();
                        }
                  : null,
              onLongPress: onLongPress,
              style: OutlinedButton.styleFrom(
                minimumSize: minimumSize,
                padding: padding ??
                    (horizontalPadding != null || verticalPadding != null
                        ? EdgeInsets.symmetric(
                            horizontal: horizontalPadding ?? 0,
                            vertical: verticalPadding ?? 0,
                          )
                        : null),
                shape: shape ??
                    (round == true
                        ? RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )
                        : null),
                side: side,
                primary: primary,
                backgroundColor: backgroundColor,
                onSurface: onSurface,
                elevation: elevation,
                textStyle: textStyle,
              ),
              focusNode: focusNode,
              autofocus: autofocus,
              clipBehavior: clipBehavior ?? Clip.none,
              child: busy
                  ? CircularProgress.small(
                      color: primary ?? context.outlinedButtonForegroundColor,
                    )
                  : child,
            ),
          );
        },
      );

  /// Create an outlined button with fully round corner.
  static Widget roundOutlined({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding = 24,
    double? verticalPadding = 11,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? backgroundColor,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) =>
      outlined(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        backgroundColor: backgroundColor,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        round: true,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a text button.
  static Widget text({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding = 24,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    OutlinedBorder? shape,
    BorderSide? side,
    Color? primary,
    Color? backgroundColor,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool round = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) =>
      Builder(
        builder: (context) => Container(
          margin: margin ??
              (horizontalMargin != null || verticalMargin != null
                  ? EdgeInsets.symmetric(
                      horizontal: horizontalMargin ?? 0,
                      vertical: verticalMargin ?? 0,
                    )
                  : null),
          child: TextButton(
            key: key,
            onPressed: enabled
                ? busy
                    ? () {}
                    : () {
                        onPressed?.call();
                        if (back) Get.back();
                      }
                : null,
            onLongPress: onLongPress,
            style: TextButton.styleFrom(
              minimumSize: minimumSize,
              padding: padding ??
                  (horizontalPadding != null || verticalPadding != null
                      ? EdgeInsets.symmetric(
                          horizontal: horizontalPadding ?? 0,
                          vertical: verticalPadding ?? 0,
                        )
                      : null),
              shape: shape ??
                  (round == true
                      ? RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        )
                      : null),
              side: side,
              primary: primary,
              backgroundColor: backgroundColor,
              onSurface: onSurface,
              elevation: elevation,
              textStyle: textStyle,
            ),
            focusNode: focusNode,
            autofocus: autofocus,
            clipBehavior: clipBehavior,
            child: busy
                ? CircularProgress.small(
                    color: primary ?? context.textButtonForegroundColor,
                  )
                : child,
          ),
        ),
      );

  /// Create a text button with fully round corner.
  static Widget roundText({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding = 24,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? backgroundColor,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) =>
      text(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        backgroundColor: backgroundColor,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        round: true,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a dialog text button.
  static Widget dialogText({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? backgroundColor,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = true,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) =>
      text(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        backgroundColor: backgroundColor,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a dialog text negative button.
  static Widget dialogNegative({
    Key? key,
    String? label,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    EdgeInsetsGeometry? margin,
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? backgroundColor,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = true,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
  }) =>
      dialogText(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        backgroundColor: backgroundColor,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: Text((label ?? GetText.cancel()).uppercase),
      );

  /// Create a dialog elevated button.
  static Widget dialogElevated({
    Key? key,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    EdgeInsetsGeometry? margin = const EdgeInsets.only(right: 7),
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = true,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
    Widget? child,
  }) =>
      elevated(
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        onPrimary: onPrimary,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a dialog elevated positive button.
  static Widget dialogPositive({
    Key? key,
    String? label,
    VoidCallback? onPressed,
    VoidCallback? onLongPress,
    Size? minimumSize,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    EdgeInsetsGeometry? margin = const EdgeInsets.only(right: 7),
    double? horizontalMargin,
    double? verticalMargin,
    BorderSide? side,
    Color? primary,
    Color? onPrimary,
    Color? onSurface,
    double? elevation,
    TextStyle? textStyle,
    FocusNode? focusNode,
    bool back = true,
    bool autofocus = false,
    bool enabled = true,
    bool busy = false,
    Clip clipBehavior = Clip.none,
  }) =>
      dialogElevated(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        minimumSize: minimumSize,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        side: side,
        primary: primary,
        onPrimary: onPrimary,
        onSurface: onSurface,
        elevation: elevation,
        textStyle: textStyle,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        enabled: enabled,
        busy: busy,
        clipBehavior: clipBehavior,
        child: Text((label ?? GetText.ok()).uppercase),
      );

  /// Create an icon button.
  static Widget icon({
    Key? key,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    VoidCallback? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool primary = false,
    bool enabled = true,
    bool busy = false,
    bool mini = false,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool? enableFeedback = true,
    BoxConstraints? constraints,
  }) =>
      ThemeBuilder((context) {
        final _tooltip = tooltip ?? label;
        final labeled = label != null;
        final labeledOrMini = labeled || mini == true;
        final _color = color ??
            (primary == true
                ? context.primaryActionIconColor
                : context.iconColor);
        final _iconSize = iconSize ??
            (labeledOrMini
                ? 20.0
                : primary == true
                    ? context.primaryActionIconTheme.size
                    : context.iconTheme.size) ??
            24.0;
        return Container(
          padding: margin,
          child: IconButton(
            key: key,
            iconSize: _iconSize,
            visualDensity: visualDensity,
            padding: padding ??
                (labeled
                    ? EdgeInsets.symmetric(vertical: mini ? 4 : 8)
                    : const EdgeInsets.symmetric(horizontal: 8)),
            alignment: alignment ?? Alignment.center,
            splashRadius: splashRadius ?? (labeled ? 24 : 18),
            icon: labeled
                ? Column(
                    children: [
                      SizedBox(
                        height: iconSize == null
                            ? (mini ? 2 : 4)
                            : ((mini ? 22 : 24) - iconSize).abs(),
                      ),
                      busy
                          ? CircularProgress.small(color: _color)
                              .sizedCenter(_iconSize)
                          : child!,
                      SizedBox(height: mini ? 2 : 2.5),
                      Expanded(
                        child: Text(
                          label,
                          style: labelStyle ??
                              TextStyle(
                                fontSize: 9,
                                color: enabled
                                    ? (tintLabel == true ? _color : null)
                                    : _color?.subbed,
                              ),
                        ),
                      ),
                    ],
                  )
                : busy
                    ? CircularProgress.small(color: _color)
                    : (child ?? const SizedBox()),
            color: _color,
            focusColor: focusColor,
            hoverColor: hoverColor,
            highlightColor: highlightColor,
            splashColor: splashColor,
            disabledColor: disabledColor ?? _color?.hinted,
            onPressed: enabled
                ? busy
                    ? () {}
                    : () {
                        onPressed?.call();
                        if (back) Get.back();
                      }
                : null,
            mouseCursor: mouseCursor ?? SystemMouseCursors.click,
            focusNode: focusNode,
            autofocus: autofocus,
            tooltip: _tooltip,
            enableFeedback: enableFeedback ?? true,
            constraints: constraints ??
                (labeled
                    ? const BoxConstraints.expand(width: 40)
                    : const BoxConstraints()),
          ),
        );
      });

  /// Create a primary icon button.
  static Widget primaryIcon({
    Key? key,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    VoidCallback? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool enabled = true,
    bool mini = false,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool enableFeedback = true,
    bool busy = false,
    BoxConstraints? constraints,
  }) =>
      icon(
        key: key,
        iconSize: iconSize,
        visualDensity: visualDensity,
        padding: padding,
        margin: margin,
        alignment: alignment,
        splashRadius: splashRadius,
        child: child,
        color: color,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        disabledColor: disabledColor,
        onPressed: onPressed,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        primary: true,
        enabled: enabled,
        busy: busy,
        mini: mini,
        tintLabel: tintLabel,
        tooltip: tooltip,
        label: label,
        labelStyle: labelStyle,
        enableFeedback: enableFeedback,
        constraints: constraints,
      );

  /// Create a mini icon button.
  static Widget miniIcon({
    Key? key,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    VoidCallback? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool primary = false,
    bool enabled = true,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool enableFeedback = true,
    bool busy = false,
    BoxConstraints? constraints,
  }) =>
      icon(
        key: key,
        iconSize: iconSize,
        visualDensity: visualDensity,
        padding: padding,
        margin: margin,
        alignment: alignment,
        splashRadius: splashRadius,
        child: child,
        color: color,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        disabledColor: disabledColor,
        onPressed: onPressed,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        primary: primary,
        enabled: enabled,
        busy: busy,
        mini: true,
        tintLabel: tintLabel,
        tooltip: tooltip,
        label: label,
        labelStyle: labelStyle,
        enableFeedback: enableFeedback,
        constraints: constraints,
      );

  /// Create an anchored icon button.
  static Widget anchoredIcon({
    Key? key,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    VoidCallback? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool back = false,
    bool autofocus = false,
    bool primary = false,
    bool enabled = true,
    bool mini = false,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool enableFeedback = true,
    bool busy = false,
    BoxConstraints? constraints,
  }) =>
      icon(
        key: key,
        iconSize: iconSize,
        visualDensity: visualDensity,
        padding: padding ?? const EdgeInsets.all(8),
        margin: margin,
        alignment: alignment,
        splashRadius: splashRadius,
        child: child,
        color: color,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        disabledColor: disabledColor,
        onPressed: onPressed,
        mouseCursor: mouseCursor,
        focusNode: focusNode,
        back: back,
        autofocus: autofocus,
        primary: primary,
        enabled: enabled,
        busy: busy,
        mini: mini,
        tintLabel: tintLabel,
        tooltip: tooltip,
        label: label,
        labelStyle: labelStyle,
        enableFeedback: enableFeedback,
        constraints: constraints,
      );

  static Widget plain({
    Key? key,
    bool back = false,
    bool enabled = true,
    bool primary = false,
    bool busy = false,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    double? topPadding,
    double? bottomPadding,
    double? leftPadding,
    double? rightPadding,
    Color? color,
    Color? backgroundColor,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = kMinInteractiveDimensionCupertino,
    double? iconSize,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
    Widget? child,
  }) =>
      ThemeBuilder((context) {
        final iconTheme =
            (primary ? context.primaryActionIconTheme : context.iconTheme)
                .copyWith(color: color, size: iconSize);
        final _color = iconTheme.color;
        return CupertinoButton(
          key: key,
          padding: padding ??
              EdgeInsets.only(
                top: verticalPadding ?? topPadding ?? 0,
                bottom: verticalPadding ?? bottomPadding ?? 0,
                left: horizontalPadding ?? leftPadding ?? 0,
                right: horizontalPadding ?? rightPadding ?? 0,
              ),
          color: backgroundColor,
          disabledColor: disabledColor,
          minSize: minSize,
          pressedOpacity: busy ? null : pressedOpacity,
          borderRadius: borderRadius,
          alignment: alignment,
          onPressed: enabled
              ? busy
                  ? () {}
                  : () {
                      onPressed?.call();
                      if (back) Get.back();
                    }
              : null,
          child: DefaultTextStyle(
            style: TextStyle(color: _color),
            child: IconTheme(
              data: iconTheme,
              child: busy
                  ? const CircularProgress.small()
                  : child ?? const SizedBox(),
            ),
          ),
        );
      });

  static Widget plainZero({
    Key? key,
    bool back = false,
    bool enabled = true,
    bool primary = false,
    bool busy = false,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    double? topPadding,
    double? bottomPadding,
    double? leftPadding,
    double? rightPadding,
    Color? color,
    Color? backgroundColor,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = 0,
    double? iconSize,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
    Widget? child,
  }) =>
      plain(
        key: key,
        back: back,
        enabled: enabled,
        primary: primary,
        busy: busy,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        color: color,
        backgroundColor: backgroundColor,
        disabledColor: disabledColor,
        minSize: minSize,
        iconSize: iconSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: onPressed,
        child: child,
      );

  static Widget plainMini({
    Key? key,
    bool back = false,
    bool enabled = true,
    bool primary = false,
    bool busy = false,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    double? topPadding,
    double? bottomPadding,
    double? leftPadding = 12,
    double? rightPadding = 12,
    Color? color,
    Color? backgroundColor,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = 0,
    double? iconSize = 20,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
    Widget? child,
  }) =>
      plain(
        key: key,
        back: back,
        enabled: enabled,
        primary: primary,
        busy: busy,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        color: color,
        backgroundColor: backgroundColor,
        disabledColor: disabledColor,
        minSize: minSize,
        iconSize: iconSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: onPressed,
        child: child,
      );

  static Widget back({
    IconData? icon,
    Color? color,
    VoidCallback? onPressed,
  }) =>
      ThemeBuilder(
        (context) => CupertinoButton(
          padding: EdgeInsets.only(left: Get.isIOS ? 9 : 2),
          onPressed:
              onPressed ?? () => Get.canPop ? Get.back() : Get.systemPop(),
          child: Icon(
            icon ?? (Get.isIOS ? Icons.arrow_back_ios : Icons.arrow_back),
            color: color ?? context.primaryIconColor,
          ),
        ).tooltip(MaterialLocalizations.of(context).backButtonTooltip),
      );

  static Widget detail({
    IconData? icon,
    Color? color,
    String? tooltip,
    double size = 14,
    Matrix4? transform,
    bool? angle180,
    bool? angle90,
    VoidCallback? onPressed,
  }) =>
      ThemeBuilder(
        (context) => CupertinoButton(
          minSize: 0,
          padding: EdgeInsets.zero,
          onPressed: onPressed,
          child: AnimatedContainer(
            duration: 200.milliseconds,
            transformAlignment: Alignment.center,
            transform: transform ??
                angle180?.mapIt((it) => Matrix4.rotationZ(it ? pi : 0)) ??
                angle90?.mapIt((it) => Matrix4.rotationZ(it ? pi / 2 : 0)),
            child: Icon(
              icon ?? CupertinoIcons.chevron_right,
              color: color ?? context.hintColor,
              size: size,
            ),
          ),
        ).tooltip(tooltip),
      );

  static Widget sticker({
    Color? color,
    VoidCallback? onPressed,
    String? tooltip,
    String? text,
    IconData? icon,
    double size = 22,
    EdgeInsets margin = const EdgeInsets.only(
      bottom: 5,
      right: 8,
      top: 5,
      left: 5,
    ),
  }) =>
      ThemeBuilder((context) {
        final _color = color ?? context.iconColor ?? context.secondaryColor;
        return Container(
          width: size,
          height: size,
          margin: margin,
          padding: EdgeInsets.only(top: icon != null ? 3.2 : 4),
          alignment: Alignment.topCenter,
          decoration: BoxDecoration(
            border: Border.all(color: _color),
            borderRadius: BorderRadius.only(
              topRight: 6.radius,
              topLeft: 6.radius,
              bottomLeft: 6.radius,
              bottomRight: 12.radius,
            ),
          ),
          child: icon != null
              ? Icon(icon, color: _color, size: 13)
              : Text(
                  text?.take(3).uppercase ?? "",
                  style: GoogleFonts.ubuntuCondensed(
                    fontSize: 8,
                    color: _color,
                  ),
                ),
        ).clickable(onTap: onPressed).tooltip(tooltip);
      });

  static Widget stickerZero({
    Color? color,
    VoidCallback? onPressed,
    String? tooltip,
    String? text,
    IconData? icon,
    double size = 22,
    EdgeInsets margin = EdgeInsets.zero,
  }) =>
      sticker(
        color: color,
        onPressed: onPressed,
        tooltip: tooltip,
        text: text,
        icon: icon,
        size: size,
        margin: margin,
      );
}
