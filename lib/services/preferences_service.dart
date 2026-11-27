// ignore_for_file: unnecessary_import
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserProfile {
  final String name;
  final String avatarIcon;
  final int totalPoints;
  final int streakDays;
  final String lastStudyDate;
  final List<int> completedUnits;
  final List<int> bookmarkedUnits;
  final Map<String, int> gameHighScores;

  UserProfile({
    required this.name,
    this.avatarIcon = 'school',
    this.totalPoints = 0,
    this.streakDays = 1,
    required this.lastStudyDate,
    this.completedUnits = const [],
    this.bookmarkedUnits = const [],
    this.gameHighScores = const {},
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'avatarIcon': avatarIcon,
        'totalPoints': totalPoints,
        'streakDays': streakDays,
        'lastStudyDate': lastStudyDate,
        'completedUnits': completedUnits,
        'bookmarkedUnits': bookmarkedUnits,
        'gameHighScores': gameHighScores,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    var completed = <int>[];
    if (json['completedUnits'] is List) {
      completed = (json['completedUnits'] as List)
          .where((e) => e != null)
          .map((e) => (e as num).toInt())
          .toList();
    }

    var bookmarks = <int>[];
    if (json['bookmarkedUnits'] is List) {
      bookmarks = (json['bookmarkedUnits'] as List)
          .where((e) => e != null)
          .map((e) => (e as num).toInt())
          .toList();
    }

    var scores = <String, int>{};
    if (json['gameHighScores'] is Map) {
      (json['gameHighScores'] as Map).forEach((k, v) {
        if (k != null && v != null) {
          scores[k.toString()] = (v as num).toInt();
        }
      });
    }

    return UserProfile(
      name: json['name'] as String? ?? 'English Learner',
      avatarIcon: json['avatarIcon'] as String? ?? 'school',
      totalPoints: (json['totalPoints'] as num?)?.toInt() ?? 0,
      streakDays: (json['streakDays'] as num?)?.toInt() ?? 1,
      lastStudyDate: json['lastStudyDate'] as String? ?? '',
      completedUnits: completed,
      bookmarkedUnits: bookmarks,
      gameHighScores: scores,
    );
  }

  UserProfile copyWith({
    String? name,
    String? avatarIcon,
    int? totalPoints,
    int? streakDays,
    String? lastStudyDate,
    List<int>? completedUnits,
    List<int>? bookmarkedUnits,
    Map<String, int>? gameHighScores,
  }) {
    return UserProfile(
      name: name ?? this.name,
      avatarIcon: avatarIcon ?? this.avatarIcon,
      totalPoints: totalPoints ?? this.totalPoints,
      streakDays: streakDays ?? this.streakDays,
      lastStudyDate: lastStudyDate ?? this.lastStudyDate,
      completedUnits: completedUnits ?? this.completedUnits,
      bookmarkedUnits: bookmarkedUnits ?? this.bookmarkedUnits,
      gameHighScores: gameHighScores ?? this.gameHighScores,
    );
  }
}

class PreferencesService {
  static final PreferencesService _instance = PreferencesService._internal();
  factory PreferencesService() => _instance;
  PreferencesService._internal();

  static const String _prefFileName = 'app_preferences.json';
  static const MethodChannel _storageChannel =
      MethodChannel('com.mmtdev.kpu.aigrammar/storage');

  Color _seedColor = const Color(0xFF4F46E5);
  double _fontScale = 1.0;
  bool _soundEffectsEnabled = true;
  bool _hasCompletedOnboarding = false;

  int _dailyGoalMinutes = 15;
  List<String> _studyDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  List<Map<String, String>> _studyNotes = [];

  UserProfile _userProfile = UserProfile(
    name: 'English Learner',
    avatarIcon: 'school',
    totalPoints: 0,
    streakDays: 1,
    lastStudyDate: '',
    completedUnits: [],
    gameHighScores: {},
  );

  Color get seedColor => _seedColor;
  double get fontScale => _fontScale;
  bool get soundEffectsEnabled => _soundEffectsEnabled;
  bool get hasCompletedOnboarding => _hasCompletedOnboarding;
  int get dailyGoalMinutes => _dailyGoalMinutes;
  List<String> get studyDays => _studyDays;
  List<Map<String, String>> get studyNotes => _studyNotes;
  UserProfile get userProfile => _userProfile;

  Future<void> init() async {
    try {
      final file = await _getPrefFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final Map<String, dynamic> jsonMap = json.decode(content);

        if (jsonMap.containsKey('seedColor')) {
          _seedColor = Color((jsonMap['seedColor'] as num).toInt());
        }
        if (jsonMap.containsKey('fontScale')) {
          _fontScale = (jsonMap['fontScale'] as num).toDouble();
        }
        if (jsonMap.containsKey('soundEffectsEnabled')) {
          _soundEffectsEnabled = jsonMap['soundEffectsEnabled'] ?? true;
        }
        if (jsonMap.containsKey('hasCompletedOnboarding')) {
          _hasCompletedOnboarding = jsonMap['hasCompletedOnboarding'] ?? false;
        }
        if (jsonMap.containsKey('dailyGoalMinutes')) {
          _dailyGoalMinutes = (jsonMap['dailyGoalMinutes'] as num).toInt();
        }
        if (jsonMap.containsKey('studyDays') && jsonMap['studyDays'] is List) {
          _studyDays = (jsonMap['studyDays'] as List).cast<String>();
        }
        if (jsonMap.containsKey('studyNotes') && jsonMap['studyNotes'] is List) {
          _studyNotes = (jsonMap['studyNotes'] as List)
              .map((e) => Map<String, String>.from(e as Map))
              .toList();
        }
        if (jsonMap.containsKey('userProfile') && jsonMap['userProfile'] is Map) {
          _userProfile = UserProfile.fromJson(
            Map<String, dynamic>.from(jsonMap['userProfile'] as Map),
          );
        }
      }
      _checkStreak();
    } catch (_) {}
  }

  Future<void> completeOnboarding() async {
    _hasCompletedOnboarding = true;
    await _persist();
  }

  Future<void> saveDailyGoalMinutes(int minutes) async {
    _dailyGoalMinutes = minutes;
    await _persist();
  }

  Future<void> saveStudyDays(List<String> days) async {
    _studyDays = days;
    await _persist();
  }

  Future<void> addStudyNote(String title, String content) async {
    final date = DateTime.now().toIso8601String().split('T')[0];
    _studyNotes.insert(0, {
      'title': title,
      'content': content,
      'date': date,
    });
    await _persist();
  }

  Future<void> deleteStudyNote(int index) async {
    if (index >= 0 && index < _studyNotes.length) {
      _studyNotes.removeAt(index);
      await _persist();
    }
  }

  Future<void> saveSeedColor(Color color) async {
    _seedColor = color;
    await _persist();
  }

  Future<void> saveFontScale(double scale) async {
    _fontScale = scale;
    await _persist();
  }

  Future<void> saveSoundEffects(bool enabled) async {
    _soundEffectsEnabled = enabled;
    await _persist();
  }

  Future<void> updateUserName(String name) async {
    _userProfile = _userProfile.copyWith(name: name);
    await _persist();
  }

  Future<void> recordGameProgress({
    required String gameTitle,
    required int pointsEarned,
  }) async {
    final currentHigh = _userProfile.gameHighScores[gameTitle] ?? 0;
    final updatedScores = Map<String, int>.from(_userProfile.gameHighScores);
    if (pointsEarned > currentHigh) {
      updatedScores[gameTitle] = pointsEarned;
    }

    final newTotalPoints = _userProfile.totalPoints + pointsEarned;

    _userProfile = _userProfile.copyWith(
      totalPoints: newTotalPoints,
      gameHighScores: updatedScores,
    );

    await _persist();
  }

  Future<void> markUnitCompleted(int unitNumber) async {
    if (!_userProfile.completedUnits.contains(unitNumber)) {
      final updatedList = List<int>.from(_userProfile.completedUnits)
        ..add(unitNumber);
      _userProfile = _userProfile.copyWith(
        completedUnits: updatedList,
        totalPoints: _userProfile.totalPoints + 20,
      );
      await _persist();
    }
  }

  Future<void> toggleUnitBookmark(int unitNumber) async {
    final updated = List<int>.from(_userProfile.bookmarkedUnits);
    if (!updated.remove(unitNumber)) updated.add(unitNumber);
    _userProfile = _userProfile.copyWith(bookmarkedUnits: updated);
    await _persist();
  }

  Future<void> resetAllProgress() async {
    _hasCompletedOnboarding = false;
    _dailyGoalMinutes = 15;
    _studyDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    _studyNotes = [];
    _userProfile = UserProfile(
      name: 'English Learner',
      avatarIcon: 'school',
      totalPoints: 0,
      streakDays: 1,
      lastStudyDate: DateTime.now().toIso8601String().split('T')[0],
      completedUnits: [],
      bookmarkedUnits: [],
      gameHighScores: {},
    );
    await _persist();
  }

  void _checkStreak() {
    final today = DateTime.now().toIso8601String().split('T')[0];
    if (_userProfile.lastStudyDate.isEmpty) {
      _userProfile = _userProfile.copyWith(lastStudyDate: today, streakDays: 1);
      _persist();
    } else if (_userProfile.lastStudyDate != today) {
      final lastDate = DateTime.tryParse(_userProfile.lastStudyDate);
      if (lastDate != null) {
        final difference = DateTime.now().difference(lastDate).inDays;
        if (difference == 1) {
          _userProfile = _userProfile.copyWith(
            lastStudyDate: today,
            streakDays: _userProfile.streakDays + 1,
          );
        } else if (difference > 1) {
          _userProfile = _userProfile.copyWith(
            lastStudyDate: today,
            streakDays: 1,
          );
        }
        _persist();
      }
    }
  }

  Future<File> _getPrefFile() async {
    final appDirectory =
        await _storageChannel.invokeMethod<String>('getAppStoragePath');
    if (appDirectory == null || appDirectory.isEmpty) {
      throw StateError('App storage directory is unavailable.');
    }
    final persistentFile = File('$appDirectory/$_prefFileName');
    final legacyFile = File('${Directory.systemTemp.path}/$_prefFileName');
    if (!await persistentFile.exists() && await legacyFile.exists()) {
      await legacyFile.copy(persistentFile.path);
    }
    return persistentFile;
  }

  Future<void> _persist() async {
    try {
      final file = await _getPrefFile();
      final data = {
        'seedColor': _seedColor.toARGB32(),
        'fontScale': _fontScale,
        'soundEffectsEnabled': _soundEffectsEnabled,
        'hasCompletedOnboarding': _hasCompletedOnboarding,
        'dailyGoalMinutes': _dailyGoalMinutes,
        'studyDays': _studyDays,
        'studyNotes': _studyNotes,
        'userProfile': _userProfile.toJson(),
      };
      await file.writeAsString(json.encode(data));
    } catch (_) {}
  }
}
