import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class GetBottomSheet extends StatelessWidget {
  static const kEdgePadding = 6.0;

  const GetBottomSheet({
    this.title,
    this.content,
    this.itemBuilder,
    this.items,
    this.headerBuilder,
    this.footerBuilder,
    this.sectionBuilder,
    this.section,
    this.leadingAction,
    this.topActions,
    this.bottomActions,
    this.physics = const AlwaysBouncingScrollPhysics(),
    this.divider,
    this.contentPadding,
    this.minHeight,
    this.itemCount,
    this.showHandle = true,
    this.centerTitle,
    this.rounded = true,
    this.dismissible = true,
    Key? key,
  }) : super(key: key);

  final Widget? title;
  final Widget? content;
  final GetItemBuilder? itemBuilder;
  final List? items;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final GetSectionBuilder? sectionBuilder;
  final GetSection? section;
  final Widget? leadingAction;
  final List<Widget>? topActions;
  final List<Widget>? bottomActions;
  final ScrollPhysics? physics;
  final DividerStyle? divider;
  final EdgeInsetsGeometry? contentPadding;
  final int? itemCount;
  final double? minHeight;
  final bool showHandle;
  final bool? centerTitle;
  final bool rounded;
  final bool dismissible;

  int? get _itemCount => itemCount ?? (content != null ? 1 : null);

  GetItemBuilder get _itemBuilder => itemBuilder ?? (_, __) => content!;

  bool get showLeading => leadingAction != null;

  bool get showToolbar =>
      title != null || topActions?.isNotEmpty == true || leadingAction != null;

  ShapeBorder get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular((rounded) ? 12 : 0),
        ),
      );

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        builder: (context, scrollController) => Material(
          color: context.backgroundColor,
          shape: shape,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RoundedHandle(visible: showHandle),
              Expanded(
                child: GetListView.builder(
                  controller: scrollController,
                  physics: physics,
                  padding: contentPadding ??
                      (itemBuilder != null ? null : kStandardPaddingH),
                  edgeDivider: DividerStyle.none,
                  divider: divider,
                  topSliverBuilder: showToolbar
                      ? (context) => GetAppBar.sliver(
                            customTitle: title,
                            actions: [
                              ...(topActions ?? []),
                              kEdgePadding.spaceX
                            ],
                            toolbarHeight: kMinInteractiveDimension,
                            elevation: 0.5,
                            elevateAlways: false,
                            translucent: false,
                            largeTitle: false,
                            backgroundColor: context.backgroundColor,
                            centerTitle: showLeading ? true : centerTitle,
                            showLeading: showLeading,
                            leading:
                                leadingAction?.paddingOnly(left: kEdgePadding),
                          )
                      : null,
                  items: items,
                  itemCount: _itemCount,
                  itemBuilder: _itemBuilder,
                  headerBuilder: headerBuilder,
                  footerBuilder: footerBuilder,
                  sectionBuilder: sectionBuilder,
                  section: section,
                ),
              ),
              if (bottomActions?.isNotEmpty == true || minHeight != null)
                Padding(
                  padding: kDensePaddingAll,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: minHeight),
                      if (bottomActions?.isNotEmpty == true)
                        ...bottomActions!.expand(
                          (e) => [kEdgePadding.spaceX, e],
                        )
                    ],
                  ),
                ),
            ],
          ),
        ),
      );
}

extension GetBottomSheetX on GetInterface {
  void bottomSheetHalf(
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? ignoreSafeArea,
    bool fullscreen = false,
    bool useRootNavigator = false,
    bool dismissible = true,
    bool enableDrag = true,
    RouteSettings? settings,
    Duration? enterDuration,
    Duration? exitDuration,
    void Function(dynamic v)? onDismiss,
    FutureOr Function()? onShow,
  }) async {
    await onShow?.call();
    bottomSheet(
      ThemeBuilder(builder),
      backgroundColor: backgroundColor,
      elevation: elevation,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      ignoreSafeArea: ignoreSafeArea,
      isScrollControlled: fullscreen,
      useRootNavigator: useRootNavigator,
      isDismissible: dismissible,
      enableDrag: enableDrag,
      settings: settings,
      enterBottomSheetDuration: enterDuration,
      exitBottomSheetDuration: exitDuration,
    ).then((value) => onDismiss?.call(value));
  }

  void bottomSheetFull(
    WidgetBuilder builder, {
    Color? backgroundColor,
    double? elevation,
    Clip? clipBehavior,
    Color? barrierColor,
    bool? ignoreSafeArea,
    bool fullscreen = true,
    bool useRootNavigator = false,
    bool dismissible = true,
    bool enableDrag = true,
    RouteSettings? settings,
    Duration? enterDuration,
    Duration? exitDuration,
    void Function(dynamic v)? onDismiss,
    FutureOr Function()? onShow,
  }) {
    bottomSheetHalf(
      builder,
      backgroundColor: backgroundColor,
      elevation: elevation,
      clipBehavior: clipBehavior,
      barrierColor: barrierColor,
      ignoreSafeArea: ignoreSafeArea,
      fullscreen: fullscreen,
      useRootNavigator: useRootNavigator,
      dismissible: dismissible,
      enableDrag: enableDrag,
      settings: settings,
      enterDuration: enterDuration,
      exitDuration: exitDuration,
      onDismiss: onDismiss,
      onShow: onShow,
    );
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
            margin: const EdgeInsets.only(top: 9, bottom: 11),
            decoration: visible == true
                ? ShapeDecoration(
                    color: (color ?? context.hintColor).withAlpha(50),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                  )
                : null,
          ),
        ],
      );
}
