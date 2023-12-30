import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/login/login_bloc.dart';
import 'package:multitrip_user/features/auth/login/forgot_password.dart';
import 'package:multitrip_user/features/auth/login/widgets/nextfloatingbutton.dart';
import 'package:multitrip_user/routes.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';

class LoginPassword extends StatefulWidget {
  final String mobilenumner;
  const LoginPassword({super.key, required this.mobilenumner});

  @override
  State<LoginPassword> createState() => _LoginPasswordState();
}

class _LoginPasswordState extends State<LoginPassword> {
  LoginBloc loginBloc = LoginBloc();
  TextEditingController loginpasswordController = TextEditingController();
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
              context.showSnackBar(context, msg: "Please Enter Password");
            } else if (loginpasswordController.text.length < 8) {
              context.showSnackBar(context,
                  msg: "Minimum 8 Characters Required ");
            } else {
              loginBloc.add(
                LoginByPassword(
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
          } else if (state is LoginFail) {
            context.showSnackBar(context, msg: state.error);
            Loader.hide();
          } else if (state is TokenExpired) {
            Loader.hide();
          } else if (state is LoginPassowrdSuccess) {
            Loader.hide();
            AppEnvironment.navigator.pushNamedAndRemoveUntil(
              GeneralRoutes.pages,
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
                  Text("Welcome back, Signin to\ncontinue",
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
                      obscureText: true,
                      decoration: InputDecoration(
                          isDense: true,
                          // fillColor: Colors.grey.shade300,
                          // filled: true,

                          hintText: "Enter password",
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
                  GestureDetector(
                    onTap: () {
                      AppEnvironment.navigator.push(MaterialPageRoute(
                          builder: (_) => ForgotPasswordScreen(
                                mobilenumner: widget.mobilenumner,
                              )));
                    },
                    child: Text(
                      "Forgot Password?",
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
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
