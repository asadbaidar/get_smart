import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_smart/get_smart.dart';

typedef SwipeRefreshState = RefreshIndicatorState;
typedef SwipeRefreshCallback = Future<void> Function();

class SwipeRefresh extends StatelessWidget {
  const SwipeRefresh({
    required this.child,
    required this.onRefresh,
    this.displacement = 40.0,
    this.edgeOffset = 0.0,
    this.color,
    this.backgroundColor,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.semanticsLabel,
    this.semanticsValue,
    this.strokeWidth = 2.0,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    Key? key,
  })  : _key = key,
        super(key: null);

  final Widget child;
  final SwipeRefreshCallback onRefresh;
  final double displacement;
  final double edgeOffset;
  final Color? color;
  final Color? backgroundColor;
  final ScrollNotificationPredicate notificationPredicate;
  final String? semanticsLabel;
  final String? semanticsValue;
  final double strokeWidth;
  final RefreshIndicatorTriggerMode triggerMode;
  final Key? _key;

  @override
  Widget build(BuildContext context) => RefreshIndicator(
        key: _key,
        child: child,
        onRefresh: onRefresh,
        displacement: displacement,
        edgeOffset: edgeOffset,
        notificationPredicate: notificationPredicate,
        semanticsLabel: semanticsLabel,
        semanticsValue: semanticsValue,
        strokeWidth: strokeWidth,
        triggerMode: triggerMode,
        color: color ?? context.primaryIconColor,
        backgroundColor: backgroundColor ?? context.primaryColor,
      );

  static GlobalKey<SwipeRefreshState> get newKey =>
      GlobalKey<SwipeRefreshState>();
}

/// A sliver widget implementing the iOS-style pull to refresh content control.
///
/// When inserted as the first sliver in a scroll view or behind other slivers
/// that still lets the scrollable overscroll in front of this sliver (such as
/// the [CupertinoSliverNavigationBar], this widget will:
///
///  * Let the user draw inside the overscrolled area via the passed in [builder].
///  * Trigger the provided [onRefresh] function when overscrolled far enough to
///    pass [refreshTriggerPullDistance].
///  * Continue to hold [refreshIndicatorExtent] amount of space for the [builder]
///    to keep drawing inside of as the [Future] returned by [onRefresh] processes.
///  * Scroll away once the [onRefresh] [Future] completes.
///
/// The [builder] function will be informed of the current [RefreshIndicatorMode]
/// when invoking it, except in the [RefreshIndicatorMode.inactive] state when
/// no space is available and nothing needs to be built. The [builder] function
/// will otherwise be continuously invoked as the amount of space available
/// changes from overscroll, as the sliver scrolls away after the [onRefresh]
/// task is done, etc.
///
/// Only one refresh can be triggered until the previous refresh has completed
/// and the indicator sliver has retracted at least 90% of the way back.
///
/// Can only be used in downward-scrolling vertical lists that overscrolls. In
/// other words, refreshes can't be triggered with [Scrollable]s using
/// [ClampingScrollPhysics] which is the default on Android. To allow overscroll
/// on Android, use an overscrolling physics such as [BouncingScrollPhysics].
/// This can be done via:
///
///  * Providing a [BouncingScrollPhysics] (possibly in combination with a
///    [AlwaysScrollableScrollPhysics]) while constructing the scrollable.
///  * By inserting a [ScrollConfiguration] with [BouncingScrollPhysics] above
///    the scrollable.
///  * By using [CupertinoApp], which always uses a [ScrollConfiguration]
///    with [BouncingScrollPhysics] regardless of platform.
///
/// In a typical application, this sliver should be inserted between the app bar
/// sliver such as [CupertinoSliverNavigationBar] and your main scrollable
/// content's sliver.
class CupertinoSliverSwipeRefresh extends StatelessWidget {
  /// Create a new refresh control for inserting into a list of slivers.
  ///
  /// The [refreshTriggerPullDistance] and [refreshIndicatorExtent] arguments
  /// must not be null and must be >= 0.
  ///
  /// The [builder] argument may be null, in which case no indicator UI will be
  /// shown but the [onRefresh] will still be invoked. By default, [builder]
  /// shows a [CupertinoActivityIndicator].
  ///
  /// The [onRefresh] argument will be called when pulled far enough to trigger
  /// a refresh.
  CupertinoSliverSwipeRefresh({
    this.refreshTriggerPullDistance = 100.0,
    this.refreshIndicatorExtent = 60.0,
    RefreshControlIndicatorBuilder? builder,
    bool? enabled,
    this.onRefresh,
    Key? key,
  })  : _key = key,
        builder = builder ??
            ((
              context,
              refreshState,
              pulledExtent,
              refreshTriggerPullDistance,
              refreshIndicatorExtent,
            ) =>
                buildRefreshIndicator(
                  context,
                  refreshState,
                  pulledExtent,
                  refreshTriggerPullDistance,
                  refreshIndicatorExtent,
                  enabled ?? onRefresh != null,
                )),
        super(key: null);

  final Key? _key;

  /// The amount of overscroll the scrollable must be dragged to trigger a reload.
  ///
  /// Must not be null, must be larger than 0.0 and larger than
  /// [refreshIndicatorExtent]. Defaults to 100px when not specified.
  ///
  /// When overscrolled past this distance, [onRefresh] will be called if not
  /// null and the [builder] will build in the [RefreshIndicatorMode.armed] state.
  final double refreshTriggerPullDistance;

  /// The amount of space the refresh indicator sliver will keep holding while
  /// [onRefresh]'s [Future] is still running.
  ///
  /// Must not be null and must be positive, but can be 0.0, in which case the
  /// sliver will start retracting back to 0.0 as soon as the refresh is started.
  /// Defaults to 60px when not specified.
  ///
  /// Must be smaller than [refreshTriggerPullDistance], since the sliver
  /// shouldn't grow further after triggering the refresh.
  final double refreshIndicatorExtent;

  /// A builder that's called as this sliver's size changes, and as the state
  /// changes.
  ///
  /// Can be set to null, in which case nothing will be drawn in the overscrolled
  /// space.
  ///
  /// Will not be called when the available space is zero such as before any
  /// overscroll.
  final RefreshControlIndicatorBuilder? builder;

  /// Callback invoked when pulled by [refreshTriggerPullDistance].
  ///
  /// If provided, must return a [Future] which will keep the indicator in the
  /// [RefreshIndicatorMode.refresh] state until the [Future] completes.
  ///
  /// Can be null, in which case a single frame of [RefreshIndicatorMode.armed]
  /// state will be drawn before going immediately to the [RefreshIndicatorMode.done]
  /// where the sliver will start retracting.
  final SwipeRefreshCallback? onRefresh;

  @override
  Widget build(BuildContext context) => CupertinoSliverRefreshControl(
        key: _key,
        refreshTriggerPullDistance: refreshTriggerPullDistance,
        refreshIndicatorExtent: refreshIndicatorExtent,
        builder: builder,
        onRefresh: onRefresh,
      );

  /// Builds a refresh indicator that reflects the standard iOS pull-to-refresh
  /// behavior. Specifically, this entails presenting an activity indicator that
  /// changes depending on the current refreshState. As the user initially drags
  /// down, the indicator will gradually reveal individual ticks until the refresh
  /// becomes armed. At this point, the animated activity indicator will begin rotating.
  /// Once the refresh has completed, the activity indicator shrinks away as the
  /// space allocation animates back to closed.
  static Widget buildRefreshIndicator(
    BuildContext context,
    RefreshIndicatorMode refreshState,
    double pulledExtent,
    double refreshTriggerPullDistance,
    double refreshIndicatorExtent,
    bool enabled,
  ) {
    final double percentageComplete =
        (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);

    // Place the indicator at the top of the sliver that opens up. Note that we're using
    // a Stack/Positioned widget because the CupertinoActivityIndicator does some internal
    // translations based on the current size (which grows as the user drags) that makes
    // Padding calculations difficult. Rather than be reliant on the internal implementation
    // of the activity indicator, the Positioned widget allows us to be explicit where the
    // widget gets placed. Also note that the indicator should appear over the top of the
    // dragged widget, hence the use of Overflow.visible.
    return Container(
      alignment: Alignment.center,
      color: context.primaryColor,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (enabled)
            Positioned(
              // top: 12.0,
              // left: 0.0,
              // right: 0.0,
              child: _buildIndicatorForRefreshState(
                refreshState,
                14.0,
                percentageComplete,
              ),
            ),
        ],
      ),
    );
  }

  static Widget _buildIndicatorForRefreshState(
    RefreshIndicatorMode refreshState,
    double radius,
    double percentageComplete,
  ) {
    switch (refreshState) {
      case RefreshIndicatorMode.drag:
        // While we're dragging, we draw individual ticks of the spinner while simultaneously
        // easing the opacity in. Note that the opacity curve values here were derived using
        // Xcode through inspecting a native app running on iOS 13.5.
        const Curve opacityCurve = Interval(0.0, 0.7, curve: Curves.easeInOut);
        return Opacity(
          opacity: opacityCurve.transform(percentageComplete),
          child: CupertinoActivityIndicator.partiallyRevealed(
            radius: radius,
            progress: percentageComplete,
          ),
        );
      case RefreshIndicatorMode.armed:
      case RefreshIndicatorMode.refresh:
        // Once we're armed or performing the refresh, we just show the normal spinner.
        return CupertinoActivityIndicator(radius: radius);
      case RefreshIndicatorMode.done:
        // When the user lets go, the standard transition is to shrink the spinner.
        return CupertinoActivityIndicator(radius: radius * percentageComplete);
      case RefreshIndicatorMode.inactive:
        // Anything else doesn't show anything.
        return Container();
    }
  }
}
