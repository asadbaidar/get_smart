import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

class Responsive extends StatelessWidget {
  Responsive({
    required this.children,
    this.runSpacing = 0.0,
    this.alignment = WrapAlignment.start,
    this.runAlignment = WrapAlignment.start,
    this.crossAxisAlignment = WrapCrossAlignment.start,
  });

  final List<Widget> children;

  /// How the children within a run should be placed in the main axis.
  ///
  /// For example, if [alignment] is [WrapAlignment.center], the children in
  /// each run are grouped together in the center of their run in the main axis.
  ///
  /// Defaults to [WrapAlignment.start].
  final WrapAlignment alignment;

  /// How the runs themselves should be placed in the cross axis.
  ///
  /// For example, if [runAlignment] is [WrapAlignment.center], the runs are
  /// grouped together in the center of the overall [Wrap] in the cross axis.
  ///
  /// Defaults to [WrapAlignment.start].
  ///
  final WrapAlignment runAlignment;

  /// How the children within a run should be aligned relative to each other in
  /// the cross axis.
  ///
  /// For example, if this is set to [WrapCrossAlignment.end], and the
  /// [direction] is [Axis.horizontal], then the children within each
  /// run will have their bottom edges aligned to the bottom edge of the run.
  ///
  /// Defaults to [WrapCrossAlignment.start].
  ///
  final WrapCrossAlignment crossAxisAlignment;

  /// How much space to place between the runs themselves in the cross axis.
  ///
  /// For example, if [runSpacing] is 10.0, the runs will be spaced at least
  /// 10.0 logical pixels apart in the cross axis.
  ///
  /// If there is additional free space in the overall [Wrap] (e.g., because
  /// the wrap has a minimum size that is not filled), the additional free space
  /// will be allocated according to the [runAlignment].
  ///
  /// Defaults to 0.0.
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: alignment,
      runSpacing: runSpacing,
      children: children,
      runAlignment: runAlignment,
      crossAxisAlignment: crossAxisAlignment,
    );
  }
}

class Div extends StatelessWidget {
  final Widget child;

  /// Small screen `< 600.0`
  ///
  /// input range [0 -12]
  ///
  /// `0` ~ 0.0 width / gone
  ///i
  /// `12` ~ full width
  ///
  /// default `12`
  final int colS;

  /// Medium screen `600.0 to 990.0`
  ///
  /// input range [0 -12]
  ///
  /// `0` ~ 0.0 width / gone
  ///
  /// `12` ~ full width
  ///
  /// `null` / `default` ~ takes [ColS] value
  final int? colM;

  /// Large screen `> 990.0`
  ///
  /// input range [0 -12]
  ///
  /// `0` ~ 0.0 width / gone
  ///
  /// `12` ~ full width
  ///
  /// `null` / `default` ~  takes [ColM] value
  final int? colL;

  /// input range [0 -12]
  ///
  /// default `0`
  final int offsetS;

  /// input range [0 -12]
  ///
  /// default `0`
  final int offsetM;

  /// input range [0 -12]
  ///
  /// default `0`
  final int offsetL;

  final double _widthMobile = 600.0;

  final double _widthTab = 990;

  Div(
      {this.colS = 12,
      this.colM,
      this.colL,
      required this.child,
      this.offsetS = 0,
      this.offsetM = 0,
      this.offsetL = 0})
      : assert(colS >= 0 && colS <= 12),
        assert(colM == null || (colM >= 0 && colM <= 12)),
        assert(colL == null || (colL >= 0 && colL <= 12)),
        assert(offsetS >= 0 && offsetS <= 11),
        assert(offsetM >= 0 && offsetM <= 11),
        assert(offsetL >= 0 && offsetL <= 11),
        assert(colS + offsetS <= 12,
            "sum of the col and the respective offset should be less than or equal to 12"),
        assert(colM == null || (colM + offsetM <= 12),
            "sum of the col and the respective offset should be less than or equal to 12"),
        assert(colL == null || (colL + offsetL <= 12),
            "sum of the col and the respective offset should be less than or equal to 12");

  @override
  Widget build(BuildContext context) {
    return _createDivWidget(child, context);
  }

  Widget _createDivWidget(Widget child, BuildContext context) {
    int _col = 0;
    int _offsetWithCol = 0;
    double width = context.mediaQuery.size.width;
    if (width < _widthMobile) {
      _col = colS;
      _offsetWithCol = (offsetS + _col >= 12) ? 12 : offsetS + _col;
    } else if (width < _widthTab) {
      _col = colM ?? colS;
      _offsetWithCol = (offsetM + _col >= 12) ? 12 : offsetM + _col;
    } else {
      _col = colL ?? colM ?? colS;
      _offsetWithCol = (offsetL + _col >= 12) ? 12 : offsetL + _col;
    }
    return LayoutBuilder(builder: (ctx, box) {
      double width = (box.maxWidth / 12) * _offsetWithCol;
      return width == 0
          ? SizedBox.shrink()
          : SizedBox(
              width: width,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(width: (box.maxWidth / 12) * _col, child: child),
                ],
              ),
            );
    });
  }
}
