import 'package:shared_preferences/shared_preferences.dart';

/// Service to track "Internet Detox" - time spent away from the app.
/// The mouse gets "fed" when the user is NOT using the app.
class DetoxService {
  static const String _keyLastActive = 'detox_last_active';
  static const String _keyTotalOfflineToday = 'detox_offline_today';
  static const String _keyLastResetDate = 'detox_last_reset_date';
  static const String _keyScreenTimeToday = 'detox_screen_time_today';

  /// Call this when app goes to foreground (resumed)
  static Future<double> onAppResumed() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);

    final lastActive = prefs.getInt(_keyLastActive);
    if (lastActive == null) {
      // First time - just record current time
      await prefs.setInt(_keyLastActive, DateTime.now().millisecondsSinceEpoch);
      return prefs.getDouble(_keyTotalOfflineToday) ?? 0.0;
    }

    // Calculate offline duration
    final now = DateTime.now().millisecondsSinceEpoch;
    final offlineMs = now - lastActive;
    final offlineHours = offlineMs / (1000 * 60 * 60); // Convert to hours

    // Add to today's total (cap at 24 hours)
    double totalOffline = prefs.getDouble(_keyTotalOfflineToday) ?? 0.0;
    totalOffline = (totalOffline + offlineHours).clamp(0.0, 24.0);
    await prefs.setDouble(_keyTotalOfflineToday, totalOffline);

    // Update last active time
    await prefs.setInt(_keyLastActive, now);

    return totalOffline;
  }

  /// Call this when app goes to background (paused)
  static Future<void> onAppPaused() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyLastActive, DateTime.now().millisecondsSinceEpoch);
  }

  /// Track screen time (time spent actively using the app)
  static Future<void> addScreenTime(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);
    
    double current = prefs.getDouble(_keyScreenTimeToday) ?? 0.0;
    await prefs.setDouble(_keyScreenTimeToday, current + hours);
  }

  /// Get today's total offline hours (feeding value)
  static Future<double> getOfflineHoursToday() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);
    return prefs.getDouble(_keyTotalOfflineToday) ?? 0.0;
  }

  /// Get today's screen time (used to determine sneezing state)
  static Future<double> getScreenTimeToday() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);
    return prefs.getDouble(_keyScreenTimeToday) ?? 0.0;
  }

  /// Check if mouse should be sneezing (screen time > 2 hours)
  static Future<bool> shouldSneeze() async {
    final screenTime = await getScreenTimeToday();
    return screenTime > 2.0;
  }

  /// Reset counters if it's a new day
  static Future<void> _resetIfNewDay(SharedPreferences prefs) async {
    final today = DateTime.now().toIso8601String().substring(0, 10); // YYYY-MM-DD
    final lastReset = prefs.getString(_keyLastResetDate);
    
    if (lastReset != today) {
      await prefs.setDouble(_keyTotalOfflineToday, 0.0);
      await prefs.setDouble(_keyScreenTimeToday, 0.0);
      await prefs.setString(_keyLastResetDate, today);
    }
  }

  /// For demo: manually set offline hours
  static Future<void> setOfflineHours(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyTotalOfflineToday, hours.clamp(0.0, 24.0));
  }

  /// For demo: manually set screen time
  static Future<void> setScreenTime(double hours) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_keyScreenTimeToday, hours.clamp(0.0, 24.0));
  }

  /// 🎮 FEED ACTION: Consume 1 hour Offline Time to reduce 1 hour Screen Time
  /// Returns: true if successful, false if not enough offline time
  static Future<bool> feed() async {
    final prefs = await SharedPreferences.getInstance();
    await _resetIfNewDay(prefs);

    double offlineTime = prefs.getDouble(_keyTotalOfflineToday) ?? 0.0;
    double screenTime = prefs.getDouble(_keyScreenTimeToday) ?? 0.0;

    // Need at least 1 hour of offline time to feed
    if (offlineTime < 1.0) {
      return false;
    }

    // Consume 1 hour offline time, reduce 1 hour screen time
    offlineTime = (offlineTime - 1.0).clamp(0.0, 24.0);
    screenTime = (screenTime - 1.0).clamp(0.0, 24.0);

    await prefs.setDouble(_keyTotalOfflineToday, offlineTime);
    await prefs.setDouble(_keyScreenTimeToday, screenTime);

    return true;
  }

  /// Check if feeding is possible (has enough offline time)
  static Future<bool> canFeed() async {
    final offlineTime = await getOfflineHoursToday();
    return offlineTime >= 1.0;
  }
}
