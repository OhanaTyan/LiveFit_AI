import 'dart:async';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class VoiceRecognitionService {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  double _confidence = 0.0;
  double _soundLevel = 0.0;
  String _currentLocale = 'zh_CN'; // 默认中文
  List<String> _availableLocales = [];

  // 获取可用的语言列表
  List<String> get availableLocales => _availableLocales;
  String get currentLocale => _currentLocale;
  double get soundLevel => _soundLevel;

  Future<void> initSpeech() async {
    _speechEnabled = await _speechToText.initialize(
      onStatus: (status) {
        // Handle status changes
      },
      onError: (errorNotification) {
        // Handle errors
      },
    );

    // 获取可用的语言列表
    if (_speechEnabled) {
      final locales = await _speechToText.locales();
      _availableLocales = locales.map((locale) => locale.localeId).toList();
    }
  }

  void setLocale(String localeId) {
    _currentLocale = localeId;
  }

  void startListening({
    required Function(String) onResult,
    required Function(String) onPartialResult,
    required Function(double) onConfidence,
    required Function(double) onSoundLevel,
    required Function(String) onStatus,
    required Function(String) onError,
  }) async {
    if (!_speechEnabled) {
      await initSpeech();
    }

    await _speechToText.listen(
      onResult: (SpeechRecognitionResult result) {
        _lastWords = result.recognizedWords;
        _confidence = result.confidence;
        onResult(_lastWords);
        onConfidence(_confidence);
      },
      listenFor: const Duration(minutes: 3),
      pauseFor: const Duration(seconds: 5),
      partialResults: true,
      localeId: _currentLocale,
      onSoundLevelChange: (level) {
        _soundLevel = level;
        onSoundLevel(level);
      },
    );
  }

  Future<void> stopListening() async {
    await _speechToText.stop();
  }

  Future<void> cancelListening() async {
    await _speechToText.cancel();
  }

  bool get isListening => _speechToText.isListening;
  bool get isAvailable => _speechEnabled;
  String get lastWords => _lastWords;
  double get confidence => _confidence;
}