import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// A widget that enables pan and zoom interactions with its child.
class GetInteractiveViewer extends StatefulWidget {
  /// Create an GetInteractiveViewer.
  ///
  /// The [child] parameter must not be null.
  const GetInteractiveViewer({
    required this.child,
    this.minScale = 1.0,
    this.maxScale = 2.5,
    this.barrierColor = Colors.black,
    this.backgroundColor,
    this.enabled = true,
    Key? key,
  }) : super(key: key);

  final Widget child;

  /// The minimum allowed scale.
  ///
  /// The scale will be clamped between this and [maxScale] inclusively.
  ///
  /// Defaults to 1.0.
  final double minScale;

  /// The maximum allowed scale.
  ///
  /// The scale will be clamped between this and [minScale] inclusively.
  ///
  /// Defaults to 2.5.
  final double maxScale;
  final Color barrierColor;
  final Color? backgroundColor;
  final bool enabled;

  @override
  State<StatefulWidget> createState() => _GetInteractiveViewerState();
}

class _GetInteractiveViewerState extends State<GetInteractiveViewer>
    with SingleTickerProviderStateMixin {
  final viewerKey = GlobalKey();
  final controller = TransformationController();
  final scaleDetails = ScaleUpdateDetails().obs;
  late AnimationController snap;

  Rect? placeholder;
  OverlayEntry? entry;
  Matrix4Tween? snapTween;

  @override
  void initState() {
    super.initState();
    snap = AnimationController(vsync: this);
    snap.addListener(() {
      if (snapTween == null) return;
      controller.value = snapTween!.evaluate(snap);
      if (snap.isCompleted) {
        entry?.remove();
        entry = null;
        setState(() => placeholder = null);
      }
    });
  }

  @override
  void dispose() {
    snap.dispose();
    super.dispose();
  }

  Widget buildViewer(BuildContext context) => InteractiveViewer(
      key: viewerKey,
      transformationController: controller,
      panEnabled: false,
      maxScale: 1,
      child: widget.child,
      onInteractionUpdate: (details) => scaleDetails.value = details,
      onInteractionStart: (details) {
        if (!widget.enabled ||
            placeholder != null ||
            details.pointerCount <= 1) {
          return;
        }

        setState(() {
          final renderViewer =
              viewerKey.context!.findRenderObject() as RenderBox;
          // placeholder = Rect.fromPoints(
          //   renderViewer.localToGlobal(Offset.zero),
          //   renderViewer
          //       .localToGlobal(renderViewer.size.bottomRight(Offset.zero)),
          // );
          placeholder = Rect.fromCenter(
            center: renderViewer
                .localToGlobal(renderViewer.size.center(Offset.zero)),
            width: renderViewer.size.width,
            height: renderViewer.size.height,
          );
        });

        entry = OverlayEntry(
          builder: (context) => Obx(
            () {
              final _details = scaleDetails.value;
              final panning = _details.pointerCount > 1;
              final barrierOpacity = max(1.0, min(_details.scale, 1.70)) % 1;
              final focal = panning ? _details.focalPoint : placeholder!.center;
              final scale = max(
                widget.minScale,
                min(_details.scale, widget.maxScale),
              );
              return Container(
                color: widget.barrierColor.withOpacity(barrierOpacity),
                child: Stack(children: [
                  AnimatedPositioned.fromRect(
                    duration: (panning ? 50 : 150).milliseconds,
                    curve: panning ? Curves.linear : Curves.easeOut,
                    rect: Rect.fromCenter(
                      center: focal,
                      width: placeholder!.width * scale,
                      height: placeholder!.height * scale,
                    ),
                    child: buildViewer(context),
                  ),
                ]),
              );
            },
          ),
        );
        Overlay.of(context)?.insert(entry!);
      },
      onInteractionEnd: (details) {
        scaleDetails.value = ScaleUpdateDetails(
          focalPoint: placeholder?.center ?? scaleDetails.value.focalPoint,
          horizontalScale: scaleDetails.value.horizontalScale,
          localFocalPoint: scaleDetails.value.localFocalPoint,
          pointerCount: scaleDetails.value.pointerCount,
          rotation: scaleDetails.value.rotation,
          scale: scaleDetails.value.scale,
          verticalScale: scaleDetails.value.verticalScale,
        );
        snapTween = Matrix4Tween(
          begin: controller.value,
          end: Matrix4.identity(),
        );
        snap.value = 0;
        snap.animateTo(
          1,
          duration: 250.milliseconds,
          curve: Curves.ease,
        );
      });

  @override
  Widget build(BuildContext context) => Container(
        color: widget.backgroundColor ?? context.canvasColor,
        width: placeholder?.width,
        height: placeholder?.height,
        child: placeholder == null ? buildViewer(context) : null,
      );
}
