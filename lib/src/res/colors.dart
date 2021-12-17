import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

extension ColorX on Color {
  bool get isDark => (299 * red + 587 * green + 114 * blue) / 1000 < 162;

  Color get contrast => isDark ? Colors.white : Colors.black;

  Brightness get brightness => isDark ? Brightness.light : Brightness.dark;

  ThemeData get theme => isDark ? ThemeData.dark() : ThemeData.light();

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

  Color get highlighted => withOpacity(0.05);

  Color get lighted => withOpacity(0.15);

  Color get dimmed => withOpacity(0.2);

  Color get hinted => withOpacity(0.34);

  Color get subbed => withOpacity(0.55);

  Color get focused => withOpacity(0.727);

  Color get activated => withOpacity(0.9);

  Color get translucent => withOpacity(0.95);

  Color get normal => withOpacity(1);
}

abstract class GetColors {
  static const black85 = Color(0xFF1D1D1D);
  static const black90 = Color(0xFF131313);
  static const black93 = Color(0xFF0C0C0C);

  static const white93 = Color(0xfffefefe);
  static const white90 = Color(0xfff7f7f7);
  static const white85 = Color(0xffefefef);

  static const grey = Color(0xff777777);
  static const greyLight = Color(0xffB5B5B5);
  static const greyDark = Color(0xff5B5B5B);
  static const blackMatte = Color(0xff090909);
  static const charcoal = Color(0xff252525);
  static const charcoalDark = Color(0xff101010);
  static const livid = Color(0xff395b74);
  static const lividLight = Color(0xff78909c);
  static const lividDark = Color(0xff2d495e);
  static const yellow = Color(0xfffbc02d);
  static const yellowDark = Color(0xffdaa206);
  static const yellowDarker = Color(0xffd88916);
  static const amber = Color(0xffffca28);
  static const orange = Color(0xffe5680f);
  static const orangeLight = Color(0xffff7043);
  static const orangeDark = Color(0xffd66000);
  static const orangeEve = Color(0xffe84d01);
  static const brown = Color(0xff795548);
  static const red = Color(0xffd50000);
  static const redLight = Color(0xffef5350);
  static const redDark = Color(0xffb40000);
  static const cherry = Color(0xffc72349);
  static const cherryDark = Color(0xffaf1e40);
  static const pink = Color(0xffad1457);
  static const pinkLight = Color(0xffec407a);
  static const pinkDark = Color(0xff790e3c);
  static const sky = Color(0xff1E88E5);
  static const skyLight = Color(0xff42a5f5);
  static const skyDark = Color(0xff0277bd);
  static const blue = Color(0xff1769aa);
  static const blueDark = Color(0xff14578c);
  static const indigo = Color(0xff3F51B5);
  static const indigoLight = Color(0xff5c6bc0);
  static const indigoDark = Color(0xff2c387e);
  static const purple = Color(0xff9c27b0);
  static const purpleLight = Color(0xffab47bc);
  static const purpleDark = Color(0xff6d1b7b);
  static const purpleEve = Color(0xff723b48);
  static const violet = Color(0xff673ab7);
  static const violetDark = Color(0xff482880);
  static const plum = Color(0xff625b91);
  static const plumLight = Color(0xff7e57c2);
  static const plumDark = Color(0xff514a78);
  static const teal = Color(0xff039694);
  static const tealLight = Color(0xff4DB6AC);
  static const tealDark = Color(0xff006974);
  static const green = Color(0xff0F9D58);
  static const greenLight = Color(0xff7cb342);
  static const greenLighter = Color(0xff66bb6a);
  static const greenDark = Color(0xff0d844a);

  static Color primary(String seed) =>
      primaries[seed.randomIn(primaries.length)];

  static Color accent(String seed) => accents[seed.randomIn(accents.length)];

  static Color material(String seed) =>
      materials[seed.randomIn(materials.length)];

  static Color mix(String seed) => mixes[seed.randomIn(mixes.length)];

  static const mixes = [
    ...materials,
    ...primaries,
    ...accents,
  ];

  static const primaries = Colors.primaries;
  static const accents = Colors.accents;
  static const materials = [
    charcoal,
    charcoalDark,
    livid,
    lividLight,
    lividDark,
    yellow,
    yellowDark,
    yellowDarker,
    amber,
    orange,
    orangeLight,
    orangeDark,
    orangeEve,
    brown,
    red,
    redLight,
    redDark,
    cherry,
    cherryDark,
    pink,
    pinkLight,
    pinkDark,
    sky,
    skyLight,
    skyDark,
    blue,
    blueDark,
    indigo,
    indigoLight,
    indigoDark,
    purple,
    purpleLight,
    purpleDark,
    purpleEve,
    violet,
    violetDark,
    plum,
    plumLight,
    plumDark,
    teal,
    tealLight,
    tealDark,
    green,
    greenLight,
    greenLighter,
    greenDark,
  ];

  static const MaterialColor black = MaterialColor(
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

  static const MaterialColor white = MaterialColor(
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
