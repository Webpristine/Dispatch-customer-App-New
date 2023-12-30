import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/routes.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/widgets/app_google_map.dart';

class RideCompleted extends StatefulWidget {
  const RideCompleted({
    super.key,
  });

  @override
  State<RideCompleted> createState() => _RideCompletedState();
}

class _RideCompletedState extends State<RideCompleted> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leadingWidth: 40.w,
        leading: InkWell(
          onTap: () {
            AppEnvironment.navigator.pushNamedAndRemoveUntil(
              GeneralRoutes.pages,
              (route) => false,
            );
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
      ),
      body: Stack(
        children: [
          AppGoogleMap(),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [],
          )
        ],
      ),
    );
  }
}
