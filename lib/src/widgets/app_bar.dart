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
    List<Widget>? actions,
    LinearProgress? progress,
    Widget? customTitle,
    String? title,
    TextStyle? titleStyle,
    bool? centerTitle,
    bool interactive = true,
    bool showLeading = true,
    double bottomHeight = 0.0,
    double bottomConstant = 48.0,
    double leadingWidth: 40.0,
    double titleSpacing: 8.0,
  }) {
    final _actions = interactive ? actions : null;
    final _toolbarHeight =
        Get.isIOS ? kMinInteractiveDimensionCupertino : kToolbarHeight;
    final _bottomHeight = (progress?.height ?? 0) +
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
            leading: showLeading ? leading ?? GetButton.back() : null,
            leadingWidth: leadingWidth,
            titleSpacing: titleSpacing,
            toolbarHeight: _toolbarHeight,
            title: customTitle ??
                (title != null ? Text(title) : Container(height: 0)),
            bottom: PreferredSize(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (bottom != null) bottom,
                  if (progress != null) progress,
                ],
              ),
              preferredSize: Size.fromHeight(_bottomHeight),
            ),
            actions: _actions,
          )),
    );
  }

  static GetSliverAppBar slivers({
    Widget? leading,
    Widget? bottom, // CupertinoSearchTextField()
    Widget? refreshSliver,
    List<Widget>? actions,
    List<Widget>? largeActions,
    LinearProgress? progress,
    Widget? customTitle,
    Widget? customLargeTitle,
    String? title,
    TextStyle? titleStyle,
    TextStyle? largeTitleStyle,
    bool largeTitle = true,
    bool? centerTitle,
    bool floating = false,
    bool pinned = true,
    bool interactive = true,
    bool showLeading = true,
    double bottomHeight = 0.0, // 36
    double largeTitleHeight = 48.0,
    double leadingWidth: 40.0,
    double titleSpacing: 8.0,
    double topPadding = kStandardPadding,
    double bottomPadding = kStandardPadding,
    double leftPadding = kStandardPaddingX,
    double rightPadding = kStandardPaddingX,
    double? verticalPadding,
    double? horizontalPadding,
  }) {
    final _actions = interactive ? actions : null;
    final _largeActions = interactive ? largeActions : null;
    if (leading == null &&
        bottom == null &&
        refreshSliver == null &&
        (_actions == null || _actions.isEmpty) &&
        (_largeActions == null || _largeActions.isEmpty) &&
        progress == null &&
        customTitle == null &&
        (customLargeTitle == null || !largeTitle) &&
        (title == null || title.isEmpty)) {
      return [];
    }
    final _topPadding = verticalPadding ?? topPadding;
    final _bottomPadding = verticalPadding ?? bottomPadding;
    final _leftPadding = horizontalPadding ?? leftPadding;
    final _rightPadding = horizontalPadding ?? rightPadding;
    final _toolbarHeight =
        Get.isIOS ? kMinInteractiveDimensionCupertino : kToolbarHeight;
    final _largeTitleHeight = largeTitleHeight;

    final _bottomHeight = (progress?.height ?? 0) +
        (bottom == null
            ? 0
            : bottomHeight + _topPadding.half.half + _bottomPadding - 2);

    final _hasLargeTitle = customLargeTitle != null ||
        (title != null && largeTitle) ||
        _largeActions?.isNotEmpty == true;

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
      if (customLargeTitle != null)
        _largeTitle = customLargeTitle;
      else if (title != null && largeTitle) {
        final _style = _titleTextStyle(context, large: true);
        final _minFontSize = visibility < 1 ? _style?.fontSize ?? 30.0 : 14.0;
        _largeTitle = AutoSizeText(
          title,
          textAlign: TextAlign.start,
          minFontSize: _minFontSize,
          style: _style,
        );
      }
      return Row(
        children: [
          if (_largeTitle != null) _largeTitle,
          Spacer(),
          ..._largeActions ?? [],
        ],
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
          leadingWidth: leadingWidth,
          titleSpacing: titleSpacing,
          automaticallyImplyLeading: false,
          leading: showLeading ? leading ?? GetButton.back() : null,
          centerTitle:
              context.appBarCenterTitle(centerTitle, actions: _actions),
          backgroundColor:
              context.primaryColor.applyIf(_blur > 0, (it) => it.translucent),
          title: customTitle ??
              title?.mapIt((it) => Transform.translate(
                    offset: GetOffset.only(dy: _dy),
                    child: Opacity(
                      opacity: _opacity,
                      child: Text(it),
                    ),
                  )),
          titleTextStyle: _titleTextStyle(context),
          actions: _actions,
          elevation: _elevation,
          toolbarHeight: _toolbarHeight,
          // flexibleSpace: Blur(blur: blur),
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
                      if (progress != null && (!floating || _overlapping))
                        progress,
                    ],
                  ),
                  preferredSize: Size.fromHeight(
                    _bottomHeight +
                        (floating ? _largeTitleHeight * _visibility : 0.0),
                  ),
                )
              : null,
        );
      }),
      if (refreshSliver != null) refreshSliver,
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
                color: context.primaryColor,
                shadowColor: context.appBarShadowColor,
                elevation: context.appBarElevation * 0.8,
                child: floating
                    ? Container(
                        color: Colors.transparent,
                        height: context.appBarElevation + 0.5,
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
                                    padding: EdgeInsets.only(top: 6),
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
              if (!_overlapping && progress != null) progress,
            ],
          ),
        );
      }),
    ];
  }
}