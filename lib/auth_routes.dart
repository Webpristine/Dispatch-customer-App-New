part of 'routes.dart';

//auth routes
class AuthRoutes {
  /// leading string for routes in auth, this needs to be used when creating
  /// new route
  static const authLeading = '/auth-route';

  static const loginmobile = '$authLeading/login-mobile';
  static const forgotPassword = '$authLeading/forgot_password';

  static const loginpassword = '$authLeading/login-password';
  static const loginotp = '$authLeading/login-otp';

  static const signupScreen = '$authLeading/signup-screen';
  static const forgotPasswordScreen = '$authLeading/forgot-password-screen';
  static const createNewPasswordScreen =
      '$authLeading/create-new-password-screen';

  static final authRoutes = <String>{
    loginmobile,
    loginotp,
    loginpassword,
    signupScreen,
    forgotPasswordScreen,
    createNewPasswordScreen
  };

  static Widget getPage(String currentRoute, Object? args) {
    Widget child;
    switch (currentRoute) {
      case AuthRoutes.loginmobile:
        child = const LoginMobile();
        break;
      case AuthRoutes.loginpassword:
        child = LoginPassword(
          mobilenumner: args as String,
        );
        break;
      case AuthRoutes.loginotp:
        child = OtpLogin(
          mobilenumber: args as String,
        );
        break;
      case AuthRoutes.signupScreen:
        child = SignUp(
          userid: args as String,
        );
        break;

      default:
        child = const SizedBox();
    }
    return child;
  }
}
