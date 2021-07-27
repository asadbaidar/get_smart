import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get_smart/get_smart.dart';

class InteractiveViewerOverlay extends StatefulWidget {
  final Widget child;
  final double maxScale;

  const InteractiveViewerOverlay({
    required this.child,
    this.maxScale = 2.5,
    Key? key,
  }) : super(key: key);

  @override
  _InteractiveViewerOverlayState createState() =>
      _InteractiveViewerOverlayState();
}

class _InteractiveViewerOverlayState extends State<InteractiveViewerOverlay>
    with SingleTickerProviderStateMixin {
  final viewerKey = GlobalKey();
  Rect? placeholder;
  OverlayEntry? entry;
  final controller = TransformationController();
  Matrix4Tween? snapTween;
  final scale = ScaleUpdateDetails().obs;
  late AnimationController snap;

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
        setState(() {
          placeholder = null;
        });
      }
    });
  }

  @override
  void dispose() {
    snap.dispose();
    super.dispose();
  }

  Widget buildViewer(BuildContext context) {
    return InteractiveViewer(
        key: viewerKey,
        transformationController: controller,
        panEnabled: false,
        maxScale: widget.maxScale,
        child: widget.child,
        onInteractionUpdate: (details) => scale.value = details,
        onInteractionStart: (details) {
          if (placeholder != null) return;

          setState(() {
            final renderViewer =
                viewerKey.context!.findRenderObject() as RenderBox;
            // final renderObject = Get.context!.findRenderObject() as RenderBox;
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
                final _scale = scale.value;
                var isPanning = _scale.pointerCount > 1;
                var point = isPanning ? _scale.focalPoint : placeholder!.center;
                final scalar = max(1.0, min(_scale.scale, widget.maxScale));
                print("scale ${_scale.scale} scalar $scalar");
                return Container(
                  color: Colors.black
                      .withOpacity(max(1, min(_scale.scale, 1.70)) % 1),
                  child: Stack(
                    children: [
                      AnimatedPositioned.fromRect(
                        duration: (isPanning ? 50 : 150).milliseconds,
                        curve: isPanning ? Curves.linear : Curves.easeOut,
                        rect: Rect.fromCenter(
                          center: point,
                          width: placeholder!.width * scalar,
                          height: placeholder!.height * scalar,
                        ),
                        child: buildViewer(context),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
          Overlay.of(context)?.insert(entry!);
        },
        onInteractionEnd: (details) {
          scale.value = ScaleUpdateDetails(
            focalPoint: placeholder?.center ?? scale.value.focalPoint,
            horizontalScale: scale.value.horizontalScale,
            localFocalPoint: scale.value.localFocalPoint,
            pointerCount: scale.value.pointerCount,
            rotation: scale.value.rotation,
            scale: scale.value.scale,
            verticalScale: scale.value.verticalScale,
          );
          snapTween = Matrix4Tween(
            begin: controller.value,
            end: Matrix4.identity(),
          );
          snap.value = 0;
          snap.animateTo(
            1,
            duration: Duration(milliseconds: 250),
            curve: Curves.ease,
          );
        });
  }

  @override
  Widget build(BuildContext context) => Container(
        child: placeholder != null
            ? SizedBox.fromSize(size: placeholder!.size)
            : buildViewer(context),
      );
}
