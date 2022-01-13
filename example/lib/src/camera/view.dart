import 'dart:io';

import 'package:camera/camera.dart';
import 'package:example/src/camera/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';
import 'package:video_player/video_player.dart';

/// Camera page for taking a picture or recording a video
class CameraPage extends StatelessWidget {
  const CameraPage({Key? key}) : super(key: key);

  CameraModel get controller => Get.$find()!;

  @override
  Widget build(BuildContext context) => GetBuilder<CameraModel>(
        init: CameraModel(),
        builder: (controller) => ThemeBuilder(
          (context) => GetScaffold(
            title: "Capture Media",
            backgroundColor: Colors.black,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBarActions: [
              if (controller.file == null)
                GetButton.primaryIcon(
                  child: Icon(controller.flashIcon),
                  label: controller.flashLabel,
                  onPressed: controller.switchFlash,
                ),
              if (controller.file == null && !controller.isRecordingVideo)
                GetButton.primaryIcon(
                  child: Icon(controller.modeIcon),
                  label: controller.modeLabel,
                  onPressed: controller.switchMode,
                ),
              8.spaceX,
            ],
            floatingActionButton: controller.file != null
                ? null
                : FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: captureShape(),
                    onPressed: controller.capture,
                  ),
            bottomBar: controller.file == null
                ? (!controller.hasActionError
                    ? null
                    : ProgressSnackBar(
                        status: controller.actionStatus,
                        error: controller.actionError,
                        onCancel: controller.cancelAction,
                        action: GetText.ok(),
                        dismissible: true,
                      ))
                : Row(children: [
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: const Icon(CupertinoIcons.clear),
                      onPressed: controller.cancelAction,
                      mini: true,
                      heroTag: null,
                    ).paddingAll(24),
                    const Spacer(),
                    if (controller.file?.isVideo == true)
                      FloatingActionButton(
                        child: Icon(controller.playIcon),
                        onPressed: controller.playVideo,
                        heroTag: null,
                      ).paddingAll(16),
                    const Spacer(),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: const Icon(CupertinoIcons.check_mark),
                      onPressed: controller.acceptFile,
                      mini: true,
                      heroTag: null,
                    ).paddingAll(24),
                  ]),
            showProgress: controller.isAnyBusy,
            childrenAtFront: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    controller.observer.value;
                    return TextBox(
                      controller.duration,
                      color: Colors.red,
                      filled: true,
                      fontSize: 16,
                      padding: 4,
                      margin: const EdgeInsets.all(16),
                    );
                  }),
                ],
              ),
            ],
            child: controller.hasError
                ? MessageView(
                    error: controller.error,
                    onAction: controller.refreshData,
                  )
                : controller.isDataReady
                    ? SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width:
                                controller.cameraState?.previewSize?.height ??
                                    0,
                            height:
                                controller.cameraState?.previewSize?.width ?? 0,
                            child: AspectRatio(
                              aspectRatio:
                                  controller.videoPlayer?.value.aspectRatio ??
                                      1 / controller.cameraState!.aspectRatio,
                              child: controller.file != null
                                  ? (controller.file!.isImage
                                      ? Image.file(File(controller.file!.path))
                                      : controller.videoPlayer != null
                                          ? VideoPlayer(controller.videoPlayer!)
                                          : Container(height: 0))
                                  : CameraPreview(controller.camera),
                            ),
                          ),
                        ),
                      )
                    : null,
          ),
          theme: GetTheme.red(context),
        ),
      );

  Widget captureShape() => Stack(
        alignment: Alignment.center,
        children: [
          Ink(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 5, color: Colors.white),
            ),
          ),
          Ink(
            width: 42.6,
            height: 42.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: controller.captureColor,
            ),
          ),
          if (controller.isRecordingVideo)
            Ink(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
        ],
      );
}
