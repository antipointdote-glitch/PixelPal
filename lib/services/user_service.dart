import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static const String _keyNickname = 'user_nickname';
  static const String _keyBirthdayMonth = 'user_birthday_month';
  static const String _keyBirthdayDay = 'user_birthday_day';
  static const String _keyProfile = 'user_profile';
  static const String _keyWeatherLocation = 'weather_location';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Nickname
  static Future<void> setNickname(String nickname) async {
    await init();
    await _prefs!.setString(_keyNickname, nickname);
  }

  static Future<String> getNickname() async {
    await init();
    return _prefs!.getString(_keyNickname) ?? 'User';
  }

  // Birthday
  static Future<void> setBirthday(int month, int day) async {
    await init();
    await _prefs!.setInt(_keyBirthdayMonth, month);
    await _prefs!.setInt(_keyBirthdayDay, day);
  }

  static Future<Map<String, int>?> getBirthday() async {
    await init();
    final month = _prefs!.getInt(_keyBirthdayMonth);
    final day = _prefs!.getInt(_keyBirthdayDay);
    if (month == null || day == null) return null;
    return {'month': month, 'day': day};
  }

  static Future<bool> isBirthdayToday() async {
    final birthday = await getBirthday();
    if (birthday == null) return false;
    final now = DateTime.now();
    return birthday['month'] == now.month && birthday['day'] == now.day;
  }

  // Profile
  static Future<void> setProfile(String profile) async {
    await init();
    await _prefs!.setString(_keyProfile, profile);
  }

  static Future<String> getProfile() async {
    await init();
    return _prefs!.getString(_keyProfile) ?? '';
  }

  // Weather Location
  static Future<void> setWeatherLocation(String location) async {
    await init();
    await _prefs!.setString(_keyWeatherLocation, location);
  }

  static Future<String> getWeatherLocation() async {
    await init();
    return _prefs!.getString(_keyWeatherLocation) ?? 'Hong Kong';
  }

  // Get context for AI (to include in prompts)
  static Future<String> getUserContext() async {
    final nickname = await getNickname();
    final profile = await getProfile();
    final isBirthday = await isBirthdayToday();
    
    String context = "The user's name is '$nickname'. Address them by this name.";
    if (profile.isNotEmpty) {
      context += " Here's what the user shared about themselves: $profile";
    }
    if (isBirthday) {
      context += " TODAY IS THE USER'S BIRTHDAY! Wish them happy birthday enthusiastically!";
    }
    return context;
  }
}
