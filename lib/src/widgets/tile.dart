import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

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
    this.titleEndPadding,
    this.titleSize,
    this.accessorySize,
    this.height,
    this.density,
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
  double? titleEndPadding;
  double? titleSize;
  double? accessorySize;
  double? height;
  VisualDensity? density;
  VoidCallback? onTap;
  VoidCallback? onTapLeading;

  bool get hasSubTiles => subTiles.isNotEmpty == true;

  @override
  String get description => title ?? "";

  @override
  Color get color => tintColor ?? title?.materialAccent ?? super.color;
}

class GetTile extends StatelessWidget {
  /// Tile with detailed accessory
  const GetTile.detailed({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isLeadingFilled = true,
    this.isDetailed = true,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled = true,
    this.expanded = false,
    this.density,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.titleEndPadding,
    this.titleSize,
    this.accessorySize,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory
  const GetTile.simple({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isLeadingFilled = true,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled = true,
    this.expanded = false,
    this.density,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.titleEndPadding,
    this.titleSize,
    this.accessorySize,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory and dense view
  const GetTile.simpleDense({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background,
    this.isLeadingFilled = true,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled = true,
    this.expanded = false,
    this.density = GetDensity.min,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.titleEndPadding,
    this.titleSize,
    this.accessorySize,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background and no boxed leading
  const GetTile.plain({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background = Colors.transparent,
    this.isLeadingFilled = false,
    this.isDetailed = false,
    this.padAccessory,
    this.showAccessory,
    this.tintAccessory,
    this.tintAble,
    this.destructive,
    this.enabled = true,
    this.expanded = false,
    this.density,
    this.horizontalPadding,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.titleEndPadding,
    this.titleSize,
    this.accessorySize,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  /// Tile with no accessory, no background and no boxed leading and
  /// have tinted accessory, minimum density and horizontal padding of 4dp.
  const GetTile.item({
    this.leading,
    this.title,
    this.subtitle,
    this.trailingTop,
    this.trailingBottom,
    this.accessory,
    this.rows,
    this.color,
    this.background = Colors.transparent,
    this.isLeadingFilled = false,
    this.isDetailed = false,
    this.padAccessory = true,
    this.showAccessory,
    this.tintAccessory = true,
    this.tintAble,
    this.destructive,
    this.enabled = true,
    this.expanded = false,
    this.density = GetDensity.min,
    this.horizontalPadding = 4,
    this.verticalPadding,
    this.topPadding,
    this.bottomPadding,
    this.titleEndPadding,
    this.titleSize = 14,
    this.accessorySize = GetTileRow.kTrailingSize,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
  final String? title;
  final String? subtitle;
  final String? trailingTop;
  final String? trailingBottom;
  final Widget? accessory;
  final List<Widget>? rows;
  final Color? color;
  final Color? background;
  final bool isLeadingFilled;
  final bool isDetailed;
  final bool? padAccessory;
  final bool? showAccessory;
  final bool? tintAccessory;
  final bool? tintAble;
  final bool? destructive;
  final bool enabled;
  final bool expanded;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? topPadding;
  final double? bottomPadding;
  final double? titleEndPadding;
  final double? titleSize;
  final double? accessorySize;
  final VisualDensity? density;
  final VoidCallback? onTap;
  final VoidCallback? onTapLeading;

  @override
  Widget build(BuildContext context) {
    final _tintAble = destructive == true ? true : (tintAble ?? false);
    final tintColor =
        destructive == true ? Colors.red : color ?? context.theme.accentColor;
    final isTrailingTop = trailingTop?.notEmpty != null;
    final isTrailingBottom = trailingBottom?.notEmpty != null;
    final accessory = this.accessory ??
        (isDetailed == true ? const Icon(Icons.chevron_right) : null);
    final showAccessory = accessory != null && (this.showAccessory ?? true);
    return InkWell(
      highlightColor: tintColor.activated,
      splashColor: tintColor.translucent,
      onTap: enabled ? onTap : null,
      child: Ink(
        color: background ?? context.theme.backgroundColor,
        child: Column(
          children: [
            // GetTileRow(
            //   child: Column(children: [
            //     GetTileRow(
            //       leading: leading,
            //       trailing: accessory,
            //       children: [],
            //       text: text,
            //       textStyle: textStyle,
            //       hint: hint,
            //       color: color,
            //       background: background,
            //       maxLines: maxLines,
            //       trailingSize: trailingSize,
            //       expanded: expanded,
            //       isLeadingFilled: isLeadingFilled,
            //       enabled: enabled,
            //       padding: padding,
            //       leadingPadding: leadingPadding,
            //       childrenPadding: childrenPadding,
            //       onTap: onTap,
            //       onTapLeading: onTapLeading,
            //     )
            //   ]),
            //   leading: leading,
            //   trailing: accessory,
            //   trailingSize: accessorySize,
            //   color: color,
            //   background: background,
            //   maxLines: maxLines,
            //   expanded: expanded,
            //   isLeadingFilled: isLeadingFilled,
            //   enabled: enabled,
            //   padding: padding,
            //   // leadingPadding: leadingPadding,
            //   // childrenPadding: childrenPadding,
            //   onTap: onTap,
            //   onTapLeading: onTapLeading,
            // ),
            ListTile(
              visualDensity: density,
              contentPadding: EdgeInsets.only(
                left: horizontalPadding ?? 16,
                right: padAccessory == true ? (horizontalPadding ?? 16) : 2,
                top: verticalPadding ?? topPadding ?? 0,
                bottom: verticalPadding ?? bottomPadding ?? 0,
              ),
              leading: leading == null
                  ? null
                  : BoxedView(
                      child: leading!,
                      color: tintColor,
                      filled: isLeadingFilled,
                      onTap: onTapLeading,
                    ),
              title: title?.notEmpty?.mapIt((it) => Text(
                    it,
                    style: TextStyle(
                      color: _tintAble ? tintColor : null,
                      fontSize: titleSize,
                    ),
                  )),
              subtitle: subtitle?.notEmpty?.mapIt((it) => Text(it)),
              trailing: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (titleEndPadding != null) SizedBox(width: titleEndPadding),
                  if (isTrailingTop || isTrailingBottom)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTrailingTop)
                          Text(trailingTop!, style: Get.textTheme.caption),
                        if (isTrailingTop && isTrailingBottom)
                          SizedBox(height: 4),
                        if (isTrailingBottom)
                          Text(trailingBottom!, style: Get.textTheme.caption),
                      ],
                    ),
                  if (showAccessory)
                    IconTheme(
                      data: IconThemeData(
                        color: tintAccessory == true
                            ? tintColor
                            : context.theme.hintColor,
                        size: accessorySize,
                      ),
                      child: accessory!,
                    ),
                  if (!showAccessory && padAccessory != true)
                    SizedBox(width: 14)
                ],
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
  static const kLeadingPadding = const EdgeInsets.only(left: 5, right: 21);
  static const kChildrenPadding = const EdgeInsets.all(1);
  static const kTrailingSize = 20.0;
  static const kMaxLines = 2;

  const GetTileRow({
    this.leading,
    this.trailing,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.maxLines = kMaxLines,
    this.trailingSize = kTrailingSize,
    this.expanded = false,
    this.isLeadingFilled = false,
    this.standalone = false,
    this.enabled = true,
    this.padding,
    this.leadingPadding = kLeadingPadding,
    this.childrenPadding = kChildrenPadding,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  const GetTileRow.standalone({
    this.leading,
    this.trailing,
    this.children,
    this.child,
    this.text,
    this.textStyle,
    this.hint,
    this.color,
    this.background,
    this.maxLines = kMaxLines,
    this.trailingSize = kTrailingSize,
    this.expanded = false,
    this.isLeadingFilled = false,
    this.standalone = true,
    this.enabled = true,
    this.padding,
    this.leadingPadding = kLeadingPadding,
    this.childrenPadding = kChildrenPadding,
    this.onTap,
    this.onTapLeading,
    Key? key,
  }) : super(key: key);

  final Widget? leading;
  final Widget? trailing;
  final List<Widget>? children;
  final Widget? child;
  final String? text;
  final TextStyle? textStyle;
  final String? hint;
  final Color? color;
  final Color? background;
  final int maxLines;
  final double? trailingSize;
  final bool expanded;
  final bool isLeadingFilled;
  final bool standalone;
  final bool enabled;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry leadingPadding;
  final EdgeInsetsGeometry childrenPadding;
  final VoidCallback? onTap;
  final VoidCallback? onTapLeading;

  @override
  Widget build(BuildContext context) {
    final _text = text ?? hint;
    final tintColor = color ??
        context.theme.primaryIconTheme.color ??
        context.theme.accentColor;
    return _text == null && children?.isNotEmpty != true
        ? Container(height: 0)
        : InkWell(
            highlightColor: tintColor.activated,
            splashColor: tintColor.translucent,
            onTap: enabled ? onTap : null,
            child: Ink(
              color: background ??
                  (standalone == true ? context.theme.backgroundColor : null),
              padding: padding ??
                  EdgeInsets.only(
                    top: background != null || standalone == true ? 16 : 0,
                    left: 16,
                    right: 16,
                    bottom: 16,
                  ),
              child: Row(children: [
                if (leading != null)
                  leading is BoxedView
                      ? leading!
                      : BoxedView(
                          child: leading!,
                          color: tintColor,
                          filled: isLeadingFilled,
                          margin: leadingPadding,
                          small: true,
                          onTap: onTapLeading,
                        ),
                Expanded(
                  child: CrossFade(
                    firstChild: child ??
                        RichText(
                          text: TextSpan(
                            text: _text,
                            style: (textStyle ?? context.textTheme.caption)!
                                .copyWith(
                              color:
                                  text == null ? context.theme.hintColor : null,
                            ),
                            children: children
                                ?.map((w) =>
                                    $cast<Text>(w)?.mapTo((Text w) => TextSpan(
                                          text: w.data,
                                          style: w.style ??
                                              context.textTheme.caption,
                                        )) ??
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.middle,
                                      child: Padding(
                                        padding: childrenPadding,
                                        child: w,
                                      ),
                                    ))
                                .toList(),
                          ),
                          maxLines: expanded == true ? null : maxLines,
                          overflow: expanded == true
                              ? TextOverflow.visible
                              : TextOverflow.ellipsis,
                        ),
                  ),
                ),
                if (trailing != null) SizedBox(width: 6),
                if (trailing != null)
                  IconTheme(
                    data: IconThemeData(
                      color: tintColor,
                      size: trailingSize,
                    ),
                    child: trailing!,
                  ),
              ]),
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

  /// Tile separator with `18` padding at start
  const GetTileSeparator.noIcon({Key? key})
      : this(style: SeparatorStyle.noIcon);

  /// Tile separator with `72` padding at start
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

  /// Tile separator with `18` padding at start
  const GetLineSeparator.noIcon({Key? key})
      : this(style: SeparatorStyle.noIcon);

  /// Tile separator with `72` padding at start
  const GetLineSeparator.padIcon({Key? key})
      : this(style: SeparatorStyle.padIcon);

  final double? margin;
  final SeparatorStyle style;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: margin ??
            (style == SeparatorStyle.full
                ? 0
                : style == SeparatorStyle.noIcon
                    ? 18
                    : 72),
      ),
      color: Get.theme.hintColor.translucent,
      height: 0.5,
    );
  }
}

class GetTileHeader extends StatelessWidget {
  /// Tile header for icon with normal padding including top/bottom separators
  const GetTileHeader({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon,
    Key? key,
  }) : super(key: key);

  /// Tile header for no icon with dense padding including top/bottom separators
  const GetTileHeader.dense({
    this.text,
    this.topSeparator = true,
    this.bottomSeparator = true,
    this.padding = 16,
    this.noIcon = true,
    Key? key,
  }) : super(key: key);

  /// Tile header for icon with normal padding including bottom separators
  const GetTileHeader.noTop({
    this.text,
    this.topSeparator = false,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon,
    Key? key,
  }) : super(key: key);

  /// Tile header for no icon with normal padding including bottom separators
  const GetTileHeader.noTopIcon({
    this.text,
    this.topSeparator = false,
    this.bottomSeparator = true,
    this.padding,
    this.noIcon = true,
    Key? key,
  }) : super(key: key);

  final String? text;
  final bool topSeparator;
  final bool bottomSeparator;
  final bool? noIcon;
  final double? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (topSeparator) GetTileSeparator(style: SeparatorStyle.full),
        Container(
          padding: EdgeInsets.only(
            left: noIcon == true ? 16 : 24,
            right: 16,
            top: padding ?? 28,
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
}
