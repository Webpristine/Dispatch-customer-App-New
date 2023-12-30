part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final Login login;
  LoginSuccess({required this.login});
}

class LoginFail extends LoginState {
  final String error;
  LoginFail({required this.error});
}

class TokenExpired extends LoginState {}

class OtpChecking extends LoginState {}

class OtpSuccess extends LoginState {
  final VerifyOtp verifyOtp;
  OtpSuccess({required this.verifyOtp});
}

class AlreadyUser extends LoginState {}

class NewUser extends LoginState {
  final VerifyOtp verifyOTP;
  NewUser({required this.verifyOTP});
}

class OtpFailed extends LoginState {
  final String error;

  OtpFailed({required this.error});
}

class UserLoading extends LoginState {}

class UserSuccess extends LoginState {
  final String message;
  UserSuccess({required this.message});
}

class UserFailed extends LoginState {
  final String error;
  UserFailed({
    required this.error,
  });
}

class LoadingLoading extends LoginState {}

class LoginPassowrdSuccess extends LoginState {
  final VerifyOtp verifyOtp;

  LoginPassowrdSuccess({
    required this.verifyOtp,
  });
}

class LogoutLoading extends LoginState {}

class LogoutSuccess extends LoginState {
  final String message;
  LogoutSuccess({required this.message});
}

class LogoutFail extends LoginState {
  final String error;
  LogoutFail({required this.error});
}

class ForgotPasswordSuccess extends LoginState {
  ForgotPasswordSuccess();
}

class ForgotPasswordFail extends LoginState {
  final String error;
  ForgotPasswordFail({required this.error});
}
