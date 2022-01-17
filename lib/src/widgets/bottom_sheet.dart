import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

class GetBottomSheet extends StatelessWidget {
  static const kEdgePadding = 6.0;

  const GetBottomSheet({
    this.customTitle,
    this.title,
    this.message,
    this.content,
    this.action,
    this.onAction,
    this.itemBuilder,
    this.items,
    this.headerBuilder,
    this.footerBuilder,
    this.sectionBuilder,
    this.section,
    this.leadingAction,
    this.actions,
    this.bottomActions,
    this.physics = const AlwaysBouncingScrollPhysics(),
    this.divider,
    this.contentPadding,
    this.initialSize = 0.6,
    this.maxSize = 1.0,
    this.itemCount,
    this.showHandle = true,
    this.centerTitle,
    this.autoImplyLeading = true,
    this.rounded = true,
    this.dismissOnDone = false,
    this.busy = false,
    this.textController,
    this.textLabel,
    this.autofocus = false,
    this.maxInput,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.textValidator,
    this.onTextChanged,
    this.onTextSubmitted,
    Key? key,
  }) : super(key: key);

  const GetBottomSheet.mid({
    this.customTitle,
    this.title,
    this.message,
    this.content,
    this.action,
    this.onAction,
    this.itemBuilder,
    this.items,
    this.headerBuilder,
    this.footerBuilder,
    this.sectionBuilder,
    this.section,
    this.leadingAction,
    this.actions,
    this.bottomActions,
    this.physics = const AlwaysBouncingScrollPhysics(),
    this.divider,
    this.contentPadding,
    this.initialSize = 0.5,
    this.maxSize = 1.0,
    this.itemCount,
    this.showHandle = true,
    this.centerTitle,
    this.autoImplyLeading = true,
    this.rounded = true,
    this.dismissOnDone = false,
    this.busy = false,
    this.textController,
    this.textLabel,
    this.autofocus = false,
    this.maxInput,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.textValidator,
    this.onTextChanged,
    this.onTextSubmitted,
    Key? key,
  }) : super(key: key);

  const GetBottomSheet.max({
    this.customTitle,
    this.title,
    this.message,
    this.content,
    this.action,
    this.onAction,
    this.itemBuilder,
    this.items,
    this.headerBuilder,
    this.footerBuilder,
    this.sectionBuilder,
    this.section,
    this.leadingAction,
    this.actions,
    this.bottomActions,
    this.physics = const AlwaysBouncingScrollPhysics(),
    this.divider,
    this.contentPadding,
    this.initialSize = 1.0,
    this.maxSize = 1.0,
    this.itemCount,
    this.showHandle = true,
    this.centerTitle,
    this.autoImplyLeading = true,
    this.rounded = true,
    this.dismissOnDone = false,
    this.busy = false,
    this.textController,
    this.textLabel,
    this.autofocus = false,
    this.maxInput,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.textValidator,
    this.onTextChanged,
    this.onTextSubmitted,
    Key? key,
  }) : super(key: key);

  const GetBottomSheet.text({
    this.customTitle,
    this.title,
    this.message,
    this.content,
    this.action,
    this.onAction,
    this.itemBuilder,
    this.items,
    this.headerBuilder,
    this.footerBuilder,
    this.sectionBuilder,
    this.section,
    this.leadingAction,
    this.actions,
    this.bottomActions,
    this.physics = const AlwaysBouncingScrollPhysics(),
    this.divider,
    this.contentPadding,
    this.initialSize = 0.6,
    this.maxSize = 1.0,
    this.itemCount,
    this.showHandle = true,
    this.centerTitle,
    this.autoImplyLeading = true,
    this.rounded = true,
    this.dismissOnDone = false,
    this.busy = false,
    required TextEditingController this.textController,
    this.textLabel,
    this.autofocus = true,
    this.maxInput,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction = TextInputAction.done,
    this.textValidator,
    this.onTextChanged,
    this.onTextSubmitted,
    Key? key,
  }) : super(key: key);

  final Widget? customTitle;
  final String? title;
  final String? message;
  final Widget? content;
  final String? action;
  final VoidCallback? onAction;
  final GetItemBuilder? itemBuilder;
  final List? items;
  final WidgetBuilder? headerBuilder;
  final WidgetBuilder? footerBuilder;
  final GetSectionBuilder? sectionBuilder;
  final GetSection? section;
  final Widget? leadingAction;
  final List<Widget>? actions;
  final List<Widget>? bottomActions;
  final ScrollPhysics? physics;
  final DividerStyle? divider;
  final EdgeInsetsGeometry? contentPadding;
  final int? itemCount;
  final double initialSize;
  final double maxSize;
  final bool showHandle;
  final bool? centerTitle;
  final bool autoImplyLeading;
  final bool rounded;
  final bool dismissOnDone;
  final bool busy;

  // TextField options
  final TextEditingController? textController;
  final String? textLabel;
  final OnStringCallback<String?>? textValidator;
  final bool autofocus;
  final int? maxInput;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final OnString? onTextChanged;
  final OnString? onTextSubmitted;

  void _onTextSubmitted([String? v]) async {
    onTextChanged?.call(v ?? "");
    if (v == null || v.isNotEmpty && textValidator?.call(v) == null) {
      onTextSubmitted?.call(v ?? "");
      if (dismissOnDone) Get.back();
    }
  }

  Widget _action({bool enabled = true}) => textController != null
      ? GetButton.text(
          enabled: enabled,
          busy: busy,
          child: Text(action!),
          onPressed: () => _onTextSubmitted(textController?.text),
        )
      : GetButton.text(
          busy: busy,
          back: dismissOnDone,
          child: Text(action!),
          onPressed: onAction,
        );

  List<Widget> get _actions => [
        ...?actions,
        if (action != null)
          if (textController != null)
            TextValueBuilder(
              value: textController!,
              builder: (_, v) => _action(enabled: v.text.isNotEmpty),
            )
          else
            _action(),
        kEdgePadding.spaceX
      ];

  Widget _contentBuilder(BuildContext context, data) =>
      message?.mapIt((it) => Padding(
            padding: kStandardPaddingV,
            child: Text(
              message!,
              style: context.subtitle1,
            ),
          )) ??
      textController?.mapIt((it) => GetTextField(
            readOnly: busy,
            controller: it,
            label: textLabel,
            validator: textValidator,
            onChanged: onTextChanged,
            onSubmitted: _onTextSubmitted,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            autofocus: autofocus,
            enableSuggestions: false,
            validateEmpty: true,
            maxLength: maxInput,
          )) ??
      content!;

  bool get _hasContent =>
      message != null || textController != null || content != null;

  int? get _itemCount => itemCount ?? (_hasContent ? 1 : null);

  GetItemBuilder get _itemBuilder => itemBuilder ?? _contentBuilder;

  bool get customLeading => leadingAction != null;

  Widget? get _leadingAction =>
      leadingAction?.paddingOnly(left: kEdgePadding) ??
      (autoImplyLeading ? GetButton.back(icon: CupertinoIcons.xmark) : null);

  bool get showToolbar =>
      title?.isNotEmpty == true ||
      customTitle != null ||
      action?.isNotEmpty == true ||
      actions?.isNotEmpty == true ||
      leadingAction != null;

  ShapeBorder get shape => RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular((rounded) ? 12 : 0),
        ),
      );

  @override
  Widget build(BuildContext context) => DraggableScrollableSheet(
        initialChildSize: initialSize,
        maxChildSize: maxSize,
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
                            customTitle: customTitle,
                            title: title,
                            actions: _actions,
                            toolbarHeight: kMinInteractiveDimension,
                            elevation: 0.5,
                            elevateAlways: false,
                            translucent: false,
                            largeTitle: false,
                            showProgress: busy,
                            backgroundColor: context.backgroundColor,
                            centerTitle: customLeading ? true : centerTitle,
                            showLeading: customLeading || autoImplyLeading,
                            leadingWidth: autoImplyLeading ? 44 : null,
                            leading: _leadingAction,
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
              if (bottomActions?.isNotEmpty == true)
                Padding(
                  padding: kDensePaddingAll,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: bottomActions!
                        .expand((e) => [kEdgePadding.spaceX, e])
                        .toList(),
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
