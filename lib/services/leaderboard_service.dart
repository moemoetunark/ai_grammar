import 'dart:convert';
import 'package:http/http.dart' as http;
import 'preferences_service.dart';

class LeaderboardService {
  // Replace this with your deployed Google Apps Script Web App URL when ready
  static const String webAppUrl = '';

  static Future<List<Map<String, dynamic>>> fetchLeaderboard() async {
    final localUser = PreferencesService().userProfile;

    final List<Map<String, dynamic>> defaultMockUsers = [
      {'name': 'Aung Aung', 'points': 1540, 'streak': 24, 'avatar': '👑'},
      {'name': 'Su Su San', 'points': 1420, 'streak': 19, 'avatar': '🥈'},
      {'name': 'David Smith', 'points': 1280, 'streak': 15, 'avatar': '🥉'},
      {
        'name': localUser.name,
        'points': localUser.totalPoints,
        'streak': localUser.streakDays,
        'avatar': '🌟',
        'isMe': true
      },
      {'name': 'Kyaw Kyaw', 'points': 980, 'streak': 12, 'avatar': '😊'},
      {'name': 'Emily Watson', 'points': 890, 'streak': 10, 'avatar': '💡'},
      {'name': 'Thura Min', 'points': 760, 'streak': 8, 'avatar': '🔥'},
    ];

    if (webAppUrl.isEmpty) {
      defaultMockUsers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
      return defaultMockUsers;
    }

    try {
      final response = await http.get(Uri.parse(webAppUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        return data.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    } catch (_) {}

    defaultMockUsers.sort((a, b) => (b['points'] as int).compareTo(a['points'] as int));
    return defaultMockUsers;
  }

  static Future<void> syncScore() async {
    if (webAppUrl.isEmpty) return;
    try {
      final localUser = PreferencesService().userProfile;
      await http.post(
        Uri.parse(webAppUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': localUser.name,
          'points': localUser.totalPoints,
          'streak': localUser.streakDays,
        }),
      );
    } catch (_) {}
  }
}
