import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get_smart/get_smart.dart';

/// The factory class class for buttons whose style are defined by a
/// [ButtonStyle] object.

/// Buttons included are:
///
///  * [TextButton], a simple ButtonStyleButton without a shadow.
///  * [ElevatedButton], a filled ButtonStyleButton whose material elevates when pressed.
///  * [OutlinedButton], similar to [TextButton], but with an outline.
///  * [IconButton], A material design icon button.
class GetButton {
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
        (states) => BorderSide(color: resolveColor(color, states)),
      );

  static Color resolveColor(Color color, Set<MaterialState> states) {
    if (states.contains(MaterialState.disabled)) return color.dimmed;
    if (states.contains(MaterialState.hovered)) return color.highlighted;
    if (states.contains(MaterialState.focused)) return color.highlighted;
    if (states.contains(MaterialState.pressed)) return color.hinted;
    return color.subbed;
  }

  /// Create an elevated button.
  static Widget elevated({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding = 24,
    double verticalPadding,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    OutlinedBorder shape,
    FocusNode focusNode,
    bool autofocus = false,
    bool round = false,
    Clip clipBehavior = Clip.none,
    Widget child,
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
          onPressed: onPressed,
          onLongPress: onLongPress,
          style: ElevatedButton.styleFrom(
            padding: padding ??
                (horizontalPadding != null || verticalPadding != null
                    ? EdgeInsets.symmetric(
                        horizontal: horizontalPadding ?? 0,
                        vertical: verticalPadding ?? 0,
                      )
                    : null),
            shape: shape ?? round == true
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                : null,
          ),
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: child,
        ),
      );

  /// Create an elevated button with fully round corner.
  static Widget roundElevated({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding = 24,
    double verticalPadding = 11,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    Widget child,
  }) =>
      elevated(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        round: true,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create an outlined button.
  static Widget outlined({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding = 24,
    double verticalPadding,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    OutlinedBorder shape,
    FocusNode focusNode,
    bool autofocus = false,
    bool round = false,
    Clip clipBehavior = Clip.none,
    Widget child,
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
            padding: padding ??
                (horizontalPadding != null || verticalPadding != null
                    ? EdgeInsets.symmetric(
                        horizontal: horizontalPadding ?? 0,
                        vertical: verticalPadding ?? 0,
                      )
                    : null),
            shape: shape ?? round == true
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                : null,
          ),
          focusNode: focusNode,
          autofocus: autofocus ?? false,
          clipBehavior: clipBehavior ?? Clip.none,
          child: child,
        ),
      );

  /// Create an outlined button with fully round corner.
  static Widget roundOutlined({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding = 24,
    double verticalPadding = 11,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    Widget child,
  }) =>
      outlined(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        round: true,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a text button.
  static Widget text({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding = 24,
    double verticalPadding,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    OutlinedBorder shape,
    FocusNode focusNode,
    bool autofocus = false,
    bool round = false,
    Clip clipBehavior = Clip.none,
    Widget child,
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
            padding: padding ??
                (horizontalPadding != null || verticalPadding != null
                    ? EdgeInsets.symmetric(
                        horizontal: horizontalPadding ?? 0,
                        vertical: verticalPadding ?? 0,
                      )
                    : null),
            shape: shape ?? round == true
                ? RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  )
                : null,
          ),
          focusNode: focusNode,
          autofocus: autofocus,
          clipBehavior: clipBehavior,
          child: child,
        ),
      );

  /// Create a text button with fully round corner.
  static Widget roundText({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding = 24,
    double verticalPadding,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    Clip clipBehavior = Clip.none,
    Widget child,
  }) =>
      text(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        round: true,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a dialog text button.
  static Widget dialogText({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding,
    double verticalPadding,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    bool enabled = true,
    Clip clipBehavior = Clip.none,
    Widget child,
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
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a dialog text negative button.
  static Widget dialogNegative({
    Key key,
    String label,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding,
    double verticalPadding,
    EdgeInsetsGeometry margin,
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    bool enabled = true,
    Clip clipBehavior = Clip.none,
  }) =>
      dialogText(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        clipBehavior: clipBehavior,
        child: Text((label ?? GetText.cancel()).uppercase),
      );

  /// Create a dialog elevated button.
  static Widget dialogElevated({
    Key key,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding,
    double verticalPadding,
    EdgeInsetsGeometry margin = const EdgeInsets.only(right: 7),
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    bool enabled = true,
    Clip clipBehavior = Clip.none,
    Widget child,
  }) =>
      elevated(
        onPressed: enabled != true
            ? null
            : () {
                onPressed?.call();
                Get.back();
              },
        onLongPress: onLongPress,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        focusNode: focusNode,
        autofocus: autofocus,
        clipBehavior: clipBehavior,
        child: child,
      );

  /// Create a dialog elevated positive button.
  static Widget dialogPositive({
    Key key,
    String label,
    VoidCallback onPressed,
    VoidCallback onLongPress,
    EdgeInsetsGeometry padding,
    double horizontalPadding,
    double verticalPadding,
    EdgeInsetsGeometry margin = const EdgeInsets.only(right: 7),
    double horizontalMargin,
    double verticalMargin,
    FocusNode focusNode,
    bool autofocus = false,
    bool enabled = true,
    Clip clipBehavior = Clip.none,
  }) =>
      dialogElevated(
        key: key,
        onPressed: onPressed,
        onLongPress: onLongPress,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        margin: margin,
        horizontalMargin: horizontalMargin,
        verticalMargin: verticalMargin,
        focusNode: focusNode,
        autofocus: autofocus,
        enabled: enabled,
        clipBehavior: clipBehavior,
        child: Text((label ?? GetText.ok()).uppercase),
      );

  /// Create an icon button.
  static Widget icon({
    Key key,
    double iconSize = 24.0,
    VisualDensity visualDensity,
    EdgeInsetsGeometry padding = const EdgeInsets.all(8.0),
    AlignmentGeometry alignment = Alignment.center,
    double splashRadius,
    Widget icon,
    Color color,
    Color focusColor,
    Color hoverColor,
    Color highlightColor,
    Color splashColor,
    Color disabledColor,
    void Function() onPressed,
    MouseCursor mouseCursor = SystemMouseCursors.click,
    FocusNode focusNode,
    bool autofocus = false,
    String tooltip,
    bool enableFeedback = true,
    BoxConstraints constraints,
  }) =>
      IconButton(
        key: key,
        iconSize: iconSize ?? 24.0,
        visualDensity: visualDensity,
        padding: padding ?? const EdgeInsets.all(8.0),
        alignment: alignment ?? Alignment.center,
        splashRadius: splashRadius,
        icon: icon ?? const SizedBox(),
        color: color,
        focusColor: focusColor,
        hoverColor: hoverColor,
        highlightColor: highlightColor,
        splashColor: splashColor,
        disabledColor: disabledColor,
        onPressed: onPressed,
        mouseCursor: mouseCursor ?? SystemMouseCursors.click,
        focusNode: focusNode,
        autofocus: autofocus ?? false,
        tooltip: tooltip,
        enableFeedback: enableFeedback ?? true,
        constraints: constraints,
      );
}
