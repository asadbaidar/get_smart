import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

extension ColorX on Color {
  bool get isDark => (299 * red + 587 * green + 114 * blue) / 1000 < 162;

  Color get contrast => isDark ? Colors.white : Colors.black;

  Brightness get brightness => isDark ? Brightness.light : Brightness.dark;

  Color get darker => withBlue(max(blue - 50, 0))
      .withGreen(max(green - 50, 0))
      .withRed(max(red - 50, 0));

  Color get themeAware => isDark
      ? (GetTheme.isDarkMode ? Colors.white : this)
      : (GetTheme.isDarkMode ? this : Colors.black);

  MaterialColor? get material =>
      this is MaterialColor ? this as MaterialColor? : null;

  MaterialAccentColor? get materialAccent =>
      this is MaterialAccentColor ? this as MaterialAccentColor? : null;

  Color get activated => withOpacity(0.05);

  Color get translucent => withOpacity(0.15);

  Color get dimmed => withOpacity(0.2);

  Color get hinted => withOpacity(0.34);

  Color get subbed => withOpacity(0.6);

  Color get highlighted => withOpacity(0.727);

  Color get actioned => withOpacity(0.9);

  Color get normal => withOpacity(1);
}

abstract class GetColors {
  static const black90 = const Color(0xFF131313);
  static const black93 = const Color(0xFF0C0C0C);

  static const MaterialColor black = const MaterialColor(
    0xFF000000,
    <int, Color>{
      50: Color(0xFFDDDDDD),
      100: Color(0xFF797979),
      200: Color(0xFF424242),
      300: Color(0xFF303030),
      400: Color(0xFF222222),
      500: Color(0xFF000000),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor white = const MaterialColor(
    0xFFFFFFFF,
    <int, Color>{
      50: Color(0x1FFFFFFF),
      100: Color(0x4DFFFFFF),
      200: Color(0x8AFFFFFF),
      300: Color(0x99FFFFFF),
      400: Color(0xB3FFFFFF),
      500: Color(0xFFFFFFFF),
      600: Color(0xFFFFFFFF),
      700: Color(0xFFFFFFFF),
      800: Color(0xFFFFFFFF),
      900: Color(0xFFFFFFFF),
    },
  );
}
