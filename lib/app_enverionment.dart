import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class AppEnvironment {
  AppEnvironment._();
  static final rootNavigationKey = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<ModalRoute>();

  // Theme configuration
  static final brightness = SchedulerBinding.instance.window.platformBrightness;

  // Navigator configuration
  static BuildContext get ctx => rootNavigationKey.currentContext!;
  static NavigatorState get navigator => rootNavigationKey.currentState!;

  // User object
  static ValueNotifier<bool> isPostUploading = ValueNotifier(false);
}
