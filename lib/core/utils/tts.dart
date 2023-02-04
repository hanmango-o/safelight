import 'package:flutter_tts/flutter_tts.dart';

class TTS {
  final FlutterTts tts;

  TTS({required this.tts});

  Future<void> call(String text) async {
    await tts.stop();
    await tts.speak(text);
  }
}
