import 'package:bloc/bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:meta/meta.dart';
import 'package:multitrip_user/api/app_repository.dart';
import 'package:multitrip_user/api/token_manager.dart';
import 'package:multitrip_user/models/login.dart';
import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/verityotp.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<LoginEvent>((event, emit) async {
      if (event is VerifyOTP) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        emit.call(OtpChecking());
        try {
          await AppRepository()
              .verifyOTP(
            otp: event.otp,
            accesstoken: GetIt.instance.get<TokenManager>().token ?? '',
            mobilenumber: event.mobilenumber,
          )
              .then((value) async {
            if (value["code"] == 401) {
            } else if (value["code"] == 201) {
              emit.call(OtpFailed(
                error: value["message"].toString(),
              ));
            } else if (value["code"] == 200) {
              final _verifyotp = VerifyOtp.fromJson(value);
              await prefs.setString(
                Strings.accesstoken,
                GetIt.instance.get<TokenManager>().token ?? '',
              );
              if (_verifyotp.email == "") {
                emit.call(NewUser(verifyOTP: _verifyotp));
              } else {
                await prefs.setString(
                  Strings.userid,
                  _verifyotp.userId,
                );
                await prefs
                    .setString(
                  Strings.accesstoken,
                  GetIt.instance.get<TokenManager>().token ?? '',
                )
                    .whenComplete(() {
                  emit.call(AlreadyUser());
                });
              }
              //
            }
          }).catchError((e) {
            emit.call(OtpFailed(
              error: e.toString(),
            ));
          });
        } on Exception catch (e) {
          emit.call(OtpFailed(
            error: e.toString(),
          ));
        }
      } else if (event is UserSignup) {
        emit.call(UserLoading());
        final SharedPreferences prefs = await SharedPreferences.getInstance();

        try {
          await AppRepository()
              .usersignup(
            email: event.email,
            password: event.password,
            userid: event.userId,
            firstname: event.firstName ?? '',
            lastName: event.lastName ?? '',
            accesstoken: prefs.getString(
              Strings.accesstoken,
            )!,
          )
              .then((value) async {
            if (value["code"] == 401) {
            } else if (value["code"] == 201) {
              emit.call(UserFailed(error: value["message"]));
            } else if (value["code"] == 200) {
              await prefs.setString(
                Strings.userid,
                event.userId,
              );
              emit.call(UserSuccess(message: value["message"]));
            }
          });
        } on Exception catch (e) {
          emit.call(
            UserFailed(
              error: e.toString(),
            ),
          );
        }
      } else if (event is LoginByPassword) {
        emit.call(LoginLoading());
        try {
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          await AppRepository()
              .loginbypassword(
            password: event.password,
            accesstoken: GetIt.instance.get<TokenManager>().token ?? '',
            mobilenumber: event.mobilenumber,
          )
              .then(
            (value) async {
              if (value["code"] == 401) {
              } else if (value["code"] == 201) {
                emit.call(
                  LoginFail(
                    error: value["message"],
                  ),
                );
              } else if (value["code"] == 200) {
                await prefs.setString(
                  Strings.accesstoken,
                  GetIt.instance.get<TokenManager>().token ?? '',
                );
                var _verifyotp = VerifyOtp.fromJson(value);
                if (_verifyotp.userId.isEmpty) {
                  emit.call(
                    LoginFail(
                      error:
                          'Please try again from other method.Unable to get the user details from server....',
                    ),
                  );
                }
                await prefs.setString(
                  Strings.accesstoken,
                  GetIt.instance.get<TokenManager>().token ?? '',
                );
                await prefs.setString(
                  Strings.userid,
                  _verifyotp.userId,
                );
                emit.call(
                  LoginPassowrdSuccess(
                    verifyOtp: _verifyotp,
                  ),
                );
              }
            },
          );
        } catch (e) {
          emit.call(
            LoginFail(
              error: e.toString(),
            ),
          );
        }
      } else if (event is ForgortPassword) {
        emit.call(LoginLoading());
        try {
          await AppRepository()
              .forgotPassword(
            password: event.password,
            mobilenumber: event.mobilenumber,
          )
              .then(
            (value) async {
              if (value["code"] == 401) {
              } else if (value["code"] == 201) {
                emit.call(
                  ForgotPasswordSuccess(),
                );
              } else if (value["code"] == 200) {
                emit.call(
                  ForgotPasswordSuccess(),
                );
              }
            },
          );
        } catch (e) {
          emit.call(
            ForgotPasswordFail(
              error: e.toString(),
            ),
          );
        }
      }
    });
  }
}
