import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:multitrip_user/app_enverionment.dart';

import 'package:multitrip_user/multitrip.dart';
import 'package:multitrip_user/routes.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/widgets/splashbackground.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _handleNavigation();
    });
  }

  Future<void> _handleNavigation() async {
    await Future.delayed(Duration(seconds: 1));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String isUserId = prefs.getString(Strings.userid) ?? "";
    final String istokenavailable = prefs.getString(Strings.accesstoken) ?? "";
    if (isUserId.isNotEmpty && istokenavailable.isNotEmpty) {
      AppEnvironment.navigator
          .pushNamedAndRemoveUntil(GeneralRoutes.pages, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil()..init(context);

    return Scaffold(
      backgroundColor: AppColors.appColor,
      body: ListView(
        children: [
          SplashBackground(),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              sizedBoxWithHeight(40),
              Text(
                "Welcome To First Choice\nDesignated Drivers",
                textAlign: TextAlign.center,
                style: AppText.text28w500.copyWith(
                  color: AppColors.black,
                ),
              ).animate().slideY(
                    duration: const Duration(milliseconds: 500),
                  ),
              sizedBoxWithHeight(20),
              InkWell(
                onTap: () {
                  isLoggedIn(context: context);
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                  width: double.infinity,
                  child: Center(
                    child: Text(
                      "Get Started",
                      style: AppText.text15w400.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                  decoration: BoxDecoration(
                    color: AppColors.green,
                    borderRadius: BorderRadius.circular(
                      10.r,
                    ),
                  ),
                ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
              )
            ],
          ),
        ],
      ),
    );
  }
}
