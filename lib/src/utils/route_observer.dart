import 'package:flutter/material.dart';

/// Route observer for listening any changes happening in the navigation.
class GetRouteObserver extends RouteObserver<PageRoute> {
  factory GetRouteObserver() => _instance;

  GetRouteObserver._private();

  static final GetRouteObserver _instance = GetRouteObserver._private();
}
