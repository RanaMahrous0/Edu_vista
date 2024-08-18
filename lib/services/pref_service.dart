import 'package:shared_preferences/shared_preferences.dart';

abstract class PerferenceService {
  static SharedPreferences? prefs;
  static Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      print('prefs is setup successfully');
    } catch (e) {
      print('error in initialize perferences : $e');
    }
  }

  static bool get isOnBoardingSeen =>
      prefs!.getBool('isOnBoardingSeen') ?? false;
  static set isOnBoardingSeen(bool value) =>
      prefs!.setBool('isOnBoardingSeen', value);
}
