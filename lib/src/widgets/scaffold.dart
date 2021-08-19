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

/*

    NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            title: Text("Hello"),
            floating: true,
            forceElevated: innerBoxIsScrolled,
          ),
        ];
      },
      body: PageView.builder(
        itemCount: pages.length,
        itemBuilder: (context, index) => Container(height: 0),
      ),
    );

*/
