import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// Signature for the callback invoked when a menu item is selected. The
/// first argument is the index of the selected item and second is the data of
/// type `T` that caused its menu to be dismissed.
typedef GetPopupMenuItemSelected<T> = void Function(int index, T data);

/// Signature used by [GetPopupMenu] to lazily construct the child widget that can
/// show the menu if onPopup method is called from the argument.
typedef GetPopupMenuChildBuilder = Widget Function(VoidCallback? onPopup);

/// Signature used by [GetPopupMenu] to lazily construct the items shown when
/// the button is pressed.
typedef GetPopupMenuItemBuilder<T> = PopupMenuEntry<int> Function(
  int index,
  T data,
);
typedef GetPopupMenuSeparatorBuilder<T> = PopupMenuEntry<int> Function(
  int index,
  T data,
);

/// Displays a menu when pressed and calls [onSelected] when the menu is dismissed
/// because an item was selected. The value passed to [onSelected] is the value of
/// the selected menu item.
class GetPopupMenu<T extends Object> extends StatelessWidget {
  /// Creates a widget that shows a popup menu.
  ///
  /// The [items] argument must not be null.
  const GetPopupMenu({
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
    Key? key,
  }) : super(key: key);

  /// If provided, [childBuilder] is the widget used for this button
  final GetPopupMenuChildBuilder? childBuilder;

  /// Called when the button is pressed to create the items to show in the menu.
  final GetPopupMenuItemBuilder<T>? itemBuilder;
  final GetPopupMenuSeparatorBuilder<T>? separatorBuilder;

  /// Called when the user selects a value from the popup menu.
  ///
  /// If the popup menu is dismissed without selecting a value, [onCanceled] is
  /// called instead.
  final GetPopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  ///
  /// If the user selects a value, [onSelected] is called instead.
  final VoidCallback? onCanceled;
  final List<T> items;

  /// The value of the menu item, if any, that should be highlighted when the
  /// menu opens.
  final int? initialSelected;

  /// The z-coordinate at which to place the menu when open. This controls the
  /// size of the shadow below the menu.
  ///
  /// Defaults to 12, the appropriate elevation for popup menus.
  final double elevation;
  final double cornerRadius;
  final double? itemHeight;
  final double? itemPadding;
  final double? titleSize;
  final double? accessorySize;
  final Color? tintColor;

  /// If provided, the background color used for the menu.
  ///
  /// If this property is null, then `PopupMenuThemeData.color` is used.
  /// If that is also null, then `Theme.of(context).cardColor` is used.
  final Color? backgroundColor;
  final EdgeInsets padding;

  /// The offset applied to the Popup Menu Button.
  ///
  /// When not set, the Popup Menu Button will be positioned directly next to
  /// the button that was used to create it.
  final Offset? offset;

  /// Whether this popup menu button is interactive.
  final bool enabled;
  final bool autoTint;
  final bool separator;
  final bool useRootNavigator;
  final String? semanticLabel;

  GetPopupMenuChildBuilder get _childBuilder =>
      childBuilder ??
      (onPressed) => GetButton.primaryIcon(
            child: const Icon(Icons.more_vert),
            onPressed: onPressed,
          );

  GetPopupMenuSeparatorBuilder<T> get _separatorBuilder =>
      separatorBuilder ?? (_, __) => const PopupMenuDivider(height: 1.5);

  GetPopupMenuItemBuilder<T> get _itemBuilder =>
      itemBuilder ??
      (index, data) =>
          $cast<GetTileData>(data)?.mapTo((GetTileData data) => GetTile.item(
                leading: data.leading?.mapIt((it) => Icon(it)),
                title: data.description,
                subtitle: data.subtitle,
                trailingTop: data.trailingTop,
                trailingBottom: data.trailingBottom,
                accessory: data.accessory?.mapIt((it) => Icon(it)),
                color: autoTint
                    ? data.colorMaterial
                    : (data.tintColor ?? tintColor),
                background: data.background ?? Colors.transparent,
                leadingFilled: data.leadingFilled ?? false,
                detail: data.detail,
                padAccessory: data.padAccessory ?? true,
                showAccessory: data.showAccessory,
                tintAccessory: data.tintAccessory ?? true,
                tintAble: data.tintAble,
                destructive: data.destructive,
                enabled: data.enabled ?? true,
                horizontalPadding: data.horizontalPadding ?? itemPadding,
                verticalPadding: data.verticalPadding,
                topPadding: data.topPadding,
                bottomPadding: data.bottomPadding,
                trailingPadding: data.trailingPadding,
                titleSize: data.titleSize ?? titleSize,
                accessorySize: data.accessorySize ?? accessorySize,
                onTapLeading: data.onTapLeading,
              ).popupMenuItem(
                enabled: data.enabled ?? true,
                height: data.height ?? itemHeight,
                padding: padding,
                value: index,
              )) ??
          GetTile.item(
            title: data.toString(),
            color: autoTint ? data.toString().color : tintColor,
            horizontalPadding: itemPadding,
            titleSize: titleSize,
            accessorySize: accessorySize,
          ).popupMenuItem(
            height: itemHeight,
            padding: padding,
            value: index,
          );

  List<PopupMenuEntry<int>> get _items => separator
      ? (items
          .expandIndexed((v, d) => [
                _itemBuilder(v, d),
                _separatorBuilder(v, d),
              ])
          .toList()
        ..removeLast())
      : items.mapIndexed(_itemBuilder).toList();

  FutureOr _onSelected(int? value) {
    final data = items.get(value);
    if (value != null && data != null) {
      onSelected?.call(value, data);
      $cast<GetTileData>(data)?.mapTo((GetTileData data) => data.onTap?.call());
    } else {
      onCanceled?.call();
    }
  }

  @override
  Widget build(BuildContext context) =>
      _childBuilder(items.isNotEmpty && enabled
          // onPressed
          ? () => showMenu(
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

extension GetPopupMenuWidget on Widget {
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
