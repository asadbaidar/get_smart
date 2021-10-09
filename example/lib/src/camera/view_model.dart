import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';
import 'package:video_player/video_player.dart';

enum CameraAction { photo, video }

class CameraModel extends GetController {
  static CameraModel? get instance => Get.$find();

  var mode = CameraAction.photo;

  bool get isPhotoMode => mode == CameraAction.photo;

  bool get isVideoMode => mode == CameraAction.video;

  IconData get modeIcon =>
      isPhotoMode ? CupertinoIcons.camera_fill : CupertinoIcons.videocam_fill;

  String get modeLabel => isPhotoMode ? "Photo" : "Video";

  void switchMode() {
    mode = isPhotoMode ? CameraAction.video : CameraAction.photo;
    update();
  }

  IconData get captureIcon => isRecordingVideo
      ? CupertinoIcons.stop_fill
      : isPhotoMode
          ? CupertinoIcons.circle
          : CupertinoIcons.circle_fill;

  Color? get captureColor => isRecordingVideo
      ? null
      : isPhotoMode
          ? Colors.white
          : Colors.red;

  void capture() => isRecordingVideo
      ? stopVideoRecording()
      : isPhotoMode
          ? takePhoto()
          : startVideoRecording();

  IconData get flashIcon {
    switch (cameraState?.flashMode ?? FlashMode.auto) {
      case FlashMode.off:
        flashLabel = "Off";
        return Icons.flash_off;
      case FlashMode.auto:
        flashLabel = "Auto";
        return Icons.flash_auto;
      case FlashMode.always:
        flashLabel = "On";
        return Icons.flash_on;
      case FlashMode.torch:
        flashLabel = "Torch";
        return Icons.highlight_rounded;
    }
  }

  final flashModes = FlashMode.values;
  int flashMode = 1;
  String flashLabel = "Auto";

  void switchFlash() => runBusyAction(() async {
        try {
          flashMode = flashMode < flashModes.length - 1 ? flashMode + 1 : 0;
          return camera
              .setFlashMode(flashModes[flashMode])
              .then((_) => GetResult.success())
              .catchError((e) => GetResult.error(
                    $cast<CameraException>(e)?.description ??
                        e?.toString() ??
                        "Something went wrong while switching flash mode. Please try again.",
                  ));
        } on CameraException catch (e) {
          return GetResult.error(e.description);
        } catch (e) {
          return GetResult.error(e.toString());
        }
      });

  CameraValue? get cameraState => isDataReady ? camera.value : null;

  bool get isRecordingVideo => cameraState?.isRecordingVideo == true;

  late CameraController camera;

  @override
  Future<void> onInit() async {
    final cameras = await availableCameras();
    camera = CameraController(cameras.first, ResolutionPreset.veryHigh);
    camera.addListener(() => observer.value++);
    super.onInit();
  }

  @override
  Future futureToRun() => prepareCamera();

  Future prepareCamera() => runBusyRunner(() async {
        try {
          return camera
              .initialize()
              .then((_) => GetResult.success())
              .catchError((e) => GetResult.error(
                    $cast<CameraException>(e)?.description ??
                        e?.toString() ??
                        "Something went wrong while setting up the camera. Please try again.",
                  ));
        } on CameraException catch (e) {
          return GetResult.error(e.description);
        } catch (e) {
          return GetResult.error(e.toString());
        }
      });

  GetFile? get file => actionData()?.value;

  @override
  void cancelAction() {
    super.cancelAction();
    videoPlayer?.pause();
  }

  void acceptFile() {
    videoPlayer?.pause();
    Get.back(result: file);
  }

  Future takePhoto() => runBusyAction(() async {
        try {
          return camera
              .takePicture()
              .then((photo) => GetResult.success()
                ..value = GetFile(
                  path: photo.path,
                  name: photo.name,
                ))
              .catchError((e) => GetResult.error(
                  $cast<CameraException>(e)?.description ?? e?.toString()));
        } on CameraException catch (e) {
          return GetResult.error(e.description);
        } catch (e) {
          return GetResult.error(e.toString());
        }
      });

  Future startVideoRecording() => runBusyAction(() async {
        try {
          if (Get.isIOS) await camera.prepareForVideoRecording();
          return camera.startVideoRecording().then((_) {
            _timer.start();
            return GetResult.success();
          }).catchError((e) => GetResult.error(
              $cast<CameraException>(e)?.description ?? e?.toString()));
        } on CameraException catch (e) {
          return GetResult.error(e.description);
        } catch (e) {
          return GetResult.error(e.toString());
        }
      });

  Future stopVideoRecording() => runBusyAction(() async {
        try {
          return camera.stopVideoRecording().then((video) {
            _timer.cancel();
            return prepareVideoPlayer(GetFile(
              path: video.path,
              name: video.name,
            ));
          }).catchError((e) => GetResult.error(
              $cast<CameraException>(e)?.description ?? e?.toString()));
        } on CameraException catch (e) {
          return GetResult.error(e.description);
        } catch (e) {
          return GetResult.error(e.toString());
        }
      });

  VideoPlayerValue? get videoState => videoPlayer?.value;
  VideoPlayerController? videoPlayer;
  final observer = 0.obs;

  Future<GetResult> prepareVideoPlayer(GetFile file) {
    videoPlayer?.dispose();
    videoPlayer = VideoPlayerController.file(File(file.path));
    videoPlayer?.addListener(() => observer.value++);
    videoPlayer?.setLooping(true);
    return videoPlayer!
        .initialize()
        .then((_) => GetResult.success()..value = file)
        .catchError((e) => GetResult.error(
              e?.toString() ??
                  "Something went wrong while saving the video. Please try again.",
            ));
  }

  final GetTimer _timer = GetTimer();

  String? get duration => (isRecordingVideo
          ? _timer.elapsed
          : file == null
              ? null
              : isPlayingVideo
                  ? videoState?.position
                  : videoState?.duration)
      ?.formattedHHmmSS;

  bool get isPlayingVideo => videoState?.isPlaying == true;

  IconData get playIcon =>
      isPlayingVideo ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill;

  void playVideo() {
    isPlayingVideo ? videoPlayer?.pause() : videoPlayer?.play();
    update();
  }

  @override
  void onClose() {
    camera.dispose();
    videoPlayer?.dispose();
    super.onClose();
  }
}
