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

  Widget get sliverFill => SliverFillRemaining(child: this);

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

  Widget clipRect({
    Key? key,
    bool clip = true,
    bool oval = false,
    BorderRadius? borderRadius,
    Clip clipBehavior = Clip.antiAlias,
  }) =>
      clip
          ? oval
              ? ClipOval(
                  key: key,
                  clipBehavior: clipBehavior,
                  child: this,
                )
              : ClipRRect(
                  key: key,
                  borderRadius: borderRadius,
                  clipBehavior: clipBehavior,
                  child: this,
                )
          : this;

  Widget row({
    Key? key,
    bool enabled = true,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> before = const [],
    List<Widget> after = const [],
  }) =>
      enabled
          ? Row(
              key: key,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: crossAxisAlignment,
              verticalDirection: verticalDirection,
              textBaseline: textBaseline,
              children: [...before, this, ...after],
            )
          : this;

  Widget column({
    Key? key,
    bool enabled = true,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> before = const [],
    List<Widget> after = const [],
  }) =>
      enabled
          ? Column(
              key: key,
              mainAxisAlignment: mainAxisAlignment,
              mainAxisSize: mainAxisSize,
              crossAxisAlignment: crossAxisAlignment,
              verticalDirection: verticalDirection,
              textBaseline: textBaseline,
              children: [...before, this, ...after],
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

  Widget sizedBox(
    double? size, {
    Key? key,
    Alignment? alignment,
  }) =>
      Container(
        alignment: alignment,
        width: size,
        height: size,
        child: this,
      );

  Widget sizedCenter(
    double? size, {
    Key? key,
  }) =>
      sizedBox(
        size,
        key: key,
        alignment: Alignment.center,
      );

  Widget material({
    Key? key,
    MaterialType type = MaterialType.transparency,
    double elevation = 0.0,
    Color? color,
    Color? shadowColor,
    TextStyle? textStyle,
    BorderRadiusGeometry? borderRadius,
    ShapeBorder? shape,
    bool borderOnForeground = true,
    Clip clipBehavior = Clip.none,
    Duration animationDuration = kThemeChangeDuration,
  }) =>
      Material(
        child: this,
        key: key,
        type: type,
        elevation: elevation,
        color: color,
        shadowColor: shadowColor,
        textStyle: textStyle,
        borderRadius: borderRadius,
        shape: shape,
        borderOnForeground: borderOnForeground,
        clipBehavior: clipBehavior,
        animationDuration: animationDuration,
      );

  Widget plainButton({
    Key? key,
    bool enabled = true,
    bool primary = false,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    double? topPadding,
    double? bottomPadding,
    double? leftPadding,
    double? rightPadding,
    Color? color,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = kMinInteractiveDimensionCupertino,
    double? iconSize,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
  }) =>
      GetButton.plain(
        key: key,
        enabled: enabled,
        primary: primary,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        color: color,
        disabledColor: disabledColor,
        minSize: minSize,
        iconSize: iconSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: onPressed,
        child: this,
      );

  Widget plainButtonZero({
    Key? key,
    bool enabled = true,
    bool primary = false,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    double? topPadding,
    double? bottomPadding,
    double? leftPadding,
    double? rightPadding,
    Color? color,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = 0,
    double? iconSize,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
  }) =>
      plainButton(
        key: key,
        enabled: enabled,
        primary: primary,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        color: color,
        disabledColor: disabledColor,
        minSize: minSize,
        iconSize: iconSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: onPressed,
      );

  Widget plainButtonMini({
    Key? key,
    bool enabled = true,
    bool primary = false,
    EdgeInsetsGeometry? padding,
    double? horizontalPadding,
    double? verticalPadding,
    double? topPadding,
    double? bottomPadding,
    double? leftPadding = 12,
    double? rightPadding = 12,
    Color? color,
    Color disabledColor = CupertinoColors.quaternarySystemFill,
    double? minSize = 0,
    double? iconSize = 20,
    double? pressedOpacity = 0.4,
    BorderRadius? borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    AlignmentGeometry alignment = Alignment.center,
    VoidCallback? onPressed,
  }) =>
      plainButton(
        key: key,
        enabled: enabled,
        primary: primary,
        padding: padding,
        horizontalPadding: horizontalPadding,
        verticalPadding: verticalPadding,
        topPadding: topPadding,
        bottomPadding: bottomPadding,
        leftPadding: leftPadding,
        rightPadding: rightPadding,
        color: color,
        disabledColor: disabledColor,
        minSize: minSize,
        iconSize: iconSize,
        pressedOpacity: pressedOpacity,
        borderRadius: borderRadius,
        alignment: alignment,
        onPressed: onPressed,
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

extension NumSpace on num {
  Widget get spaceX => Space.x(toDouble());

  Widget get spaceY => Space.y(toDouble());

  Widget get space => Space.all(toDouble());
}

extension GetBoxDecoration on BoxDecoration {
  static BoxDecoration only(
    BuildContext context, {
    double? top,
    double? bottom,
    double? left,
    double? right,
    Color? color,
    Color? borderColor,
    double? borderRadius,
  }) {
    final _borderColor = borderColor ?? context.hintColor.dimmed;
    return BoxDecoration(
      color: color ?? context.backgroundColor,
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

  static BoxDecoration symmetric(
    BuildContext context, {
    double? vertical,
    double? horizontal,
    Color? color,
    Color? borderColor,
    double? borderRadius,
  }) =>
      only(
        context,
        top: vertical,
        bottom: vertical,
        left: horizontal,
        right: horizontal,
        color: color,
        borderColor: borderColor,
        borderRadius: borderRadius,
      );

  static BoxDecoration all(
    BuildContext context, {
    double? border,
    Color? color,
    Color? borderColor,
    double? borderRadius,
  }) =>
      symmetric(
        context,
        vertical: border,
        horizontal: border,
        color: color,
        borderColor: borderColor,
        borderRadius: borderRadius,
      );
}

extension GetShimmer on Shimmer {
  static Widget plain() => ThemeBuilder((context) => Column(children: [
        Expanded(
          child: Container(
            color: context.canvasColor,
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Shimmer.fromColors(
                period: 900.milliseconds,
                baseColor: context.canvasColor,
                highlightColor: context.backgroundColor,
                child: Column(children: [
                  Container(
                    height: Get.mediaQuery.size.height,
                    color: Colors.grey,
                  ),
                ]),
              ),
            ),
          ),
        ),
      ]));

  static Widget custom(WidgetBuilder builder) =>
      ThemeBuilder((context) => Container(
            color: context.backgroundColor,
            child: Shimmer.fromColors(
              baseColor: context.highlightColor,
              highlightColor: context.canvasColor,
              child: builder(context),
            ),
          ));

  static Widget tileOvalLeading({
    String? title,
    String? subtitle,
    bool leading = true,
    double topPadding = kMediumPaddingY,
  }) =>
      tile(
        title: title,
        subtitle: subtitle,
        leading: leading,
        leadingOval: true,
        topPadding: topPadding,
      );

  static Widget tile({
    String? title,
    String? subtitle,
    bool leading = true,
    bool leadingOval = false,
    double topPadding = kMediumPaddingY,
  }) =>
      custom((context) => GetTile.medium(
          leading: leading ? 24.space : null,
          leadingOval: leadingOval,
          topPadding: topPadding + topPadding.half,
          titleChild: title?.mapIt((it) => Container(
                color: Colors.grey,
                child: Text(it, style: context.overline),
              )),
          verticalSpacing: 8,
          subtitleChild: subtitle?.mapIt(
            (it) => Container(
              color: Colors.grey,
              child: Text(it, style: context.overline),
            ),
          )));

  static Widget article() => ThemeBuilder((context) => Column(children: [
        Expanded(
          child: Container(
            color: context.backgroundColor,
            padding: EdgeInsets.all(24),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Shimmer.fromColors(
                baseColor: context.highlightColor.withOpacity(0.3),
                highlightColor: context.highlightColor.withOpacity(0.2),
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
      ]));

  static Widget dark() => Column(children: [
        Expanded(
          child: Container(
            color: GetColors.black93,
            padding: EdgeInsets.only(top: 4),
            child: SingleChildScrollView(
              physics: NeverScrollableScrollPhysics(),
              child: Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: GetColors.black93,
                child: Column(children: [
                  Container(
                    color: Colors.grey,
                    margin: EdgeInsets.symmetric(horizontal: 30),
                    constraints: BoxConstraints.expand(height: 18),
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
