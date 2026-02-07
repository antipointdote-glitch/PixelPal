import 'package:shared_preferences/shared_preferences.dart';

/// 🚶 Step Tracking Service for Stone (The Walker)
/// Manages step counting, feeding conversion, and release eligibility
class StepTrackingService {
  static const String _keyTotalSteps = 'stone_total_steps';
  static const String _keyUnconvertedSteps = 'stone_unconverted_steps';
  static const String _keyIsReleased = 'stone_is_released';
  static const String _keyReleaseCount = 'stone_release_count';
  
  static const int stepsPerFeeding = 1000;
  static const int stepsForFirstRelease = 5000;
  
  // Singleton instance
  static final StepTrackingService _instance = StepTrackingService._internal();
  factory StepTrackingService() => _instance;
  StepTrackingService._internal();
  
  // Cached values
  int _totalSteps = 0;
  int _unconvertedSteps = 0;
  bool _isReleased = false;
  int _releaseCount = 0;  // How many times Stone has been released
  bool _initialized = false;
  
  /// Initialize and load persisted data
  Future<void> init() async {
    if (_initialized) return;
    
    final prefs = await SharedPreferences.getInstance();
    _totalSteps = prefs.getInt(_keyTotalSteps) ?? 0;
    _unconvertedSteps = prefs.getInt(_keyUnconvertedSteps) ?? 0;
    _isReleased = prefs.getBool(_keyIsReleased) ?? false;
    _releaseCount = prefs.getInt(_keyReleaseCount) ?? 0;
    _initialized = true;
    
    print('🚶 StepTrackingService initialized: $_totalSteps total steps, release count: $_releaseCount');
  }
  
  /// Get total lifetime steps
  int get totalSteps => _totalSteps;
  
  /// Get steps not yet converted to feedings
  int get unconvertedSteps => _unconvertedSteps;
  
  /// Check if Stone has been released
  bool get isReleased => _isReleased;
  
  /// Get how many times Stone has been released
  int get releaseCount => _releaseCount;
  
  /// Check if Stone has ever returned (free step counter mode)
  bool get hasReturnedBefore => _releaseCount > 0 && !_isReleased;
  
  /// Check if Stone is ready for release
  /// First time: requires 5000 steps
  /// After returning: can release anytime
  bool get isReadyForRelease => !_isReleased && (_releaseCount > 0 || _totalSteps >= stepsForFirstRelease);
  
  /// Get progress toward first release (0.0 - 1.0)
  double get releaseProgress => _releaseCount > 0 ? 1.0 : (_totalSteps / stepsForFirstRelease).clamp(0.0, 1.0);
  
  /// Get number of feedings available (1000 steps = 1 feeding)
  int get availableFeedings => _unconvertedSteps ~/ stepsPerFeeding;
  
  /// Add steps (from pedometer or simulation)
  Future<void> addSteps(int count) async {
    if (_isReleased || count <= 0) return;
    
    _totalSteps += count;
    _unconvertedSteps += count;
    
    await _save();
    print('🚶 Added $count steps. Total: $_totalSteps, Unconverted: $_unconvertedSteps');
  }
  
  /// Consume 1000 steps for one feeding, returns true if successful
  Future<bool> consumeFeedingSteps() async {
    if (_unconvertedSteps < stepsPerFeeding) return false;
    
    _unconvertedSteps -= stepsPerFeeding;
    await _save();
    
    print('🍽️ Consumed $stepsPerFeeding steps for feeding. Remaining unconverted: $_unconvertedSteps');
    return true;
  }
  
  /// Mark Stone as released (farewell complete)
  Future<void> releaseStone() async {
    _isReleased = true;
    _releaseCount++;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsReleased, true);
    await prefs.setInt(_keyReleaseCount, _releaseCount);
    
    print('🌊 Stone has been released to the river... (release #$_releaseCount)');
  }
  
  /// Reset all data (for testing)
  Future<void> reset() async {
    _totalSteps = 0;
    _unconvertedSteps = 0;
    _isReleased = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyTotalSteps);
    await prefs.remove(_keyUnconvertedSteps);
    await prefs.remove(_keyIsReleased);
    
    print('🔄 StepTrackingService reset');
  }
  
  /// Undo release - bring Stone back (keeps all steps)
  Future<void> undoRelease() async {
    _isReleased = false;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsReleased, false);
    
    print('🗿 Stone has returned from the river!');
  }
  
  /// Save current state to SharedPreferences
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyTotalSteps, _totalSteps);
    await prefs.setInt(_keyUnconvertedSteps, _unconvertedSteps);
  }
}
