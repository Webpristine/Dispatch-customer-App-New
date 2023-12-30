import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/app_image.dart';

class SplashBackground extends StatelessWidget {
  const SplashBackground({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AppImage(
          Images.background,
          fit: BoxFit.cover,
          height: MediaQuery.of(context).size.height * 0.65,
          width: double.infinity,
        ),
        Padding(
            padding: EdgeInsets.only(
              top: 170.h,
            ),
            child: Center(
              child: AppImage(
                Images.appLogo,
                height: 170.h,
                width: 170.h,
                fit: BoxFit.contain,
              ).animate().fade(
                    duration: const Duration(milliseconds: 500),
                  ),
            ))
      ],
    );
  }
}
