import 'package:flutter/material.dart';
import 'screens/app_settings_screen.dart';
import 'screens/grammar_screen.dart';
import 'screens/home_dashboard.dart';
import 'screens/listening_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/speaking_screen.dart';

void main() => runApp(const AIGrammarApp());

class AIGrammarApp extends StatefulWidget {
  const AIGrammarApp({super.key});

  @override
  State<AIGrammarApp> createState() => _AIGrammarAppState();
}

class _AIGrammarAppState extends State<AIGrammarApp> {
  Color _seedColor = const Color(0xFF96FB06);
  double _fontScale = 1;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'AI English Grammar & Learning',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: _seedColor),
          fontFamily: 'MyanmarCustom',
          useMaterial3: true,
          scaffoldBackgroundColor: const Color(0xFFF7F7F4),
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
        home: HomeScreen(
          seedColor: _seedColor,
          fontScale: _fontScale,
          onSeedColorChanged: (color) => setState(() => _seedColor = color),
          onFontScaleChanged: (scale) => setState(() => _fontScale = scale),
        ),
      );
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    required this.seedColor,
    required this.fontScale,
    required this.onSeedColorChanged,
    required this.onFontScaleChanged,
  });

  final Color seedColor;
  final double fontScale;
  final ValueChanged<Color> onSeedColorChanged;
  final ValueChanged<double> onFontScaleChanged;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showSettings = false;

  static const _sectionNames = [
    'Home',
    'Grammar',
    'Speaking',
    'Reading',
    'Listening'
  ];
  static const _sectionIcons = [
    Icons.home_outlined,
    Icons.menu_book_outlined,
    Icons.mic_outlined,
    Icons.chrome_reader_mode_outlined,
    Icons.headphones_outlined,
  ];

  late final List<Widget> _screens = [
    HomeDashboard(onActivitySelected: _selectActivity),
    const GrammarScreen(),
    const SpeakingScreen(),
    const ReadingScreen(),
    const ListeningScreen(),
  ];

  void _selectActivity(int index) => setState(() => _currentIndex = index);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'AI English Learning · ${_showSettings ? 'Settings' : _sectionNames[_currentIndex]}'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.tertiary
                    ],
                  ),
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.school_rounded, size: 36, color: Colors.white),
                      SizedBox(height: 12),
                      Text(
                        'AI English Learning',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Text(
                        'Your daily English practice',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ),
              for (var index = 0; index < _sectionNames.length; index++)
                ListTile(
                  leading: Icon(_sectionIcons[index]),
                  title: Text(_sectionNames[index]),
                  selected: _currentIndex == index,
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _showSettings = false;
                    });
                    Navigator.pop(context);
                  },
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.settings_outlined),
                title: const Text('Settings'),
                selected: _showSettings,
                onTap: () {
                  setState(() => _showSettings = true);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
      body: _showSettings
          ? AppSettingsScreen(
              seedColor: widget.seedColor,
              fontScale: widget.fontScale,
              onSeedColorChanged: widget.onSeedColorChanged,
              onFontScaleChanged: widget.onFontScaleChanged,
            )
          : IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: _showSettings
          ? null
          : NavigationBar(
              selectedIndex: _currentIndex,
              onDestinationSelected: _selectActivity,
              destinations: const [
                NavigationDestination(
                    icon: Icon(Icons.home_outlined),
                    selectedIcon: Icon(Icons.home),
                    label: 'Home'),
                NavigationDestination(
                    icon: Icon(Icons.menu_book_outlined),
                    selectedIcon: Icon(Icons.menu_book),
                    label: 'Grammar'),
                NavigationDestination(
                    icon: Icon(Icons.mic_outlined),
                    selectedIcon: Icon(Icons.mic),
                    label: 'Speaking'),
                NavigationDestination(
                    icon: Icon(Icons.chrome_reader_mode_outlined),
                    selectedIcon: Icon(Icons.chrome_reader_mode),
                    label: 'Reading'),
                NavigationDestination(
                    icon: Icon(Icons.headphones_outlined),
                    selectedIcon: Icon(Icons.headphones),
                    label: 'Listening'),
              ],
            ),
    );
  }
}
