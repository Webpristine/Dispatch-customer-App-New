import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multitrip_user/app_enverionment.dart';
import 'package:multitrip_user/blocs/login/login_bloc.dart';
import 'package:multitrip_user/bottomnavigationbar.dart';
import 'package:multitrip_user/features/auth/login/widgets/nextfloatingbutton.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:multitrip_user/shared/ui/common/spacing.dart';
import 'package:multitrip_user/themes/app_text.dart';

class SignUp extends StatefulWidget {
  final String userid;
  const SignUp({super.key, required this.userid});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  LoginBloc loginBloc = LoginBloc();
  @override
  void initState() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    super.initState();
  }

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPassController = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();
  bool ispasswordvisible = false;
  bool isconfirmvisible = false;
  void changeconfirmpasswordvisiblity() {
    setState(() {
      isconfirmvisible = !isconfirmvisible;
    });
  }

  void changepasswordvisiblity() {
    setState(() {
      ispasswordvisible = !ispasswordvisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.appColor,
        floatingActionButton: Visibility(
          visible: MediaQuery.of(context).viewInsets.bottom == 0.0,
          child: InkWell(
              onTap: () {
                if (emailController.text.isValidEmail() == false) {
                  context.showSnackBarError(
                    context,
                    msg: "Please enter valid email",
                  );
                } else if (passwordController.text.isEmpty) {
                  context.showSnackBarError(context,
                      msg: "Please Enter Password");
                } else if (passwordController.text.length < 8) {
                  context.showSnackBar(context,
                      msg: "Minimum 8 Characters Required ");
                } else if (firstName.text.length < 4) {
                  context.showSnackBar(context,
                      msg: "Please enter the first name");
                } else if (lastName.text.length < 4) {
                  context.showSnackBar(context,
                      msg: "Please enter the last name");
                } else if (passwordController.text != cPassController.text) {
                  context.showSnackBar(context, msg: "Password not match");
                } else {
                  loginBloc.add(
                    UserSignup(
                      email: emailController.text,
                      password: passwordController.text,
                      userId: widget.userid,
                      firstName: firstName.text,
                      lastName: lastName.text,
                    ),
                  );
                }
              },
              child: NextFloatingButton()),
        ),
        body: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is UserLoading) {
              Loader.show(
                context,
              );
            } else if (state is UserSuccess) {
              Loader.hide();

              AppEnvironment.navigator.pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (_) => PagesWidget(
                      currentTab: 0,
                    ),
                  ),
                  (_) => false);
              // Navigator.pushReplacement(context,
              //     MaterialPageRoute(builder: (context) => PagesWidget()));
            } else if (state is TokenExpired) {
              Loader.hide();
            } else if (state is UserFailed) {
              Loader.hide();
              context.showSnackBar(context, msg: state.error);
            }
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedBoxWithHeight(0),
                    InkWell(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();

                        Navigator.pop(context);
                      },
                      child: Icon(
                        Icons.arrow_back,
                        color: AppColors.black,
                        size: 20,
                      ),
                    ),
                    sizedBoxWithHeight(10),
                    Text("What's your name and email?",
                        style: AppText.text22w500.copyWith(
                          color: AppColors.black,
                        )),
                    sizedBoxWithHeight(40),
                    Text(
                      "Receipts will be sent to your email",
                      style: GoogleFonts.nunito(
                        color: Colors.grey.shade500,
                        fontSize: 18,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppColors.grey500,
                        controller: firstName,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "First Name",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppColors.grey500,
                        controller: lastName,
                        decoration: InputDecoration(
                            isDense: true,
                            hintText: "Last Name",
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.hintColor,
                              fontSize: 14.sp,
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
                    ),
                    sizedBoxWithHeight(20),
                    Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: "Enter your email",
                          hintStyle: GoogleFonts.poppins(
                            color: AppColors.hintColor,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 1,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: AppColors.black,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        cursorColor: AppColors.grey500,
                        obscureText: ispasswordvisible ? false : true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                                onTap: () {
                                  changepasswordvisiblity();
                                },
                                child: Icon(
                                  ispasswordvisible
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.black,
                                )),
                            isDense: true,
                            hintText: "Password",
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.hintColor,
                              fontSize: 14.sp,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      color: Colors.grey.shade300,
                      child: TextFormField(
                        obscureText: isconfirmvisible ? false : true,
                        keyboardType: TextInputType.visiblePassword,
                        controller: cPassController,
                        cursorColor: AppColors.grey500,
                        decoration: InputDecoration(
                            suffixIcon: InkWell(
                                onTap: () {
                                  changeconfirmpasswordvisiblity();
                                },
                                child: Icon(
                                  isconfirmvisible
                                      ? Icons.remove_red_eye
                                      : Icons.visibility_off_rounded,
                                  color: AppColors.black,
                                )),
                            isDense: true,
                            hintText: "Confirm Password",
                            hintStyle: GoogleFonts.poppins(
                              color: AppColors.hintColor,
                              fontSize: 14.sp,
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
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
