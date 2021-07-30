import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

typedef PopupMenuItemSelected<T> = void Function(int value, T data);
typedef PopupMenuChildBuilder = Widget Function(VoidCallback? onPopup);
typedef PopupMenuItemBuilder<T> = PopupMenuEntry<int> Function(
  int value,
  T data,
);
typedef PopupMenuSeparatorBuilder<T> = PopupMenuEntry<int> Function(
  int value,
  T data,
);

class PopupMenu<T extends Object> extends StatelessWidget {
  const PopupMenu({
    this.childBuilder,
    this.itemBuilder,
    this.separatorBuilder,
    this.onSelected,
    this.onCanceled,
    required this.items,
    this.initialSelected,
    this.elevation = 12,
    this.cornerRadius = 16,
    this.itemHeight = 36,
    this.itemPadding = 4,
    this.titleSize = 14,
    this.accessorySize = 20,
    this.tintColor,
    this.backgroundColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 12),
    this.offset,
    this.enabled = true,
    this.autoTint = false,
    this.separator = true,
    this.useRootNavigator = false,
    this.semanticLabel,
  });

  final PopupMenuChildBuilder? childBuilder;
  final PopupMenuItemBuilder<T>? itemBuilder;
  final PopupMenuSeparatorBuilder<T>? separatorBuilder;
  final PopupMenuItemSelected<T>? onSelected;
  final VoidCallback? onCanceled;
  final List<T> items;
  final int? initialSelected;
  final double elevation;
  final double cornerRadius;
  final double? itemHeight;
  final double? itemPadding;
  final double? titleSize;
  final double? accessorySize;
  final Color? tintColor;
  final Color? backgroundColor;
  final EdgeInsets padding;
  final Offset? offset;
  final bool enabled;
  final bool autoTint;
  final bool separator;
  final bool useRootNavigator;
  final String? semanticLabel;

  PopupMenuChildBuilder get _childBuilder =>
      childBuilder ??
      (onPressed) => GetButton.primaryIcon(
            child: Icon(Icons.more_vert),
            onPressed: onPressed,
          );

  PopupMenuSeparatorBuilder<T> get _separatorBuilder =>
      separatorBuilder ?? (value, data) => const PopupMenuDivider(height: 1.5);

  PopupMenuItemBuilder<T> get _itemBuilder =>
      itemBuilder ??
      (value, data) =>
          $cast<GetTileData>(data)?.mapTo((GetTileData data) => GetTile.item(
                leading: data.icon?.mapIt((it) => Icon(it)),
                title: data.title,
                subtitle: data.subtitle,
                trailingTop: data.trailingTop,
                trailingBottom: data.trailingBottom,
                accessory: data.accessory?.mapIt((it) => Icon(it)),
                color: autoTint
                    ? data.materialPrimary
                    : (data.tintColor ?? tintColor),
                background: data.background ?? Colors.transparent,
                isLeadingFilled: data.isLeadingBoxed ?? false,
                isDetailed: data.isDetailed,
                padAccessory: data.padAccessory ?? true,
                showAccessory: data.showAccessory,
                tintAccessory: data.tintAccessory ?? true,
                tintAble: data.tintAble,
                destructive: data.destructive,
                enabled: data.enabled,
                density: data.density ?? GetDensity.min,
                horizontalPadding: data.horizontalPadding ?? itemPadding,
                verticalPadding: data.verticalPadding,
                topPadding: data.topPadding,
                bottomPadding: data.bottomPadding,
                titleEndPadding: data.titleEndPadding,
                titleSize: data.titleSize ?? titleSize,
                accessorySize: data.accessorySize ?? accessorySize,
                onTapLeading: data.onTapLeading,
              ).popupMenuItem(
                enabled: data.enabled ?? true,
                height: data.height ?? itemHeight,
                padding: padding,
                value: value,
              )) ??
          Container(height: 0).popupMenuItem(value: value);

  List<PopupMenuEntry<int>> get _items => separator
      ? (items
          .expandIndexed((v, d) => [
                _itemBuilder(v, d),
                _separatorBuilder(v, d),
              ])
          .toList()
            ..removeLast())
      : items.mapIndexed(_itemBuilder).toList();

  _onSelected(value) {
    final data = items.get(value);
    if (value != null && data != null) {
      onSelected?.call(value, data);
      $cast<GetTileData>(data)?.mapTo((GetTileData data) => data.onTap?.call());
    } else
      onCanceled?.call();
  }

  @override
  Widget build(BuildContext context) =>
      _childBuilder(items.isNotEmpty && enabled
          ? /*onPressed:*/ () => showMenu(
                context: context,
                items: _items,
                position: context.position(offset: offset),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(cornerRadius),
                ),
                color: backgroundColor,
                initialValue: initialSelected,
                elevation: elevation,
                useRootNavigator: useRootNavigator,
                semanticLabel: semanticLabel,
              ).then(_onSelected)
          : null);
}

extension PopupMenuWidget on Widget {
  PopupMenuItem<T> popupMenuItem<T>({
    T? value,
    bool enabled = true,
    double? height = 36,
    EdgeInsets? padding,
    TextStyle? textStyle,
    MouseCursor? mouseCursor,
  }) =>
      PopupMenuItem<T>(
        value: value,
        enabled: enabled,
        height: height ?? kMinInteractiveDimension,
        padding: padding,
        textStyle: textStyle,
        mouseCursor: mouseCursor,
        child: this,
      );
}
