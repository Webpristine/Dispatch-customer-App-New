import 'package:flutter/material.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/auth/login/login_mobile.dart';
import 'package:multitrip_user/features/auth/login/login_password.dart';
import 'package:multitrip_user/features/auth/login/otp_login.dart';
import 'package:multitrip_user/features/auth/signup/signup.dart';
import 'package:multitrip_user/features/splash/splash.dart';

part 'auth_routes.dart';
part 'general_routes.dart';

///
/// Routes are divided into multiple parts based on modules
/// [AuthRoutes] contains auth module routes
///

class Routes {
  static String currentRoute = '/';
  static const splash = '/';

  static final routes = <String>{
    splash,
    ...AuthRoutes.authRoutes,
    ...GeneralRoutes.generalRoutes,
  };

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    currentRoute = settings.name ?? '/';
    Widget child;
    if (currentRoute.startsWith(AuthRoutes.authLeading)) {
      child = AuthRoutes.getPage(currentRoute, args);
    } else if (currentRoute.startsWith(GeneralRoutes.generalLeading)) {
      child = GeneralRoutes.getPage(currentRoute, args);
    } else if (currentRoute == Routes.splash) {
      child = const SplashScreen();
    } else {
      child = const SizedBox();
    }

    return MaterialPageRoute(
      builder: (_) => child,
      settings: settings,
    );
  }
}
