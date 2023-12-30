import 'package:multitrip_user/shared/shared.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  String? token;
  saveToken(String accessToken) async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(Strings.accesstoken)) {
      return;
    }
    await prefs.setString(Strings.accesstoken, accessToken);

    token = accessToken;
  }
}
