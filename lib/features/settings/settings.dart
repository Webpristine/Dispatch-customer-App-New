import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';
import 'package:multitrip_user/blocs/login/login_bloc.dart';
import 'package:multitrip_user/features/auth/login/login_mobile.dart';
import 'package:multitrip_user/features/settings/settings_add_home_work.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/widgets/html_render.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app_enverionment.dart';

class Settings extends StatefulWidget {
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  LoginBloc loginBloc = LoginBloc();
  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      appBar: AppBar(
        backgroundColor: AppColors.appColor,
        elevation: 0,
        leading: InkWell(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.close,
            color: Colors.black,
          ),
        ),
      ),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LogoutLoading) {
            Loader.show(context,
                progressIndicator: CircularProgressIndicator(
                  color: AppColors.green,
                ));
          } else if (state is LogoutFail) {
            Loader.hide();
            context.showSnackBar(context, msg: state.error);
          } else if (state is LogoutSuccess) {
            Loader.hide();

            // BlocProvider.of<DashboardBloc>(context).add(
            //   InitBloc(),
            // );

            AppEnvironment.navigator.pushReplacement(
              MaterialPageRoute(
                builder: (context) => LoginMobile(),
              ),
            );
          }
        },
        child: Consumer<AccountController>(builder: (context, model, _) {
          return Padding(
            padding: EdgeInsets.all(
              16.r,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Settings",
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                sizedBoxWithHeight(40),
                Row(
                  children: [
                    Container(
                      // padding: EdgeInsets.all(15),
                      clipBehavior: Clip.hardEdge,
                      height: 60.h,
                      width: 60.w,
                      decoration: BoxDecoration(
                        color: AppColors.green,
                        shape: BoxShape.circle,
                        image:
                            (model.userModel?.profilePhoto?.isNotEmpty ?? false)
                                ? DecorationImage(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(
                                        model.userModel?.profilePhoto ?? ''),
                                  )
                                : null,
                      ),
                      child:
                          (model.userModel?.profilePhoto?.isNotEmpty ?? false)
                              ? null
                              : Center(
                                  child: Icon(
                                    Icons.person,
                                    size: 40,
                                    color: Colors.white,
                                  ),
                                ),
                    ),
                    sizedBoxWithWidth(8),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          model.userModel?.name ?? "",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Text(
                          model.userModel?.mobileNumber ?? "",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        Text(
                          model.userModel?.email ?? "",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                sizedBoxWithHeight(40),
                InkWell(
                  onTap: () {
                    AppEnvironment.navigator.push(
                      MaterialPageRoute(
                        builder: (context) => AddHomeAndWork(),
                      ),
                    );
                  },
                  child: settingoptions(
                    icon: Icon(Icons.home),
                    text: "Saved Places",
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    AppEnvironment.navigator.push(MaterialPageRoute(
                        builder: (_) => HtmlRenderWidgetScreen(
                            endPoint: '/privacy_policy')));
                  },
                  child: settingoptions(
                      icon: Icon(Icons.lock),
                      text: "Privacy",
                      subTitle: 'Manage the data you share with us'),
                ),
                Spacer(),
                Divider(
                  color: AppColors.greydark,
                  thickness: 5,
                ),
                InkWell(
                  onTap: () async {
                    Loader.show(
                      context,
                    );

                    final SharedPreferences prefs =
                        await SharedPreferences.getInstance();

                    try {
                      await AppRepository().douserlogout(
                          accesstoken: prefs.getString(
                            Strings.accesstoken,
                          )!,
                          userid: prefs.getString(Strings.userid)!);

                      await prefs.remove(Strings.accesstoken);
                      // BlocProvider.of<DashboardBloc>(context).add(
                      //   InitBloc(),
                      // );
                      Loader.hide();
                      AppEnvironment.navigator.pushAndRemoveUntil(
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LoginMobile()),
                        (route) {
                          return false;
                        },
                      );

                      prefs.clear();
                    } catch (e) {
                      Loader.hide();
                      context.showSnackBar(context, msg: e.toString());
                    }
                    // loginBloc.add(
                    //   DoUserLogout(),
                    // );
                  },
                  child: Text(
                    "Sign Out",
                    style: GoogleFonts.poppins(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: AppColors.colorRed,
                    ),
                  ),
                ),
                sizedBoxWithHeight(20),
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget settingoptions(
    {required Widget icon, required String text, String? subTitle}) {
  return Column(
    children: [
      sizedBoxWithHeight(15),
      Row(
        children: [
          icon,
          sizedBoxWithWidth(10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: GoogleFonts.poppins(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (subTitle != null) ...{
                Text(
                  subTitle,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              },
            ],
          ),
          Spacer(),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 14.h,
          )
        ],
      ),
      Divider()
    ],
  );
}
