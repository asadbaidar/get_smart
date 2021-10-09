import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

/// States that an application can be in.
///
/// The function below describe notifications from the operating system.
/// Applications should not expect to always receive all possible
/// notifications. For example, if the users pulls out the battery from the
/// device, no notification will be sent before the application is suddenly
/// terminated, along with the rest of the operating system.
///
/// See also:
///
///  * [WidgetsBindingObserver], for a mechanism to observe the lifecycle state
///    from the widgets layer.
class GetAppLifecycle extends StatefulWidget {
  const GetAppLifecycle({
    this.onResume,
    this.onPaused,
    this.onInactive,
    this.onDetached,
    this.child,
    Key? key,
  }) : super(key: key);

  final Widget? child;

  /// The application is visible and responding to user input.
  final VoidCallback? onResume;

  /// The application is in an inactive state and is not receiving user input.
  ///
  /// On iOS, this state corresponds to an app or the Flutter host view running
  /// in the foreground inactive state. Apps transition to this state when in
  /// a phone call, responding to a TouchID request, when entering the app
  /// switcher or the control center, or when the UIViewController hosting the
  /// Flutter app is transitioning.
  ///
  /// On Android, this corresponds to an app or the Flutter host view running
  /// in the foreground inactive state.  Apps transition to this state when
  /// another activity is focused, such as a split-screen app, a phone call,
  /// a picture-in-picture app, a system dialog, or another window.
  ///
  /// Apps in this state should assume that they may be
  /// [AppLifecycleState.paused] at any time.
  final VoidCallback? onInactive;

  /// The application is not currently visible to the user, not responding to
  /// user input, and running in the background.
  ///
  /// When the application is in this state, the engine will not call the
  /// [PlatformDispatcher.onBeginFrame] and [PlatformDispatcher.onDrawFrame]
  /// callbacks.
  final VoidCallback? onPaused;

  /// The application is still hosted on a flutter engine but is detached from
  /// any host views.
  ///
  /// When the application is in this state, the engine is running without
  /// a view. It can either be in the progress of attaching a view when engine
  /// was first initializes, or after the view being destroyed due to a Navigator
  /// pop.
  final VoidCallback? onDetached;

  @override
  _GetAppLifecycleState createState() => _GetAppLifecycleState();
}

class _GetAppLifecycleState extends State<GetAppLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child ?? 0.space;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        widget.onResume?.call();
        break;
      case AppLifecycleState.paused:
        widget.onPaused?.call();
        break;
      case AppLifecycleState.inactive:
        widget.onInactive?.call();
        break;
      case AppLifecycleState.detached:
        widget.onDetached?.call();
        break;
    }
  }
}
