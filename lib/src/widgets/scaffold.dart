import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// A smart scaffold.
/// All individual pages should be wrapped in it.
class GetScaffold extends StatelessWidget {
  const GetScaffold({
    this.child,
    this.children,
    this.progress,
    this.appBar,
    this.customTitle,
    this.title,
    this.subtitle,
    this.appBarLeading,
    this.appBarBottom,
    this.withBottomBar,
    this.bottomBar,
    this.bottomSheet,
    this.sliver,
    this.childrenAtFront,
    this.bottomBarLeftItems,
    this.bottomBarRightItems,
    this.bottomBarCenterItems,
    this.bottomBarChildren,
    this.appBarActions,
    this.floatingActionButton,
    this.backgroundColor,
    this.titleStyle,
    this.centerTitle,
    this.extendBody = true,
    this.showAppBarLeading = true,
    this.showProgress = false,
    this.showScrollbar = true,
    this.hideToolbars = false,
    this.hideAbleAppBar = false,
    this.interactive = true,
    this.appBarBottomHeight = 0.0,
    this.floatingActionButtonLocation,
    this.bottomBarAlignment,
    Key? key,
  })  : _key = key,
        super(key: null);

  final Widget? child;
  final List<Widget>? children;
  final LinearProgress? progress;
  final dynamic appBar;
  final Widget? customTitle;
  final String? title;
  final String? subtitle;
  final Widget? appBarLeading;
  final Widget? appBarBottom;
  final Widget? withBottomBar;
  final Widget? bottomBar;
  final Widget? bottomSheet;
  final Widget? sliver;
  final List<Widget>? childrenAtFront;
  final List<Widget>? bottomBarLeftItems;
  final List<Widget>? bottomBarRightItems;
  final List<Widget>? bottomBarCenterItems;
  final List<Widget>? bottomBarChildren;
  final List<Widget>? appBarActions;
  final FloatingActionButton? floatingActionButton;
  final Color? backgroundColor;
  final TextStyle? titleStyle;
  final bool? centerTitle;
  final bool extendBody;
  final bool showAppBarLeading;
  final bool showProgress;
  final bool showScrollbar;
  final bool hideToolbars;
  final bool hideAbleAppBar;
  final bool interactive;
  final double appBarBottomHeight;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final CrossAxisAlignment? bottomBarAlignment;
  final Key? _key;

  @override
  Widget build(BuildContext context) {
    GetTheme.resetSystemChrome(context);
    if (!interactive) context.endEditing();
    return Scaffold(
      key: _key,
      extendBody: extendBody,
      backgroundColor: backgroundColor,
      appBar: _appBar(context),
      bottomNavigationBar: _bottomBar(context),
      body: _body(context),
      floatingActionButton: interactive ? floatingActionButton : null,
      floatingActionButtonLocation: floatingActionButtonLocation ??
          (subtitle?.notBlank == null
              ? FloatingActionButtonLocation.endFloat
              : FloatingActionButtonLocation.endDocked),
      bottomSheet: bottomSheet,
    );
  }

  Widget _body(BuildContext context) => hideAbleAppBar && sliver == null
      ? Column(
          children: [
            _hideAbleAppBar(context),
            Expanded(child: _buildBody(context)),
          ],
        )
      : _buildBody(context);

  Widget _buildBody(BuildContext context) => Stack(children: [
        sliver ?? (showScrollbar ? Scrollbar(child: _child) : _child),
        if (!interactive) Clickable(),
        GetAppLifecycle(
          onDetached: Get.context?.endEditing,
          onResume: () => GetTheme.resetSystemChrome(context),
        ),
        ...childrenAtFront ?? [],
      ]);

  Widget get _child =>
      child ??
      ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [Responsive(children: children ?? [])],
      );

  Widget _hideAbleAppBar(BuildContext context) {
    final appBar = _buildAppBar(context);
    return CrossFade(
      showFirst: hideToolbars,
      secondChild: SizedBox(
        height: appBar.preferredSize.height,
        child: appBar,
      ),
    );
  }

  GetSimpleAppBar? _appBar(BuildContext context) => sliver != null
      ? null
      : hideAbleAppBar
          ? GetAppBar.status(context, hidden: hideToolbars)
          : _buildAppBar(context);

  GetSimpleAppBar _buildAppBar(BuildContext context) =>
      appBar != null && appBar is GetSimpleAppBar
          ? appBar
          : GetAppBar.simple(
              leading: appBarLeading,
              bottom: appBarBottom,
              actions: appBarActions,
              progress: progress,
              customTitle: customTitle,
              title: title,
              titleStyle: titleStyle,
              centerTitle: centerTitle,
              interactive: interactive,
              showLeading: showAppBarLeading,
              showProgress: showProgress,
              bottomHeight: appBarBottomHeight,
            );

  Widget _bottomBar(BuildContext context) => Blur(
        blur: 6,
        child: withBottomBar != null
            ? _bottomAppBar
            : CrossFade(
                firstChild: hideToolbars ? Container(height: 0) : bottomBar,
                secondChild: _bottomAppBar,
              ),
      );

  Widget get _bottomAppBar {
    List<Widget> _bottomBarLeft = interactive ? bottomBarLeftItems ?? [] : [];
    List<Widget> _bottomBarRight = interactive ? bottomBarRightItems ?? [] : [];
    List<Widget> _bottomBarCenter =
        interactive ? bottomBarCenterItems ?? [] : [];
    List<Widget>? _bottomBarChildren = interactive ? bottomBarChildren : null;
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
                        padding: const EdgeInsets.symmetric(horizontal: 8),
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
