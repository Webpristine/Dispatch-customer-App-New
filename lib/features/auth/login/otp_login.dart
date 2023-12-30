import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/login/login_bloc.dart';
import 'package:multitrip_user/features/auth/login/widgets/nextfloatingbutton.dart';
import 'package:multitrip_user/routes.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';

class OtpLogin extends StatefulWidget {
  final String mobilenumber;
  const OtpLogin({super.key, required this.mobilenumber});

  @override
  State<OtpLogin> createState() => _OtpLoginState();
}

class _OtpLoginState extends State<OtpLogin> {
  TextEditingController otpController = TextEditingController();
  LoginBloc loginBloc = LoginBloc();
  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state is OtpChecking) {
          Loader.show(context,
              progressIndicator: CircularProgressIndicator(
                color: AppColors.appColor,
              ));
        } else if (state is AlreadyUser) {
          Loader.hide();
          AppEnvironment.navigator.pushNamedAndRemoveUntil(
            GeneralRoutes.pages,
            (route) => false,
          );
          // Navigator.pushAndRemoveUntil(
          //   context,
          //   MaterialPageRoute(builder: (context) => PagesWidget()),
          //   (route) => false,
          // );
        } else if (state is TokenExpired) {
          Loader.hide();
        } else if (state is NewUser) {
          Loader.hide();
          AppEnvironment.navigator.pushReplacementNamed(AuthRoutes.signupScreen,
              arguments: state.verifyOTP.userId);
        } else if (state is OtpFailed) {
          Loader.hide();
          context.showSnackBar(context, msg: state.error);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        floatingActionButton: InkWell(
          onTap: () {
            if (otpController.text.isEmpty) {
              context.showSnackBar(context, msg: "Please Enter OTP");
            } else if (otpController.text.length != 4) {
              context.showSnackBar(context,
                  msg: "OTP length should be 4 character");
            } else {
              loginBloc.add(
                VerifyOTP(
                  otp: otpController.text,
                  mobilenumber: widget.mobilenumber,
                ),
              );
            }
          },
          child: NextFloatingButton(),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(
              16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  sizedBoxWithHeight(0),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: AppColors.black,
                      size: 20,
                    ),
                  ),
                  sizedBoxWithHeight(
                    10,
                  ),
                  Text(
                    "Verify your phone number",
                    style: AppText.text22w500.copyWith(
                      color: AppColors.black,
                    ),
                  ).animate()
                    ..flipV(duration: 600.ms)
                        .then(delay: 200.ms) // baseline=800ms
                        .slide(),
                  sizedBoxWithHeight(
                    40,
                  ),
                  Text(
                    "Enter the 4-digit code sent to you",
                    style: AppText.text16w400.copyWith(
                      color: AppColors.grey500,
                    ),
                  )
                      .animate()
                      .flipH(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(15),
                  Container(
                    color: Colors.grey.shade300,
                    child: TextFormField(
                      cursorColor: AppColors.grey500,
                      maxLength: 4,
                      controller: otpController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        counterText: '',
                        isDense: true,
                        hintText: " Enter the OTP code",
                        hintStyle: GoogleFonts.nunito(
                          color: AppColors.hintColor,
                          fontWeight: FontWeight.w400,
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                          color: AppColors.black,
                          width: 1,
                        )),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: AppColors.black,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                  )
                      .animate()
                      .slideX(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(20),
                  Text(
                    "Resend code via SMS",
                    style: GoogleFonts.nunito(
                      color: Colors.blue.shade800,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
