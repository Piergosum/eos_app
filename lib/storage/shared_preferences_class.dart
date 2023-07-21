import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesClass {
  static SharedPreferences? prefsInstance;

  static init() async {
    prefsInstance ??= await SharedPreferences.getInstance();
  }
}
