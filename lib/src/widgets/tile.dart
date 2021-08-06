import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

const kStandardPadding = 12.0;
const kStandardPaddingX = 12.0;
const kStandardPaddingY = 11.0;
const kStandardPaddingAll = const EdgeInsets.all(kStandardPadding);
const kStandardPaddingH = const EdgeInsets.symmetric(
  horizontal: kStandardPaddingX,
);
const kStandardPaddingV = const EdgeInsets.symmetric(
  vertical: kStandardPaddingY,
);
const kStandardPaddingForm = const EdgeInsets.symmetric(
  horizontal: 16,
  vertical: 4,
);

class GetTileData extends GetObject {
  @override
  List<Function> get builders => [() => GetTileData()];

  GetTileData({
    this.icon,
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
    this.isLeadingFilled,
    this.isDetailed = false,
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

  IconData? icon;
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
  bool? isLeadingFilled;
  bool isDetailed;
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
  static const kConstraints = const BoxConstraints(minHeight: 31);
  static const kTitleSize = 14.0;

  /// Tile with detailed accessory
  const GetTile.detailed({
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
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = true,
    this.isLeadingOval = false,
    this.isDetailed = true,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with detailed accessory
  const GetTile.detailedExpanded({
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
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = true,
    this.isLeadingOval = false,
    this.isDetailed = true,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding = 16,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
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
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = true,
    this.isLeadingOval = false,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory
  const GetTile.simpleExpanded({
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
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = true,
    this.isLeadingOval = false,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding = 16,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment = CrossAxisAlignment.start,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and dense view
  const GetTile.simpleDense({
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
    this.color,
    this.background,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = true,
    this.isLeadingOval = false,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background and no filled leading
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
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = false,
    this.isLeadingOval = true,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding/*= 0*/,
    this.verticalPadding/*= 0*/,
    this.topPadding = 0,
    this.bottomPadding = 10,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin /*EdgeInsets.zero*/,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
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
    this.color,
    this.background = Colors.transparent,
    this.headColor,
    this.trailingColor,
    this.isLeadingFilled = false,
    this.isLeadingOval = false,
    this.isDetailed = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory = true,
    this.tintAble,
    this.isTitleBold = true,
    this.destructive,
    this.enabled = true,
    this.horizontalPadding = 4,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.trailingPadding,
    this.titleSize = kTitleSize,
    this.leadingSize,
    this.accessorySize = GetTileRow.kTrailingSize,
    this.trailingSize = GetTileRow.kTrailingSize,
    this.titleMaxLines,
    this.subtitleMaxLines,
    this.padding,
    this.leadingMargin = GetTileRow.kLeadingMargin,
    this.leadingPadding = GetTileRow.kLeadingPadding,
    this.titleChildrenPadding = GetTileRow.kChildrenPadding,
    this.subtitleChildrenPadding = GetTileRow.kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment = CrossAxisAlignment.center,
    this.onTapTitle,
    this.onTapSubtitle,
    this.onTap,
    this.onTapHead,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
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
  final Color? color;
  final Color? background;
  final Color? headColor;
  final Color? trailingColor;
  final bool isLeadingFilled;
  final bool isLeadingOval;
  final bool isDetailed;
  final bool? padAccessory;
  final bool? showAccessory;
  final bool? tintAccessory;
  final bool? tintAble;
  final bool isTitleBold;
  final bool? destructive;
  final bool enabled;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final double? trailingPadding;
  final double? titleSize;
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
        destructive == true ? Colors.red : color ?? context.theme.accentColor;
    final _trailingColor = _tintAble
        ? tintColor
        : trailingColor ??
            context.theme.iconTheme.color ??
            context.theme.accentColor;
    final isTrailingTop =
        trailingTop?.notEmpty != null || trailingTopChild != null;
    final isTrailingBottom =
        trailingBottom?.notEmpty != null || trailingBottomChild != null;
    final _accessory = accessory ??
        (isDetailed == true
            ? const Icon(
                CupertinoIcons.chevron_right,
                size: 14,
              )
            : null);
    final _showAccessory = _accessory != null && (showAccessory ?? true);
    final _trailingPadding =
        trailingPadding?.mapIt((it) => EdgeInsets.only(left: it)) ??
            GetTileRow.kTrailingPadding;
    final _titleStyle = titleStyle ??
        (isTitleBold
            ? context.textTheme.bodyText1
            : context.textTheme.bodyText2);
    final _titleColor = _tintAble ? tintColor : null;
    final _subtitleStyle = subtitleStyle ?? context.textTheme.bodyText2;
    final _subtitleColor = _tintAble ? tintColor : _subtitleStyle?.color;
    final _padding = leading != null ? 8.0 : kStandardPaddingX;
    final _leftPadding = horizontalPadding ?? leftPadding ?? _padding;
    final _rightPadding = horizontalPadding ?? rightPadding ?? _padding;
    return InkWell(
      highlightColor: tintColor.activated,
      splashColor: tintColor.translucent,
      onTap: enabled ? onTap : null,
      child: Ink(
        color: background ?? context.theme.backgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GetTileRow(
              child: Column(children: [
                GetTileRow(
                  child: titleChild,
                  children: titleChildren,
                  childrenPadding: titleChildrenPadding,
                  text: title?.notEmpty,
                  textStyle: _titleStyle?.copyWith(
                    color: _titleColor,
                  ),
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
                  alignment: alignment == CrossAxisAlignment.center
                      ? alignment
                      : CrossAxisAlignment.baseline,
                  enabled: enabled,
                  padding: EdgeInsets.zero,
                  onTap: onTapTitle,
                ),
                GetTileRow(
                  child: subtitleChild,
                  children: subtitleChildren,
                  childrenPadding: subtitleChildrenPadding,
                  text: subtitle?.notEmpty,
                  textStyle: _subtitleStyle?.copyWith(
                    color: _subtitleColor?.subbed,
                  ),
                  fontSize: titleSize,
                  hint: subtitleHint,
                  trailingText: trailingSubtitle,
                  trailingStyle: trailingStyle,
                  trailing: trailingSubtitleChild,
                  trailingPadding: _trailingPadding,
                  trailingColor: trailingColor,
                  trailingSize: trailingSize,
                  color: tintColor,
                  maxLines: subtitleMaxLines,
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
              isLeadingSmall: false,
              isLeadingFilled: isLeadingFilled,
              isLeadingOval: isLeadingOval,
              leadingMargin: leadingMargin,
              leadingPadding: leadingPadding,
              isDetailed: isDetailed,
              constraints: constraints,
              color: color,
              background: headColor,
              alignment: alignment,
              enabled: enabled,
              padding: padding ??
                  EdgeInsets.only(
                    left: _leftPadding,
                    right: padAccessory == true
                        ? _rightPadding
                        : _showAccessory
                            ? 6
                            : 0,
                    top: verticalPadding ?? topPadding ?? kStandardPaddingY,
                    bottom:
                        verticalPadding ?? bottomPadding ?? kStandardPaddingY,
                  ),
              onTap: onTapHead,
              onTapLeading: onTapLeading,
              trailingSize: accessorySize,
              trailingColor:
                  tintAccessory == true ? tintColor : context.theme.hintColor,
              trailingStyle: trailingStyle,
              trailingPadding: _trailingPadding,
              trailing: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (trailingPadding != null) SizedBox(width: trailingPadding),
                  if (isTrailingTop || isTrailingBottom)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTrailingTop || isTrailingBottom)
                          SizedBox(height: 1),
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
                                style: trailingStyle ?? Get.textTheme.caption,
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
                                style: trailingStyle ?? Get.textTheme.caption,
                              ),
                      ],
                    ),
                  if (_showAccessory)
                    Padding(
                      padding: isTrailingTop || isTrailingBottom
                          ? (isDetailed
                              ? const EdgeInsets.only(left: 2)
                              : _trailingPadding)
                          : EdgeInsets.zero,
                      child: IconTheme(
                        data: IconThemeData(
                          color: tintAccessory == true
                              ? tintColor
                              : context.theme.hintColor,
                          size: accessorySize,
                        ),
                        child: _accessory!,
                      ),
                    ),
                  if (!_showAccessory && padAccessory != true)
                    SizedBox(width: _rightPadding)
                ],
              ).applyIf(
                _showAccessory || isTrailingTop || isTrailingBottom,
                (it) => it.paddingOnly(top: 1),
              ),
            ),
            ...rows ?? [],
          ],
        ),
      ),
    );
  }
}

class GetTileRow extends StatelessWidget {
  static const kLeadingMargin = const EdgeInsets.symmetric(horizontal: 5);
  static const kLeadingPadding = const EdgeInsets.only(right: 8);
  static const kTrailingPadding = const EdgeInsets.only(left: 6);
  static const kChildrenPadding = const EdgeInsets.all(1);
  static const kConstraints = const BoxConstraints(minHeight: 26.5);
  static const kTrailingSize = 20.0;
  static const kLeadingSize = 20.0;
  static const kMaxLines = 2;

  const GetTileRow({
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
    this.maxLines = kMaxLines,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxedView.kBoxSize,
    this.trailingSize = kTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = false,
    this.isLeadingFilled = false,
    this.isLeadingSmall = true,
    this.isLeadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.isDetailed = false,
    this.padding,
    this.leadingMargin = kLeadingMargin,
    this.leadingPadding = kLeadingPadding,
    this.trailingPadding = kTrailingPadding,
    this.childrenPadding = kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  const GetTileRow.expanded({
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
    this.maxLines = kMaxLines,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxedView.kBoxSize,
    this.trailingSize = kTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = true,
    this.isLeadingFilled = false,
    this.isLeadingSmall = true,
    this.isLeadingOval = false,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.isDetailed = false,
    this.padding,
    this.leadingMargin = kLeadingMargin,
    this.leadingPadding = kLeadingPadding,
    this.trailingPadding = kTrailingPadding,
    this.childrenPadding = kChildrenPadding,
    this.constraints = kConstraints,
    this.alignment: CrossAxisAlignment.start,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

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
    this.maxLines = kMaxLines,
    this.fontSize = 12,
    this.leadingSize = kLeadingSize,
    this.leadingBoxSize = BoxedView.kBoxSize,
    this.trailingSize = kTrailingSize,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = false,
    this.isLeadingFilled = false,
    this.isLeadingSmall = true,
    this.isLeadingOval = false,
    this.themed = false,
    this.wrap = true,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.isDetailed = false,
    this.padding = const EdgeInsets.symmetric(horizontal: 7),
    this.leadingMargin = EdgeInsets.zero,
    this.leadingPadding = const EdgeInsets.only(right: 3),
    this.trailingPadding = kTrailingPadding,
    this.childrenPadding = kChildrenPadding,
    this.constraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

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
    this.maxLines = kMaxLines,
    this.fontSize = 12,
    this.leadingSize = kLeadingSize,
    this.leadingBoxSize = BoxedView.kBoxSize,
    this.trailingSize = kTrailingSize,
    this.horizontalPadding,
    this.verticalPadding = 0,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = false,
    this.isLeadingFilled = true,
    this.isLeadingSmall = true,
    this.isLeadingOval = true,
    this.themed = false,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.isDetailed = false,
    this.padding,
    this.leadingMargin = kLeadingMargin,
    this.leadingPadding = kLeadingPadding,
    this.trailingPadding = kTrailingPadding,
    this.childrenPadding = kChildrenPadding,
    this.constraints,
    this.alignment: CrossAxisAlignment.center,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

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
    this.maxLines = kMaxLines,
    this.fontSize,
    this.leadingSize,
    this.leadingBoxSize = BoxedView.kBoxSize,
    this.trailingSize = kTrailingSize,
    this.horizontalPadding,
    this.verticalPadding = kStandardPaddingY,
    this.topPadding,
    this.bottomPadding,
    this.leftPadding,
    this.rightPadding,
    this.expanded = true,
    this.isLeadingFilled = true,
    this.isLeadingSmall = true,
    this.isLeadingOval = false,
    this.themed = true,
    this.wrap = false,
    this.enabled = true,
    this.tintAble = false,
    this.destructive,
    this.isDetailed = false,
    this.padding,
    this.leadingMargin = kLeadingMargin,
    this.leadingPadding = kLeadingPadding,
    this.trailingPadding = kTrailingPadding,
    this.childrenPadding = kChildrenPadding,
    this.constraints = GetTile.kConstraints,
    this.alignment: CrossAxisAlignment.start,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
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
  final double? fontSize;
  final double? leadingSize;
  final double? leadingBoxSize;
  final double? trailingSize;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? leftPadding;
  final double? rightPadding;
  final bool expanded;
  final bool isLeadingFilled;
  final bool isLeadingSmall;
  final bool isLeadingOval;
  final bool themed;
  final bool wrap;
  final bool enabled;
  final bool tintAble;
  final bool? destructive;
  final bool isDetailed;
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
    final _text = text ?? hint;
    final _color =
        context.theme.primaryIconTheme.color ?? context.theme.accentColor;
    final _tintColor = destructive == true ? Colors.red : color ?? _color;
    final _tintAble = destructive == true || tintAble;
    final _trailingColor = trailingColor ?? (_tintAble ? _tintColor : _color);
    final _textStyle = textStyle ?? context.textTheme.caption;
    final _constrained = alignment == CrossAxisAlignment.start ||
        alignment == CrossAxisAlignment.end;
    final _trailing = trailing ??
        (isDetailed
            ? const Icon(
                CupertinoIcons.chevron_right,
                size: 14,
              )
            : null);
    final _boxedView = $cast<BoxedView>(leading);
    final _horizontalPadding = leading != null ? 8.0 : kStandardPaddingX;
    return _text == null && child == null && children?.isNotEmpty != true
        ? Container(height: 0, width: 0)
        : InkWell(
            highlightColor: _tintColor.activated,
            splashColor: _tintColor.translucent,
            onTap: enabled ? onTap : null,
            child: Ink(
              color: background ??
                  (themed == true ? context.theme.backgroundColor : null),
              padding: padding ??
                  EdgeInsets.only(
                    left:
                        horizontalPadding ?? leftPadding ?? _horizontalPadding,
                    right:
                        horizontalPadding ?? rightPadding ?? _horizontalPadding,
                    top: verticalPadding ?? topPadding ?? 8,
                    bottom: verticalPadding ?? bottomPadding ?? 8,
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
                            child: BoxedView(
                              child: _boxedView?.child ?? leading!,
                              color: _boxedView?.color ?? _tintColor,
                              filled: _boxedView?.filled ?? isLeadingFilled,
                              margin: _boxedView?.margin ?? leadingPadding,
                              small: _boxedView?.small ?? isLeadingSmall,
                              wrap: _boxedView?.wrap ?? false,
                              boxSize:
                                  _boxedView?.boxSize ?? BoxedView.kBoxSize,
                              fontSize: _boxedView?.fontSize,
                              iconSize: _boxedView?.iconSize ?? leadingSize,
                              oval: _boxedView?.oval ?? isLeadingOval,
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
                                color: text == null
                                    ? context.theme.hintColor
                                    : null,
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
                  if (_trailing != null)
                    Container(
                      constraints: _constrained ? constraints : null,
                      alignment: Alignment.center,
                      padding: isDetailed
                          ? const EdgeInsets.only(left: 2)
                          : trailingPadding,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: _trailing is Icon ? 1 : 0,
                        ),
                        child: IconTheme(
                          data: IconThemeData(
                            color: _trailingColor,
                            size: trailingSize,
                          ),
                          child: trailingText?.notEmpty?.mapIt((t) => Text(
                                    t,
                                    style: trailingStyle ??
                                        context.textTheme.caption,
                                  )) ??
                              _trailing,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
  }
}

enum SeparatorStyle { full, padIcon, noIcon }

class GetTileSeparator extends StatelessWidget {
  const GetTileSeparator({
    this.margin,
    this.style = SeparatorStyle.padIcon,
    Key? key,
  }) : super(key: key);

  /// Tile separator with full edge to edge length
  const GetTileSeparator.full({Key? key}) : this(style: SeparatorStyle.full);

  /// Tile separator with `12` padding at start
  const GetTileSeparator.noIcon({Key? key})
      : this(style: SeparatorStyle.noIcon);

  /// Tile separator with `56` padding at start
  const GetTileSeparator.padIcon({Key? key})
      : this(style: SeparatorStyle.padIcon);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Ink(
      color: Get.theme.backgroundColor,
      child: GetLineSeparator(
        margin: margin,
        style: style,
      ),
    );
  }
}

class GetLineSeparator extends StatelessWidget {
  const GetLineSeparator({
    this.margin,
    this.style = SeparatorStyle.padIcon,
    Key? key,
  }) : super(key: key);

  /// Tile separator with full edge to edge length
  const GetLineSeparator.full({Key? key}) : this(style: SeparatorStyle.full);

  /// Tile separator with `12` padding at start
  const GetLineSeparator.noIcon({Key? key})
      : this(style: SeparatorStyle.noIcon);

  /// Tile separator with `56` padding at start
  const GetLineSeparator.padIcon({Key? key})
      : this(style: SeparatorStyle.padIcon);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) => Container(
        margin: EdgeInsets.only(
          left: margin ??
              (style == SeparatorStyle.full
                  ? 0
                  : style == SeparatorStyle.noIcon
                      ? kStandardPaddingX
                      : 56),
        ),
        color: Get.theme.hintColor.translucent,
        height: 0.5,
      );
}

class GetTileHeader extends StatelessWidget {
  /// Tile header for icon with normal padding including top/bottom separators
  const GetTileHeader({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.top,
    this.noIcon,
    Key? key,
  }) : super(key: key);

  /// Tile header for no icon with dense padding including top/bottom separators
  const GetTileHeader.dense({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.top = 16,
    this.noIcon = true,
    Key? key,
  }) : super(key: key);

  /// Tile header for icon with normal padding including bottom separators
  const GetTileHeader.noTop({
    this.text,
    this.topSeparator = false,
    this.bottomSeparator = true,
    this.top,
    this.noIcon,
    Key? key,
  }) : super(key: key);

  /// Tile header for no icon with normal padding including bottom separators
  const GetTileHeader.noTopIcon({
    this.text,
    this.topSeparator = false,
    this.bottomSeparator = true,
    this.top,
    this.noIcon = true,
    Key? key,
  }) : super(key: key);

  final String? text;
  final bool topSeparator;
  final bool bottomSeparator;
  final bool? noIcon;
  final double? top;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (topSeparator) GetTileSeparator(style: SeparatorStyle.full),
          Container(
            padding: EdgeInsets.only(
              left: noIcon == true ? kStandardPaddingX : 16,
              right: kStandardPaddingX,
              top: top ?? 28,
              bottom: 8,
            ),
            child: Text(
              text?.uppercase ?? "",
              style: Get.textTheme.caption,
            ),
          ),
          if (bottomSeparator) GetTileSeparator(style: SeparatorStyle.full),
        ],
      );
}
