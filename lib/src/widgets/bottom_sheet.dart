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
    Key key,
  }) : super(key: key);

  final Widget title;
  final Widget content;
  final Widget leadingAction;
  final List<Widget> topActions;
  final List<Widget> bottomActions;
  final EdgeInsetsGeometry contentPadding;
  final double minHeight;

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
          AppBar(
            automaticallyImplyLeading: false,
            title: title,
            backgroundColor: Colors.transparent,
            actionsIconTheme: context.theme.iconTheme,
            brightness: context.theme.brightness,
            iconTheme: context.theme.iconTheme,
            elevation: 0,
            textTheme: context.textTheme,
            primary: false,
            actions: topActions,
            leading: leadingAction,
          ),
          Column(children: [
            Padding(
              padding: contentPadding ?? EdgeInsets.symmetric(horizontal: 16),
              child: content,
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8),
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
            SizedBox(height: 8),
          ]),
        ],
      ),
    );
  }
}

extension GetBottomSheetX on GetInterface {
  void modalBottomSheet(
    Widget bottomsheet, {
    Color backgroundColor,
    double elevation,
    bool persistent = true,
    ShapeBorder shape,
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
      bottomsheet,
      backgroundColor: backgroundColor,
      elevation: elevation,
      persistent: persistent,
      shape: shape,
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
