import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
    bool? autofocus = false,
    bool round = false,
    bool enabled = true,
    Clip? clipBehavior = Clip.none,
    Widget? child,
  }) =>
      Container(
        margin: margin ??
            (horizontalMargin != null || verticalMargin != null
                ? EdgeInsets.symmetric(
                    horizontal: horizontalMargin ?? 0,
                    vertical: verticalMargin ?? 0,
                  )
                : null),
        child: ElevatedButton(
          key: key,
          onPressed: enabled ? onPressed : null,
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
          child: child,
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
    bool? autofocus = false,
    bool round = false,
    bool enabled = true,
    Clip? clipBehavior = Clip.none,
    required Widget icon,
    required Widget label,
  }) =>
      Container(
        margin: margin ??
            (horizontalMargin != null || verticalMargin != null
                ? EdgeInsets.symmetric(
                    horizontal: horizontalMargin ?? 0,
                    vertical: verticalMargin ?? 0,
                  )
                : null),
        child: ElevatedButton.icon(
          key: key,
          onPressed: enabled ? onPressed : null,
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
          icon: icon,
          label: label,
        ),
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
    bool autofocus = false,
    bool enabled = true,
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
        autofocus: autofocus,
        round: true,
        enabled: enabled,
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
    bool? autofocus = false,
    bool round = false,
    Clip? clipBehavior = Clip.none,
    required Widget child,
  }) =>
      Container(
        margin: margin ??
            (horizontalMargin != null || verticalMargin != null
                ? EdgeInsets.symmetric(
                    horizontal: horizontalMargin ?? 0,
                    vertical: verticalMargin ?? 0,
                  )
                : null),
        child: OutlinedButton(
          key: key,
          onPressed: onPressed,
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
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: child,
        ),
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
    bool autofocus = false,
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
        round: true,
        focusNode: focusNode,
        autofocus: autofocus,
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
    bool autofocus = false,
    bool round = false,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) =>
      Container(
        margin: margin ??
            (horizontalMargin != null || verticalMargin != null
                ? EdgeInsets.symmetric(
                    horizontal: horizontalMargin ?? 0,
                    vertical: verticalMargin ?? 0,
                  )
                : null),
        child: TextButton(
          key: key,
          onPressed: onPressed,
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
          child: child,
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
    bool autofocus = false,
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
        round: true,
        focusNode: focusNode,
        autofocus: autofocus,
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
    bool autofocus = false,
    bool enabled = true,
    Clip clipBehavior = Clip.none,
    required Widget child,
  }) =>
      text(
        key: key,
        onPressed: enabled != true
            ? null
            : () {
                onPressed?.call();
                Get.back();
              },
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
        autofocus: autofocus,
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
    bool autofocus = false,
    bool enabled = true,
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
        autofocus: autofocus,
        enabled: enabled,
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
    bool autofocus = false,
    bool enabled = true,
    Clip clipBehavior = Clip.none,
    Widget? child,
  }) =>
      elevated(
        onPressed: enabled != true
            ? null
            : () {
                onPressed?.call();
                Get.back();
              },
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
        autofocus: autofocus,
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
    bool autofocus = false,
    bool enabled = true,
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
        autofocus: autofocus,
        enabled: enabled,
        clipBehavior: clipBehavior,
        child: Text((label ?? GetText.ok()).uppercase),
      );

  /// Create an icon button.
  static Widget icon({
    Key? key,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    void Function()? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool? autofocus = false,
    bool primary = false,
    bool? enabled = true,
    bool mini = false,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool? enableFeedback = true,
    BoxConstraints? constraints,
  }) {
    var labeled = label != null;
    var labeledOrMini = labeled || mini == true;
    var _color = primary == true
        ? Get.theme.primaryIconTheme.color
        : Get.theme.iconTheme.color;
    return IconButton(
      key: key,
      iconSize: iconSize ??
          (labeledOrMini
              ? 20.0
              : primary == true
                  ? Get.theme.primaryIconTheme.size
                  : Get.theme.iconTheme.size) ??
          24.0,
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
                child!,
                SizedBox(height: mini ? 2 : 2.5),
                Expanded(
                  child: Text(
                    label!,
                    style: labelStyle ??
                        TextStyle(
                          fontSize: 9,
                          color: enabled == true
                              ? (tintLabel == true ? _color : null)
                              : _color?.subbed,
                        ),
                  ),
                ),
              ],
            )
          : (child ?? const SizedBox()),
      color: color,
      focusColor: focusColor,
      hoverColor: hoverColor,
      highlightColor: highlightColor,
      splashColor: splashColor,
      disabledColor: disabledColor ?? _color?.hinted,
      onPressed: (enabled ?? true) ? onPressed : null,
      mouseCursor: mouseCursor ?? SystemMouseCursors.click,
      focusNode: focusNode,
      autofocus: autofocus ?? false,
      tooltip: tooltip,
      enableFeedback: enableFeedback ?? true,
      constraints: constraints ??
          (labeled ? BoxConstraints.expand(width: 40) : BoxConstraints()),
    );
  }

  /// Create a primary icon button.
  static Widget primaryIcon({
    Key? key,
    double? iconSize,
    VisualDensity? visualDensity,
    EdgeInsetsGeometry? padding,
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    void Function()? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
    bool enabled = true,
    bool mini = false,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool enableFeedback = true,
    BoxConstraints? constraints,
  }) =>
      GetButton.icon(
        key: key,
        iconSize: iconSize,
        visualDensity: visualDensity,
        padding: padding,
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
        autofocus: autofocus,
        primary: true,
        enabled: enabled,
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
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    void Function()? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
    bool primary = false,
    bool enabled = true,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool enableFeedback = true,
    BoxConstraints? constraints,
  }) =>
      GetButton.icon(
        key: key,
        iconSize: iconSize,
        visualDensity: visualDensity,
        padding: padding,
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
        autofocus: autofocus,
        primary: primary,
        enabled: enabled,
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
    AlignmentGeometry? alignment,
    double? splashRadius,
    Widget? child,
    Color? color,
    Color? focusColor,
    Color? hoverColor,
    Color? highlightColor,
    Color? splashColor,
    Color? disabledColor,
    void Function()? onPressed,
    MouseCursor? mouseCursor,
    FocusNode? focusNode,
    bool autofocus = false,
    bool primary = false,
    bool enabled = true,
    bool mini = false,
    bool tintLabel = true,
    String? tooltip,
    String? label,
    TextStyle? labelStyle,
    bool enableFeedback = true,
    BoxConstraints? constraints,
  }) =>
      GetButton.icon(
        key: key,
        iconSize: iconSize,
        visualDensity: visualDensity,
        padding: padding ?? const EdgeInsets.all(8),
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
        autofocus: autofocus,
        primary: primary,
        enabled: enabled,
        mini: mini,
        tintLabel: tintLabel,
        tooltip: tooltip,
        label: label,
        labelStyle: labelStyle,
        enableFeedback: enableFeedback,
        constraints: constraints,
      );

  static Widget back({
    Color? color,
    VoidCallback? onPressed,
  }) =>
      GetBuild(
        (context) => CupertinoButton(
          child: Icon(
            Get.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
            color: context.primaryIconColor,
          ),
          padding: EdgeInsets.only(left: Get.isIOS ? 9 : 2),
          onPressed: () => Get.canPop ? Get.back() : Get.systemPop(),
        ).tooltip(Get.localization.backButtonTooltip),
      );

  static Widget sticker({
    Color? color,
    VoidCallback? onPressed,
    String? tooltip,
    String? text,
    IconData? icon,
    EdgeInsets margin = const EdgeInsets.only(
      bottom: 6,
      right: 8,
      top: 6,
      left: 6,
    ),
  }) {
    var _color = color ?? Get.iconColor ?? Get.theme.accentColor;
    return Container(
      width: 20,
      height: 20,
      margin: margin,
      padding: EdgeInsets.only(top: icon != null ? 2.2 : 3),
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
  }
}
