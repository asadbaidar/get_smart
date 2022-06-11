import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_smart/get_smart.dart';

class DottedPageView extends StatefulWidget {
  DottedPageView.builder({
    this.dotColor = Colors.white38,
    this.dotActiveColor = Colors.white,
    this.scrollDirection = Axis.horizontal,
    this.autoPlay = true,
    this.reverse = false,
    PageController? controller,
    this.physics,
    this.pageSnapping = true,
    this.onPageChanged,
    this.itemBuilder,
    this.itemCount = 0,
    this.dragStartBehavior = DragStartBehavior.start,
    this.allowImplicitScrolling = false,
    this.restorationId,
    this.clipBehavior = Clip.hardEdge,
    this.size,
    Key? key,
  })  : _key = key,
        controller = controller ?? PageController(),
        super(key: null);

  final Color dotColor;
  final Color dotActiveColor;
  final Axis scrollDirection;
  final bool autoPlay;
  final bool reverse;
  final PageController controller;
  final ScrollPhysics? physics;
  final bool pageSnapping;
  final void Function(int)? onPageChanged;
  final IndexedWidgetBuilder? itemBuilder;
  final int itemCount;
  final DragStartBehavior dragStartBehavior;
  final bool allowImplicitScrolling;
  final String? restorationId;
  final Clip clipBehavior;
  final Size? size;
  final Key? _key;

  @override
  State<StatefulWidget> createState() => _DottedPageViewState();
}

class _DottedPageViewState extends State<DottedPageView>
    with SingleTickerProviderStateMixin {
  static const double duration = 10;
  final _index = 0.obs;
  Ticker? _ticker;
  int _elapsed = 0;

  @override
  void initState() {
    super.initState();
    if (widget.autoPlay == true) {
      _ticker = createTicker((elapsed) {
        if (_elapsed != elapsed.inSeconds &&
            elapsed.inSeconds >= duration &&
            elapsed.inSeconds % duration == 0) {
          _elapsed = elapsed.inSeconds;
          updatePage();
        }
      });
      _ticker?.start();
    }
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _ticker = null;
    super.dispose();
  }

  void updatePage() {
    if (widget.controller.hasClients) {
      widget.controller.animateToPage(
        _index.value == widget.itemCount - 1 ? 0 : _index.value + 1,
        duration: 1500.milliseconds,
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox.fromSize(
        size: widget.size,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            PageView.builder(
              key: widget._key,
              scrollDirection: widget.scrollDirection,
              reverse: widget.reverse,
              controller: widget.controller,
              physics: widget.physics,
              pageSnapping: widget.pageSnapping,
              onPageChanged: (index) {
                _index.value = index;
                widget.onPageChanged?.call(index);
              },
              itemBuilder: widget.itemBuilder!,
              itemCount: widget.itemCount,
              dragStartBehavior: widget.dragStartBehavior,
              allowImplicitScrolling: widget.allowImplicitScrolling,
              restorationId: widget.restorationId,
              clipBehavior: widget.clipBehavior,
            ),
            if (widget.itemCount > 1)
              Obx(
                () => DotsIndicator(
                  decorator: DotsDecorator(
                    color: widget.dotColor,
                    activeColor: widget.dotActiveColor,
                    size: const Size.square(8),
                    activeSize: const Size.square(8),
                    spacing: const EdgeInsets.all(4),
                  ),
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  dotsCount: widget.itemCount,
                  position: min(_index.value, widget.itemCount - 1).toDouble(),
                ),
              ),
          ],
        ),
      );
}
