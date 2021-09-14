import 'package:example/src/login_page.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Get Smart Demo',
        builder: (context, child) => Theme(
          data: GetTheme.blackWhite(context),
          child: child!,
        ),
        localizationsDelegates: [GetLocalizations.delegate],
        supportedLocales: GetLocalizations.supportedLocales,
        initialRoute: AppRoute.login,
        getPages: AppRoute.pages,
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
      );
}

class AppRoute {
  static final login = $route(LoginPage);

  static List<GetPage> get pages => [
        GetPage(
          name: login,
          page: () => const LoginPage(),
          transition: Transition.noTransition,
        ),
      ];
}
