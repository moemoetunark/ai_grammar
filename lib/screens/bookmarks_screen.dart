import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/preferences_service.dart';
import 'grammar_screen.dart';

class BookmarksScreen extends StatefulWidget {
  const BookmarksScreen({super.key});

  @override
  State<BookmarksScreen> createState() => _BookmarksScreenState();
}

class _BookmarksScreenState extends State<BookmarksScreen> {
  final _preferences = PreferencesService();
  List<dynamic> _units = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadUnits();
  }

  Future<void> _loadUnits() async {
    try {
      final jsonString = await rootBundle.loadString('assets/grammar_data.json');
      final data = json.decode(jsonString) as Map<String, dynamic>;
      if (!mounted) return;
      setState(() {
        _units = data['basic'] as List<dynamic>? ?? [];
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookmarked = _preferences.userProfile.bookmarkedUnits;
    final user = _preferences.userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      appBar: AppBar(
        title: const Text('Bookmarked Grammar Lessons'),
        backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : bookmarked.isEmpty
              ? const Center(
                  child: Text(
                    'You have no bookmarked lessons yet.',
                    style: TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: bookmarked.length,
                  itemBuilder: (context, index) {
                    final unitNumber = bookmarked[index];
                    final unitIndex = unitNumber - 1;
                    if (unitIndex < 0 || unitIndex >= _units.length) {
                      return const SizedBox.shrink();
                    }
                    final unit = _units[unitIndex] as Map<String, dynamic>;
                    final category = '${unit['categories'] ?? 'Unit $unitNumber'}';
                    final description = '${unit['descriptions'] ?? ''}';
                    final isCompleted = user.completedUnits.contains(unitNumber);

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: Colors.black.withValues(alpha: 0.05)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x12000000),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(18),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(18),
                          onTap: () async {
                            await Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => GrammarDetailScreen(
                                  unitNumber: unitNumber,
                                  category: category,
                                  description: description,
                                  details: unit['details'],
                                  exercises: unit['exercises'],
                                ),
                              ),
                            );
                            if (mounted) setState(() {});
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    gradient: isCompleted
                                        ? const LinearGradient(
                                            colors: [Color(0xFF10B981), Color(0xFF059669)],
                                          )
                                        : const LinearGradient(
                                            colors: [Color(0xFF6366F1), Color(0xFF4F46E5)],
                                          ),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: (isCompleted
                                                ? const Color(0xFF10B981)
                                                : const Color(0xFF6366F1))
                                            .withValues(alpha: 0.3),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Center(
                                    child: isCompleted
                                        ? const Icon(Icons.check_rounded,
                                            color: Colors.white, size: 26)
                                        : Text(
                                            '$unitNumber',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w900,
                                              fontSize: 18,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        category,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF1E293B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          color: Colors.grey[600],
                                          height: 1.3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.bookmark_rounded,
                                        color: Colors.amber,
                                      ),
                                      onPressed: () async {
                                        await _preferences.toggleUnitBookmark(unitNumber);
                                        setState(() {});
                                      },
                                    ),
                                    const Icon(Icons.arrow_forward_ios_rounded,
                                        size: 16, color: Colors.grey),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
