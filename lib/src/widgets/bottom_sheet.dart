import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class GetBottomSheet extends StatelessWidget {
  const GetBottomSheet({
    this.title,
    this.content,
    this.leadingAction,
    this.topActions,
    this.bottomActions,
    this.contentPadding,
    this.minHeight,
    this.showHandle = true,
    this.centerTitle,
    Key key,
  }) : super(key: key);

  final Widget title;
  final Widget content;
  final Widget leadingAction;
  final List<Widget> topActions;
  final List<Widget> bottomActions;
  final EdgeInsetsGeometry contentPadding;
  final double minHeight;
  final bool showHandle;
  final bool centerTitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: ShapeDecoration(
        color: context.theme.backgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) RoundedHandle() else SizedBox(height: 6),
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
              actions: topActions,
              leading: leadingAction,
            ),
          Column(children: [
            if (content != null)
              Padding(
                padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
                child: content,
              ),
            if (bottomActions?.isNotEmpty == true || minHeight != null)
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 20, right: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SizedBox(height: minHeight),
                    if (bottomActions?.isNotEmpty == true)
                      ...bottomActions.expand(
                        (element) => [SizedBox(width: 6), element],
                      )
                  ],
                ),
              ),
            SizedBox(height: 16),
          ]),
        ],
      ),
    );
  }
}

extension GetBottomSheetX on GetInterface {
  void modalBottomSheet(
    Widget sheet, {
    Color backgroundColor,
    double elevation,
    Clip clipBehavior,
    Color barrierColor,
    bool ignoreSafeArea,
    bool isScrollControlled = false,
    bool useRootNavigator = false,
    bool isDismissible = true,
    bool enableDrag = true,
    RouteSettings settings,
    Duration enterBottomSheetDuration,
    Duration exitBottomSheetDuration,
    void Function(dynamic v) onDismiss,
    FutureOr Function() onShow,
  }) async {
    await onShow?.call();
    bottomSheet(
      sheet,
      backgroundColor: backgroundColor,
      elevation: elevation,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      ignoreSafeArea: ignoreSafeArea,
      isScrollControlled: isScrollControlled,
      useRootNavigator: useRootNavigator,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      settings: settings,
      enterBottomSheetDuration: enterBottomSheetDuration,
      exitBottomSheetDuration: exitBottomSheetDuration,
    ).then((value) {
      onDismiss?.call(value);
    });
  }
}

class RoundedHandle extends StatelessWidget {
  const RoundedHandle({Key key, this.color}) : super(key: key);

  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 4,
            width: 34,
            margin: EdgeInsets.only(top: 9),
            decoration: ShapeDecoration(
              color: (color ?? context.theme.hintColor).withAlpha(50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4)),
              ),
            ),
          ),
        ],
      );
}
