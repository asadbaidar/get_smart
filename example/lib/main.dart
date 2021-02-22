import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Get Smart Demo',
      builder: (context, child) => Theme(
        data: GetTheme.black(context),
        child: child,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  static const items = [
    "One",
    "Two",
    "Three",
    "Four",
    "Five",
    "Six",
  ];

  @override
  Widget build(BuildContext context) {
    return GetScaffold(
      isHome: true,
      title: "Get Smart Home",
      child: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (_, __) => AppTileSeparator(),
        itemBuilder: (_, index) {
          var data = items[index];
          return AppTile.simple(
            icon: CupertinoIcons.bitcoin_circle,
            title: data,
            color: data.materialPrimary,
            isIconBoxed: false,
            onPressed: () {},
          );
        },
      ),
    );
  }
}
