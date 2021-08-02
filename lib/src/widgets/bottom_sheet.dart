import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class GetBottomSheet extends StatelessWidget {
  GetBottomSheet({
    this.title,
    this.content,
    this.leadingAction,
    this.topActions,
    this.bottomActions,
    this.contentPadding,
    this.minHeight,
    this.showHandle = true,
    this.centerTitle,
    this.rounded = true,
    this.isDismissible = true,
    this.fullscreen,
    this.onDismiss,
    Key? key,
  }) : super(key: key);

  final Widget? title;
  final Widget? content;
  final Widget? leadingAction;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final EdgeInsetsGeometry? contentPadding;
  final double? minHeight;
  final bool showHandle;
  final bool? centerTitle;
  final bool rounded;
  final bool isDismissible;
  final bool? fullscreen;
  final void Function(dynamic v)? onDismiss;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Clickable(
            child: Container(
              constraints: BoxConstraints.expand(height: kToolbarHeight),
              color: Colors.transparent,
            ),
            onTap: () => isDismissible ? Get.back() : null,
          ),
          Flexible(
            child: Container(
              decoration: ShapeDecoration(
                color: context.theme.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular((rounded) ? 12 : 0),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RoundedHandle(visible: showHandle),
                  if (title != null ||
                      topActions?.isNotEmpty == true ||
                      leadingAction != null)
                    AppBar(
                      automaticallyImplyLeading: false,
                      title: title,
                      backgroundColor: Colors.transparent,
                      actionsIconTheme: context.theme.iconTheme,
                      brightness: context.theme.brightness,
                      iconTheme: context.theme.iconTheme,
                      toolbarHeight: 44,
                      elevation: 0,
                      centerTitle: centerTitle,
                      textTheme: context.textTheme,
                      primary: false,
                      actions: [...(topActions ?? []), SizedBox(width: 6)],
                      leading: leadingAction,
                    ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: SafeArea(
                        top: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (content != null)
                              Padding(
                                padding: contentPadding ??
                                    EdgeInsets.symmetric(horizontal: 16),
                                child: content,
                              ),
                            if (bottomActions?.isNotEmpty == true ||
                                minHeight != null)
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8, top: 20, right: 8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(height: minHeight),
                                    if (bottomActions?.isNotEmpty == true)
                                      ...bottomActions!.expand(
                                        (element) =>
                                            [SizedBox(width: 6), element],
                                      )
                                  ],
                                ),
                              ),
                            SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      );
}

extension GetBottomSheetX on GetInterface {
  void modalBottomSheet(
    Widget Function() builder, {
    Color? backgroundColor,
    double? elevation,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? ignoreSafeArea,
    bool? fullscreen,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings? settings,
    Duration? enterBottomSheetDuration,
    Duration? exitBottomSheetDuration,
    void Function(dynamic v)? onDismiss,
    FutureOr Function()? onShow,
  }) async {
    await onShow?.call();
    final _sheet = builder();
    final _bottomSheet = $cast<GetBottomSheet>(_sheet);
    final _fullscreen = _bottomSheet?.fullscreen;
    final _isDismissible = _bottomSheet?.isDismissible;
    final _onDismiss = _bottomSheet?.onDismiss;
    bottomSheet(
      _sheet,
      backgroundColor: backgroundColor,
      elevation: elevation,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      ignoreSafeArea: ignoreSafeArea,
      isScrollControlled: _fullscreen ?? fullscreen ?? true,
      useRootNavigator: useRootNavigator,
      isDismissible: _isDismissible ?? isDismissible,
      enableDrag: enableDrag,
      settings: settings,
      enterBottomSheetDuration: enterBottomSheetDuration,
      exitBottomSheetDuration: exitBottomSheetDuration,
    ).then((value) {
      onDismiss?.call(value);
      _onDismiss?.call(value);
    });
  }
}

class RoundedHandle extends StatelessWidget {
  const RoundedHandle({
    Key? key,
    this.color,
    this.visible = true,
  }) : super(key: key);

  final Color? color;
  final bool visible;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 4,
            width: 36,
            margin: EdgeInsets.only(top: 9),
            decoration: visible == true
                ? ShapeDecoration(
                    color: (color ?? context.theme.hintColor).withAlpha(50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  )
                : null,
          ),
        ],
      );
}
