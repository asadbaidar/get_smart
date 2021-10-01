import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

const kDensePadding = 8.0;
const kDensePaddingX = 8.0;
const kDensePaddingY = 8.0;

const kMediumPadding = 12.0;
const kMediumPaddingX = 12.0;
const kMediumPaddingY = 12.0;

const kStandardPadding = 16.0;
const kStandardPaddingX = 16.0;
const kStandardPaddingY = 11.0;

const kExtendedPadding = 16.0;
const kExtendedPaddingX = 16.0;
const kExtendedPaddingY = 14.0;

const kDensePaddingAll = const EdgeInsets.all(kDensePadding);
const kMediumPaddingAll = const EdgeInsets.all(kMediumPadding);
const kStandardPaddingAll = const EdgeInsets.all(kStandardPadding);
const kExtendedPaddingAll = const EdgeInsets.all(kExtendedPadding);

const kDensePaddingH = const EdgeInsets.symmetric(
  horizontal: kDensePaddingX,
);
const kMediumPaddingH = const EdgeInsets.symmetric(
  horizontal: kMediumPaddingX,
);
const kStandardPaddingH = const EdgeInsets.symmetric(
  horizontal: kStandardPaddingX,
);
const kExtendedPaddingH = const EdgeInsets.symmetric(
  horizontal: kExtendedPaddingX,
);

const kDensePaddingV = const EdgeInsets.symmetric(
  horizontal: kDensePaddingY,
);
const kMediumPaddingV = const EdgeInsets.symmetric(
  horizontal: kMediumPaddingY,
);
const kStandardPaddingV = const EdgeInsets.symmetric(
  horizontal: kStandardPaddingY,
);
const kExtendedPaddingV = const EdgeInsets.symmetric(
  horizontal: kExtendedPaddingY,
);

const kStandardPaddingForm = const EdgeInsets.symmetric(
  horizontal: kStandardPaddingX,
  vertical: 4,
);

const kTileConstraints = const BoxConstraints(minHeight: 31);
const kTileFontSize = 14.0;
const kTileRowFontSize = 12.0;

const kTileRowLeadingMargin = EdgeInsets.zero;
const kTileRowLeadingPadding = const EdgeInsets.only(right: kStandardPaddingX);
const kTileRowLeadingDensePadding = const EdgeInsets.only(
  right: kDensePaddingX,
);
const kTileRowLeadingMediumPadding = const EdgeInsets.only(
  right: kMediumPaddingX,
);
const kTileRowTrailingPadding = const EdgeInsets.only(left: 6);
const kTileRowChildrenPadding = const EdgeInsets.all(0.5);
const kTileRowConstraints = const BoxConstraints(minHeight: 26.5);
const kTileRowTrailingSize = 20.0;
const kTileRowLeadingSmallSize = 20.0;
const kTileRowMaxLines = 2;

class GetTileData extends GetObject {
  @override
  List<Function> get builders => [() => GetTileData()];

  GetTileData({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.subTiles = const [],
    Color? color,
    this.background,
    this.value,
    this.header,
    this.isHeader = false,
    this.leadingFilled,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.trailingPadding,
    this.titleSize,
    this.accessorySize,
    this.height,
    this.onTap,
    this.onTapLeading,
  }) : tintColor = color;

  IconData? leading;
  String? title;
  String? subtitle;
  String? trailingTop;
  String? trailingBottom;
  IconData? accessory;
  List<GetTileData> subTiles;
  Color? tintColor;
  Color? background;
  dynamic value;
  dynamic header;
  bool isHeader;
  bool? leadingFilled;
  bool detail;
  bool? padAccessory;
  bool? showAccessory;
  bool? tintAccessory;
  bool? tintAble;
  bool? destructive;
  bool? enabled;
  double? horizontalPadding;
  double? verticalPadding;
  double? topPadding;
  double? bottomPadding;
  double? trailingPadding;
  double? titleSize;
  double? accessorySize;
  double? height;
  VoidCallback? onTap;
  VoidCallback? onTapLeading;

  bool get hasSubTiles => subTiles.isNotEmpty == true;

  @override
  String get description => title ?? "";

  @override
  Color get color => tintColor ?? title?.materialAccent ?? super.color;
}

class GetTile extends StatelessWidget {
  /// Tile with detail accessory
  const GetTile.detail({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = true,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with detail accessory and should be used if have extended content
  const GetTile.detailExtend({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = true,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kExtendedPaddingY,
    this.bottomPadding = kExtendedPaddingY,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory
  const GetTile.simple({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and should be used if have extended content
  const GetTile.extend({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kExtendedPaddingY,
    this.bottomPadding = kExtendedPaddingY,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and dense paddings
  const GetTile.dense({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kDensePaddingY,
    this.bottomPadding = kDensePaddingY,
    this.leftPadding = kDensePaddingX,
    this.rightPadding = kDensePaddingX,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingDensePadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and medium paddings
  const GetTile.medium({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kMediumPaddingY,
    this.bottomPadding = kMediumPaddingY,
    this.leftPadding = kMediumPaddingX,
    this.rightPadding = kMediumPaddingX,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingMediumPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and centered content alignment
  const GetTile.center({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, w500 title and simple centered content alignment
  const GetTile.center500({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = false,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w500,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile having rich features with no accessory and top leading
  const GetTile.rich({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = true,
    this.leadingOval = true,
    this.detail = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding = kMediumPaddingX,
    this.rightPadding = kMediumPaddingX,
    this.trailingPadding,
    this.verticalSpacing = 5,
    this.titleSize = kTileRowFontSize,
    this.subtitleSize = kTileRowFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingMediumPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = const BoxConstraints(minHeight: 34),
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile having row features with no accessory and centered leading
  const GetTile.row({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = true,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kDensePaddingY,
    this.bottomPadding = kDensePaddingY,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileRowFontSize,
    this.subtitleSize = kTileRowFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile having row features with no accessory and top leading
  const GetTile.rowRich({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = true,
    this.leadingSmall = true,
    this.leadingOval = true,
    this.detail = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kStandardPaddingY,
    this.bottomPadding = kStandardPaddingY,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.trailingPadding,
    this.verticalSpacing = 5,
    this.titleSize = kTileRowFontSize,
    this.subtitleSize = kTileRowFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile having row features with no accessory and anchored leading at top
  const GetTile.rowExtend({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kDensePaddingY,
    this.bottomPadding = kDensePaddingY,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileRowFontSize,
    this.subtitleSize = kTileRowFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background and not filled but oval leading
  const GetTile.plain({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = false,
    this.leadingSmall = false,
    this.leadingOval = true,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 0,
    this.bottomPadding = 10,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background, no side paddings, and not filled
  /// but oval leading.
  /// Most compatible to show user profile data.
  const GetTile.profile({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = false,
    this.leadingSmall = false,
    this.leadingOval = true,
    this.detail = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.titleWeight = FontWeight.w600,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.leftPadding = 0,
    this.rightPadding = 0,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines = 1,
    this.subtitleMaxLines = 1,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingDensePadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background and no filled leading and
  /// have tinted accessory, and horizontal padding of 4dp.
  const GetTile.item({
    this.leading,
    this.title,
    this.subtitle,
    this.titleChild,
    this.subtitleChild,
    this.titleChildren,
    this.subtitleChildren,
    this.titleHint,
    this.subtitleHint,
    this.trailingTop,
    this.trailingTopChild,
    this.trailingBottom,
    this.trailingBottomChild,
    this.trailingTitle,
    this.trailingTitleChild,
    this.trailingSubtitle,
    this.trailingSubtitleChild,
    this.titleStyle,
    this.subtitleStyle,
    this.trailingStyle,
    this.accessory,
    this.rows,
    this.belowRows,
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.detail = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory = true,
    this.tintAble,
    this.titleWeight,
    this.subtitleWeight,
    this.titleSubbed = false,
    this.subtitleSubbed = true,
    this.destructive,
    this.titleExpanded = false,
    this.subtitleExpanded = false,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding = 4,
    this.rightPadding = 4,
    this.trailingPadding,
    this.verticalSpacing = 0,
    this.titleSize = kTileFontSize,
    this.subtitleSize = kTileFontSize,
    this.leadingSize,
    this.accessorySize = kTileRowTrailingSize,
    this.trailingSize = kTileRowTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.titleChildrenPadding = kTileRowChildrenPadding,
    this.subtitleChildrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final dynamic leading;
  final String? title;
  final String? subtitle;
  final Widget? titleChild;
  final Widget? subtitleChild;
  final List<Widget>? titleChildren;
  final List<Widget>? subtitleChildren;
  final String? titleHint;
  final String? subtitleHint;
  final String? trailingTop;
  final Widget? trailingTopChild;
  final String? trailingBottom;
  final Widget? trailingBottomChild;
  final String? trailingTitle;
  final Widget? trailingTitleChild;
  final String? trailingSubtitle;
  final Widget? trailingSubtitleChild;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? trailingStyle;
  final Widget? accessory;
  final List<Widget>? rows;
  final List<Widget>? belowRows;
  final Color? color;
  final Color? background;
  final Color? headColor;
  final Color? trailingColor;
  final bool leadingFilled;
  final bool leadingSmall;
  final bool leadingOval;
  final bool detail;
  final bool? padAccessory;
  final bool? showAccessory;
  final bool? tintAccessory;
  final bool? tintAble;
  final FontWeight? titleWeight;
  final FontWeight? subtitleWeight;
  final bool titleSubbed;
  final bool subtitleSubbed;
  final bool? destructive;
  final bool titleExpanded;
  final bool subtitleExpanded;
  final bool enabled;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final double? trailingPadding;
  final double verticalSpacing;
  final double? titleSize;
  final double? subtitleSize;
  final double? leadingSize;
  final double? accessorySize;
  final double? trailingSize;
  final int? titleMaxLines;
  final int? subtitleMaxLines;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry leadingMargin;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry titleChildrenPadding;
  final EdgeInsetsGeometry subtitleChildrenPadding;
  final BoxConstraints? constraints;
  final CrossAxisAlignment alignment;
  final VoidCallback? onTapTitle;
  final VoidCallback? onTapSubtitle;
  final VoidCallback? onTap;
  final VoidCallback? onTapHead;
  final VoidCallback? onTapLeading;

  @override
  Widget build(BuildContext context) {
    final _tintAble = destructive == true ? true : (tintAble ?? false);
    final tintColor =
        destructive == true ? Colors.red : color ?? context.secondaryColor;
    final _trailingColor = _tintAble
        ? tintColor
        : trailingColor ?? context.iconColor ?? context.secondaryColor;
    final isTrailingTop =
        trailingTop?.notEmpty != null || trailingTopChild != null;
    final isTrailingBottom =
        trailingBottom?.notEmpty != null || trailingBottomChild != null;
    final isTrailingTitle =
        trailingTitle?.notEmpty != null || trailingTitleChild != null;
    final isTrailingSubtitle =
        trailingSubtitle?.notEmpty != null || trailingSubtitleChild != null;
    final _accessory = accessory ??
        (detail == true ? const Icon(CupertinoIcons.chevron_right) : null);
    final _isTitle = title?.notEmpty != null ||
        titleHint?.notEmpty != null ||
        titleChild != null ||
        titleChildren?.isNotEmpty == true;
    final _isSubtitle = subtitle?.notEmpty != null ||
        subtitleHint?.notEmpty != null ||
        subtitleChild != null ||
        subtitleChildren?.isNotEmpty == true;
    final _showAccessory = _accessory != null && (showAccessory ?? true);
    final _showTrailing = isTrailingTop ||
        isTrailingBottom ||
        isTrailingTitle ||
        isTrailingSubtitle;
    final _trailingPadding =
        trailingPadding?.mapIt((it) => EdgeInsets.only(left: it)) ??
            kTileRowTrailingPadding;
    final _titleStyle = (titleStyle ?? context.bodyText2);
    final _titleColor = _tintAble ? tintColor : _titleStyle?.color;
    final _subtitleStyle = subtitleStyle ?? context.bodyText2;
    final _subtitleColor = _tintAble ? tintColor : _subtitleStyle?.color;
    final _leftPadding = horizontalPadding ?? leftPadding ?? kStandardPaddingX;
    final _rightPadding =
        horizontalPadding ?? rightPadding ?? kStandardPaddingX;
    final _topPadding = verticalPadding ?? topPadding ?? kStandardPaddingY;
    final _bottomPadding =
        verticalPadding ?? bottomPadding ?? kStandardPaddingY;
    final _padding = padding ??
        EdgeInsets.only(
          left: _leftPadding,
          right: padAccessory == true
              ? _rightPadding
              : _showAccessory
                  ? 6.0
                  : _showTrailing
                      ? _rightPadding
                      : 0.0,
          top: _topPadding,
          bottom: _bottomPadding.half,
        );
    return InkWell(
      highlightColor: tintColor.highlighted,
      splashColor: tintColor.lighted,
      onTap: enabled ? onTap : null,
      child: Ink(
        color: background ?? context.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GetTileRow.simple(
              child: Column(children: [
                GetTileRow.simple(
                  child: titleChild,
                  children: titleChildren,
                  childrenPadding: titleChildrenPadding,
                  text: title?.notEmpty,
                  textStyle: _titleStyle?.copyWith(
                    color: _titleColor?.applyIf(
                      titleSubbed,
                      (it) => it.subbed,
                    ),
                  ),
                  fontWeight: titleWeight,
                  fontSize: titleSize,
                  hint: titleHint,
                  trailingText: trailingTitle,
                  trailingStyle: trailingStyle,
                  trailing: trailingTitleChild,
                  trailingPadding: _trailingPadding,
                  trailingColor: trailingColor,
                  trailingSize: trailingSize,
                  color: tintColor,
                  maxLines: titleMaxLines,
                  expanded: titleExpanded,
                  alignment: alignment == CrossAxisAlignment.center
                      ? alignment
                      : CrossAxisAlignment.baseline,
                  enabled: enabled,
                  padding: EdgeInsets.zero,
                  onTap: onTapTitle,
                ),
                if (_isTitle && _isSubtitle) verticalSpacing.spaceY,
                GetTileRow.simple(
                  child: subtitleChild,
                  children: subtitleChildren,
                  childrenPadding: subtitleChildrenPadding,
                  text: subtitle?.notEmpty,
                  textStyle: _subtitleStyle?.copyWith(
                    color: _subtitleColor?.applyIf(
                      subtitleSubbed,
                      (it) => it.subbed,
                    ),
                  ),
                  fontWeight: subtitleWeight,
                  fontSize: subtitleSize,
                  hint: subtitleHint,
                  trailingText: trailingSubtitle,
                  trailingStyle: trailingStyle,
                  trailing: trailingSubtitleChild,
                  trailingPadding: _trailingPadding,
                  trailingColor: trailingColor,
                  trailingSize: trailingSize,
                  color: tintColor,
                  maxLines: subtitleMaxLines,
                  expanded: subtitleExpanded,
                  alignment: alignment == CrossAxisAlignment.center
                      ? alignment
                      : CrossAxisAlignment.baseline,
                  enabled: enabled,
                  padding: EdgeInsets.zero,
                  onTap: onTapSubtitle,
                )
              ]),
              leading: leading,
              leadingSize: leadingSize,
              leadingSmall: leadingSmall,
              leadingFilled: leadingFilled,
              leadingOval: leadingOval,
              leadingMargin: leadingMargin,
              leadingPadding: leadingPadding,
              detail: detail,
              constraints: constraints,
              color: color,
              background: headColor,
              alignment: alignment,
              enabled: enabled,
              padding: _padding,
              onTap: onTapHead,
              onTapLeading: onTapLeading,
              trailingSize: accessorySize,
              trailingColor:
                  tintAccessory == true ? tintColor : context.hintColor,
              trailingStyle: trailingStyle,
              trailingPadding: _trailingPadding,
              trailing: _showAccessory || isTrailingTop || isTrailingBottom
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (trailingPadding != null)
                          SizedBox(width: trailingPadding),
                        if (isTrailingTop || isTrailingBottom)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (isTrailingTop)
                                trailingTopChild?.mapIt((it) => IconTheme(
                                          data: IconThemeData(
                                            color: _trailingColor,
                                            size: trailingSize,
                                          ),
                                          child: it!,
                                        )) ??
                                    Text(
                                      trailingTop!,
                                      style: trailingStyle ?? context.caption,
                                    ),
                              if (isTrailingTop && isTrailingBottom)
                                SizedBox(height: 1.5),
                              if (isTrailingBottom)
                                trailingBottomChild?.mapIt((it) => IconTheme(
                                          data: IconThemeData(
                                            color: _trailingColor,
                                            size: trailingSize,
                                          ),
                                          child: it!,
                                        )) ??
                                    Text(
                                      trailingBottom!,
                                      style: trailingStyle ?? context.caption,
                                    ),
                            ],
                          ),
                        if (_showAccessory)
                          Padding(
                            padding: isTrailingTop || isTrailingBottom
                                ? (detail
                                    ? const EdgeInsets.only(left: 2)
                                    : _trailingPadding)
                                : EdgeInsets.zero,
                            child: IconTheme(
                              data: IconThemeData(
                                color: tintAccessory == true
                                    ? tintColor
                                    : context.hintColor,
                                size: detail ? 14 : accessorySize,
                              ),
                              child: _accessory!,
                            ),
                          ),
                      ],
                    )
                  : null,
            ),
            ...rows ?? [],
            SizedBox(height: _bottomPadding.half),
            ...belowRows ?? [],
          ],
        ),
      ),
    );
  }
}

class GetTileRow extends StatelessWidget {
  /// Row with simple content
  const GetTileRow.simple({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with simple content and dense paddings
  const GetTileRow.dense({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kDensePaddingY,
    this.bottomPadding = kDensePaddingY,
    this.leftPadding = kDensePaddingX,
    this.rightPadding = kDensePaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingDensePadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with simple content and medium paddings
  const GetTileRow.medium({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kMediumPaddingY,
    this.bottomPadding = kMediumPaddingY,
    this.leftPadding = kMediumPaddingX,
    this.rightPadding = kMediumPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingMediumPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with extended content
  const GetTileRow.extend({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = true,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.start,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with grouped header content including top/bottom separators
  const GetTileRow.header({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 28,
    this.bottomPadding,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = true,
    this.header = true,
    this.topSeparator = SeparatorStyle.full,
    this.bottomSeparator = SeparatorStyle.full,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with grouped header content without top/bottom separators
  const GetTileRow.headerPlain({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 28,
    this.bottomPadding,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = true,
    this.header = true,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with grouped header dense content including top/bottom separators
  const GetTileRow.headerDense({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 16,
    this.bottomPadding,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = true,
    this.header = true,
    this.topSeparator = SeparatorStyle.full,
    this.bottomSeparator = SeparatorStyle.full,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with grouped header dense content including bottom separator only
  const GetTileRow.headerTopDense({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 16,
    this.bottomPadding,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = true,
    this.header = true,
    this.topSeparator,
    this.bottomSeparator = SeparatorStyle.full,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with grouped header dense content without top/bottom separators
  const GetTileRow.headerPlainDense({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 16,
    this.bottomPadding,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = true,
    this.header = true,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with dense header content and without top separator to use at
  /// top of the views
  const GetTileRow.headerTop({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 28,
    this.bottomPadding,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = true,
    this.header = true,
    this.topSeparator,
    this.bottomSeparator = SeparatorStyle.full,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with wrapped layout and can be used in the buttons too
  const GetTileRow.wrap({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize = kTileRowFontSize,
    this.leadingSize,
    this.leadingBoxSize = 24,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = false,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = false,
    this.wrap = true,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingDensePadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with rich content
  const GetTileRow.rich({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize = kTileRowFontSize,
    this.leadingSize = kTileRowLeadingSmallSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = 0,
    this.bottomPadding = 0,
    this.leftPadding = kStandardPaddingX,
    this.rightPadding = kStandardPaddingX,
    this.expanded = false,
    this.leadingFilled = true,
    this.leadingSmall = true,
    this.leadingOval = true,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileRowConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Row with simple content and layout as [GetTile.simple]
  const GetTileRow.item({
    this.leading,
    this.trailing,
    this.trailingText,
    this.trailingStyle,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.trailingColor,
    this.maxLines = kTileRowMaxLines,
    this.fontWeight,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxView.kBoxSize,
    this.trailingSize = kTileRowTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding = kStandardPaddingY,
    this.bottomPadding = kStandardPaddingY,
    this.leftPadding,
    this.rightPadding,
    this.expanded = true,
    this.leadingFilled = true,
    this.leadingSmall = true,
    this.leadingOval = false,
    this.themed = true,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.detail = false,
    this.allCaps = false,
    this.header = false,
    this.topSeparator,
    this.bottomSeparator,
    this.padding,
    this.leadingMargin = kTileRowLeadingMargin,
    this.leadingPadding = kTileRowLeadingPadding,
    this.trailingPadding = kTileRowTrailingPadding,
    this.childrenPadding = kTileRowChildrenPadding,
    this.constraints = kTileConstraints,
    this.alignment: CrossAxisAlignment.start,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final dynamic leading;
  final Widget? trailing;
  final String? trailingText;
  final TextStyle? trailingStyle;
  final List<Widget>? children;
  final Widget? child;
  final String? text;
  final TextStyle? textStyle;
  final String? hint;
  final Color? color;
  final Color? background;
  final Color? trailingColor;
  final int? maxLines;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? leadingSize;
  final double leadingBoxSize;
  final double? trailingSize;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final bool expanded;
  final bool leadingFilled;
  final bool leadingSmall;
  final bool leadingOval;
  final bool themed;
  final bool wrap;
  final bool enabled;
  final bool tintAble;
  final bool? destructive;
  final bool detail;
  final bool allCaps;
  final bool header;
  final SeparatorStyle? topSeparator;
  final SeparatorStyle? bottomSeparator;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry leadingMargin;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry trailingPadding;
  final EdgeInsetsGeometry childrenPadding;
  final BoxConstraints? constraints;
  final CrossAxisAlignment alignment;
  final VoidCallback? onTap;
  final VoidCallback? onTapLeading;

  @override
  Widget build(BuildContext context) {
    final _text = (text ?? hint)?.applyIf(allCaps, (String it) => it.uppercase);
    final _color = context.primaryIconColor ?? context.secondaryColor;
    final _tintColor = destructive == true ? Colors.red : color ?? _color;
    final _tintAble = destructive == true || tintAble;
    final _trailingColor = trailingColor ??
        (detail
            ? context.hintColor
            : _tintAble
                ? _tintColor
                : _color);
    final _textStyle =
        (textStyle ?? context.caption)?.copyWith(fontWeight: fontWeight);
    final _constrained = alignment == CrossAxisAlignment.start ||
        alignment == CrossAxisAlignment.end;
    final _trailing =
        trailing ?? (detail ? const Icon(CupertinoIcons.chevron_right) : null);
    final _showTrailing = trailing != null || trailingText?.notEmpty != null;
    final _boxedView = $cast<BoxView>(leading);
    return _text?.notEmpty == null &&
            child == null &&
            children?.isNotEmpty != true
        ? Container(height: 0, width: 0)
        : InkWell(
            highlightColor: _tintColor.highlighted,
            splashColor: _tintColor.lighted,
            onTap: enabled ? onTap : null,
            child: Ink(
              color: background ??
                  (themed == true ? context.backgroundColor : null),
              padding: padding ??
                  EdgeInsets.only(
                    left: horizontalPadding ?? leftPadding ?? kStandardPaddingX,
                    right:
                        horizontalPadding ?? rightPadding ?? kStandardPaddingX,
                    top: verticalPadding ?? topPadding ?? kDensePaddingY,
                    bottom: verticalPadding ?? bottomPadding ?? kDensePaddingY,
                  ),
              child: Row(
                mainAxisSize: wrap ? MainAxisSize.min : MainAxisSize.max,
                crossAxisAlignment: alignment,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  CrossFade(
                    showFirst: leading != null,
                    firstChild: leading != null
                        ? Container(
                            constraints: _constrained ? constraints : null,
                            alignment: Alignment.center,
                            padding: leadingMargin,
                            child: BoxView(
                              child: _boxedView?.child ?? leading!,
                              color: _boxedView?.color ?? _tintColor,
                              filled: _boxedView?.filled ?? leadingFilled,
                              margin: _boxedView?.margin ?? leadingPadding,
                              small: _boxedView?.small ?? leadingSmall,
                              wrap: _boxedView?.wrap ?? false,
                              boxSize: _boxedView?.boxSize ?? leadingBoxSize,
                              fontSize: _boxedView?.fontSize,
                              iconSize: _boxedView?.iconSize ?? leadingSize,
                              oval: _boxedView?.oval ?? leadingOval,
                              onTap: _boxedView?.onTap ?? onTapLeading,
                            ),
                          )
                        : null,
                  ),
                  CrossFade(
                    firstChild: Container(
                      constraints: _constrained ? constraints : null,
                      alignment: Alignment.centerLeft,
                      child: child ??
                          RichText(
                            text: TextSpan(
                              text: _text,
                              style: _textStyle?.copyWith(
                                color: text == null ? context.hintColor : null,
                                fontSize: fontSize,
                              ),
                              children: children
                                  ?.map((w) =>
                                      $cast<Text>(w)?.mapTo(
                                        (Text w) => TextSpan(
                                          text: w.data,
                                          style:
                                              (w.style ?? _textStyle)?.copyWith(
                                            fontSize: fontSize,
                                          ),
                                        ),
                                      ) ??
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: childrenPadding,
                                          child: w,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            maxLines: expanded ? null : maxLines,
                            overflow: expanded || maxLines == null
                                ? TextOverflow.visible
                                : TextOverflow.ellipsis,
                          ),
                    ),
                  ).flex(enabled: !wrap, expanded: true),
                  if (_showTrailing)
                    Container(
                      constraints: _constrained ? constraints : null,
                      alignment: Alignment.center,
                      padding: detail
                          ? const EdgeInsets.only(left: 2)
                          : trailingPadding,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _trailing is Icon ? 1 : 0,
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            color: _trailingColor,
                            size: detail ? 14 : trailingSize,
                          ),
                          child: trailingText?.notEmpty?.mapIt((t) => Text(
                                    t,
                                    style: trailingStyle ?? context.caption,
                                  )) ??
                              _trailing ??
                              0.space,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ).column(
            // enabled: header,
            crossAxisAlignment:
                header ? CrossAxisAlignment.stretch : CrossAxisAlignment.start,
            before: [
              if (topSeparator != null) GetTileSeparator(style: topSeparator!),
            ],
            after: [
              if (bottomSeparator != null)
                GetTileSeparator(style: bottomSeparator!),
            ],
          );
  }
}

enum SeparatorStyle { full, leading, notLeading }

class GetTileSeparator extends StatelessWidget {
  const GetTileSeparator({
    this.margin,
    this.style = SeparatorStyle.leading,
    Key? key,
  }) : super(key: key);

  /// Tile separator with full edge to edge length
  const GetTileSeparator.full({Key? key}) : this(style: SeparatorStyle.full);

  /// Tile separator with [kStandardPaddingX] padding at start
  const GetTileSeparator.notLeading({Key? key})
      : this(style: SeparatorStyle.notLeading);

  /// Tile separator with `[kStandardPaddingX.twice + BoxedView.kBoxSize]`
  /// padding at start
  const GetTileSeparator.leading({Key? key})
      : this(style: SeparatorStyle.leading);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) => Ink(
        color: context.backgroundColor,
        child: GetLineSeparator(
          margin: margin,
          style: style,
        ),
      );
}

class GetLineSeparator extends StatelessWidget {
  const GetLineSeparator({
    this.margin,
    this.style = SeparatorStyle.leading,
    Key? key,
  }) : super(key: key);

  /// Tile separator with full edge to edge length
  const GetLineSeparator.full({Key? key}) : this(style: SeparatorStyle.full);

  /// Tile separator with [kStandardPaddingX] padding at start
  const GetLineSeparator.notLeading({Key? key})
      : this(style: SeparatorStyle.notLeading);

  /// Tile separator with `[kStandardPaddingX.twice + BoxedView.kBoxSize]`
  /// padding at start
  const GetLineSeparator.leading({Key? key})
      : this(style: SeparatorStyle.leading);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          left: margin ??
              (style == SeparatorStyle.full
                  ? 0
                  : style == SeparatorStyle.notLeading
                      ? kStandardPaddingX
                      : kStandardPaddingX.twice + BoxView.kBoxSize),
        ),
        color: context.hintColor.lighted,
        height: 0.5,
      );
}
