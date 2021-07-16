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
    this.appBarRightItems,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
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
  final List<Widget>? appBarRightItems;
  final FloatingActionButton? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final GlobalKey<ScaffoldState>? _key;

  bool get _isInteractive => isInteractive == true;

  double get _progressBarHeight => progressBar?.height ?? 1;

  double get _appBarExtensionSize => (appBarExtension != null
      ? kToolbarHeight + _progressBarHeight + (appBarExtensionSize ?? 0)
      : _progressBarHeight);

  @override
  Widget build(BuildContext context) {
    GetTheme.resetSystemChrome(context);
    if (!_isInteractive) context.endEditing();
    return Scaffold(
      key: _key,
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      appBar: sliver != null
          ? null
          : hideAbleAppBar == true
              ? AppBar(
                  toolbarHeight: Get.mediaQuery.viewInsets.top.abs(),
                  elevation: hideToolbars ? Get.theme.appBarTheme.elevation : 0,
                )
              : _appBar,
      bottomNavigationBar: withBottomBar != null
          ? _bottomAppBar
          : CrossFade(
              firstChild: hideToolbars ? Container(height: 0) : bottomBar,
              secondChild: _bottomAppBar,
            ),
      body: hideAbleAppBar == true && sliver == null
          ? Column(
              children: [
                _hideAbleAppBar,
                Expanded(child: _body),
              ],
            )
          : _body,
      floatingActionButton: _isInteractive ? floatingActionButton : null,
      floatingActionButtonLocation: floatingActionButtonLocation ??
          (subtitle?.isBlank ?? true
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

  Widget get _body => Stack(children: [
        sliver ?? (showScrollbar == true ? Scrollbar(child: _child) : _child),
        if (!_isInteractive) Clickable(),
        GetAppLifecycle(
          onDetached: Get.context!.endEditing,
          onResume: () => GetTheme.resetSystemChrome(Get.context),
        ),
        ...childrenAtFront ?? [],
      ]);

  Widget get _hideAbleAppBar => CrossFade(
        showFirst: hideToolbars,
        secondChild: SizedBox(
          height: kToolbarHeight + _appBarExtensionSize,
          child: _appBar,
        ),
      );

  AppBar get _appBar => AppBar(
        centerTitle: _centerTitle,
        automaticallyImplyLeading: false,
        leading: hideAppBarLeading == true
            ? null
            : appBarLeading ?? GetButton.back(),
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
        actions: _isInteractive ? appBarRightItems : null,
      );

  Widget get _bottomAppBar {
    List<Widget> _bottomBarLeftItems =
        _isInteractive ? bottomBarLeftItems ?? [] : [];
    List<Widget> _bottomBarRightItems =
        _isInteractive ? bottomBarRightItems ?? [] : [];
    List<Widget> _bottomBarCenterItems =
        _isInteractive ? bottomBarCenterItems ?? [] : [];
    return (subtitle?.isBlank ?? true) &&
            _bottomBarLeftItems.isBlank! &&
            _bottomBarRightItems.isBlank! &&
            _bottomBarCenterItems.isBlank!
        ? Container(height: 0)
        : BottomBar(
            visible: !hideToolbars,
            topChild: withBottomBar,
            leftItems: _bottomBarLeftItems,
            rightItems: _bottomBarRightItems,
            centerItems: subtitle?.isBlank ?? true
                ? _bottomBarCenterItems
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

  bool? get _centerTitle {
    if (centerTitle != null) return centerTitle;
    if (customTitle != null) return true;
    if (Get.theme.appBarTheme.centerTitle != null)
      return Get.theme.appBarTheme.centerTitle;
    switch (Get.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return appBarRightItems == null || appBarRightItems!.length < 2;
      default:
        return false;
    }
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
