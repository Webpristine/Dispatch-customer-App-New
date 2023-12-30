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

class ForgotPasswordScreen extends StatefulWidget {
  final String mobilenumner;
  const ForgotPasswordScreen({super.key, required this.mobilenumner});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  LoginBloc loginBloc = LoginBloc();
  TextEditingController loginpasswordController = TextEditingController();
  TextEditingController confrimpass = TextEditingController();
  @override
  void initState() {
    super.initState();
    loginBloc = BlocProvider.of<LoginBloc>(context);
    print(widget.mobilenumner);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appColor,
      floatingActionButton: InkWell(
          onTap: () {
            if (loginpasswordController.text.isEmpty) {
              context.showSnackBar(context, msg: "Please Enter new Password");
            } else if (loginpasswordController.text.length < 8) {
              context.showSnackBar(context,
                  msg: "Minimum 8 Characters Required ");
            } else if (confrimpass.text.isEmpty) {
              context.showSnackBar(context,
                  msg: "Please enter confirm Password");
            } else if (confrimpass.text.length < 8) {
              context.showSnackBar(context,
                  msg: "Minimum 8 Characters Required ");
            } else if (confrimpass.text != loginpasswordController.text) {
              context.showSnackBar(context,
                  msg: "Confirm password and password is not matched.");
            } else {
              loginBloc.add(
                ForgortPassword(
                  password: loginpasswordController.text,
                  mobilenumber: widget.mobilenumner,
                ),
              );
            }
          },
          child: NextFloatingButton()),
      body: BlocListener<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state is LoadingLoading) {
            Loader.show(context,
                progressIndicator: CircularProgressIndicator(
                  color: AppColors.appColor,
                ));
          } else if (state is ForgotPasswordFail) {
            context.showSnackBar(context, msg: state.error);
            Loader.hide();
          } else if (state is TokenExpired) {
            Loader.hide();
          } else if (state is ForgotPasswordSuccess) {
            Loader.hide();
            context.showSnackBar(context, msg: 'Password changed');

            AppEnvironment.navigator.pushNamedAndRemoveUntil(
              AuthRoutes.loginmobile,
              (route) => false,
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                  sizedBoxWithHeight(24),
                  Text("Forgot Password",
                          style: AppText.text22w500.copyWith(
                            color: AppColors.black,
                          ))
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(36),
                  Container(
                    color: Colors.grey.shade300,
                    child: TextFormField(
                      controller: loginpasswordController,
                      cursorColor: AppColors.grey500,
                      obscureText: false,
                      decoration: InputDecoration(
                          isDense: true,
                          // fillColor: Colors.grey.shade300,
                          // filled: true,

                          hintText: "Enter new  password",
                          hintStyle: GoogleFonts.nunito(
                            color: AppColors.black,
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
                          ))),
                    ),
                  )
                      .animate()
                      .flip(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  sizedBoxWithHeight(36),
                  Container(
                    color: Colors.grey.shade300,
                    child: TextFormField(
                      controller: confrimpass,
                      cursorColor: AppColors.grey500,
                      obscureText: true,
                      decoration: InputDecoration(
                          isDense: true,
                          // fillColor: Colors.grey.shade300,
                          // filled: true,

                          hintText: "Enter confirm password",
                          hintStyle: GoogleFonts.nunito(
                            color: AppColors.black,
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
                          ))),
                    ),
                  )
                      .animate()
                      .flip(duration: 600.ms)
                      .then(delay: 200.ms) // baseline=800ms
                      .slide(),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
