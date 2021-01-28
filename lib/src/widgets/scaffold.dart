import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_smart/get_smart.dart';
import 'package:responsive_ui/responsive_ui.dart';

/// A smart scaffold.
/// All individual pages should be wrapped in it.
class GetScaffold extends StatelessWidget {
  const GetScaffold({
    this.child,
    this.children,
    this.title,
    this.subtitle,
    this.showProgress = false,
    this.isInteractive = true,
    this.appBarExtension,
    this.appBarExtensionSize,
    this.withBottomBar,
    this.bottomBar,
    this.bottomBarLeftItems,
    this.bottomBarRightItems,
    this.bottomBarCenterItems,
    this.appBarRightItems,
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endDocked,
    Key key,
  }) : _key = key;

  final Widget child;
  final List<Widget> children;
  final String title;
  final String subtitle;
  final bool showProgress;
  final bool isInteractive;
  final Widget appBarExtension;
  final double appBarExtensionSize;
  final Widget withBottomBar;
  final Widget bottomBar;
  final List<Widget> bottomBarLeftItems;
  final List<Widget> bottomBarRightItems;
  final List<Widget> bottomBarCenterItems;
  final List<Widget> appBarRightItems;
  final FloatingActionButton floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final GlobalKey<ScaffoldState> _key;

  bool get _isInteractive => isInteractive == true;

  @override
  Widget build(BuildContext context) {
    GetTheme.resetSystemChrome(context);
    if (!_isInteractive) context?.endEditing();
    return Scaffold(
      key: _key,
      extendBody: true,
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          if (Navigator.canPop(context))
            Get.back();
          else
            SystemNavigator.pop(animated: true);
        }),
        title: Column(children: [if (title != null) Text(title)]),
        bottom: PreferredSize(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (appBarExtension != null) appBarExtension,
              LinearProgress(visible: showProgress),
            ],
          ),
          preferredSize: Size.fromHeight(appBarExtension != null
              ? kToolbarHeight + 1 + (appBarExtensionSize ?? 0)
              : 1),
        ),
        actions: _isInteractive ? appBarRightItems : null,
      ),
      bottomNavigationBar: withBottomBar != null
          ? _bottomAppBar
          : CrossFade(
              firstChild: bottomBar,
              secondChild: _bottomAppBar,
            ),
      body: Scrollbar(
        child: Stack(children: [
          child ??
              ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [Responsive(children: children)],
              ),
          if (!_isInteractive) Clickable(),
        ]),
      ),
      floatingActionButton: _isInteractive ? floatingActionButton : null,
      floatingActionButtonLocation: subtitle?.isBlank ?? true
          ? FloatingActionButtonLocation.endFloat
          : floatingActionButtonLocation,
    );
  }

  Widget get _bottomAppBar {
    List<Widget> _bottomBarLeftItems =
        _isInteractive ? bottomBarLeftItems ?? [] : [];
    List<Widget> _bottomBarRightItems =
        _isInteractive ? bottomBarRightItems ?? [] : [];
    List<Widget> _bottomBarCenterItems =
        _isInteractive ? bottomBarCenterItems ?? [] : [];
    return (subtitle?.isBlank ?? true) &&
            (_bottomBarLeftItems.isBlank) &&
            (_bottomBarRightItems.isBlank) &&
            (_bottomBarCenterItems.isBlank)
        ? Container(height: 0)
        : BottomBar(
            snackBar: withBottomBar,
            leftItems: _bottomBarLeftItems,
            rightItems: _bottomBarRightItems,
            centerItems: subtitle?.isBlank ?? true
                ? _bottomBarCenterItems
                : [
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: AutoSizeText(
                          subtitle,
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
