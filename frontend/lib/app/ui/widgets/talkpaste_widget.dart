import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:provider/provider.dart';
import 'package:frontend/app/services/speech_recognition_service.dart';
import 'package:frontend/app/services/settings_service.dart';
import 'package:frontend/app/ui/widgets/equalizer_animation_widget.dart';
import 'package:screen_retriever/screen_retriever.dart'; // New import
import 'dart:async'; // Added for Timer

class TalkPasteWidget extends StatefulWidget {
  const TalkPasteWidget({super.key});

  @override
  State<TalkPasteWidget> createState() => _TalkPasteWidgetState();
}

class _TalkPasteWidgetState extends State<TalkPasteWidget> with WindowListener, SingleTickerProviderStateMixin {
  Size? _windowSize; // Current size of the window, nullable until initialized
  Size? _initialWindowSize; // Store the original window size, nullable until initialized
  late Size _screenSize = const Size(1920, 1080); // Default initial screen size
  bool _isHovered = false;
  bool _isInitialPositionSet = false; // Flag to set initial position only once
  bool _isDragging = false; // New flag to indicate if dragging is active

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _initWindow(); // Initial window setup
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  Future<void> _initWindow() async {
    await windowManager.ensureInitialized();

    try {
      _screenSize = await screenRetriever.getPrimaryDisplay().then((display) => display.size); // Get actual screen size

      final currentWindowPosition = await windowManager.getPosition();
      if (!_isInitialPositionSet && currentWindowPosition == Offset.zero) {
        _windowSize = await windowManager.getSize();
        _initialWindowSize = _windowSize; // Store the actual initial size only once
        const double padding = 20.0;
        await windowManager.setPosition(Offset(
          _screenSize.width - _windowSize!.width - padding,
          _screenSize.height - _windowSize!.height - padding,
        ));
        _isInitialPositionSet = true;
      } else {
        _windowSize = await windowManager.getSize(); // Always update current window size
      }
    } catch (e) {
      debugPrint('Error getting window/screen size: $e');
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SpeechRecognitionService, SettingsService>(
      builder: (context, speechService, settingsService, child) {
        bool isListening = speechService.isListening;
        bool hideWidget = settingsService.settings.hideWidget;

        if (_windowSize == null) {
          return const SizedBox.shrink();
        }

        return Visibility(
          visible: !hideWidget,
          child: MouseRegion(
            onEnter: (event) {
              setState(() {
                _isHovered = true;
              });
            },
            onExit: (event) {
              setState(() {
                _isHovered = false;
              });
            },
            cursor: isListening ? SystemMouseCursors.basic : (_isDragging ? SystemMouseCursors.grabbing : SystemMouseCursors.grab),
            child: GestureDetector(
              onPanStart: (details) async {
                if (isListening) return;
                setState(() { _isDragging = true; });
                await windowManager.startDragging();
              },
              onPanEnd: (details) {
                if (isListening) return;
                setState(() { _isDragging = false; });
              },
              child: Container(
                width: _windowSize!.width,
                height: _windowSize!.height,
                decoration: BoxDecoration(
                  color: isListening ? Colors.deepPurple.shade700 : (_isHovered ? Colors.grey.shade800 : Colors.grey.shade700),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: isListening
                    ? Stack(
                        alignment: Alignment.center,
                        children: [
                          EqualizerAnimationWidget(size: _windowSize!.height * 0.7),
                        ],
                      )
                    : Center(
                        child: Icon(
                          _isHovered ? Icons.touch_app : Icons.mic,
                          size: _windowSize!.height * 0.5,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void onWindowFocus() {}

  @override
  void onWindowBlur() {}

  @override
  void onWindowResize() async {
    _windowSize = await windowManager.getSize();
    if (mounted) {
      setState(() {});
    }
  }
}
