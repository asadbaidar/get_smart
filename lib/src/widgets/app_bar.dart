import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

typedef GetSimpleAppBar = PreferredSizeWidget;
typedef GetSliverAppBar = List<Widget>;

class GetAppBar {
  static AppBar status(
    BuildContext context, {
    bool hidden = false,
  }) =>
      AppBar(
        toolbarHeight: context.viewInsets.top.abs(),
        elevation: hidden ? context.appBarElevation : 0,
      );

  static GetSimpleAppBar simple({
    Widget? leading,
    Widget? bottom,
    Widget? flexibleSpace,
    List<Widget>? actions,
    LinearProgress? progress,
    Widget? customTitle,
    String? title,
    TextStyle? titleStyle,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool? centerTitle,
    bool interactive = true,
    bool showLeading = true,
    bool? showProgress,
    double? elevation,
    double? toolbarHeight,
    double bottomHeight = 0.0,
    double bottomConstant = 48.0,
    double? leadingWidth,
    double? titleSpacing,
  }) {
    final _actions = interactive ? actions : null;
    final _progress = progress ??
        (showProgress != null ? LinearProgress(visible: showProgress) : null);
    final _toolbarHeight = toolbarHeight ??
        (Get.isIOS ? kMinInteractiveDimensionCupertino : kToolbarHeight);
    final _bottomHeight = (_progress?.height ?? 0) +
        (bottom == null ? 0 : bottomHeight + bottomConstant);
    return PreferredSize(
      preferredSize: Size.fromHeight(_toolbarHeight + _bottomHeight),
      child: ThemeBuilder((context) => AppBar(
            centerTitle:
                context.appBarCenterTitle(centerTitle, actions: _actions),
            automaticallyImplyLeading: false,
            titleTextStyle: context.appBarTheme.titleTextStyle?.copyWith(
              fontSize: titleStyle?.fontSize,
              color: titleStyle?.color,
              fontWeight: titleStyle?.fontWeight,
              fontFamily: titleStyle?.fontFamily,
            ),
            flexibleSpace: flexibleSpace,
            shape: shape,
            elevation: elevation,
            backgroundColor: backgroundColor,
            leading: showLeading ? leading ?? GetButton.back() : null,
            leadingWidth: leadingWidth ?? (leading == null ? 40.0 : null),
            titleSpacing: titleSpacing ??
                (showLeading ? kDensePaddingX : kStandardPaddingX),
            toolbarHeight: _toolbarHeight,
            title: customTitle ??
                (title != null ? Text(title) : Container(height: 0)),
            bottom: PreferredSize(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (bottom != null) bottom,
                  if (_progress != null) _progress,
                ],
              ),
              preferredSize: Size.fromHeight(_bottomHeight),
            ),
            actions: _actions,
          )),
    );
  }

  static GetSliverAppBar sliver({
    Widget? leading,
    Widget? bottom, // CupertinoSearchTextField()
    Widget? flexibleSpace,
    Widget? sliverRefresh,
    List<Widget>? actions,
    List<Widget>? largeActions,
    LinearProgress? progress,
    Widget? customTitle,
    Widget? customLargeTitle,
    String? title,
    TextStyle? titleStyle,
    TextStyle? largeTitleStyle,
    ShapeBorder? shape,
    Color? backgroundColor,
    bool largeTitle = true,
    bool? centerTitle,
    bool floating = false,
    bool pinned = true,
    bool interactive = true,
    bool showLeading = true,
    bool translucent = true,
    bool elevateAlways = true,
    bool? showProgress,
    double? elevation,
    double? toolbarHeight,
    double bottomHeight = 0.0,
    double bottomConstant = 36.0,
    double largeTitleHeight = 47.0,
    double? leadingWidth,
    double? titleSpacing,
    double topPadding = kStandardPadding,
    double bottomPadding = kStandardPadding,
    double leftPadding = kStandardPaddingX,
    double rightPadding = kStandardPaddingX,
    double? verticalPadding,
    double? horizontalPadding,
    SwipeRefreshCallback? onRefresh,
  }) {
    final _actions = interactive ? actions : null;
    final _largeActions = interactive ? largeActions : null;
    if (leading == null &&
        bottom == null &&
        sliverRefresh == null &&
        (_actions == null || _actions.isEmpty) &&
        (_largeActions == null || _largeActions.isEmpty) &&
        progress == null &&
        showProgress == null &&
        customTitle == null &&
        (customLargeTitle == null || !largeTitle) &&
        (title == null || title.isEmpty)) {
      return [];
    }
    final _topPadding = verticalPadding ?? topPadding;
    final _bottomPadding = verticalPadding ?? bottomPadding;
    final _leftPadding = horizontalPadding ?? leftPadding;
    final _rightPadding = horizontalPadding ?? rightPadding;

    final _progress = progress ??
        (showProgress != null ? LinearProgress(visible: showProgress) : null);

    final _hasLargeTitle = customLargeTitle != null ||
        (title != null && largeTitle) ||
        _largeActions?.isNotEmpty == true;

    final _largeTitleHeight =
        (_progress?.height ?? 0) + (_hasLargeTitle ? largeTitleHeight : 0);

    final _bottomHeight = (_progress?.height ?? 0) +
        (bottom == null
            ? 0
            : bottomHeight +
                bottomConstant +
                _topPadding.half.half +
                _bottomPadding -
                2);

    double _floatingBottomHeight({double visibility = 1.0}) =>
        _bottomHeight +
        (floating ? (_hasLargeTitle ? largeTitleHeight : 0) * visibility : 0.0);

    TextStyle? _titleTextStyle(BuildContext context, {bool large = false}) {
      final _style = large ? largeTitleStyle : titleStyle;
      final _fontSize = large ? 30.0 : null;
      final _fontWeight = large ? FontWeight.bold : null;
      return context.appBarTheme.titleTextStyle?.copyWith(
        fontSize: _style?.fontSize ?? _fontSize,
        color: _style?.color,
        fontWeight: _style?.fontWeight ?? _fontWeight,
        fontFamily: _style?.fontFamily,
      );
    }

    Widget _buildLargeTitle(BuildContext context, {double visibility = 1.0}) {
      Widget? _largeTitle;
      if (customLargeTitle != null) {
        _largeTitle = customLargeTitle;
      } else if (title != null && largeTitle) {
        final _style = _titleTextStyle(context, large: true);
        final _minFontSize = visibility < 1 ? _style?.fontSize ?? 30.0 : 14.0;
        _largeTitle = AutoSizeText(
          title,
          textAlign: TextAlign.start,
          minFontSize: _minFontSize,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          style: _style,
        );
      }
      return Container(
        constraints: BoxConstraints(minHeight: bottomConstant),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (_largeTitle != null)
              _largeTitle.flex(flex: 1000000000000000000, expanded: true),
            if (_largeActions?.isNotEmpty == true) 2.spaceX,
            const Spacer(),
            ..._largeActions ?? [],
          ],
        ),
      );
    }

    return [
      SliverLayoutBuilder(builder: (context, constraints) {
        // $debugPrint(constraints);
        final _offset = constraints.scrollOffset;
        final _elevation = floating
            ? context.appBarElevation
            : ((_offset * 1.01) - _largeTitleHeight)
                .clamp(0.0, context.appBarElevation);
        final _blur = ((_offset * 1.01) - _largeTitleHeight).clamp(0.0, 6.0);
        final _opacity = ((_offset - 15) / 15).clamp(0.0, 1.0);
        final _dy = ((_offset * -1.01) + 30).clamp(0.0, 14.0);
        final _visibility = ((25 - _offset) / 25).clamp(0.0, 1.0);
        final _overlapping = _offset >= _largeTitleHeight;
        // $debugPrint(elevation);
        return SliverAppBar(
          leadingWidth: leadingWidth ?? (leading == null ? 40.0 : null),
          titleSpacing: titleSpacing ??
              (showLeading ? kDensePaddingX : kStandardPaddingX),
          automaticallyImplyLeading: false,
          leading: showLeading ? leading?.row() ?? GetButton.back() : null,
          centerTitle:
              context.appBarCenterTitle(centerTitle, actions: _actions),
          backgroundColor: (backgroundColor ?? context.primaryColor)
              .applyIf(translucent && _blur > 0, (it) => it?.translucent),
          title: customTitle ??
              title?.mapIt((it) => !_hasLargeTitle
                  ? Text(it)
                  : Transform.translate(
                      offset: GetOffset.only(dy: _dy),
                      child: Opacity(
                        opacity: _opacity,
                        child: Text(it),
                      ),
                    )),
          titleTextStyle: _titleTextStyle(context),
          actions: _actions,
          elevation: elevation ?? _elevation,
          toolbarHeight: toolbarHeight ?? context.toolbarHeight,
          shape: shape,
          flexibleSpace: flexibleSpace,
          //Blur(blur: _blur)
          floating: floating,
          pinned: pinned,
          bottom: floating || _overlapping && pinned
              ? PreferredSize(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (floating && _hasLargeTitle)
                        SizedBox(
                          height: _largeTitleHeight * _visibility,
                          child: Opacity(
                            opacity: _visibility,
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: 5,
                                left: _leftPadding,
                                right: _rightPadding,
                                bottom: _bottomPadding.half,
                              ),
                              child: _buildLargeTitle(
                                context,
                                visibility: _visibility,
                              ),
                            ),
                          ),
                        ),
                      if (bottom != null)
                        Padding(
                          padding: EdgeInsets.only(
                            top: _topPadding.half.half,
                            bottom: _bottomPadding - 2,
                            left: _leftPadding,
                            right: _rightPadding,
                          ),
                          child: bottom,
                        ),
                      if (_progress != null && (!floating || _overlapping))
                        _progress,
                    ],
                  ),
                  preferredSize: Size.fromHeight(
                    _floatingBottomHeight(visibility: _visibility),
                  ),
                )
              : null,
        );
      }),
      sliverRefresh ??
          CupertinoSliverSwipeRefresh(
            onRefresh: onRefresh,
            backgroundColor: backgroundColor,
          ),
      SliverLayoutBuilder(builder: (context, constraints) {
        // $debugPrint(constraints);
        final _offset = constraints.scrollOffset == 0
            ? constraints.overlap
            : constraints.scrollOffset;
        final _opacity = ((25 - _offset) / 25).clamp(0.0, 1.0);
        final _dy = _offset.clamp(0.0, 20.0);
        final _overlapping = constraints.overlap >= _largeTitleHeight;
        // $debugPrint(_offset);
        return SliverToBoxAdapter(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Material(
                color: backgroundColor ?? context.primaryColor,
                shadowColor: context.appBarShadowColor,
                elevation: elevateAlways
                    ? elevation ?? context.appBarElevation * 0.8
                    : 0,
                child: floating ||
                        !(_hasLargeTitle || !_overlapping && bottom != null)
                    ? Container(
                        color: Colors.transparent,
                        height: context.appBarElevation +
                            (floating ? 0 : _largeTitleHeight),
                      )
                    : Container(
                        padding: EdgeInsets.only(
                          left: _leftPadding,
                          right: _rightPadding,
                          bottom: _bottomPadding.half,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_hasLargeTitle)
                              Transform.translate(
                                offset: GetOffset.only(dy: -_dy),
                                child: Opacity(
                                  opacity: _opacity,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: _buildLargeTitle(context),
                                  ),
                                ),
                              ),
                            if (!_overlapping && bottom != null)
                              Padding(
                                padding: EdgeInsets.only(
                                  top: _topPadding.half,
                                  bottom: _bottomPadding.half,
                                ),
                                child: bottom,
                              ),
                          ],
                        ),
                      ),
              ),
              if (!_overlapping && _progress != null) _progress,
            ],
          ),
        );
      }),
    ];
  }
}
