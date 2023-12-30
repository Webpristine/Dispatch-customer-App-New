import 'dart:developer';
import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/api/token_manager.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/features/auth/login/login_password.dart';
import 'package:multitrip_user/features/auth/login/widgets/nextfloatingbutton.dart';
import 'package:multitrip_user/models/login.dart';
import 'package:multitrip_user/routes.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:multitrip_user/widgets/splashbackground.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../api/app_repository.dart';

class LoginMobile extends StatefulWidget {
  const LoginMobile({super.key});

  @override
  State<LoginMobile> createState() => _LoginMobileState();
}

class _LoginMobileState extends State<LoginMobile> {
  Country country = Country(
    phoneCode: "+1",
    countryCode: "CA",
    e164Sc: 1,
    geographic: false,
    level: 1,
    name: "CANADA",
    example: "",
    displayName: "Canada",
    displayNameNoCountryCode: "",
    e164Key: "",
  );

  douserlogin({bool isPassword = false}) async {
    print("Calling");
    Loader.show(context,
        progressIndicator: CircularProgressIndicator(
          color: AppColors.appColor,
        ));
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    int deviceType = 1;

    try {
      await AppRepository().saveAccessToken();

      final fcmToken = await FirebaseMessaging.instance.getToken();
      await prefs.setString('fcm', fcmToken ?? '');
      if (Platform.isAndroid) {
        deviceType = 1;
      } else {
        deviceType = 2;
      }

      final login = await AppRepository().douserlogin(
          devicetype: deviceType.toString(),
          mobilenumber: phoneController.text,
          fcm: prefs.getString('fcm')!);
      Loader.hide();
      if (login["code"] == 200 || login["code"] == 201) {
        Loader.hide();
        final mobile = phoneController.text;
        phoneController.clear();
        GetIt.instance.get<TokenManager>().token = login['access_token'];
        if (isPassword && mobile.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPassword(
                mobilenumner: mobile,
              ),
            ),
          );
          return;
        }
        AppEnvironment.navigator
            .pushNamed(AuthRoutes.loginotp, arguments: mobile);
      }
    } catch (e) {
      Loader.hide();
      context.showSnackBar(
        context,
        msg: e.toString(),
      );
    } finally {
      Loader.hide();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  TextEditingController phoneController = TextEditingController();

  final _formkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Visibility(
        visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
        child: InkWell(
          onTap: () async {
            if (phoneController.text.isEmpty) {
              context.showSnackBar(context, msg: "Please enter mobile number");
            } else if (phoneController.text.length < 10) {
              context.showSnackBar(context,
                  msg: "Number should be 10 Characters ");
            } else if (phoneController.text.length > 11) {
              context.showSnackBar(context,
                  msg: "number should be 11 Characters long");
            } else {
              douserlogin();
              // AppEnvironment.navigator.pushNamed(
              //   AuthRoutes.otplogin,
              // );
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              NextFloatingButton(),
            ],
          ),
        ),
      ),
      backgroundColor: AppColors.appColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SplashBackground(),
            Padding(
              padding: EdgeInsets.only(left: 16.w, right: 16.w, top: 16.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Enter your mobile number",
                          style: AppText.text22w500.copyWith(
                            color: AppColors.black,
                          ))
                      .animate()
                      .moveX(
                          curve: Curves.fastOutSlowIn,
                          duration: Duration(milliseconds: 700)),
                  sizedBoxWithHeight(15),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          showCountryPicker(
                            context: context,
                            showPhoneCode:
                                true, // optional. Shows phone code before the country name.
                            onSelect: (Country scountry) {
                              setState(() {
                                country = scountry;
                                log(scountry.name + scountry.countryCode);
                              });
                            },
                          );
                        },
                        child: Container(
                          width: 65.w,
                          height: 40.h,
                          color: AppColors.mobilegrey,
                          padding: EdgeInsets.symmetric(
                            horizontal: 5.w,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                country.flagEmoji,
                                style: TextStyle(fontSize: 20.sp),
                              ),
                              sizedBoxWithWidth(10),
                              Icon(
                                Icons.arrow_drop_down_rounded,
                                color: AppColors.black,
                                size: 15,
                              ),
                            ],
                          ),
                        ),
                      ),
                      sizedBoxWithWidth(10),
                      Expanded(
                        child: Container(
                            height: 40.h,
                            padding: EdgeInsets.only(left: 10.w),
                            child: Row(
                              children: [
                                Text(country.phoneCode,
                                    style: AppText.text15Normal.copyWith(
                                      color: AppColors.black,
                                    )),
                                sizedBoxWithWidth(10),
                                Expanded(
                                  child: Form(
                                    key: _formkey,
                                    child: TextFormField(
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      maxLength: 11,
                                      cursorColor: AppColors.grey500,
                                      controller: phoneController,
                                      keyboardType: TextInputType.number,
                                      style: AppText.text15Normal.copyWith(
                                        color: AppColors.black,
                                      ),
                                      decoration: InputDecoration(
                                        counterText: '',
                                        isDense: true,
                                        hintText: " Mobile Number",
                                        hintStyle:
                                            AppText.text15Normal.copyWith(
                                          color: AppColors.hintColor,
                                        ),
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            color: AppColors.mobilegrey),
                      ),
                    ],
                  ).animate().scaleXY(
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 700)),
                  sizedBoxWithHeight(8),
                  InkWell(
                    onTap: () {
                      if (phoneController.text.isEmpty) {
                        context.showSnackBar(context,
                            msg: "Please enter mobile number");
                      } else if (phoneController.text.length > 11) {
                        context.showSnackBar(context,
                            msg: "number should be 11 Characters long");
                      } else {
                        douserlogin(isPassword: true);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Login with password",
                          style: GoogleFonts.poppins(
                              color: AppColors.green,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ).animate().slideX(
                      begin: 10,
                      curve: Curves.easeIn,
                      duration: Duration(milliseconds: 700)),
                  sizedBoxWithHeight(7),
                  Padding(
                    padding: EdgeInsets.only(
                      right: 50.w,
                    ),
                    child: Text(
                        "By proceeding you are consenting to receive calls or SMS messages, including by automated dialer from FCDD and its affiliates to the number you provide",
                        textAlign: TextAlign.justify,
                        style: AppText.text15w400.copyWith(
                          color: AppColors.colorgrey,
                          fontSize: 13.sp,
                        ))
                      ..animate().scaleX(
                          begin: 10,
                          curve: Curves.easeIn,
                          duration: Duration(milliseconds: 700)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
