import 'package:flutter_tts/flutter_tts.dart';

/// تحويل النص إلى صوت عبر محرك الجهاز (يعمل دون إنترنت إن كان الصوت العربي منزّلًا).
class Speaker {
  static final FlutterTts _tts = FlutterTts();
  static bool available = false;

  static Future<void> init() async {
    try {
      final r = await _tts.isLanguageAvailable('ar');
      available = r == true || r == 1;
      if (available) {
        await _tts.setLanguage('ar');
        await _tts.setSpeechRate(0.45);
        await _tts.setVolume(1.0);
      }
    } catch (_) {
      available = false;
    }
  }

  /// يرجع false إذا لم يتوفر الصوت، ليعرض التطبيق النص بالشاشة الكاملة بدلًا منه.
  static Future<bool> speak(String text) async {
    if (text.trim().isEmpty) return false;
    if (!available) await init();
    if (!available) return false;
    try {
      await _tts.stop();
      await _tts.speak(text);
      return true;
    } catch (_) {
      return false;
    }
  }
}
