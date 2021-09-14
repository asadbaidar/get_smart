import 'dart:io';

import 'package:camera/camera.dart';
import 'package:example/src/camera/view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get_smart/get_smart.dart';
import 'package:video_player/video_player.dart';

/// Camera page for taking a picture or recording a video
class CameraPage extends StatelessWidget {
  const CameraPage();

  CameraModel get model => Get.$find()!;

  @override
  Widget build(BuildContext context) => GetBuilder<CameraModel>(
        init: CameraModel(),
        builder: (model) => ThemeBuilder(
          (context) => GetScaffold(
            title: "Capture Media",
            backgroundColor: Colors.black,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            appBarRightItems: [
              if (model.file == null)
                GetButton.primaryIcon(
                  child: Icon(model.flashIcon),
                  label: model.flashLabel,
                  onPressed: model.switchFlash,
                ),
              if (model.file == null && !model.isRecordingVideo)
                GetButton.primaryIcon(
                  child: Icon(model.modeIcon),
                  label: model.modeLabel,
                  onPressed: model.switchMode,
                ),
              SizedBox(width: 8),
            ],
            floatingActionButton: model.file != null
                ? null
                : FloatingActionButton(
                    backgroundColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: captureShape(),
                    onPressed: model.capture,
                  ),
            bottomBar: model.file == null
                ? (!model.hasActionError
                    ? null
                    : ProgressSnackBar(
                        status: model.actionStatus,
                        error: model.actionError,
                        onCancel: model.cancelAction,
                        action: GetText.ok(),
                        isDismissible: true,
                      ))
                : Row(children: [
                    FloatingActionButton(
                      backgroundColor: Colors.red,
                      child: Icon(CupertinoIcons.clear),
                      onPressed: model.cancelAction,
                      mini: true,
                      heroTag: null,
                    ).paddingAll(24),
                    Spacer(),
                    if (model.file?.isVideo == true)
                      FloatingActionButton(
                        child: Icon(model.playIcon),
                        onPressed: model.playVideo,
                        heroTag: null,
                      ).paddingAll(16),
                    Spacer(),
                    FloatingActionButton(
                      backgroundColor: Colors.green,
                      child: Icon(CupertinoIcons.check_mark),
                      onPressed: model.acceptFile,
                      mini: true,
                      heroTag: null,
                    ).paddingAll(24),
                  ]),
            showProgress: model.isAnyBusy,
            childrenAtFront: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    model.observer.value;
                    return TextBox(
                      model.duration,
                      color: Colors.red,
                      filled: true,
                      fontSize: 16,
                      padding: 4,
                      margin: EdgeInsets.all(16),
                    );
                  }),
                ],
              ),
            ],
            child: model.hasError
                ? MessageView(
                    error: model.modelError,
                    onAction: () => model.futureToRun(),
                  )
                : model.isDataReady
                    ? SizedBox.expand(
                        child: FittedBox(
                          fit: BoxFit.cover,
                          child: SizedBox(
                            width: model.cameraState?.previewSize?.height ?? 0,
                            height: model.cameraState?.previewSize?.width ?? 0,
                            child: AspectRatio(
                              aspectRatio:
                                  model.videoPlayer?.value.aspectRatio ??
                                      1 / model.cameraState!.aspectRatio,
                              child: model.file != null
                                  ? (model.file!.isImage
                                      ? Image.file(File(model.file!.path))
                                      : model.videoPlayer != null
                                          ? VideoPlayer(model.videoPlayer!)
                                          : Container(height: 0))
                                  : CameraPreview(model.camera),
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
              color: model.captureColor,
            ),
          ),
          if (model.isRecordingVideo)
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
