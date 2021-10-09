// ignore_for_file: constant_identifier_names

import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';

class GetIcons {
  GetIcons._();

  static const _kFontFam = "GetIcons";
  static const _kFontPkg = "get_smart";

  static const IconData apple_filled =
      IconData(0xe800, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bag =
      IconData(0xe801, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bag_rect =
      IconData(0xe802, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bag_rect_wide =
      IconData(0xe803, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmark =
      IconData(0xe804, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData bookmark_wide =
      IconData(0xe805, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData circle =
      IconData(0xe806, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData content =
      IconData(0xe807, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData download =
      IconData(0xe808, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData doctor_filled =
      IconData(0xe809, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData download_cloud =
      IconData(0xe80a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData download_tray =
      IconData(0xe80b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData facebook_filled =
      IconData(0xe80c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData file =
      IconData(0xe80d, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData google_colored =
      IconData(0xe80e, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData help =
      IconData(0xe80f, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData history =
      IconData(0xe810, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData magazine =
      IconData(0xe811, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData magazine_wide =
      IconData(0xe812, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData nurse_filled =
      IconData(0xe813, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData rectangle_vert =
      IconData(0xe814, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData search =
      IconData(0xe815, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData settings =
      IconData(0xe816, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData share =
      IconData(0xe817, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData shop =
      IconData(0xe818, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData stack_right =
      IconData(0xe819, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData text =
      IconData(0xe81a, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData unlocked =
      IconData(0xe81b, fontFamily: _kFontFam, fontPackage: _kFontPkg);
  static const IconData upload_cloud =
      IconData(0xe81c, fontFamily: _kFontFam, fontPackage: _kFontPkg);
}

/// Icon asset names
enum GetIconAsset {
  find,
  apple_filled,
  bag,
  bag_rect,
  bag_rect_wide,
  bookmark,
  bookmark_wide,
  circle,
  content,
  doctor_filled,
  download,
  download_cloud,
  download_tray,
  facebook_filled,
  file,
  google_colored,
  help,
  history,
  magazine,
  magazine_wide,
  nurse_filled,
  rectangle_vert,
  search,
  settings,
  share,
  shop,
  stack_right,
  text,
  unlocked,
  upload_cloud,
}

/// Image asset names
enum GetImageAsset {
  find,
  appstore,
  playstore,
}

/// Asset directories mapping for easy access.
/// <p>
/// ### Usage
/// ```
/// IconAsset.my_icon_name.png
/// ```
/// <p>
/// ### How it works
/// If you want to add new file type extension for assets, then just make a
/// copy of [$png] or any defined type in [AssetX] and add it in the
/// desired extension for Object class.
///
/// To use it, make an enum named Asset at the end and put the same asset
/// name in that as in the asset directory
/// i.e for icon directory, enum name must be as IconAsset
/// <p>
/// ### Some key practices
///
/// - Don't add file type extensions in the object of enums meaning no png or
/// jpg at the end.
///
/// - Use the underscore naming convention for all files in asset directory.
///
/// - If you want to add new directory in assets, then make a similar enum
/// with specific name and maps its directory name in [AssetX].
///
/// - Also map that directory in `pubspec.yaml` under the assets property.
extension GetAsset on Object {
  static const package = "get_smart";

  String get $svg => "$_name.svg";

  String get $png => "$_name.png";

  String get $gif => "$_name.gif";

  String get $jpg => "$_name.jpg";

  String get $jpeg => "$_name.jpeg";

  String get $pdf => "$_name.pdf";

  String _asset([String? name]) =>
      "assets/" +
      typeName.replaceAll("Asset", "").replaceAll("Get", "").lowercase +
      "/${name ?? keyName}";

  String get _name => this is String ? this as String : _asset();

  String $asset(String name) => _asset(name);
}
