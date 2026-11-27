import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:just_audio/just_audio.dart';
import '../services/preferences_service.dart';

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
      final jsonString =
          await rootBundle.loadString('assets/grammar_data.json');
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

    final user = PreferencesService().userProfile;

    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search grammar topics...',
                      prefixIcon: const Icon(Icons.search, color: Color(0xFF6366F1)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
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
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          itemCount: filteredUnits.length,
                          itemBuilder: (context, index) {
                            final unit = filteredUnits[index];
                            final unitNum = basicUnits.indexOf(unit) + 1;
                            final category =
                                unit['categories'] ?? 'Unit $unitNum';
                            final description = unit['descriptions'] ?? '';
                            final isCompleted =
                                user.completedUnits.contains(unitNum);
                            final isBookmarked =
                                user.bookmarkedUnits.contains(unitNum);

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
                                    await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GrammarDetailScreen(
                                          unitNumber: unitNum,
                                          category: category,
                                          description: description,
                                          details: unit['details'],
                                          exercises: unit['exercises'],
                                        ),
                                      ),
                                    );
                                    setState(() {});
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Row(
                                      children: [
                                        // Unit Badge
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
                                                    '$unitNum',
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
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
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
                                              icon: Icon(
                                                isBookmarked
                                                    ? Icons.bookmark_rounded
                                                    : Icons.bookmark_border_rounded,
                                                color: isBookmarked
                                                    ? Colors.amber
                                                    : Colors.grey[400],
                                              ),
                                              onPressed: () async {
                                                await PreferencesService()
                                                    .toggleUnitBookmark(unitNum);
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
                ),
              ],
            ),
    );
  }
}

class InlineAdBannerCard extends StatelessWidget {
  const InlineAdBannerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant
              .withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Ad',
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          const SizedBox(width: 12),
          const Icon(Icons.ads_click, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          const Text(
            'AdMob Inline Adaptive Banner',
            style: TextStyle(
                fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

class GrammarDetailScreen extends StatefulWidget {
  final int unitNumber;
  final String category;
  final String description;
  final dynamic details;
  final dynamic exercises;

  const GrammarDetailScreen({
    super.key,
    required this.unitNumber,
    required this.category,
    required this.description,
    required this.details,
    required this.exercises,
  });

  @override
  State<GrammarDetailScreen> createState() => _GrammarDetailScreenState();
}

class _GrammarDetailScreenState extends State<GrammarDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final isBookmarked = PreferencesService()
        .userProfile
        .bookmarkedUnits
        .contains(widget.unitNumber);

    return Scaffold(
      appBar: AppBar(
        title: Text('Unit ${widget.unitNumber}: ${widget.category}'),
        backgroundColor:
            Theme.of(context).colorScheme.surfaceContainerHighest,
        actions: [
          IconButton(
            icon: Icon(
              isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: isBookmarked ? Colors.amber : null,
            ),
            onPressed: () async {
              await PreferencesService()
                  .toggleUnitBookmark(widget.unitNumber);
              setState(() {});
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _DetailsTabView(
        unitNumber: widget.unitNumber,
        category: widget.category,
        description: widget.description,
        details: widget.details,
      ),
    );
  }
}

class _DetailsTabView extends StatefulWidget {
  final int unitNumber;
  final String category;
  final String description;
  final dynamic details;

  const _DetailsTabView({
    required this.unitNumber,
    required this.category,
    required this.description,
    required this.details,
  });

  @override
  State<_DetailsTabView> createState() => _DetailsTabViewState();
}

class _DetailsTabViewState extends State<_DetailsTabView> {
  late final WebViewController _controller;
  bool _isLoadingHtml = true;
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initWebView();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _initWebView() async {
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterTTS',
        onMessageReceived: (JavaScriptMessage msg) async {
          try {
            final data = jsonDecode(msg.message) as Map<String, dynamic>;
            final text = data['text'] ?? '';
            if (text.isNotEmpty) {
              final encoded = Uri.encodeComponent(text);
              await _audioPlayer.setUrl(
                  'https://translate.google.com/translate_tts?ie=UTF-8&q=$encoded&tl=en&client=tw-ob');
              await _audioPlayer.play();
            }
          } catch (_) {}
        },
      );

    try {
      final htmlPath = 'assets/html/unit_${widget.unitNumber}.html';
      final htmlString = await rootBundle.loadString(htmlPath);
      await _controller.loadHtmlString(htmlString);
      if (mounted) {
        setState(() {
          _isLoadingHtml = false;
        });
      }
    } catch (_) {
      final fallbackHtml = '''
        <!DOCTYPE html>
        <html lang="en">
        <head>
          <meta charset="utf-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <style>
            body { font-family: sans-serif; padding: 20px; background-color: #F8FAFC; color: #1E293B; line-height: 1.6; }
            h1 { color: #6366F1; font-size: 22px; }
            .card { background: white; padding: 18px; border-radius: 16px; box-shadow: 0 4px 12px rgba(0,0,0,0.06); margin-top: 16px; }
            .btn { background: #6366F1; color: white; border: none; padding: 10px 16px; border-radius: 10px; font-weight: bold; cursor: pointer; }
          </style>
        </head>
        <body>
          <h1>Unit ${widget.unitNumber}: ${widget.category}</h1>
          <div class="card">
            <p>${widget.description}</p>
            <button class="btn" onclick="speakText('${widget.category}. ${widget.description}')">🔊 Pronounce Title</button>
          </div>
          <script>
            function speakText(text) {
              if (window.FlutterTTS) {
                window.FlutterTTS.postMessage(JSON.stringify({ action: 'speak', text: text }));
              }
            }
          </script>
        </body>
        </html>
      ''';
      await _controller.loadHtmlString(fallbackHtml);
      if (mounted) {
        setState(() {
          _isLoadingHtml = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingHtml) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebViewWidget(
      controller: _controller,
      gestureRecognizers: {
        Factory<VerticalDragGestureRecognizer>(
          () => VerticalDragGestureRecognizer(),
        ),
      },
    );
  }
}
