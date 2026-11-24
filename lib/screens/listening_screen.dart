import 'package:flutter/material.dart';

class ListeningScreen extends StatefulWidget {
  const ListeningScreen({super.key});

  @override
  State<ListeningScreen> createState() => _ListeningScreenState();
}

class _ListeningScreenState extends State<ListeningScreen> {
  bool _isPlaying = false;
  double _currentSliderValue = 0.0;

  final List<Map<String, String>> _listeningLessons = const [
    {
      'title': 'Lesson 1: Greetings & Introductions',
      'duration': '1:45',
      'transcript': 'A: Hello, nice to meet you. My name is David.\nB: Hi David, I am Sarah. Where are you from?\nA: I am from Canada. And you?\nB: I am from Australia.',
    },
    {
      'title': 'Lesson 2: Ordering Food at a Cafe',
      'duration': '2:15',
      'transcript': 'Waiterm: Good morning! What would you like to order?\nCustomer: Good morning. I would like a cup of black coffee and a croissant, please.\nWaiterm: Sure! Anything else?\nCustomer: No, that is all. Thank you.',
    },
    {
      'title': 'Lesson 3: Asking for Directions',
      'duration': '2:30',
      'transcript': 'Tourist: Excuse me, is there a bank near here?\nPasserby: Yes, walk straight down this street, then turn left at the traffic lights. The bank is on your right.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.secondaryContainer,
                ],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                const Text(
                  'Now Playing',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Lesson 1: Greetings & Introductions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                Slider(
                  value: _currentSliderValue,
                  max: 100,
                  onChanged: (value) {
                    setState(() {
                      _currentSliderValue = value;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('0:30', style: TextStyle(fontSize: 12)),
                    Text('1:45', style: TextStyle(fontSize: 12)),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.replay_10, size: 32),
                      onPressed: () {},
                    ),
                    const SizedBox(width: 16),
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      child: IconButton(
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white, size: 32),
                        onPressed: () {
                          setState(() {
                            _isPlaying = !_isPlaying;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: const Icon(Icons.forward_10, size: 32),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'All Listening Lessons',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _listeningLessons.length,
              itemBuilder: (context, index) {
                final lesson = _listeningLessons[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
                      child: Icon(Icons.headphones, color: Theme.of(context).colorScheme.onTertiaryContainer),
                    ),
                    title: Text(lesson['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Duration: ${lesson['duration']}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_circle_fill, size: 32),
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Playing ${lesson['title']}')),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
