import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/account/account_controller.dart';

import 'package:multitrip_user/features/auth/login/login_mobile.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountChangePassword extends StatefulWidget {
  const AccountChangePassword({
    super.key,
  });

  @override
  State<AccountChangePassword> createState() => _AccountChangePasswordState();
}

class _AccountChangePasswordState extends State<AccountChangePassword> {
  bool isconfirmvisible = false;
  bool ispasswordvisible = false;
  final _confirmPass = TextEditingController();
  final _pass = TextEditingController();
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
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: AppColors.black,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 10.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              Strings.account,
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            sizedBoxWithHeight(
              40,
            ),
            Text(
              Strings.newpassword,
              style: GoogleFonts.poppins(
                color: AppColors.black,
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
            sizedBoxWithHeight(
              10,
            ),
            Text(
              Strings.passwordtext,
              style: GoogleFonts.poppins(
                  color: AppColors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w300),
            ),
            sizedBoxWithHeight(
              15,
            ),
            Text(
              Strings.newpassword,
              style: AppText.text15Normal.copyWith(
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
            sizedBoxWithHeight(
              5,
            ),
            Container(
              color: Colors.grey.shade300,
              child: TextFormField(
                keyboardType: TextInputType.visiblePassword,
                cursorColor: AppColors.grey500,
                obscureText: ispasswordvisible ? false : true,
                controller: _pass,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade300,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  suffix: InkWell(
                      onTap: () {
                        setState(() {
                          ispasswordvisible = !ispasswordvisible;
                        });
                      },
                      child: Icon(
                        ispasswordvisible
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_rounded,
                        color: AppColors.black,
                      )),
                  border: InputBorder.none,
                ),
              ),
            ),
            sizedBoxWithHeight(
              15,
            ),
            Text(
              Strings.confirmpassword,
              style: AppText.text15Normal.copyWith(
                color: AppColors.black,
                fontSize: 14.sp,
              ),
            ),
            sizedBoxWithHeight(
              5,
            ),
            Container(
              color: Colors.grey.shade300,
              child: TextFormField(
                obscureText: isconfirmvisible ? false : true,
                keyboardType: TextInputType.visiblePassword,
                cursorColor: AppColors.grey500,
                controller: _confirmPass,
                decoration: InputDecoration(
                  fillColor: Colors.grey.shade300,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  suffix: InkWell(
                      onTap: () {
                        setState(() {
                          isconfirmvisible = !isconfirmvisible;
                        });
                      },
                      child: Icon(
                        isconfirmvisible
                            ? Icons.remove_red_eye
                            : Icons.visibility_off_rounded,
                        color: AppColors.black,
                      )),
                  border: InputBorder.none,
                ),
              ),
            ),
            Spacer(),
            GestureDetector(
              onTap: _handleOnTap,
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: 15.h,
                  bottom: 30.h,
                ),
                child: Center(
                  child: Text(
                    Strings.update,
                    style: AppText.text15w500.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: 16.h,
                ),
                decoration: BoxDecoration(
                  color: AppColors.green,
                  borderRadius: BorderRadius.circular(
                    10.r,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleOnTap() async {
    FocusScope.of(context).unfocus();
    if (_pass.text.isEmpty || _confirmPass.text.isEmpty) {
      context.showSnackBar(context, msg: 'Please enter the fields');
      return;
    }
    if (_pass.text.length != _confirmPass.text.length ||
        _pass.text != _confirmPass.text) {
      context.showSnackBar(context,
          msg: 'Password and confirm password must be same');
      return;
    }
    Loader.show(context);
    await context.read<AccountController>().updatePassword(
          password: _pass.text,
          onFailure: () {
            Loader.hide();
            context.showSnackBar(context,
                msg: 'Failed to Updated, Please try again');
          },
          onSuccess: () async {
            Loader.hide();
            context.showSnackBar(context, msg: 'Successfully Updated');
            await _logout();
          },
        );
  }

  Future<void> _logout() async {
    Loader.show(
      context,
    );

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      await AppRepository()
          .douserlogout(
              accesstoken: prefs.getString(
                Strings.accesstoken,
              )!,
              userid: prefs.getString(Strings.userid)!)
          .then((value) {
        if (value["code"] == 401) {
        } else if (value["code"] == 201) {
          Loader.hide();
          context.showSnackBar(context, msg: value["message"]);
        } else if (value["code"] == 200) {
          Loader.hide();

          // BlocProvider.of<DashboardBloc>(context).add(
          //   InitBloc(),
          // );
          AppEnvironment.navigator.pushAndRemoveUntil(
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const LoginMobile()),
            (route) {
              return false;
            },
          );
          prefs.clear();
        }
      });
    } catch (e) {
      Loader.hide();
      context.showSnackBar(context, msg: e.toString());
    } finally {
      Loader.hide();
    }
  }
}
