import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

/// Theme extension
class GetTheme {
  static const kAccentColor = Color(0xFF2196F3);
  static const kPrimarySwatch = Colors.blue;
  static const kBackgroundLight = Colors.white;
  static const kCanvasColorLight = Color(0xFFF2F2F2);
  static const kPrimaryBackgroundLight = Color(0xFFFAFAFA);
  static const kBackgroundDark = Color(0xFF172329);
  static const kCanvasColorDark = Color(0xFF26343C);
  static const kPrimaryBackgroundDark = Color(0xFF37474F);

  static final kErrorTextStyle = ui.TextStyle(
    color: Colors.red,
    fontSize: 13.0,
    fontFamily: "monospace",
    fontWeight: FontWeight.bold,
  );

  static bool isDark(BuildContext? context) =>
      ThemeMode.system == ThemeMode.dark ||
      MediaQuery.platformBrightnessOf(context!) == Brightness.dark;

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
    Brightness? brightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    Brightness primaryBrightness = Brightness.dark,
    Color primaryBackgroundLight = Colors.black,
    Color bottomBackgroundLight = Colors.white,
    Color bottomForegroundLight = Colors.black,
    Color primaryBackgroundDark = GetColors.black90,
    Color bottomBackgroundDark = GetColors.black90,
    Color bottomForegroundDark = Colors.white,
  }) =>
      builder(
        context,
        brightness: brightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryIconTheme: primaryIconTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
        primaryBrightness: primaryBrightness,
        // light theme attributes
        primaryBackgroundLight: primaryBackgroundLight,
        bottomBackgroundLight: bottomBackgroundLight,
        bottomForegroundLight: bottomForegroundLight,
        accentColorLight: Colors.black,
        primarySwatchLight: GetColors.black,
        // dark theme attributes
        primaryBackgroundDark: primaryBackgroundDark,
        bottomBackgroundDark: bottomBackgroundDark,
        bottomForegroundDark: bottomForegroundDark,
        accentColorDark: Colors.white,
        primarySwatchDark: GetColors.white,
        backgroundDark: GetColors.black90,
        canvasColorDark: GetColors.black93,
      );

  static ThemeData sky(
    BuildContext context, {
    Brightness? brightness,
    String? fontFamily,
    TextTheme? textTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
  }) =>
      builder(
        context,
        brightness: brightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
      );

  static ThemeData builder(
    BuildContext context, {
    Brightness? brightness,
    Brightness? primaryBrightness,
    Brightness? bottomBrightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    Color accentColorLight = kAccentColor,
    Color primarySwatchLight = kPrimarySwatch,
    Color backgroundLight = kBackgroundLight,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = kPrimaryBackgroundLight,
    Color bottomBackgroundLight = kPrimaryBackgroundLight,
    Color bottomForegroundLight = kAccentColor,
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
    final isDarkPrimary = _primaryBrightness == Brightness.dark;
    final isDarkBottom = _bottomBrightness == Brightness.dark;
    final theme = ThemeData(brightness: _brightness);
    final bottomTheme = ThemeData(brightness: _bottomBrightness);
    final _accentColor = isDark ? accentColorDark : accentColorLight;
    final _primaryForeground =
        isDarkPrimary ? accentColorDark : accentColorLight;
    final _bottomForeground =
        isDarkBottom ? bottomForegroundDark : bottomForegroundLight;
    final _primarySwatch = isDark ? primarySwatchDark : primarySwatchLight;
    final _primaryBackground =
        isDark ? primaryBackgroundDark : primaryBackgroundLight;
    final _bottomBackground =
        isDarkBottom ? bottomBackgroundDark : bottomBackgroundLight;
    var _primaryIconTheme = IconThemeData(
      color: primaryIconTheme?.color ?? _primaryForeground,
      opacity: primaryIconTheme?.opacity,
      size: primaryIconTheme?.size ?? 24.0,
    );
    return ThemeData(
      brightness: _brightness,
      backgroundColor: isDark ? backgroundDark : backgroundLight,
      canvasColor: isDark ? canvasColorDark : canvasColorLight,
      scaffoldBackgroundColor: isDark ? canvasColorDark : canvasColorLight,
      primarySwatch: $cast(_primarySwatch),
      primaryColor: _primaryBackground,
      bottomAppBarColor: _bottomBackground,
      accentColor: _accentColor,
      hintColor: theme.hintColor.hinted,
      primaryColorBrightness: _primaryBrightness,
      primaryIconTheme: _primaryIconTheme,
      iconTheme: IconThemeData(
        color: _accentColor,
        size: 24.0,
      ),
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
          visualDensity: elevatedButtonStyle?.visualDensity,
          tapTargetSize: elevatedButtonStyle?.tapTargetSize,
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
          visualDensity: outlinedButtonStyle?.visualDensity,
          tapTargetSize: outlinedButtonStyle?.tapTargetSize,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          shape: textButtonStyle?.shape,
          side: textButtonStyle?.side,
          elevation: textButtonStyle?.elevation,
          minimumSize: textButtonStyle?.minimumSize,
          padding: textButtonStyle?.padding,
          backgroundColor: textButtonStyle?.backgroundColor,
          foregroundColor: textButtonStyle?.foregroundColor,
          textStyle: textButtonStyle?.textStyle,
          visualDensity: textButtonStyle?.visualDensity,
          tapTargetSize: textButtonStyle?.tapTargetSize,
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
        brightness: _primaryBrightness,
        titleTextStyle: TextStyle(
          fontSize: 18,
          color: _primaryBackground.contrast,
          fontWeight: FontWeight.w500,
          fontFamily: fontFamily,
        ),
        toolbarTextStyle: TextStyle(
          fontSize: 14,
          color: _primaryBackground.contrast.activated,
          fontFamily: fontFamily,
        ),
        foregroundColor: _primaryBackground.contrast,
        iconTheme: _primaryIconTheme,
        actionsIconTheme: _primaryIconTheme,
        backwardsCompatibility: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          // systemNavigationBarDividerColor: _bottomBackground,
          // systemNavigationBarIconBrightness: _bottomBrightness.inverse,
          // systemNavigationBarColor: _bottomBackground,
          statusBarBrightness: _primaryBrightness,
          statusBarIconBrightness: _primaryBrightness.inverse,
          statusBarColor: Colors.transparent,
        ),
      ),
      bottomAppBarTheme: BottomAppBarTheme(
        elevation: 4,
        color: _bottomBackground,
        shape: CircularNotchedRectangle(),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        elevation: 4,
        selectedLabelStyle: TextStyle(
          fontSize: 10,
          fontFamily: fontFamily,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 9.8,
          fontFamily: fontFamily,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: _bottomBackground,
        selectedItemColor: _bottomForeground,
        unselectedItemColor: bottomTheme.hintColor.hinted,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _bottomBackground,
      ),
      switchTheme: SwitchThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        splashRadius: 16,
      ),
    );
  }

  /// Resolves which theme to use based on brightness.
  static Widget defaultBuilder(BuildContext context, Widget? child) => Theme(
        data: sky(context),
        child: child!,
      );

  static setErrorStyle({Color? backgroundColor, ui.TextStyle? textStyle}) {
    RenderErrorBox.backgroundColor = backgroundColor ?? kBackgroundLight;
    RenderErrorBox.textStyle = textStyle ?? kErrorTextStyle;
  }

  static resetSystemChrome(BuildContext? context) {
    setErrorStyle(backgroundColor: context?.theme.backgroundColor);
    // var brightness = GetTheme.brightnessInverse(context);
    // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    //   // systemNavigationBarIconBrightness: brightness,
    //   statusBarBrightness: brightness,
    //   statusBarIconBrightness: brightness,
    //   // systemNavigationBarColor: Get.bottomBarColor,
    //   statusBarColor: Colors.transparent,
    // ));
    var _systemOverlayStyle = context?.theme.appBarTheme.systemOverlayStyle;
    var _primaryBrightness = context?.theme.appBarTheme.brightness;
    // var _bottomBackground = context?.theme.bottomAppBarTheme.color;
    // var _bottomBrightness = _bottomBackground?.brightness;
    SystemChrome.setSystemUIOverlayStyle(_systemOverlayStyle ??
        SystemUiOverlayStyle(
          // systemNavigationBarDividerColor: _bottomBackground,
          // systemNavigationBarIconBrightness: _bottomBrightness?.inverse,
          // systemNavigationBarColor: _bottomBackground,
          statusBarBrightness: _primaryBrightness,
          statusBarIconBrightness: _primaryBrightness?.inverse,
          statusBarColor: Colors.transparent,
        ));
  }
}

extension GetInterfaceTheme on GetInterface {
  AppBarTheme get appBarTheme => theme.appBarTheme;

  TextTheme get primaryTextTheme => theme.primaryTextTheme;

  /// The background color for primary parts of the app (app bars, tab bars, etc)
  Color get primaryColor => theme.primaryColor;

  Color? get primaryIconColor => theme.primaryIconTheme.color;

  BottomAppBarTheme get bottomBarTheme => theme.bottomAppBarTheme;

  /// The background color for bottom parts of the app (bottom bars, snack bars, etc)
  Color get bottomBarColor => theme.bottomAppBarColor;
}

extension GetContextTheme on BuildContext {
  AppBarTheme get appBarTheme => theme.appBarTheme;

  TextTheme get primaryTextTheme => theme.primaryTextTheme;

  /// The background color for primary parts of the app (app bars, tab bars, etc)
  Color get primaryColor => theme.primaryColor;

  Color? get primaryIconColor => theme.primaryIconTheme.color;

  BottomAppBarTheme get bottomBarTheme => theme.bottomAppBarTheme;

  /// The background color for bottom parts of the app (bottom bars, snack bars, etc)
  Color get bottomBarColor => theme.bottomAppBarColor;
}

/// Font extension
///
/// Default material specs:
/// ```
/// NAME         SIZE  WEIGHT  SPACING
/// headline1    96.0  light   -1.5
/// headline2    60.0  light   -0.5
/// headline3    48.0  regular  0.0
/// headline4    34.0  regular  0.25
/// headline5    24.0  regular  0.0
/// headline6    20.0  medium   0.15
/// subtitle1    16.0  regular  0.15
/// subtitle2    14.0  medium   0.1
/// bodyText1    16.0  regular  0.5
/// bodyText2    14.0  regular  0.25
/// button       14.0  medium   1.25
/// caption      12.0  regular  0.4
/// overline     10.0  regular  1.5
///
/// "light" = `FontWeight.w300`
/// "regular" = `FontWeight.w400`
/// "medium" = `FontWeight.w500`
/// ```
class GetFont {
  static const avenirNext = "AvenirNext";
  static const dietDidot = "DietDidot";
  static const stoneSerif = "StoneSerif";
  static final avenirNextTextTheme = textTheme(fontFamily: avenirNext);
  static final dietDidotTextTheme = textTheme(fontFamily: dietDidot);
  static final stoneSerifTextTheme = textTheme(fontFamily: stoneSerif);

  static TextTheme textTheme({String? fontFamily}) => TextTheme(
        headline1: TextStyle(
          fontSize: 80,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        headline2: TextStyle(
          fontSize: 50,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        headline3: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        headline4: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        headline5: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        headline6: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          fontFamily: fontFamily,
        ),
        bodyText1: TextStyle(
          fontSize: 15,
          fontFamily: fontFamily,
        ),
        bodyText2: TextStyle(
          fontSize: 11,
          fontFamily: fontFamily,
        ),
        subtitle1: TextStyle(
          fontSize: 14,
          fontFamily: fontFamily,
        ),
        subtitle2: TextStyle(
          fontSize: 10,
          fontFamily: fontFamily,
        ),
        caption: TextStyle(
          fontSize: 10,
          fontFamily: fontFamily,
        ),
        overline: TextStyle(
          fontSize: 8,
          fontFamily: fontFamily,
        ),
        button: TextStyle(
          fontSize: 15,
          fontFamily: fontFamily,
        ),
      );
}

extension BrightnessX on Brightness {
  Brightness get inverse =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}

extension TextStyleX on TextStyle {
  TextStyle get underlined => apply(decoration: TextDecoration.underline);

  TextStyle get italic => apply(fontStyle: FontStyle.italic);

  TextStyle get bold => apply(fontWeightDelta: 1);
}
