import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_smart/src/utils/utils.dart';

/// All app themes to be used in the app should be defined here
class AppTheme {
  static final kBackgroundLight = Colors.white;
  static final kCanvasColorLight = Color(0xFFF2F2F2);
  static final kPrimaryBackgroundLight = Colors.grey.shade50;
  static final kBackgroundDark = Color(0xFF172329);
  static final kCanvasColorDark = Color(0xFF26343C);
  static final kPrimaryBackgroundDark = Colors.blueGrey.shade800;
  static final kAccentColor = kPrimarySwatch.shade500;
  static final kPrimarySwatch = Colors.blue;

  static ThemeData light(BuildContext context) => _builder(
        context,
      );

  static ThemeData dark(BuildContext context) => _builder(
        context,
        brightness: Brightness.dark,
      );

  static red(BuildContext context) => ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          brightness: brightness(context),
        ),
      );

  static bool isDark(BuildContext context) =>
      ThemeMode.system == ThemeMode.dark ||
      MediaQuery.platformBrightnessOf(context) == Brightness.dark;

  static bool get isDarkMode => isDark(Get.context);

  static Brightness brightness(BuildContext context) =>
      getBrightness(isDark(context));

  static Brightness brightnessInverse(BuildContext context) =>
      getBrightness(!isDark(context));

  static Brightness getBrightness(bool isDark) =>
      isDark ? Brightness.dark : Brightness.light;

  static ThemeData _builder(
    BuildContext context, {
    Brightness brightness = Brightness.light,
  }) {
    final isDark = brightness == Brightness.dark;
    final theme = ThemeData(brightness: brightness);
    return ThemeData(
      brightness: brightness,
      backgroundColor: isDark ? kBackgroundDark : kBackgroundLight,
      canvasColor: isDark ? kCanvasColorDark : kCanvasColorLight,
      primarySwatch: kPrimarySwatch,
      accentColor: kAccentColor,
      hintColor: theme.hintColor.hinted,
      primaryColorBrightness: brightness,
      primaryIconTheme: IconThemeData(color: kAccentColor),
      iconTheme: IconThemeData(color: kAccentColor),
      buttonColor: kAccentColor,
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 1,
        color: isDark ? kPrimaryBackgroundDark : kPrimaryBackgroundLight,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 4,
        color: isDark ? kPrimaryBackgroundDark : kPrimaryBackgroundLight,
        shape: CircularNotchedRectangle(),
      ),
    );
  }

  /// Resolves which theme to use based on brightness.
  static Widget builder(BuildContext context, Widget child) {
    return Theme(
      data: isDark(context) ? dark(context) : light(context),
      child: child,
    );
  }

  static resetSystemChrome(BuildContext context) {
    // var theme = Theme.of(context);
    var brightness = AppTheme.brightnessInverse(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // systemNavigationBarIconBrightness: brightness,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      // systemNavigationBarColor: theme.bottomAppBarTheme.color,
      statusBarColor: Colors.transparent,
    ));
  }
}
