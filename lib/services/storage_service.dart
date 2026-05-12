import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static const _key = 'dashboard_url';
  static const _defaultUrl = 'http://127.0.0.1:9119';

  static String getDashboardUrl() {
    return _prefs?.getString(_key) ?? _defaultUrl;
  }

  static Future<void> setDashboardUrl(String url) async {
    await _prefs?.setString(_key, url.trim());
  }
}
