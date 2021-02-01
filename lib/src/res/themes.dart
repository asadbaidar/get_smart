import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_smart/get_smart.dart';

/// All app themes to be used in the app should be defined here
class GetTheme {
  static const kAccentColor = Color(0xFF2196F3);
  static const kPrimarySwatch = Colors.blue;
  static const kBackgroundLight = Colors.white;
  static const kCanvasColorLight = Color(0xFFF2F2F2);
  static const kPrimaryBackgroundLight = Color(0xFFFAFAFA);
  static const kBackgroundDark = Color(0xFF172329);
  static const kCanvasColorDark = Color(0xFF26343C);
  static const kPrimaryBackgroundDark = Color(0xFF37474F);

  static const kFontAvenirNext = "AvenirNext";
  static const kTextAvenirNext = TextTheme(
    headline5: TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    headline6: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    bodyText2: TextStyle(
      fontSize: 11,
    ),
    caption: TextStyle(
      fontSize: 10,
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

  static ThemeData red(BuildContext context) => ThemeData.from(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.red,
          brightness: brightness(context),
        ),
      );

  static ThemeData black(
    BuildContext context, {
    Brightness brightness,
    String fontFamily,
    TextTheme textTheme,
    ButtonStyle elevatedButtonStyle,
    ButtonStyle outlinedButtonStyle,
  }) =>
      builder(
        context,
        brightness: brightness,
        primaryBrightness: Brightness.dark,
        fontFamily: fontFamily,
        textTheme: textTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        accentColorLight: Colors.black,
        primarySwatchLight: GetColors.black,
        bottomForegroundLight: Colors.black,
        primaryBackgroundLight: Colors.black,
        bottomBackgroundLight: Colors.white,
        // dark theme attributes
        accentColorDark: Colors.white,
        primarySwatchDark: GetColors.white,
        bottomForegroundDark: Colors.white,
        primaryBackgroundDark: const Color(0xFF0F0F0F),
        bottomBackgroundDark: const Color(0xFF0F0F0F),
        backgroundDark: const Color(0xFF0F0F0F),
        canvasColorDark: const Color(0xFF0C0C0C),
      );

  static ThemeData sky(
    BuildContext context, {
    Brightness brightness,
    String fontFamily,
    TextTheme textTheme,
    ButtonStyle elevatedButtonStyle,
    ButtonStyle outlinedButtonStyle,
  }) =>
      builder(
        context,
        brightness: brightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
      );

  static ThemeData builder(
    BuildContext context, {
    Brightness brightness,
    Brightness primaryBrightness,
    Brightness bottomBrightness,
    String fontFamily,
    TextTheme textTheme,
    ButtonStyle elevatedButtonStyle,
    ButtonStyle outlinedButtonStyle,
    Color accentColorLight = kAccentColor,
    Color primarySwatchLight = kPrimarySwatch,
    Color backgroundLight = kBackgroundLight,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = kPrimaryBackgroundLight,
    Color bottomBackgroundLight = kPrimaryBackgroundLight,
    Color bottomForegroundLight = kPrimaryBackgroundLight,
    Color accentColorDark = kAccentColor,
    Color primarySwatchDark = kPrimarySwatch,
    Color backgroundDark = kBackgroundDark,
    Color canvasColorDark = kCanvasColorDark,
    Color primaryBackgroundDark = kPrimaryBackgroundDark,
    Color bottomBackgroundDark = kPrimaryBackgroundDark,
    Color bottomForegroundDark = kAccentColor,
  }) {
    final _brightness = brightness ?? GetTheme.brightness(context);
    final _primaryBrightness = primaryBrightness ?? _brightness;
    final _bottomBrightness = bottomBrightness ?? _brightness;
    final isDark = _brightness == Brightness.dark;
    final isDarkBottom = _bottomBrightness == Brightness.dark;
    final theme = ThemeData(brightness: _brightness);
    final bottomTheme = ThemeData(brightness: _bottomBrightness);
    final _accentColor = isDark ? accentColorDark : accentColorLight;
    final _bottomForeground =
        isDarkBottom ? bottomForegroundDark : bottomForegroundLight;
    final _primarySwatch = isDark ? primarySwatchDark : primarySwatchLight;
    final _primaryBackground =
        isDark ? primaryBackgroundDark : primaryBackgroundLight;
    final _bottomBackground =
        isDarkBottom ? bottomBackgroundDark : bottomBackgroundLight;
    return ThemeData(
      brightness: _brightness,
      backgroundColor: isDark ? backgroundDark : backgroundLight,
      canvasColor: isDark ? canvasColorDark : canvasColorLight,
      primarySwatch: _primarySwatch,
      accentColor: _accentColor,
      hintColor: theme.hintColor.hinted,
      primaryColorBrightness: _primaryBrightness,
      primaryIconTheme: IconThemeData(color: _accentColor),
      iconTheme: IconThemeData(color: _accentColor),
      buttonColor: _accentColor,
      fontFamily: fontFamily,
      textTheme: textTheme,
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          elevation:
              elevatedButtonStyle?.elevation ?? GetButton.defaultElevation(),
          shape: elevatedButtonStyle?.shape ?? GetButton.defaultShape(),
          minimumSize: elevatedButtonStyle?.minimumSize,
          padding: elevatedButtonStyle?.padding,
          side: elevatedButtonStyle?.side,
          backgroundColor: elevatedButtonStyle?.backgroundColor,
          foregroundColor: elevatedButtonStyle?.foregroundColor,
          textStyle: elevatedButtonStyle?.textStyle,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          shape: outlinedButtonStyle?.shape ?? GetButton.defaultShape(),
          side:
              outlinedButtonStyle?.side ?? GetButton.defaultSide(_accentColor),
          elevation: outlinedButtonStyle?.elevation,
          minimumSize: outlinedButtonStyle?.minimumSize,
          padding: outlinedButtonStyle?.padding,
          backgroundColor: outlinedButtonStyle?.backgroundColor,
          foregroundColor: outlinedButtonStyle?.foregroundColor,
          textStyle: outlinedButtonStyle?.textStyle,
        ),
      ),
      buttonTheme: ButtonThemeData(
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      appBarTheme: AppBarTheme(
        elevation: 1,
        color: _primaryBackground,
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 4,
        color: _primaryBackground,
        shape: CircularNotchedRectangle(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 4,
        selectedLabelStyle: TextStyle(fontSize: 10),
        unselectedLabelStyle: TextStyle(fontSize: 9.8),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: _bottomBackground,
        selectedItemColor: _bottomForeground,
        unselectedItemColor: bottomTheme.hintColor.hinted,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _primaryBackground,
      ),
    );
  }

  /// Resolves which theme to use based on brightness.
  static Widget defaultBuilder(BuildContext context, Widget child) => Theme(
        data: sky(context),
        child: child,
      );

  static resetSystemChrome(BuildContext context) {
    var brightness = GetTheme.brightnessInverse(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      // systemNavigationBarIconBrightness: brightness,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
      // systemNavigationBarColor: Get.theme.bottomAppBarTheme.color,
      statusBarColor: Colors.transparent,
    ));
  }
}
