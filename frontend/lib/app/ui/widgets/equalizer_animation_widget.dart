import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/app/services/speech_recognition_service.dart';

class EqualizerAnimationWidget extends StatefulWidget {
  final double size;

  const EqualizerAnimationWidget({super.key, this.size = 100});

  @override
  State<EqualizerAnimationWidget> createState() => _EqualizerAnimationWidgetState();
}

class _EqualizerAnimationWidgetState extends State<EqualizerAnimationWidget> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100), // Быстрая анимация для эквалайзера
    );
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);

    // Listen to speech service for amplitude changes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<SpeechRecognitionService>(context, listen: false)
          .addListener(_handleAmplitudeChange);
    });
  }

  void _handleAmplitudeChange() {
    if (mounted) {
      final speechService = Provider.of<SpeechRecognitionService>(context, listen: false);
      // Normalize amplitude (speech_to_text provides -Infinity to 0.0, we want 0.0 to 1.0)
      // A simple mapping: -50.0 dB to 0.0 dB maps to 0.0 to 1.0 scale
      double normalizedAmplitude = (speechService.currentAmplitude.clamp(-50.0, 0.0) / -50.0).abs();
      
      // Animate based on normalized amplitude
      _animationController.animateTo(normalizedAmplitude, duration: const Duration(milliseconds: 50));
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    Provider.of<SpeechRecognitionService>(context, listen: false)
        .removeListener(_handleAmplitudeChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: EqualizerPainter(
            animationValue: _animation.value,
            isListening: Provider.of<SpeechRecognitionService>(context).isListening,
          ),
        );
      },
    );
  }
}

class EqualizerPainter extends CustomPainter {
  final double animationValue; // Normalized amplitude from 0.0 to 1.0
  final bool isListening;

  EqualizerPainter({required this.animationValue, required this.isListening});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white // Цвет точек
      ..style = PaintingStyle.fill;

    const double dotRadius = 4.0;
    const int numberOfDots = 5; // Количество точек в эквалайзере
    final double spacing = (size.width - (numberOfDots * dotRadius * 2)) / (numberOfDots - 1);

    for (int i = 0; i < numberOfDots; i++) {
      // Calculate base x position for each dot
      double x = (dotRadius * 2 * i) + (spacing * i) + dotRadius;

      // Animate dot height based on amplitude and index
      double animatedHeight = isListening
          ? (size.height / 2) * animationValue * (1 + (sin(i * pi / (numberOfDots - 1)) * 0.5)) // Более выраженная анимация в центре
          : 0.0; // Скрываем, если не слушаем

      canvas.drawCircle(
        Offset(x, size.height / 2 - animatedHeight / 2), // Top part
        dotRadius,
        paint,
      );
      canvas.drawCircle(
        Offset(x, size.height / 2 + animatedHeight / 2), // Bottom part
        dotRadius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant EqualizerPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue || oldDelegate.isListening != isListening;
  }
}
