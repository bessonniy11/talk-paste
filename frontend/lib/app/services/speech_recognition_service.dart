import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechRecognitionService with ChangeNotifier {
  final SpeechToText _speechToText = SpeechToText();
  bool _isListening = false;
  String _recognizedText = '';
  double _currentAmplitude = 0.0; // To be used for equalizer animation

  bool get isListening => _isListening;
  String get recognizedText => _recognizedText;
  double get currentAmplitude => _currentAmplitude;

  Future<void> init() async {
    bool available = await _speechToText.initialize(
      onStatus: (status) {
        debugPrint('Speech recognition status: $status');
        _isListening = _speechToText.isListening;
        notifyListeners();
      },
      onError: (error) {
        debugPrint('Speech recognition error: $error');
        _isListening = false;
        notifyListeners();
      },
    );
    if (!available) {
      debugPrint('The user has denied the use of speech recognition.');
    }
  }

  void startListening() async {
    if (_speechToText.isAvailable && !_speechToText.isListening) {
      _recognizedText = ''; // Clear previous text
      _currentAmplitude = 0.0;
      await _speechToText.listen(
        onResult: (SpeechRecognitionResult result) {
          _recognizedText = result.recognizedWords;
          debugPrint('Recognized: $_recognizedText');
          notifyListeners();
        },
        onSoundLevelChange: (level) {
          _currentAmplitude = level;
          // debugPrint('Sound level: $level');
          notifyListeners();
        },
      );
      _isListening = true;
      notifyListeners();
    }
  }

  void stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
      _isListening = false;
      notifyListeners();
    }
  }

  void cancelListening() async {
    if (_speechToText.isListening) {
      await _speechToText.cancel();
      _isListening = false;
      _recognizedText = ''; // Clear text on cancel
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _speechToText.cancel();
    super.dispose();
  }
}
