import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GetMaterialApp(
        title: 'Get Smart Demo',
        builder: (context, child) => Theme(
          data: GetTheme.black(context),
          child: child,
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
  static final login = routeOf(LoginPage);

  static List<GetPage> get pages => [
        GetPage(
          name: login,
          page: () => LoginPage(),
          transition: Transition.noTransition,
        ),
      ];
}

class LoginPage extends StatelessWidget {
  final formKey = GlobalKey<FormState>();

  bool get isValid => true; //formKey.state?.validate() == true;

  @override
  Widget build(BuildContext context) => GetScaffold(
        hideAppBarLeading: true,
        centerTitle: true,
        title: "Log In",
        children: [
          Padding(
            padding: EdgeInsets.all(26),
            child: Form(
              // key: formKey,
              child: Column(children: [
                GetTextField(
                  label: "Email",
                  inputFormatters: [TextInputFilter.noWhitespace],
                  filled: true,
                ),
                SizedBox(height: 8),
                GetTextField(
                  label: "Password",
                  inputFormatters: [TextInputFilter.noWhitespace],
                  obscureText: true,
                  showCounter: false,
                  filled: true,
                ),
                SizedBox(height: 12),
                GetButton.roundElevated(
                  horizontalPadding: 48,
                  verticalPadding: 14,
                  child: Text("Log In"),
                  onPressed: () {
                    if (isValid) Get.to(() => HomePage());
                  },
                ),
              ]),
            ),
          )
        ],
      );
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
  Widget build(BuildContext context) => GetScaffold(
        title: "Get Smart Home",
        child: ListView.separated(
          itemCount: items.length,
          separatorBuilder: (_, __) => AppTileSeparator(),
          itemBuilder: (_, index) {
            var data = items[index];
            return AppTile.simple(
              icon: CupertinoIcons.home,
              title: data,
              color: data.materialPrimary,
              isIconBoxed: false,
              onTap: () => null,
            );
          },
        ),
      );
}
