import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:get_smart/get_smart.dart';

/// Theme extension
class GetTheme {
  static const kSecondaryColor = Color(0xFF2196F3);
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

  static ThemeData blackWhite(
    BuildContext context, {
    Brightness? brightness,
    Brightness primaryBrightness = Brightness.dark,
    Brightness? bottomBrightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    TextStyle? titleTextStyle,
    // light theme attributes
    Color secondaryColorLight = Colors.black,
    Color primarySwatchLight = GetColors.black,
    Color backgroundLight = Colors.white,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = Colors.black,
    Color bottomBackgroundLight = Colors.white,
    Color bottomForegroundLight = Colors.black,
    // dark theme attributes
    Color secondaryColorDark = Colors.white,
    Color primarySwatchDark = GetColors.white,
    Color backgroundDark = GetColors.black90,
    Color canvasColorDark = GetColors.black93,
    Color primaryBackgroundDark = GetColors.black90,
    Color bottomBackgroundDark = GetColors.black90,
    Color bottomForegroundDark = Colors.white,
  }) =>
      builder(
        context,
        brightness: brightness,
        primaryBrightness: primaryBrightness,
        bottomBrightness: bottomBrightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryIconTheme: primaryIconTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
        titleTextStyle: titleTextStyle,
        // light theme attributes
        secondaryColorLight: secondaryColorLight,
        primarySwatchLight: primarySwatchLight,
        backgroundLight: backgroundLight,
        canvasColorLight: canvasColorLight,
        primaryBackgroundLight: primaryBackgroundLight,
        bottomBackgroundLight: bottomBackgroundLight,
        bottomForegroundLight: bottomForegroundLight,
        // dark theme attributes
        secondaryColorDark: secondaryColorDark,
        primarySwatchDark: primarySwatchDark,
        backgroundDark: backgroundDark,
        canvasColorDark: canvasColorDark,
        primaryBackgroundDark: primaryBackgroundDark,
        bottomBackgroundDark: bottomBackgroundDark,
        bottomForegroundDark: bottomForegroundDark,
      );

  static ThemeData blackWhiteFlat(
    BuildContext context, {
    Brightness? brightness,
    Brightness primaryBrightness = Brightness.dark,
    Brightness? bottomBrightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    TextStyle? titleTextStyle,
    // light theme attributes
    Color secondaryColorLight = Colors.black,
    Color primarySwatchLight = GetColors.black,
    Color backgroundLight = Colors.white,
    Color canvasColorLight = Colors.white,
    Color primaryBackgroundLight = Colors.black,
    Color bottomBackgroundLight = Colors.white,
    Color bottomForegroundLight = Colors.black,
    // dark theme attributes
    Color secondaryColorDark = Colors.white,
    Color primarySwatchDark = GetColors.white,
    Color backgroundDark = GetColors.black93,
    Color canvasColorDark = GetColors.black93,
    Color primaryBackgroundDark = GetColors.black90,
    Color bottomBackgroundDark = GetColors.black90,
    Color bottomForegroundDark = Colors.white,
  }) =>
      builder(
        context,
        brightness: brightness,
        primaryBrightness: primaryBrightness,
        bottomBrightness: bottomBrightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryIconTheme: primaryIconTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
        titleTextStyle: titleTextStyle,
        // light theme attributes
        secondaryColorLight: secondaryColorLight,
        primarySwatchLight: primarySwatchLight,
        backgroundLight: backgroundLight,
        canvasColorLight: canvasColorLight,
        primaryBackgroundLight: primaryBackgroundLight,
        bottomBackgroundLight: bottomBackgroundLight,
        bottomForegroundLight: bottomForegroundLight,
        // dark theme attributes
        secondaryColorDark: secondaryColorDark,
        primarySwatchDark: primarySwatchDark,
        backgroundDark: backgroundDark,
        canvasColorDark: canvasColorDark,
        primaryBackgroundDark: primaryBackgroundDark,
        bottomBackgroundDark: bottomBackgroundDark,
        bottomForegroundDark: bottomForegroundDark,
      );

  static ThemeData sky(
    BuildContext context, {
    Brightness? brightness,
    Brightness? primaryBrightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    TextStyle? titleTextStyle,
    // light theme attributes
    Color secondaryColorLight = kSecondaryColor,
    Color primarySwatchLight = kPrimarySwatch,
    Color backgroundLight = kBackgroundLight,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = kPrimaryBackgroundLight,
    // dark theme attributes
    Color secondaryColorDark = kSecondaryColor,
    Color primarySwatchDark = kPrimarySwatch,
    Color backgroundDark = kBackgroundDark,
    Color canvasColorDark = kCanvasColorDark,
    Color primaryBackgroundDark = kPrimaryBackgroundDark,
  }) =>
      simpleBuilder(
        context,
        brightness: brightness,
        primaryBrightness: primaryBrightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryIconTheme: primaryIconTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
        titleTextStyle: titleTextStyle,
        // light theme attributes
        secondaryColorLight: secondaryColorLight,
        primarySwatchLight: primarySwatchLight,
        backgroundLight: backgroundLight,
        canvasColorLight: canvasColorLight,
        primaryBackgroundLight: primaryBackgroundLight,
        // dark theme attributes
        secondaryColorDark: secondaryColorDark,
        primarySwatchDark: primarySwatchDark,
        backgroundDark: backgroundDark,
        canvasColorDark: canvasColorDark,
        primaryBackgroundDark: primaryBackgroundDark,
      );

  static ThemeData black(
    BuildContext context, {
    Brightness? brightness,
    Brightness? primaryBrightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    TextStyle? titleTextStyle,
    // light theme attributes
    Color secondaryColorLight = Colors.black,
    Color primarySwatchLight = GetColors.black,
    Color backgroundLight = kBackgroundLight,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = kPrimaryBackgroundLight,
    // dark theme attributes
    Color secondaryColorDark = Colors.white,
    Color primarySwatchDark = GetColors.white,
    Color backgroundDark = GetColors.black93,
    Color canvasColorDark = GetColors.black90,
    Color primaryBackgroundDark = GetColors.black85,
  }) =>
      simpleBuilder(
        context,
        brightness: brightness,
        primaryBrightness: primaryBrightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryIconTheme: primaryIconTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
        titleTextStyle: titleTextStyle,
        // light theme attributes
        secondaryColorLight: secondaryColorLight,
        primarySwatchLight: primarySwatchLight,
        backgroundLight: backgroundLight,
        canvasColorLight: canvasColorLight,
        primaryBackgroundLight: primaryBackgroundLight,
        // dark theme attributes
        secondaryColorDark: secondaryColorDark,
        primarySwatchDark: primarySwatchDark,
        backgroundDark: backgroundDark,
        canvasColorDark: canvasColorDark,
        primaryBackgroundDark: primaryBackgroundDark,
      );

  static ThemeData simpleBuilder(
    BuildContext context, {
    Brightness? brightness,
    Brightness? primaryBrightness,
    String? fontFamily,
    TextTheme? textTheme,
    IconThemeData? primaryIconTheme,
    ButtonStyle? elevatedButtonStyle,
    ButtonStyle? outlinedButtonStyle,
    ButtonStyle? textButtonStyle,
    TextStyle? titleTextStyle,
    // light theme attributes
    Color secondaryColorLight = kSecondaryColor,
    Color primarySwatchLight = kPrimarySwatch,
    Color backgroundLight = kBackgroundLight,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = kPrimaryBackgroundLight,
    // dark theme attributes
    Color secondaryColorDark = kSecondaryColor,
    Color primarySwatchDark = kPrimarySwatch,
    Color backgroundDark = kBackgroundDark,
    Color canvasColorDark = kCanvasColorDark,
    Color primaryBackgroundDark = kPrimaryBackgroundDark,
  }) =>
      builder(
        context,
        brightness: brightness,
        primaryBrightness: primaryBrightness,
        bottomBrightness: primaryBrightness,
        fontFamily: fontFamily,
        textTheme: textTheme,
        primaryIconTheme: primaryIconTheme,
        elevatedButtonStyle: elevatedButtonStyle,
        outlinedButtonStyle: outlinedButtonStyle,
        textButtonStyle: textButtonStyle,
        titleTextStyle: titleTextStyle,
        // light theme attributes
        secondaryColorLight: secondaryColorLight,
        primarySwatchLight: primarySwatchLight,
        backgroundLight: backgroundLight,
        canvasColorLight: canvasColorLight,
        primaryBackgroundLight: primaryBackgroundLight,
        bottomBackgroundLight: primaryBackgroundLight,
        bottomForegroundLight: secondaryColorLight,
        // dark theme attributes
        secondaryColorDark: secondaryColorDark,
        primarySwatchDark: primarySwatchDark,
        backgroundDark: backgroundDark,
        canvasColorDark: canvasColorDark,
        primaryBackgroundDark: primaryBackgroundDark,
        bottomBackgroundDark: primaryBackgroundDark,
        bottomForegroundDark: secondaryColorDark,
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
    TextStyle? titleTextStyle,
    // light theme attributes
    Color secondaryColorLight = kSecondaryColor,
    Color primarySwatchLight = kPrimarySwatch,
    Color backgroundLight = kBackgroundLight,
    Color canvasColorLight = kCanvasColorLight,
    Color primaryBackgroundLight = kPrimaryBackgroundLight,
    Color bottomBackgroundLight = kPrimaryBackgroundLight,
    Color bottomForegroundLight = kSecondaryColor,
    // dark theme attributes
    Color secondaryColorDark = kSecondaryColor,
    Color primarySwatchDark = kPrimarySwatch,
    Color backgroundDark = kBackgroundDark,
    Color canvasColorDark = kCanvasColorDark,
    Color primaryBackgroundDark = kPrimaryBackgroundDark,
    Color bottomBackgroundDark = kPrimaryBackgroundDark,
    Color bottomForegroundDark = kSecondaryColor,
  }) {
    final _brightness = brightness ?? GetTheme.brightness(context);
    final _primaryBrightness = primaryBrightness ?? _brightness;
    final _bottomBrightness = bottomBrightness ?? _brightness;
    final isDark = _brightness == Brightness.dark;
    final isDarkPrimary = _primaryBrightness == Brightness.dark;
    final isDarkBottom = _bottomBrightness == Brightness.dark;
    final theme = ThemeData(brightness: _brightness);
    final bottomTheme = ThemeData(brightness: _bottomBrightness);
    final _secondaryColor = isDark ? secondaryColorDark : secondaryColorLight;
    final _primaryForeground =
        isDarkPrimary ? secondaryColorDark : secondaryColorLight;
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
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: $cast(_primarySwatch),
        accentColor: _secondaryColor,
        brightness: _brightness,
        backgroundColor: isDark ? backgroundDark : backgroundLight,
      ),
      primaryColor: _primaryBackground,
      brightness: _brightness,
      backgroundColor: isDark ? backgroundDark : backgroundLight,
      canvasColor: isDark ? canvasColorDark : canvasColorLight,
      scaffoldBackgroundColor: isDark ? canvasColorDark : canvasColorLight,
      bottomAppBarColor: _bottomBackground,
      hintColor: theme.hintColor.hinted,
      primaryColorBrightness: _primaryBrightness,
      primaryIconTheme: _primaryIconTheme,
      iconTheme: IconThemeData(
        color: _secondaryColor,
        size: 24.0,
      ),
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
          side: outlinedButtonStyle?.side ??
              GetButton.defaultSide(_secondaryColor),
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
        elevation: 1.0,
        shadowColor: Colors.black,
        color: _primaryBackground,
        titleTextStyle: TextStyle(
          fontSize: titleTextStyle?.fontSize ?? 18,
          color: titleTextStyle?.color ?? _primaryBackground.contrast,
          fontWeight: titleTextStyle?.fontWeight ?? FontWeight.w600,
          fontFamily: titleTextStyle?.fontFamily ?? fontFamily,
        ),
        toolbarTextStyle: TextStyle(
          fontSize: 14,
          color: _primaryBackground.contrast.activated,
          fontFamily: fontFamily,
        ),
        foregroundColor: _primaryBackground.contrast,
        iconTheme: _primaryIconTheme,
        actionsIconTheme: _primaryIconTheme,
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
          height: 2,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 9.8,
          fontFamily: fontFamily,
          height: 2,
        ),
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        backgroundColor: _bottomBackground,
        selectedItemColor: _bottomForeground,
        unselectedItemColor: bottomTheme.hintColor.hinted,
        selectedIconTheme: IconThemeData(size: 20),
        unselectedIconTheme: IconThemeData(size: 20),
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

  static void setErrorStyle({Color? backgroundColor, ui.TextStyle? textStyle}) {
    RenderErrorBox.backgroundColor = backgroundColor ?? kBackgroundLight;
    RenderErrorBox.textStyle = textStyle ?? kErrorTextStyle;
  }

  static void resetSystemChrome(BuildContext context) {
    setErrorStyle(backgroundColor: context.backgroundColor);
    final _systemOverlayStyle = context.systemOverlayStyle;
    if (_systemOverlayStyle != null)
      SystemChrome.setSystemUIOverlayStyle(_systemOverlayStyle);
  }
}

extension BrightnessX on Brightness {
  Brightness get inverse =>
      this == Brightness.dark ? Brightness.light : Brightness.dark;
}

extension TextStyleX on TextStyle {
  TextStyle get underlined => apply(decoration: TextDecoration.underline);

  TextStyle get italic => apply(fontStyle: FontStyle.italic);

  TextStyle get bold => copyWith(fontWeight: FontWeight.w600);

  TextStyle get bolder => copyWith(fontWeight: FontWeight.bold);
}

extension GetContextTheme on BuildContext {
  /// similar to [MediaQuery.of(context).viewPadding]
  EdgeInsets get viewPadding => mediaQuery.viewPadding;

  /// similar to [MediaQuery.of(context).viewInsets]
  EdgeInsets get viewInsets => mediaQuery.viewInsets;

  /// The overall theme brightness.
  Brightness get brightness => theme.brightness;

  /// A theme for customizing the color, elevation, brightness, iconTheme and
  /// textTheme of [AppBar]s.
  AppBarTheme get appBarTheme => theme.appBarTheme;

  /// Overrides the default value of [AppBar.systemOverlayStyle]
  /// property in all descendant [AppBar] widgets.
  SystemUiOverlayStyle? get systemOverlayStyle =>
      appBarTheme.systemOverlayStyle;

  /// [AppBar.elevation] in all descendant [AppBar] widgets. Defaults to 4.0.
  double get appBarElevation => appBarTheme.elevation ?? 4.0;

  /// [AppBar.shadowColor] in all descendant widgets. Defaults to [Colors.black].
  Color get appBarShadowColor => appBarTheme.shadowColor ?? Colors.black;

  /// Whether the title should be centered.
  /// Overrides or returns the default value for [AppBar.centerTitle].
  bool? appBarCenterTitle(bool? centerTitle, {List<Widget>? actions}) {
    if (centerTitle != null) return centerTitle;
    if (appBarTheme.centerTitle != null) return appBarTheme.centerTitle;
    switch (Get.platform) {
      case TargetPlatform.iOS:
      case TargetPlatform.macOS:
        return actions == null || actions.length < 2;
      default:
        return false;
    }
  }

  /// A text theme that contrasts with the primary color.
  TextTheme get primaryTextTheme => theme.primaryTextTheme;

  /// A set of thirteen colors that can be used to configure the
  /// color properties of most components.
  ColorScheme get colors => theme.colorScheme;

  /// The background color for primary parts of the app (app bars, tab bars, etc)
  Color get primaryColor => theme.primaryColor;

  /// An accent color that, when used sparingly, calls attention to parts
  /// of your app.
  Color get secondaryColor => colors.secondary;

  /// The default color for primary icons.
  Color? get primaryIconColor => theme.primaryIconTheme.color;

  /// An icon theme that contrasts with the primary color.
  IconThemeData get primaryIconTheme => theme.primaryIconTheme;

  /// An icon theme that contrasts with the card and canvas colors.
  IconThemeData get iconTheme => theme.iconTheme;

  /// A theme for customizing the shape, elevation, and color of a [BottomAppBar].
  BottomAppBarTheme get bottomBarTheme => theme.bottomAppBarTheme;

  /// A theme for customizing the appearance and layout of [BottomNavigationBar]
  /// widgets.
  BottomNavigationBarThemeData get bottomNavBarTheme =>
      theme.bottomNavigationBarTheme;

  /// The background color for bottom parts of the app (bottom bars, snack bars, etc)
  Color get bottomBarColor => theme.bottomAppBarColor;

  /// The color to use for hint text or placeholder text, e.g. in
  /// [TextField] fields.
  Color get hintColor => theme.hintColor;

  /// The highlight color used during ink splash animations or to
  /// indicate an item in a menu is selected.
  Color get highlightColor => theme.highlightColor;

  /// The default color of [MaterialType.canvas] [Material].
  Color get canvasColor => theme.canvasColor;

  /// A color that contrasts with the [primaryColor], e.g. used as the
  /// remaining part of a progress bar.
  Color get backgroundColor => theme.backgroundColor;

  /// The default color of the [Material] that underlies the [Scaffold]. The
  /// background color for a typical material app or a page within the app.
  Color get scaffoldBackgroundColor => theme.scaffoldBackgroundColor;

  /// Extremely large text.
  TextStyle? get headline1 => textTheme.headline1;

  /// Very, very large text.
  ///
  /// Used for the date in the dialog shown by [showDatePicker].
  TextStyle? get headline2 => textTheme.headline2;

  /// Very large text.
  TextStyle? get headline3 => textTheme.headline3;

  /// Large text.
  TextStyle? get headline4 => textTheme.headline4;

  /// Used for large text in dialogs (e.g., the month and year in the dialog
  /// shown by [showDatePicker]).
  TextStyle? get headline5 => textTheme.headline5;

  /// Used for the primary text in app bars and dialogs (e.g., [AppBar.title]
  /// and [AlertDialog.title]).
  TextStyle? get headline6 => textTheme.headline6;

  /// Used for the primary text in lists (e.g., [ListTile.title]).
  TextStyle? get subtitle1 => textTheme.subtitle1;

  /// For medium emphasis text that's a little smaller than [subtitle1].
  TextStyle? get subtitle2 => textTheme.subtitle2;

  /// Used for emphasizing text that would otherwise be [bodyText2].
  TextStyle? get bodyText1 => textTheme.bodyText1;

  /// The default text style for [Material].
  TextStyle? get bodyText2 => textTheme.bodyText2;

  /// Used for auxiliary text associated with images.
  TextStyle? get caption => textTheme.caption;

  /// Used for text on [ElevatedButton], [TextButton] and [OutlinedButton].
  TextStyle? get button => textTheme.button;

  /// The smallest style.
  ///
  /// Typically used for captions or to introduce a (larger) headline.
  TextStyle? get overline => textTheme.overline;

  /// Extremely large text that contrasts with the primary color.
  TextStyle? get primaryHeadline1 => primaryTextTheme.headline1;

  /// Very, very large text that contrasts with the primary color.
  ///
  /// Used for the date in the dialog shown by [showDatePicker].
  TextStyle? get primaryHeadline2 => primaryTextTheme.headline2;

  /// Very large text that contrasts with the primary color.
  TextStyle? get primaryHeadline3 => primaryTextTheme.headline3;

  /// Large text that contrasts with the primary color.
  TextStyle? get primaryHeadline4 => primaryTextTheme.headline4;

  /// Used for large text in dialogs (e.g., the month and year in the dialog
  /// shown by [showDatePicker]) that contrasts with the primary color.
  TextStyle? get primaryHeadline5 => primaryTextTheme.headline5;

  /// Used for the primary text in app bars and dialogs (e.g., [AppBar.title]
  /// and [AlertDialog.title]) that contrasts with the primary color.
  TextStyle? get primaryHeadline6 => primaryTextTheme.headline6;

  /// Used for the primary text in lists (e.g., [ListTile.title]) that
  /// contrasts with the primary color.
  TextStyle? get primarySubtitle1 => primaryTextTheme.subtitle1;

  /// For medium emphasis text that's a little smaller than [subtitle1] and
  /// contrasts with the primary color.
  TextStyle? get primarySubtitle2 => primaryTextTheme.subtitle2;

  /// Used for emphasizing text that would otherwise be [bodyText2] and
  /// contrasts with the primary color.
  TextStyle? get primaryBodyText1 => primaryTextTheme.bodyText1;

  /// The default text style for [Material] that contrasts with the
  /// primary color.
  TextStyle? get primaryBodyText2 => primaryTextTheme.bodyText2;

  /// Used for auxiliary text associated with images that contrasts
  /// with the primary color.
  TextStyle? get primaryCaption => primaryTextTheme.caption;

  /// Used for text on [ElevatedButton], [TextButton] and [OutlinedButton]
  /// that contrasts with the primary color.
  TextStyle? get primaryButton => primaryTextTheme.button;

  /// The smallest style that contrasts with the primary color.
  ///
  /// Typically used for captions or to introduce a (larger) headline.
  TextStyle? get primaryOverline => primaryTextTheme.overline;
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
