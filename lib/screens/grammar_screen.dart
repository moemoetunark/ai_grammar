import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class GrammarScreen extends StatefulWidget {
  const GrammarScreen({super.key});

  @override
  State<GrammarScreen> createState() => _GrammarScreenState();
}

class _GrammarScreenState extends State<GrammarScreen> {
  Map<String, dynamic> _grammarData = {};
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadGrammarData();
  }

  Future<void> _loadGrammarData() async {
    try {
      final jsonString = await rootBundle.loadString('assets/grammar_data.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      setState(() {
        _grammarData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final basicUnits = _grammarData['basic'] as List<dynamic>? ?? [];

    final filteredUnits = basicUnits.where((unit) {
      final category = unit['categories']?.toString().toLowerCase() ?? '';
      final description = unit['descriptions']?.toString().toLowerCase() ?? '';
      return category.contains(_searchQuery.toLowerCase()) ||
          description.contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search grammar topics...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                Expanded(
                  child: filteredUnits.isEmpty
                      ? const Center(child: Text('No grammar topics found.'))
                      : ListView.builder(
                          itemCount: filteredUnits.length,
                          itemBuilder: (context, index) {
                            final unit = filteredUnits[index];
                            final category = unit['categories'] ?? 'Unit ${index + 1}';
                            final description = unit['descriptions'] ?? '';
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Text(
                                    '${index + 1}',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  category,
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                subtitle: Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Text(
                                    description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => GrammarDetailScreen(
                                        unitNumber: index + 1,
                                        details: unit['details'] is Map
                                            ? Map<String, dynamic>.from(
                                                unit['details'] as Map,
                                              )
                                            : const {},
                                        exercises: unit['exercises'] is Map
                                            ? Map<String, dynamic>.from(
                                                unit['exercises'] as Map,
                                              )
                                            : const {},
                                      ),
                                    ),
                                  );
                                },
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

class GrammarDetailScreen extends StatelessWidget {
  final int unitNumber;
  final Map<String, dynamic> details;
  final Map<String, dynamic> exercises;

  const GrammarDetailScreen({
    super.key,
    required this.unitNumber,
    required this.details,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lesson $unitNumber'),
          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.menu_book), text: 'Lesson details'),
              Tab(icon: Icon(Icons.quiz_outlined), text: 'Exercises'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _LessonContent(data: details),
            _ExerciseContent(data: exercises),
          ],
        ),
      ),
    );
  }
}

const _ink = Color(0xFF352C2A);
const _accent = Color(0xFFC44338);
const _paper = Color(0xFFFFF9F6);

class _LessonContent extends StatelessWidget {
  final Map<String, dynamic> data;
  const _LessonContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final tables = (data['tables'] as List? ?? []).cast<Map>();
    final examples = (data['examples'] as List? ?? []).cast<List>();
    final notes = (data['notes'] as List? ?? []).cast<List>();
    return Container(
      color: const Color(0xFFF3EEE9),
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          _panel(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(data['title'] ?? '', style: const TextStyle(fontSize: 23, fontWeight: FontWeight.bold, color: _ink)),
              Text(data['subtitle'] ?? '', style: const TextStyle(color: _accent, fontSize: 16, height: 1.4)),
              const SizedBox(height: 8),
              Wrap(spacing: 6, runSpacing: 6, children: [
                for (final line in data['introduction'] as List? ?? [])
                  Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7), decoration: BoxDecoration(color: _paper, borderRadius: BorderRadius.circular(10), border: Border.all(color: const Color(0xFFF0DDD5))), child: Text('$line', style: const TextStyle(fontSize: 15, height: 1.4))),
              ]),
            ]),
          ),
          for (final table in tables) _GrammarTable(data: Map<String, dynamic>.from(table)),
          _sectionTitle(data['examplesTitle'] ?? 'Examples'),
          for (final example in examples) _ExampleCard(english: '${example[0]}', translation: '${example[1]}'),
          for (final note in notes) _ExampleCard(english: '${note[0]}', translation: '${note[1]}'),
          _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(data['questionTitle'] ?? 'Questions', style: const TextStyle(color: _accent, fontWeight: FontWeight.bold, fontSize: 17)), const SizedBox(height: 4), Text(data['questionNote'] ?? '', style: const TextStyle(fontSize: 16, height: 1.4))])),
        ],
      ),
    );
  }
}

Widget _panel({required Widget child}) => Container(
      margin: const EdgeInsets.only(bottom: 9),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10), boxShadow: const [BoxShadow(color: Color(0x14633C32), blurRadius: 8, offset: Offset(0, 2))]),
      child: child,
    );

Widget _sectionTitle(String title) => Padding(
      padding: const EdgeInsets.fromLTRB(3, 4, 3, 6),
      child: Text(title, style: const TextStyle(color: _accent, fontWeight: FontWeight.bold, fontSize: 18, height: 1.35)),
    );

class _GrammarTable extends StatelessWidget {
  final Map<String, dynamic> data;
  const _GrammarTable({required this.data});

  @override
  Widget build(BuildContext context) {
    final headers = (data['headers'] as List).cast<String>();
    final rows = (data['rows'] as List).cast<List>();
    return _panel(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('${data['title']}', style: const TextStyle(color: _accent, fontWeight: FontWeight.bold, fontSize: 16, height: 1.35)),
      const SizedBox(height: 5),
      Table(border: TableBorder.all(color: const Color(0xFFE6AAA0)), columnWidths: {0: const FlexColumnWidth(1.2), 1: const FlexColumnWidth(1), 2: const FlexColumnWidth(1.5)}, children: [
        TableRow(decoration: const BoxDecoration(color: Color(0xFFFFF0EB)), children: headers.map((text) => _tableCell(text, bold: true)).toList()),
        for (final row in rows) TableRow(children: row.map((text) => _tableCell('$text')).toList()),
      ]),
    ]));
  }
}

Widget _tableCell(String text, {bool bold = false}) => Padding(padding: const EdgeInsets.all(6), child: Text(text, style: TextStyle(fontSize: 14, height: 1.35, fontWeight: bold ? FontWeight.bold : FontWeight.normal, color: _ink)));

class _ExampleCard extends StatelessWidget {
  final String english;
  final String translation;
  const _ExampleCard({required this.english, required this.translation});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 7),
        decoration: const BoxDecoration(color: _paper, border: Border(left: BorderSide(color: Color(0xFFEB6955), width: 3))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(english, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, height: 1.4)), const SizedBox(height: 4), Text(translation, style: const TextStyle(fontSize: 17, height: 1.6, color: Color(0xFF3F332F))) ]),
      );
}

class _ExerciseContent extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ExerciseContent({required this.data});

  @override
  Widget build(BuildContext context) {
    final groups = (data['groups'] as List? ?? []).cast<Map>();
    return Container(
      color: const Color(0xFFF5F1ED),
      child: ListView(padding: const EdgeInsets.all(12), children: [
        Text(data['title'] ?? 'Practice', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: _accent)),
        for (final group in groups) _ExerciseGroup(data: Map<String, dynamic>.from(group)),
      ]),
    );
  }
}

class _ExerciseGroup extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ExerciseGroup({required this.data});

  @override
  Widget build(BuildContext context) {
    final items = (data['items'] as List? ?? []).cast<String>();
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(9), border: Border.all(color: const Color(0xFFEFDFD9))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('${data['title']}', style: const TextStyle(fontWeight: FontWeight.bold, color: _accent, fontSize: 16, height: 1.4)),
        if ('${data['translation'] ?? ''}'.isNotEmpty) Padding(padding: const EdgeInsets.only(top: 3, bottom: 7), child: Text('${data['translation']}', style: const TextStyle(fontSize: 14, height: 1.5, color: Color(0xFF625852)))),
        for (var i = 0; i < items.length; i++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 24,
                  child: Text(
                    '${i + 1}',
                    style: const TextStyle(fontSize: 14, color: Color(0xFF705E57)),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Text(
                    items[i],
                    style: const TextStyle(fontSize: 16, height: 1.4, color: _ink),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    minLines: 1,
                    maxLines: 2,
                    decoration: const InputDecoration(
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 4),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFC88376)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: _accent, width: 2),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      ]),
    );
  }
}
