import 'package:flutter/material.dart';
import 'screens/grammar_screen.dart';
import 'screens/speaking_screen.dart';
import 'screens/reading_screen.dart';
import 'screens/listening_screen.dart';

void main() {
  runApp(const AIGrammarApp());
}

class AIGrammarApp extends StatelessWidget {
  const AIGrammarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI English Grammar & Learning',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF633C32)),
        fontFamily: 'MyanmarCustom',
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  static const _sectionNames = ['Grammar', 'Speaking', 'Reading', 'Listening'];
  static const _sectionIcons = [
    Icons.menu_book_outlined,
    Icons.mic_outlined,
    Icons.chrome_reader_mode_outlined,
    Icons.headphones_outlined,
  ];

  final List<Widget> _screens = const [
    GrammarScreen(),
    SpeakingScreen(),
    ReadingScreen(),
    ListeningScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AI English Learning · ${_sectionNames[_currentIndex]}'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            children: [
              DrawerHeader(
                margin: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                ),
                child: const Align(
                  alignment: Alignment.bottomLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Icon(Icons.school_outlined, size: 36),
                      SizedBox(height: 12),
                      Text('AI English Learning', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text('Choose a learning activity'),
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
                    setState(() => _currentIndex = index);
                    Navigator.pop(context);
                  },
                ),
            ],
          ),
        ),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
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
