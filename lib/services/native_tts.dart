import 'package:flutter/services.dart';

class NativeTts {
  static const MethodChannel _channel =
      MethodChannel('com.example.ai_grammar/tts');

  static Future<void> speak(String text,
      {String lang = 'en-GB', double rate = 0.9}) async {
    try {
      await _channel.invokeMethod('speak', {
        'text': text,
        'lang': lang,
        'rate': rate,
      });
    } catch (_) {}
  }

  static Future<void> stop() async {
    try {
      await _channel.invokeMethod('stop');
    } catch (_) {}
  }
}
