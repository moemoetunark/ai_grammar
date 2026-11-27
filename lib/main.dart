import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/app_settings_screen.dart';
import 'screens/bookmarks_screen.dart';
import 'screens/grammar_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/listening_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/speaking_screen.dart';
import 'screens/study_planner_screen.dart';
import 'screens/user_profile_screen.dart';
import 'screens/webview_test_screen.dart';
import 'services/preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = PreferencesService();
  await prefs.init();
  runApp(const AIGrammarApp());
}

class AIGrammarApp extends StatefulWidget {
  const AIGrammarApp({super.key});

  @override
  State<AIGrammarApp> createState() => _AIGrammarAppState();
}

class _AIGrammarAppState extends State<AIGrammarApp> {
  late Color _seedColor;
  late double _fontScale;
  final _prefs = PreferencesService();

  @override
  void initState() {
    super.initState();
    _seedColor = _prefs.seedColor;
    _fontScale = _prefs.fontScale;
  }

  void _updateSeedColor(Color color) {
    setState(() => _seedColor = color);
    _prefs.saveSeedColor(color);
  }

  void _updateFontScale(double scale) {
    setState(() => _fontScale = scale);
    _prefs.saveFontScale(scale);
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'AI English Grammar & Learning',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
          fontFamily: 'MyanmarCustom',
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFE2E8F0),
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
          navigationBarTheme: const NavigationBarThemeData(
            backgroundColor: Color(0xFFFFFFFF),
            elevation: 2,
            indicatorColor: Color(0xFFE9E4DE),
          ),
        ),
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: TextScaler.linear(_fontScale)),
          child: child!,
        ),
        home: _prefs.hasCompletedOnboarding
            ? HomeScreen(
                seedColor: _seedColor,
                fontScale: _fontScale,
                onSeedColorChanged: _updateSeedColor,
                onFontScaleChanged: _updateFontScale,
              )
            : const OnboardingScreen(),
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.seedColor = const Color(0xFF4F46E5),
    this.fontScale = 1.0,
    this.onSeedColorChanged,
    this.onFontScaleChanged,
  });

  final Color seedColor;
  final double fontScale;
  final ValueChanged<Color>? onSeedColorChanged;
  final ValueChanged<double>? onFontScaleChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  void _showRateAppDialog() {
    int selectedStars = 5;
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Rate AI English Grammar ⭐'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'If you enjoy using our app, please take a moment to rate us! Your feedback helps us improve.',
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  5,
                  (index) => IconButton(
                    icon: Icon(
                      index < selectedStars
                          ? Icons.star_rounded
                          : Icons.star_border_rounded,
                      color: Colors.amber,
                      size: 32,
                    ),
                    onPressed: () {
                      setDialogState(() {
                        selectedStars = index + 1;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Thank you for rating us $selectedStars stars! 🎉'),
                    backgroundColor: Colors.green,
                  ),
                );
              },
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSubscribeYouTubeDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.subscriptions_rounded, color: Colors.red, size: 28),
            SizedBox(width: 10),
            Text('Subscribe on YouTube'),
          ],
        ),
        content: const Text(
          'Subscribe to our official YouTube channel for daily English grammar video explanations and conversation practice!',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            icon: const Icon(Icons.open_in_new, color: Colors.white),
            label: const Text('Subscribe Now', style: TextStyle(color: Colors.white)),
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening YouTube Channel...'),
                  backgroundColor: Colors.red,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('AdMob & Privacy Policy 🔒'),
        content: const SingleChildScrollView(
          child: Text(
            'We value your privacy. This application uses Google AdMob to deliver non-intrusive advertisements. '
            'AdMob may collect device identifiers and usage data to serve personalized or non-personalized ads in compliance with Google Play Developer Policies.\n\n'
            'All your study progress, quiz scores, and settings are stored locally on your device and are never shared with third parties.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showExitAppDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Exit App?'),
        content: const Text('Are you sure you want to close AI English Grammar?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.pop(context);
              SystemNavigator.pop();
            },
            child: const Text('Exit App', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = PreferencesService().userProfile;

    final screens = [
      HomeDashboard(onActivitySelected: (index) {
        setState(() => _currentIndex = index);
      }),
      const GrammarScreen(),
      const SpeakingScreen(),
      const ReadingScreen(),
      const ListeningScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _currentIndex == 0
              ? 'AI English Grammar'
              : _currentIndex == 1
                  ? 'Grammar Lessons'
                  : _currentIndex == 2
                      ? 'AI Speaking Practice'
                      : _currentIndex == 3
                          ? 'Reading Stories'
                          : 'Listening Practice',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (_) => const UserProfileScreen()),
              );
              setState(() {});
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => AppSettingsScreen(
                    seedColor: widget.seedColor,
                    fontScale: widget.fontScale,
                    onSeedColorChanged: (color) {
                      if (widget.onSeedColorChanged != null) {
                        widget.onSeedColorChanged!(color);
                      } else {
                        PreferencesService().saveSeedColor(color);
                      }
                      setState(() {});
                    },
                    onFontScaleChanged: (scale) {
                      if (widget.onFontScaleChanged != null) {
                        widget.onFontScaleChanged!(scale);
                      } else {
                        PreferencesService().saveFontScale(scale);
                      }
                      setState(() {});
                    },
                  ),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFFF1F5F9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              accountName: Text(
                user.name,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              accountEmail: Text(
                'Streak: ${user.streakDays} Days · ${user.totalPoints} PTS',
                style: const TextStyle(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.school,
                    color: Theme.of(context).colorScheme.primary, size: 36),
              ),
            ),
            const SizedBox(height: 8),

            _DrawerCardTile(
              icon: Icons.account_circle_outlined,
              title: 'User Profile & Stats',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (_) => const UserProfileScreen()),
                );
                setState(() {});
              },
            ),
            _DrawerCardTile(
              icon: Icons.leaderboard_rounded,
              iconColor: Colors.amber[700],
              title: 'Global Leaderboard',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const LeaderboardScreen(),
                  ),
                );
                if (mounted) setState(() {});
              },
            ),
            _DrawerCardTile(
              icon: Icons.calendar_month_rounded,
              iconColor: const Color(0xFF6366F1),
              title: 'Study Planner & Notes',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const StudyPlannerScreen(),
                  ),
                );
                if (mounted) setState(() {});
              },
            ),
            _DrawerCardTile(
              icon: Icons.bookmarks_outlined,
              title: 'Bookmarked Lessons',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const BookmarksScreen(),
                  ),
                );
                if (mounted) setState(() {});
              },
            ),
            _DrawerCardTile(
              icon: Icons.language_outlined,
              title: 'WebView Audio Test',
              onTap: () async {
                Navigator.pop(context);
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const WebViewTestScreen(),
                  ),
                );
              },
            ),

            const Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'COMMUNITY & SUPPORT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                  letterSpacing: 0.8,
                ),
              ),
            ),

            _DrawerCardTile(
              icon: Icons.subscriptions_rounded,
              iconColor: Colors.red,
              title: 'Subscribe on YouTube',
              onTap: () {
                Navigator.pop(context);
                _showSubscribeYouTubeDialog();
              },
            ),
            _DrawerCardTile(
              icon: Icons.star_rounded,
              iconColor: Colors.amber[700],
              title: 'Rate This App',
              onTap: () {
                Navigator.pop(context);
                _showRateAppDialog();
              },
            ),
            _DrawerCardTile(
              icon: Icons.privacy_tip_outlined,
              iconColor: Colors.blue[700],
              title: 'AdMob Privacy Policy',
              onTap: () {
                Navigator.pop(context);
                _showPrivacyPolicyDialog();
              },
            ),

            const SizedBox(height: 12),

            _DrawerCardTile(
              icon: Icons.power_settings_new_rounded,
              iconColor: Colors.red,
              title: 'Exit App',
              onTap: () {
                Navigator.pop(context);
                _showExitAppDialog();
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Grammar',
          ),
          NavigationDestination(
            icon: Icon(Icons.mic_outlined),
            selectedIcon: Icon(Icons.mic),
            label: 'Speaking',
          ),
          NavigationDestination(
            icon: Icon(Icons.chrome_reader_mode_outlined),
            selectedIcon: Icon(Icons.chrome_reader_mode),
            label: 'Reading',
          ),
          NavigationDestination(
            icon: Icon(Icons.headphones_outlined),
            selectedIcon: Icon(Icons.headphones),
            label: 'Listening',
          ),
        ],
      ),
    );
  }
}

class _DrawerCardTile extends StatelessWidget {
  const _DrawerCardTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        leading: Icon(icon, color: iconColor ?? Theme.of(context).colorScheme.primary),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: iconColor ?? const Color(0xFF1E293B),
          ),
        ),
        trailing: const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.grey),
        onTap: onTap,
      ),
    );
  }
}
