import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get_it/get_it.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/api/token_manager.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/blocs/address/address_bloc.dart';
import 'package:multitrip_user/blocs/bookride/bookride_bloc.dart';
import 'package:multitrip_user/blocs/confirmride/confirmride_bloc.dart';
import 'package:multitrip_user/blocs/dashboard/dashboard_controller.dart';
import 'package:multitrip_user/blocs/locationbloc/location_bloc_bloc.dart';
import 'package:multitrip_user/blocs/login/login_bloc.dart';
import 'package:multitrip_user/blocs/member/member_bloc.dart';
import 'package:multitrip_user/features/rate/rate_driver_controller.dart';
import 'package:multitrip_user/logic/add_member/member_controller.dart';
import 'package:multitrip_user/logic/after_booking_controller.dart';
import 'package:multitrip_user/logic/vehicle/vehicle_controller.dart';
import 'package:multitrip_user/notitifcation.dart';
import 'package:multitrip_user/routes.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MultiTrip extends StatefulWidget {
  const MultiTrip({
    super.key,
  });

  @override
  State<MultiTrip> createState() => _MultiTripState();
}

class _MultiTripState extends State<MultiTrip> {
  final getIt = GetIt.I;

  @override
  void initState() {
    super.initState();
    _registerNotifiers();
    _askNotificationPermission();
    _handleNotification();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LocationBlocBloc(),
        ),
        BlocProvider(
          create: (context) => LoginBloc(),
        ),
        BlocProvider(
          create: (context) => AddressBloc(),
        ),
        BlocProvider(
          create: (context) => BookrideBloc(),
        ),
        BlocProvider(
          create: (context) => MemberBloc(),
        ),
        BlocProvider(
          create: (context) => ConfirmrideBloc(),
        ),
      ],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => getIt<DashBoardController>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<AccountController>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<MembersController>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<AfterBookingController>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<RateDriverController>(),
          ),
          ChangeNotifierProvider(
            create: (_) => getIt<VehicleController>(),
          ),
        ],
        child: KeyboardVisibilityProvider(
          child: MaterialApp(
            color: AppColors.appColor,
            onGenerateRoute: Routes.onGenerateRoute,
            navigatorKey: AppEnvironment.rootNavigationKey,
            navigatorObservers: [
              AppEnvironment.routeObserver,
            ],
            initialRoute: Routes.splash,
            title: Strings.appname,
            debugShowCheckedModeBanner: false,
          ),
        ),
      ),
    );
  }

  void _registerNotifiers() {
    getIt.registerSingleton(
      VehicleController(),
    );
    getIt.registerSingleton(
      AccountController(),
    );
    getIt.registerSingleton(
      MembersController(),
    );
    getIt.registerSingleton(
      AfterBookingController(),
    );
    getIt.registerSingleton(
      RateDriverController(),
    );
    getIt.registerSingleton(
      DashBoardController(),
    );
    getIt.registerSingleton(
      TokenManager(),
    );
  }

  void _askNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
  }

  Future<void> _handleNotification() async {
    await LocalNotification.instance.init();

    final message = await FirebaseMessaging.instance.getInitialMessage();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.data);

      LocalNotification.instance.showNotification(message);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      LocalNotification.instance.showNotification(message);
    });

    FirebaseMessaging.instance.getToken().then((token) async {});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String istokenavailable = prefs.getString(Strings.userid) ?? "";
    if (istokenavailable.isNotEmpty) {
      AppEnvironment.navigator
          .pushNamedAndRemoveUntil(GeneralRoutes.pages, (_) => false);
    }
    final fcmToken = await FirebaseMessaging.instance.getToken();
    await prefs.setString('fcm', fcmToken ?? '');
  }

  @override
  void onPause() {}

  @override
  void onResume() {}

  Future<void> _handleNavigation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String isUserId = prefs.getString(Strings.userid) ?? "";
    final String istokenavailable = prefs.getString(Strings.accesstoken) ?? "";
    if (isUserId.isNotEmpty && istokenavailable.isNotEmpty) {
      AppEnvironment.navigator
          .pushNamedAndRemoveUntil(GeneralRoutes.pages, (_) => false);
    }
  }
}

Future<void> isLoggedIn({required BuildContext context}) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String isUserId = prefs.getString(Strings.userid) ?? "";
  final String istokenavailable = prefs.getString(Strings.accesstoken) ?? "";
  if (istokenavailable.isEmpty || isUserId.isEmpty) {
    AppEnvironment.navigator.popAndPushNamed(AuthRoutes.loginmobile);
  } else {
    AppEnvironment.navigator
        .pushNamedAndRemoveUntil(GeneralRoutes.pages, (_) => false);
  }
}
