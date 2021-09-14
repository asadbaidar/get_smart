import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// A smart scaffold.
/// All individual pages should be wrapped in it.
class GetScaffold extends StatelessWidget {
  const GetScaffold({
    this.child,
    this.children,
    this.title,
    this.subtitle,
    this.customTitle,
    this.backgroundColor,
    this.titleTextStyle,
    this.centerTitle,
    this.extendBody = true,
    this.showProgress = false,
    this.showScrollbar = true,
    this.hideToolbars = false,
    this.hideAbleAppBar = false,
    this.isInteractive = true,
    this.hideAppBarLeading = false,
    this.progressBar,
    this.appBarLeading,
    this.appBarExtension,
    this.appBarExtensionSize,
    this.withBottomBar,
    this.bottomBar,
    this.bottomSheet,
    this.sliver,
    this.childrenAtFront,
    this.bottomBarLeftItems,
    this.bottomBarRightItems,
    this.bottomBarCenterItems,
    this.bottomBarChildren,
    this.appBarRightItems,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.bottomBarAlignment,
    Key? key,
  }) : _key = key as GlobalKey<ScaffoldState>?;

  final Widget? child;
  final List<Widget>? children;
  final String? title;
  final String? subtitle;
  final Widget? customTitle;
  final Color? backgroundColor;
  final TextStyle? titleTextStyle;
  final bool? centerTitle;
  final bool extendBody;
  final bool showProgress;
  final bool showScrollbar;
  final bool hideToolbars;
  final bool hideAbleAppBar;
  final bool isInteractive;
  final bool hideAppBarLeading;
  final LinearProgress? progressBar;
  final Widget? appBarLeading;
  final Widget? appBarExtension;
  final double? appBarExtensionSize;
  final Widget? withBottomBar;
  final Widget? bottomBar;
  final Widget? bottomSheet;
  final Widget? sliver;
  final List<Widget>? childrenAtFront;
  final List<Widget>? bottomBarLeftItems;
  final List<Widget>? bottomBarRightItems;
  final List<Widget>? bottomBarCenterItems;
  final List<Widget>? bottomBarChildren;
  final List<Widget>? appBarRightItems;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final CrossAxisAlignment? bottomBarAlignment;
  final GlobalKey<ScaffoldState>? _key;

  double get _progressBarHeight => progressBar?.height ?? 1;

  double get _appBarExtensionSize => (appBarExtension != null
      ? 48 + _progressBarHeight + (appBarExtensionSize ?? 0)
      : _progressBarHeight);

  @override
  Widget build(BuildContext context) {
    GetTheme.resetSystemChrome(context);
    if (!isInteractive) context.endEditing();
    return Scaffold(
      key: _key,
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      appBar: sliver != null
          ? null
          : hideAbleAppBar
              ? AppBar(
                  toolbarHeight: context.viewInsets.top.abs(),
                  elevation: hideToolbars ? context.appBarElevation : 0,
                )
              : _appBar(context),
      bottomNavigationBar: Blur(
        blur: 6,
        child: withBottomBar != null
            ? _bottomAppBar
            : CrossFade(
                firstChild: hideToolbars ? Container(height: 0) : bottomBar,
                secondChild: _bottomAppBar,
              ),
      ),
      body: hideAbleAppBar && sliver == null
          ? Column(
              children: [
                _hideAbleAppBar(context),
                Expanded(child: _body(context)),
              ],
            )
          : _body(context),
      floatingActionButton: isInteractive ? floatingActionButton : null,
      floatingActionButtonLocation: floatingActionButtonLocation ??
          (subtitle?.notBlank == null
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.endDocked),
      bottomSheet: bottomSheet,
    );
  }

  Widget get _child =>
      child ??
      ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [Responsive(children: children ?? [])],
      );

  Widget _body(BuildContext context) => Stack(children: [
        sliver ?? (showScrollbar ? Scrollbar(child: _child) : _child),
        if (!isInteractive) Clickable(),
        GetAppLifecycle(
          onDetached: Get.context?.endEditing,
          onResume: () => GetTheme.resetSystemChrome(context),
        ),
        ...childrenAtFront ?? [],
      ]);

  Widget _hideAbleAppBar(BuildContext context) => CrossFade(
        showFirst: hideToolbars,
        secondChild: SizedBox(
          height: kToolbarHeight + _appBarExtensionSize,
          child: _appBar(context),
        ),
      );

  AppBar _appBar(BuildContext context) => AppBar(
        centerTitle: _centerTitle(context),
        automaticallyImplyLeading: false,
        titleTextStyle: context.appBarTheme.titleTextStyle?.copyWith(
          fontSize: titleTextStyle?.fontSize,
          color: titleTextStyle?.color,
          fontWeight: titleTextStyle?.fontWeight,
          fontFamily: titleTextStyle?.fontFamily,
        ),
        leading: hideAppBarLeading ? null : appBarLeading ?? GetButton.back(),
        leadingWidth: 46,
        title: customTitle ??
            (title != null ? Text(title!) : Container(height: 0)),
        bottom: PreferredSize(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (appBarExtension != null) appBarExtension!,
              progressBar ?? LinearProgress(visible: showProgress),
            ],
          ),
          preferredSize: Size.fromHeight(_appBarExtensionSize),
        ),
        actions: isInteractive ? appBarRightItems : null,
      );

  bool? _centerTitle(BuildContext context) {
    if (centerTitle != null) return centerTitle;
    if (context.appBarTheme.centerTitle != null)
      return context.appBarTheme.centerTitle;
    switch (Get.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return appBarRightItems == null || appBarRightItems!.length < 2;
      default:
        return false;
    }
  }

  Widget get _bottomAppBar {
    List<Widget> _bottomBarLeft = isInteractive ? bottomBarLeftItems ?? [] : [];
    List<Widget> _bottomBarRight =
        isInteractive ? bottomBarRightItems ?? [] : [];
    List<Widget> _bottomBarCenter =
        isInteractive ? bottomBarCenterItems ?? [] : [];
    List<Widget>? _bottomBarChildren = isInteractive ? bottomBarChildren : null;
    return subtitle?.notBlank == null &&
            _bottomBarLeft.isEmpty &&
            _bottomBarRight.isEmpty &&
            _bottomBarCenter.isEmpty &&
            _bottomBarChildren == null
        ? Container(height: 0)
        : BottomBar(
            visible: !hideToolbars,
            alignment: bottomBarAlignment ??
                (subtitle?.notBlank == null
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.center),
            top: withBottomBar,
            children: _bottomBarChildren,
            left: _bottomBarLeft,
            right: _bottomBarRight,
            center: subtitle?.notBlank == null
                ? _bottomBarCenter
                : [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: AutoSizeText(
                          subtitle!,
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    )
                  ],
          );
  }

  static GlobalKey<ScaffoldState> get newKey => GlobalKey<ScaffoldState>();
}

class GetAppBar {
  static List<Widget> slivers({
    Widget? leading,
    Widget? bottom, // CupertinoSearchTextField()
    Widget? refreshSliver,
    List<Widget>? actions,
    List<Widget>? largeActions,
    LinearProgress? progress,
    Widget? customTitle,
    Widget? customLargeTitle,
    String? title,
    TextStyle? titleStyle,
    TextStyle? largeTitleStyle,
    bool largeTitle = true,
    bool floating = false,
    bool pinned = true,
    bool autoLeading = true,
    double bottomHeight = 0.0, // 36
    double largeTitleHeight = 48.0,
    double topPadding = kStandardPadding,
    double bottomPadding = kStandardPadding,
    double leftPadding = kStandardPaddingX,
    double rightPadding = kStandardPaddingX,
    double? verticalPadding,
    double? horizontalPadding,
  }) {
    if (leading == null &&
        bottom == null &&
        refreshSliver == null &&
        (actions == null || actions.isEmpty) &&
        (largeActions == null || largeActions.isEmpty) &&
        progress == null &&
        customTitle == null &&
        (customLargeTitle == null || !largeTitle) &&
        (title == null || title.isEmpty)) {
      return [];
    }
    final _topPadding = verticalPadding ?? topPadding;
    final _bottomPadding = verticalPadding ?? bottomPadding;
    final _leftPadding = horizontalPadding ?? leftPadding;
    final _rightPadding = horizontalPadding ?? rightPadding;
    final _toolbarHeight =
        Get.isIOS ? kMinInteractiveDimensionCupertino : kToolbarHeight;
    final _largeTitleHeight = largeTitleHeight;
    final _bottomHeight = (progress?.height ?? 0) +
        (bottom == null
            ? 0
            : bottomHeight + _topPadding.half.half + _bottomPadding - 2);
    return [
      SliverLayoutBuilder(
        builder: (context, constraints) {
          // $debugPrint(constraints);
          final offset = constraints.scrollOffset;
          final elevation = floating
              ? context.appBarElevation
              : ((offset * 1.01) - 48).clamp(0.0, context.appBarElevation);
          final blur = ((offset * 1.01) - 48).clamp(0.0, 6.0);
          final opacity = ((offset - 15) / 15).clamp(0.0, 1.0);
          final dy = ((offset * -1.01) + 30).clamp(0.0, 14.0);

          final iOpacity = ((25 - offset) / 25).clamp(0.0, 1.0);
          // final iDy = offset.clamp(0.0, 20.0);
          final overlapping = offset >= _largeTitleHeight;
          // $debugPrint(elevation);
          return SliverAppBar(
            leadingWidth: 40,
            titleSpacing: 8,
            automaticallyImplyLeading: false,
            leading: leading ?? (autoLeading ? GetButton.back() : null),
            backgroundColor:
                context.primaryColor.applyIf(blur > 0, (it) => it.translucent),
            title: customTitle ??
                title?.mapIt((it) => Transform.translate(
                      offset: GetOffset.only(dy: dy),
                      child: Opacity(
                        opacity: opacity /*!floating ? 0 : opacity*/,
                        child: Text(it),
                      ),
                    )),
            titleTextStyle: titleStyle,
            actions: actions,
            elevation: elevation,
            toolbarHeight: _toolbarHeight,
            // flexibleSpace: Blur(blur: blur),
            floating: floating,
            pinned: pinned,
            bottom: floating || overlapping && pinned
                ? PreferredSize(
                    child: Column(children: [
                      if (floating &&
                          (customLargeTitle != null ||
                              (title != null && largeTitle) ||
                              largeActions?.isNotEmpty == true))
                        SizedBox(
                          height: _largeTitleHeight * iOpacity,
                          child: Opacity(
                            opacity: iOpacity,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                left: _leftPadding,
                                right: _rightPadding,
                                bottom: _bottomPadding.half,
                              ),
                              child: Row(
                                children: [
                                  if (customLargeTitle != null)
                                    customLargeTitle,
                                  if (customLargeTitle == null &&
                                      title != null &&
                                      largeTitle)
                                    AutoSizeText(
                                      title,
                                      textAlign: TextAlign.start,
                                      minFontSize: iOpacity < 1 ? 30 : 12,
                                      style: largeTitleStyle ??
                                          context.headline5?.copyWith(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ...largeActions ?? [],
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (bottom != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: _topPadding.half.half,
                            bottom: _bottomPadding - 2,
                            left: _leftPadding,
                            right: _rightPadding,
                          ),
                          child: bottom,
                        ),
                      if (progress != null && (!floating || overlapping))
                        progress,
                    ]),
                    preferredSize: Size.fromHeight(
                      _bottomHeight +
                          (floating ? _largeTitleHeight * iOpacity : 0.0),
                    ),
                  )
                : null,
          );
        },
      ),
      if (refreshSliver != null) refreshSliver,
      SliverLayoutBuilder(
        builder: (context, constraints) {
          // $debugPrint(constraints);
          final offset = constraints.scrollOffset == 0
              ? constraints.overlap
              : constraints.scrollOffset;
          final opacity = ((25 - offset) / 25).clamp(0.0, 1.0);
          final dy = offset.clamp(0.0, 20.0);
          final overlapping = constraints.overlap >= _largeTitleHeight;
          // $debugPrint(offset);
          return SliverToBoxAdapter(
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Material(
                  color: context.primaryColor,
                  shadowColor: context.appBarShadowColor,
                  elevation: context.appBarElevation * 0.8,
                  child: floating
                      ? Container(
                          color: Colors.transparent,
                          height: context.appBarElevation + 0.5,
                        )
                      : Container(
                          padding: EdgeInsets.only(
                            left: _leftPadding,
                            right: _rightPadding,
                            bottom: _bottomPadding.half,
                          ),
                          child: Column(
                            children: [
                              if (customLargeTitle != null ||
                                  (title != null && largeTitle) ||
                                  largeActions?.isNotEmpty == true)
                                Transform.translate(
                                  offset: GetOffset.only(dy: -dy),
                                  child: Opacity(
                                    opacity: opacity,
                                    child: Padding(
                                      padding: EdgeInsets.only(top: 6),
                                      child: Row(
                                        children: [
                                          if (customLargeTitle != null)
                                            customLargeTitle,
                                          if (customLargeTitle == null &&
                                              title != null &&
                                              largeTitle)
                                            AutoSizeText(
                                              title,
                                              textAlign: TextAlign.start,
                                              style: largeTitleStyle ??
                                                  context.headline5?.copyWith(
                                                    fontSize: 30,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ...largeActions ?? [],
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              if (!overlapping && bottom != null)
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: _topPadding.half,
                                    bottom: _bottomPadding.half,
                                  ),
                                  child: bottom,
                                ),
                            ],
                          ),
                        ),
                ),
                if (!overlapping && progress != null) progress,
              ],
            ),
          );
        },
      ),
    ];
  }
}
