import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// Diary Service for Bunny pet
/// Stores text entries and photo paths like an old-school blog
class DiaryService {
  static const String _storageKey = 'diary_entries';
  
  List<DiaryEntry> _entries = [];
  
  /// Initialize service
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final dataStr = prefs.getString(_storageKey);
    
    if (dataStr != null) {
      final List<dynamic> data = jsonDecode(dataStr);
      _entries = data.map((e) => DiaryEntry.fromJson(e)).toList();
    }
  }
  
  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final data = _entries.map((e) => e.toJson()).toList();
    await prefs.setString(_storageKey, jsonEncode(data));
  }
  
  /// Get all entries (newest first)
  List<DiaryEntry> get entries => List.unmodifiable(_entries.reversed.toList());
  
  /// Add a new diary entry
  Future<void> addEntry({required String text, String? imagePath}) async {
    final entry = DiaryEntry(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: text,
      imagePath: imagePath,
      timestamp: DateTime.now(),
    );
    _entries.add(entry);
    await _save();
  }
  
  /// Delete an entry
  Future<void> deleteEntry(String id) async {
    _entries.removeWhere((e) => e.id == id);
    await _save();
  }
  
  /// Get total entry count
  int get entryCount => _entries.length;
}

class DiaryEntry {
  final String id;
  final String text;
  final String? imagePath;
  final DateTime timestamp;
  
  DiaryEntry({
    required this.id,
    required this.text,
    this.imagePath,
    required this.timestamp,
  });
  
  factory DiaryEntry.fromJson(Map<String, dynamic> json) {
    return DiaryEntry(
      id: json['id'],
      text: json['text'],
      imagePath: json['imagePath'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'imagePath': imagePath,
      'timestamp': timestamp.toIso8601String(),
    };
  }
  
  String get formattedDate {
    return '${timestamp.year}/${timestamp.month.toString().padLeft(2, '0')}/${timestamp.day.toString().padLeft(2, '0')} ${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
