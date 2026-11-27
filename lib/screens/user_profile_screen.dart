import 'package:flutter/material.dart';
import '../services/preferences_service.dart';

class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final PreferencesService _prefs = PreferencesService();
  late UserProfile _profile;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profile = _prefs.userProfile;
    _nameController.text = _profile.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _refreshProfile() {
    setState(() {
      _profile = _prefs.userProfile;
    });
  }

  void _editName() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile Name'),
        content: TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Your Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (_nameController.text.trim().isNotEmpty) {
                await _prefs.updateUserName(_nameController.text.trim());
                _refreshProfile();
                if (context.mounted) Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: theme.colorScheme.surfaceContainerHighest,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Profile Header Card
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: primary.withValues(alpha: 0.15),
                    child: Icon(Icons.school_rounded, size: 48, color: primary),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          _profile.name,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit_outlined, size: 20),
                        onPressed: _editName,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Offline & Preferences Managed Locally',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Learning Stats Row
          Row(
            children: [
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.emoji_events,
                            color: Colors.amber, size: 32),
                        const SizedBox(height: 6),
                        Text(
                          '${_profile.totalPoints} PTS',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('Total Points', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Card(
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: Colors.redAccent, size: 32),
                        const SizedBox(height: 6),
                        Text(
                          '${_profile.streakDays} Days',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text('Daily Streak', style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Study Progress
          Text('Study Progress',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.indigo),
              title: const Text('Grammar Lessons Completed'),
              subtitle: Text(
                  '${_profile.completedUnits.length} Units Finished'),
              trailing: Chip(
                label: Text(
                  '${_profile.completedUnits.length} / 115',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Game High Scores
          Text('Game High Scores',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          if (_profile.gameHighScores.isEmpty)
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  'No game scores recorded yet. Play games on the Home screen to earn points!',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            )
          else
            for (final entry in _profile.gameHighScores.entries)
              Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.sports_esports, color: Colors.orange),
                  title: Text(entry.key),
                  trailing: Text(
                    '${entry.value} High Score',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ),
              ),

          const SizedBox(height: 24),

          // Reset Progress
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.redAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.restart_alt_rounded),
            label: const Text('Reset All Local Progress'),
            onPressed: () async {
              final scaffoldMessenger = ScaffoldMessenger.of(context);
              final confirm = await showDialog<bool>(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('Reset All Progress?'),
                  content: const Text(
                      'This will reset your points, streak, completed lessons, and game scores.'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Reset',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await _prefs.resetAllProgress();
                _refreshProfile();
                scaffoldMessenger.showSnackBar(
                  const SnackBar(content: Text('All local progress reset.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
