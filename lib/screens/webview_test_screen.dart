import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewTestScreen extends StatefulWidget {
  const WebViewTestScreen({super.key});

  @override
  State<WebViewTestScreen> createState() => _WebViewTestScreenState();
}
class _WebViewTestScreenState extends State<WebViewTestScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String _currentText = 'Hello, welcome to English grammar learning!';

  late final WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..addJavaScriptChannel(
      'FlutterTTS',
      onMessageReceived: (JavaScriptMessage msg) async {
        try {
          final data = jsonDecode(msg.message) as Map<String, dynamic>;
          final action = data['action'];
          final text = data['text'] ?? '';

          if (action == 'speak' && text.isNotEmpty) {
            setState(() => _currentText = text);
            _playPronunciationSample(text);
          } else if (action == 'stop') {
            await _audioPlayer.stop();
            setState(() => _isPlaying = false);
          }
        } catch (_) {}
      },
    )
    ..setNavigationDelegate(
      NavigationDelegate(
        onProgress: (progress) {
          if (mounted) setState(() => _progress = progress);
        },
        onWebResourceError: (error) {
          if (error.isForMainFrame == true && mounted) {
            setState(() => _error = error.description);
          }
        },
      ),
    );

  int _progress = 0;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadAsset();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playPronunciationSample(String text) async {
    try {
      setState(() => _isPlaying = true);
      final encodedText = Uri.encodeComponent(text);
      final ttsUrl =
          'https://translate.google.com/translate_tts?ie=UTF-8&q=$encodedText&tl=en&client=tw-ob';
      await _audioPlayer.setUrl(ttsUrl);
      await _audioPlayer.play();
      if (mounted) setState(() => _isPlaying = false);
    } catch (_) {
      if (mounted) setState(() => _isPlaying = false);
    }
  }

  Future<void> _loadAsset() async {
    setState(() {
      _error = null;
      _progress = 0;
    });
    try {
      await _controller.loadFlutterAsset('assets/html/unit_1.html');
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('WebView & Audio Pronunciation'),
          actions: [
            IconButton(
              tooltip: 'Reload',
              onPressed: _loadAsset,
              icon: const Icon(Icons.refresh),
            ),
          ],
        ),
        body: Column(
          children: [
            if (_progress < 100 && _error == null)
              LinearProgressIndicator(value: _progress / 100),
            if (_error != null)
              MaterialBanner(
                content: Text('Could not load the page: $_error'),
                actions: [
                  TextButton(onPressed: _loadAsset, child: const Text('Retry')),
                ],
              ),
            Expanded(child: WebViewWidget(controller: _controller)),
            Container(
              padding: const EdgeInsets.all(12),
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
              child: Row(
                children: [
                  const Icon(Icons.volume_up_rounded),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _isPlaying
                          ? 'Speaking: "$_currentText"'
                          : 'Tap any sentence in WebView to pronounce',
                      style: const TextStyle(fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying
                          ? Icons.stop_circle_rounded
                          : Icons.play_circle_filled_rounded,
                      size: 36,
                    ),
                    onPressed: () async {
                      if (_isPlaying) {
                        await _audioPlayer.stop();
                        setState(() => _isPlaying = false);
                      } else {
                        _playPronunciationSample(_currentText);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
