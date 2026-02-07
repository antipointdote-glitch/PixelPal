import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Tamagotchi Squad Service
/// Manages 9 bootleg Tamagotchis that need feeding via to-do tasks
class SquadService {
  static const String _storageKey = 'squad_data';
  static const int squadSize = 9;
  
  // Squad member names (deformed bootleg Tamagotchis)
  static const List<String> squadNames = [
    'Blobchi',
    'Glitchchi',
    'Wobbchi',
    'Meltchi',
    'Crackchi',
    'Fuzzchi',
    'Pixlchi',
    'Derptchi',
    'Borkchi',
  ];
  
  // Squad member states
  List<bool> _isFed = List.filled(squadSize, false);
  List<String> _tasks = [];
  DateTime? _lastResetDate;
  
  /// Initialize service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString(_storageKey);
    
    if (dataStr != null) {
      final data = jsonDecode(dataStr);
      _isFed = List<bool>.from(data['isFed'] ?? List.filled(squadSize, false));
      _tasks = List<String>.from(data['tasks'] ?? []);
      _lastResetDate = data['lastReset'] != null ? DateTime.parse(data['lastReset']) : null;
    }
    
    // Reset if new day
    final today = DateTime.now();
    if (_lastResetDate == null || 
        _lastResetDate!.day != today.day || 
        _lastResetDate!.month != today.month ||
        _lastResetDate!.year != today.year) {
      _isFed = List.filled(squadSize, false);
      _tasks = [];
      _lastResetDate = today;
      await _save();
    }
  }
  
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = {
      'isFed': _isFed,
      'tasks': _tasks,
      'lastReset': _lastResetDate?.toIso8601String(),
    };
    await prefs.setString(_storageKey, jsonEncode(data));
  }
  
  /// Get number of fed squad members
  int get fedCount => _isFed.where((f) => f).length;
  
  /// Get number of hungry squad members
  int get hungryCount => squadSize - fedCount;
  
  /// Check if all squad members are fed
  bool get allFed => fedCount == squadSize;
  
  /// Check if a specific member is fed
  bool isMemberFed(int index) => _isFed[index];
  
  /// Get list of completed tasks
  List<String> get completedTasks => List.unmodifiable(_tasks);
  
  /// Complete a task and feed the next hungry squad member
  Future<int?> completeTask(String task) async {
    if (allFed) return null; // All already fed
    
    _tasks.add(task);
    
    // Find first hungry member
    for (int i = 0; i < squadSize; i++) {
      if (!_isFed[i]) {
        _isFed[i] = true;
        await _save();
        return i;
      }
    }
    return null;
  }
  
  /// Get riot messages from hungry members
  List<String> getHungryRiotMessages() {
    final messages = <String>[];
    for (int i = 0; i < squadSize; i++) {
      if (!_isFed[i]) {
        messages.add(_getRiotMessage(i));
      }
    }
    return messages;
  }
  
  String _getRiotMessage(int index) {
    final name = squadNames[index];
    final riots = [
      '*$name flails around* HUNGRY!!! FEED ME!!!',
      '*$name vibrates angrily* WHERE IS MY FOOD?!',
      '*$name throws tantrum* I WANT TASKS!!!',
      '*$name glitches out* STARVING HERE!!!',
      '*$name wobbles aggressively* GIVE ME DOPAMINE!!!',
    ];
    return riots[DateTime.now().millisecond % riots.length];
  }
  
  /// Get happy message when fed
  String getHappyMessage(int index) {
    final name = squadNames[index];
    final happies = [
      '*$name bounces happily* YAY! FOOD! TASK COMPLETE!',
      '*$name glows with joy* DOPAMINE RECEIVED! THANK YOU!',
      '*$name spins excitedly* YUMMY PRODUCTIVITY!',
      '*$name does happy dance* TASK = DELICIOUS!',
    ];
    return happies[DateTime.now().millisecond % happies.length];
  }
  
  /// Suggested easy tasks for ADHD users
  static const List<String> suggestedTasks = [
    'Take a deep breath',
    'Drink water',
    'Stretch for 30 seconds',
    'Look away from screen',
    'Reply to one message',
    'Put one thing away',
    'Brush teeth',
    'Wash face',
    'Make bed',
    'Take medication',
    'Eat something',
    'Stand up and move',
  ];
}
