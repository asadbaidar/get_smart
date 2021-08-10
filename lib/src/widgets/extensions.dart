import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

extension GetFocusNode on FocusNode {
  void forward({FocusNode? to}) {
    unfocus();
    to?.requestFocus();
  }
}

extension GetWidgetX on Widget {
  WidgetSpan get widgetSpan => WidgetSpan(child: this);

  Widget tooltip([String? message]) => message?.notEmpty != null
      ? Tooltip(message: message!, child: this)
      : this;

  Widget clipOval({
    Key? key,
    bool clip = true,
    CustomClipper<Rect>? clipper,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      clip
          ? ClipOval(
              key: key,
              clipper: clipper,
              clipBehavior: clipBehavior,
              child: this,
            )
          : this;

  Widget row({
    Key? key,
    bool enabled = false,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> children = const [],
  }) =>
      enabled
          ? Row(
              key: key,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: crossAxisAlignment,
              verticalDirection: verticalDirection,
              textBaseline: textBaseline,
              children: [this, ...children],
            )
          : this;

  Widget flex({
    Key? key,
    int flex = 1,
    bool enabled = true,
    bool expanded = false,
  }) =>
      enabled
          ? Flexible(
              key: key,
              flex: flex,
              fit: expanded ? FlexFit.tight : FlexFit.loose,
              child: this,
            )
          : this;

  Widget textButton({
    Key? key,
    bool enabled = true,
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    Color? color,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = kMinInteractiveDimensionCupertino,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
  }) =>
      CupertinoButton(
        key: key,
        padding: padding,
        color: color,
        disabledColor: disabledColor,
        minSize: minSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: enabled ? onPressed : null,
        child: this,
      );

  Widget textButtonZero({
    Key? key,
    bool enabled = true,
    EdgeInsetsGeometry? padding = EdgeInsets.zero,
    Color? color,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = 0,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
  }) =>
      CupertinoButton(
        key: key,
        padding: padding,
        color: color,
        disabledColor: disabledColor,
        minSize: minSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: enabled ? onPressed : null,
        child: this,
      );
}

extension GetDiagnosticable on Diagnosticable {
  S use<S>(S dependency,
          {String? tag,
          bool permanent = false,
          InstanceBuilderCallback<S>? builder}) =>
      Get.put<S>(dependency, tag: typeName + (tag ?? ""), permanent: permanent);
}

extension GetGlobalKey<T extends State<StatefulWidget>> on GlobalKey<T> {
  BuildContext? get context => currentContext;

  Widget? get widget => currentWidget;

  T? get state => currentState;
}

extension GetDensity on VisualDensity {
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

extension GetContext on BuildContext {
  void endEditing() {
    FocusManager.instance.primaryFocus?.unfocus();
    FocusScope.of(this).unfocus();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  void endIfEditing() {
    final focus = FocusScope.of(this);
    if (focus.hasFocus == true) {
      FocusScope.of(this).unfocus();
      SystemChannels.textInput.invokeMethod('TextInput.hide');
    }
  }

  NavigatorState get navigator => Navigator.of(this);

  RelativeRect position({Offset? offset}) {
    final _offset = offset ?? Offset.zero;
    final RenderBox widget = findRenderObject() as RenderBox;
    final RenderBox overlay =
        navigator.overlay!.context.findRenderObject() as RenderBox;
    return RelativeRect.fromRect(
      Rect.fromPoints(
        widget.localToGlobal(_offset, ancestor: overlay),
        widget.localToGlobal(
          widget.size.bottomRight(Offset.zero) + _offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  }
}

extension GetOffset on Offset {
  static Offset only({double? dx, double? dy}) => Offset(dx ?? 0, dy ?? 0);

  static Offset all(double d) => Offset(d, d);
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

extension GetShimmer on Shimmer {
  static Widget plain() => Column(children: [
        Expanded(
          child: Container(
            color: Get.theme.canvasColor,
            child: Shimmer.fromColors(
              period: 900.milliseconds,
              baseColor: Get.theme.canvasColor,
              highlightColor: Get.theme.backgroundColor,
              child: Column(children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(color: Colors.grey),
                ),
              ]),
            ),
          ),
        ),
      ]);

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
