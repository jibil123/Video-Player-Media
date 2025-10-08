import 'package:shared_preferences/shared_preferences.dart';

class SharedPreference {
  static Future<SharedPreferences> _getPrefs() async =>
      await SharedPreferences.getInstance();
  static const String token = 'token';
  static const String isLoged = 'isLoged';

  static Future<void> saveToken({required String tokenData}) async {
    final pref = await _getPrefs();
    pref.setString(token, tokenData);
    pref.setBool(isLoged, true);
  }

  static Future<void> clearLogin() async {
    final pref = await _getPrefs();
    pref.setString(token, '');
    pref.setBool(isLoged, false);
  }

  static Future<bool> isLogedOrNot() async {
    final pref = await _getPrefs();
    final isLoged1 = pref.getBool(isLoged);
    return isLoged1 ?? false;
  }

  static Future<String> getToken() async {
    final pref = await _getPrefs();
    final token1 = pref.getString(token);
    return token1 ?? '';
  }
}
