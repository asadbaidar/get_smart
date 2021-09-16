// ignore_for_file: unnecessary_null_comparison

import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// Scroll physics that always lets the user scroll and bounce back
/// from the edge.
class AlwaysBouncingScrollPhysics extends BouncingScrollPhysics {
  /// Creates scroll physics that always lets the user scroll
  /// and bounce back from the edge.
  const AlwaysBouncingScrollPhysics()
      : super(parent: const AlwaysScrollableScrollPhysics());
}

/// A scrollable list of widgets arranged linearly.
///
/// The [GetListView.builder] constructor takes an [IndexedWidgetBuilder], which
/// builds the children on demand. This constructor is appropriate for list views
/// with a large (or infinite) number of children because the builder is called
/// only for those children that are actually visible.
///
/// To control the initial scroll offset of the scroll view, provide a
/// [controller] with its [ScrollController.initialScrollOffset] property set.
///
/// By default, [GetListView] will automatically pad the list's scrollable
/// extremities to avoid partial obstructions indicated by [MediaQuery]'s
/// padding. To avoid this behavior, override with a zero [padding] property.
///
/// ### Construction
///
/// While laying out the list, visible children's elements, states and render
/// objects will be created lazily based on existing widgets
///
/// ### Destruction
///
/// When a child is scrolled out of view, the associated element subtree,
/// states and render objects are destroyed. A new child at the same position
/// in the list will be lazily recreated along with new elements, states and
/// render objects when it is scrolled back.
///
/// ### Destruction mitigation
///
/// In order to preserve state as child elements are scrolled in and out of
/// view, the following options are possible:
///
///  * Moving the ownership of non-trivial UI-state-driving business logic
///    out of the list child subtree. For instance, if a list contains posts
///    with their number of upvotes coming from a cached network response, store
///    the list of posts and upvote number in a data model outside the list. Let
///    the list child UI subtree be easily recreate-able from the
///    source-of-truth model object. Use [StatefulWidget]s in the child
///    widget subtree to store instantaneous UI state only.
///
///  * Letting [KeepAlive] be the root widget of the list child widget subtree
///    that needs to be preserved. The [KeepAlive] widget marks the child
///    subtree's top render object child for keepalive. When the associated top
///    render object is scrolled out of view, the list keeps the child's render
///    object (and by extension, its associated elements and states) in a cache
///    list instead of destroying them. When scrolled back into view, the render
///    object is repainted as-is (if it wasn't marked dirty in the interim).
///
///    This only works if `addAutomaticKeepAlives` and `addRepaintBoundaries`
///    are false since those parameters cause the [GetListView] to wrap each child
///    widget subtree with other widgets.
///
///  * Using [AutomaticKeepAlive] widgets (inserted by default when
///    `addAutomaticKeepAlives` is true). [AutomaticKeepAlive] allows descendant
///    widgets to control whether the subtree is actually kept alive or not.
///    This behavior is in contrast with [KeepAlive], which will unconditionally keep
///    the subtree alive.
///
///    As an example, the [EditableText] widget signals its list child element
///    subtree to stay alive while its text field has input focus. If it doesn't
///    have focus and no other descendants signaled for keepalive via a
///    [KeepAliveNotification], the list child element subtree will be destroyed
///    when scrolled away.
///
///    [AutomaticKeepAlive] descendants typically signal it to be kept alive
///    by using the [AutomaticKeepAliveClientMixin], then implementing the
///    [AutomaticKeepAliveClientMixin.wantKeepAlive] getter and calling
///    [AutomaticKeepAliveClientMixin.updateKeepAlive].
///
/// The [key], [scrollDirection], [reverse], [controller], [primary], [physics],
/// and [shrinkWrap] properties on [GetListView] map directly to the identically
/// named properties on [CustomScrollView].
///
/// The [padding] property corresponds to having a [SliverPadding] in the
/// [CustomScrollView.slivers] property instead of the list itself, and having
/// the [SliverList] instead be a child of the [SliverPadding].
class GetListView extends ScrollView {
  /// Creates a scrollable, linear array of widgets from an explicit [List].
  ///
  /// This constructor is appropriate for list views with a small number of
  /// children because constructing the [List] requires doing work for every
  /// child that could possibly be displayed in the list view instead of just
  /// those children that are actually visible.
  ///
  /// Like other widgets in the framework, this widget expects that
  /// the [children] list will not be mutated after it has been passed in here.
  /// See the documentation at [SliverChildListDelegate.children] for more details.
  ///
  /// It is usually more efficient to create children on demand using
  /// [GetListView.builder] because it will create the widget children lazily as necessary.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildListDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildListDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildListDelegate.addSemanticIndexes] property. None
  /// may be null.
  const GetListView({
    Key? key,
    List<Widget> children = const [],
    this.replaceBuilder,
    this.sliverHeaders,
    this.sliverFooters,
    this.footerSeparator = SeparatorStyle.full,
    this.replace = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.padding,
    this.itemExtent,
    this.prototypeItem,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics = const AlwaysBouncingScrollPhysics(),
    bool shrinkWrap = false,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(children != null),
        assert(
          itemExtent == null || prototypeItem == null,
          'You can only pass itemExtent or prototypeItem, not both.',
        ),
        children = children,
        itemCount = children.length,
        itemBuilder = null,
        separatorBuilder = null,
        super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          cacheExtent: cacheExtent,
          semanticChildCount: children.length,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  /// Creates a fixed-length scrollable linear array of list "items" separated
  /// by list item "separators".
  ///
  /// This constructor is appropriate for list views with a large number of
  /// item and separator children because the builders are only called for
  /// the children that are actually visible.
  ///
  /// The `itemBuilder` callback will be called with indices greater than
  /// or equal to zero and less than `itemCount`.
  ///
  /// Separators only appear between list items: separator 0 appears after item
  /// 0 and the last separator appears before the last item.
  ///
  /// The `separatorBuilder` callback will be called with indices greater than
  /// or equal to zero and less than `itemCount`.
  ///
  /// The `itemBuilder` and `separatorBuilder` callbacks should always return a
  /// non-null widget, and actually create widget instances when called. Avoid
  /// using a builder that returns a previously-constructed widget; if the list
  /// view's children are created in advance.
  ///
  /// The `addAutomaticKeepAlives` argument corresponds to the
  /// [SliverChildBuilderDelegate.addAutomaticKeepAlives] property. The
  /// `addRepaintBoundaries` argument corresponds to the
  /// [SliverChildBuilderDelegate.addRepaintBoundaries] property. The
  /// `addSemanticIndexes` argument corresponds to the
  /// [SliverChildBuilderDelegate.addSemanticIndexes] property. None may be
  /// null.
  const GetListView.builder({
    Key? key,
    required IndexedWidgetBuilder itemBuilder,
    this.separatorBuilder,
    this.replaceBuilder,
    this.sliverHeaders,
    this.sliverFooters,
    this.itemCount = 0,
    this.footerSeparator = SeparatorStyle.full,
    this.replace = false,
    this.addAutomaticKeepAlives = true,
    this.addRepaintBoundaries = true,
    this.addSemanticIndexes = true,
    this.padding,
    Axis scrollDirection = Axis.vertical,
    bool reverse = false,
    ScrollController? controller,
    bool? primary,
    ScrollPhysics? physics = const AlwaysBouncingScrollPhysics(),
    bool shrinkWrap = false,
    double? cacheExtent,
    DragStartBehavior dragStartBehavior = DragStartBehavior.start,
    ScrollViewKeyboardDismissBehavior keyboardDismissBehavior =
        ScrollViewKeyboardDismissBehavior.manual,
    String? restorationId,
    Clip clipBehavior = Clip.hardEdge,
  })  : assert(itemBuilder != null),
        assert(itemCount != null && itemCount >= 0),
        itemBuilder = itemBuilder,
        children = null,
        itemExtent = null,
        prototypeItem = null,
        super(
          key: key,
          scrollDirection: scrollDirection,
          reverse: reverse,
          controller: controller,
          primary: primary,
          physics: physics,
          shrinkWrap: shrinkWrap,
          cacheExtent: cacheExtent,
          semanticChildCount: itemCount,
          dragStartBehavior: dragStartBehavior,
          keyboardDismissBehavior: keyboardDismissBehavior,
          restorationId: restorationId,
          clipBehavior: clipBehavior,
        );

  final List<Widget>? children;
  final IndexedWidgetBuilder? itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final WidgetBuilder? replaceBuilder;
  final List<Widget>? sliverHeaders;
  final List<Widget>? sliverFooters;
  final int itemCount;
  final SeparatorStyle? footerSeparator;
  final bool replace;
  final bool addAutomaticKeepAlives;
  final bool addRepaintBoundaries;
  final bool addSemanticIndexes;

  /// The amount of space by which to inset the children.
  final EdgeInsetsGeometry? padding;

  /// If non-null, forces the children to have the given extent in the scroll
  /// direction.
  ///
  /// Specifying an [itemExtent] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final double? itemExtent;

  /// If non-null, forces the children to have the same extent as the given
  /// widget in the scroll direction.
  ///
  /// Specifying an [prototypeItem] is more efficient than letting the children
  /// determine their own extent because the scrolling machinery can make use of
  /// the foreknowledge of the children's extent to save work, for example when
  /// the scroll position changes drastically.
  final Widget? prototypeItem;

  /// computing the actual child count.
  int get _itemCount => max(0,
      _hasSeparator ? itemCount * 2 + (_footerSeparator ? 0 : -1) : itemCount);

  bool get _hasSeparator => separatorBuilder != null;

  bool get _replace => replace && replaceBuilder != null;

  bool get _footerSeparator => footerSeparator != null && itemCount > 0;

  @override
  List<Widget> buildSlivers(BuildContext context) => [
        if (sliverHeaders != null) ...sliverHeaders!,
        _buildSliverList(context),
        if (sliverFooters != null) ...sliverFooters!,
      ];

  SliverChildDelegate get _childrenDelegate => children != null
      ? SliverChildListDelegate(
          children ?? [],
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
        )
      : SliverChildBuilderDelegate(
          (context, index) {
            if (_hasSeparator) {
              final itemIndex = index ~/ 2;
              final isLast = _footerSeparator && index == itemCount * 2 - 1;
              return isLast
                  ? GetTileSeparator(style: footerSeparator!)
                  : index.isEven
                      ? itemBuilder!(context, itemIndex)
                      : separatorBuilder!(context, itemIndex);
            } else {
              return itemBuilder!(context, index);
            }
          },
          childCount: _itemCount,
          addAutomaticKeepAlives: addAutomaticKeepAlives,
          addRepaintBoundaries: addRepaintBoundaries,
          addSemanticIndexes: addSemanticIndexes,
          semanticIndexCallback: (_, index) =>
              _hasSeparator && index.isEven ? index ~/ 2 : null,
        );

  Widget _sliverList(BuildContext context) => _replace
      ? replaceBuilder!(context).sliverFill
      : itemExtent != null
          ? SliverFixedExtentList(
              delegate: _childrenDelegate,
              itemExtent: itemExtent!,
            )
          : prototypeItem != null
              ? SliverPrototypeExtentList(
                  delegate: _childrenDelegate,
                  prototypeItem: prototypeItem!,
                )
              : SliverList(delegate: _childrenDelegate);

  Widget _buildSliverList(BuildContext context) {
    Widget sliverList = _sliverList(context);
    EdgeInsetsGeometry? effectivePadding = padding;
    if (padding == null) {
      final MediaQueryData? mediaQuery = MediaQuery.maybeOf(context);
      if (mediaQuery != null) {
        // Automatically pad sliver with padding from MediaQuery.
        final EdgeInsets mediaQueryHorizontalPadding =
            mediaQuery.padding.copyWith(top: 0.0, bottom: 0.0);
        final EdgeInsets mediaQueryVerticalPadding =
            mediaQuery.padding.copyWith(top: 0.0, left: 0.0, right: 0.0);
        // Consume the main axis padding with SliverPadding.
        effectivePadding = scrollDirection == Axis.vertical
            ? mediaQueryVerticalPadding
            : mediaQueryHorizontalPadding;
        // Leave behind the cross axis padding.
        sliverList = MediaQuery(
          data: mediaQuery.copyWith(
            padding: scrollDirection == Axis.vertical
                ? mediaQueryHorizontalPadding
                : mediaQueryVerticalPadding,
          ),
          child: sliverList,
        );
      }
    }
    if (effectivePadding != null)
      sliverList = SliverPadding(padding: effectivePadding, sliver: sliverList);
    return sliverList;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<EdgeInsetsGeometry>('padding', padding,
        defaultValue: null));
  }
}
