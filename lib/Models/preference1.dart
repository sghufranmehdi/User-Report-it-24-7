import 'package:shared_preferences/shared_preferences.dart';

class MySharedPreferences1 {
  MySharedPreferences1._privateConstructor();

  static final MySharedPreferences1 instance =
      MySharedPreferences1._privateConstructor();

  setBooleanVal(String key, bool value) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    myPrefs.setBool(key, value);
  }

  Future<bool> getBooleanVal(
    String key,
  ) async {
    SharedPreferences myPrefs = await SharedPreferences.getInstance();
    return myPrefs.getBool(key) ?? false;
  }
}
