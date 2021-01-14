import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_smart/src/res/themes.dart';
import 'package:get_smart/src/widgets/app_widgets.dart';
import 'package:responsive_ui/responsive_ui.dart';

/// A responsive scaffold.
/// All individual pages should be wrapped in it.
class AppPage extends StatelessWidget {
  const AppPage({
    this.child,
    this.children,
    this.title,
    this.subtitle,
    this.showProgress = false,
    this.appBarExtension,
    this.appBarExtensionSize,
    this.snackBar,
    this.bottomSnackBar,
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
  final Widget appBarExtension;
  final double appBarExtensionSize;
  final Widget snackBar;
  final Widget bottomSnackBar;
  final List<Widget> bottomBarLeftItems;
  final List<Widget> bottomBarRightItems;
  final List<Widget> bottomBarCenterItems;
  final List<Widget> appBarRightItems;
  final FloatingActionButton floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final GlobalKey<ScaffoldState> _key;

  @override
  Widget build(BuildContext context) {
    AppTheme.resetSystemChrome(context);
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
        actions: appBarRightItems,
      ),
      bottomNavigationBar: snackBar != null
          ? bottomAppBar
          : CrossFade(
              firstChild: bottomSnackBar,
              secondChild: bottomAppBar,
            ),
      body: Scrollbar(
        child: child ??
            ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [Responsive(children: children)],
            ),
      ),
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: subtitle?.isBlank ?? true
          ? FloatingActionButtonLocation.endFloat
          : floatingActionButtonLocation,
    );
  }

  Widget get bottomAppBar => (subtitle?.isBlank ?? true) &&
          (bottomBarLeftItems?.isBlank ?? true) &&
          (bottomBarRightItems?.isBlank ?? true) &&
          (bottomBarCenterItems?.isBlank ?? true)
      ? Container(height: 0)
      : BottomBar(
          snackBar: snackBar,
          leftItems: bottomBarLeftItems,
          rightItems: bottomBarRightItems,
          centerItems: subtitle?.isBlank ?? true
              ? bottomBarCenterItems
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

  static GlobalKey<ScaffoldState> get newKey => GlobalKey<ScaffoldState>();
}
