// lib/features/avatar_studio/renderer/dummy_2d_overlay.dart
import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class Dummy2DOverlay extends CustomPainter {
  final Map<String, Offset> landmarks;

  Dummy2DOverlay({required this.landmarks});

  @override
  void paint(Canvas canvas, Size size) {
    if (landmarks.isEmpty) return;

    // The brush for our dummy 2D asset
    final neonPaint = Paint()
      ..color = AppTheme.cyberCyan
      ..style = PaintingStyle.fill;

    final glowPaint = Paint()
      ..color = AppTheme.electricMagenta.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;

    // 1. Draw a dummy asset on the NOSE
    if (landmarks.containsKey('nose')) {
      canvas.drawCircle(landmarks['nose']!, 12, neonPaint);
      canvas.drawCircle(landmarks['nose']!, 20, glowPaint);
    }

    // 2. Draw dummy assets on the EYES
    if (landmarks.containsKey('left_eye')) {
      canvas.drawCircle(landmarks['left_eye']!, 10, neonPaint);
    }
    if (landmarks.containsKey('right_eye')) {
      canvas.drawCircle(landmarks['right_eye']!, 10, neonPaint);
    }
  }

  @override
  bool shouldRepaint(covariant Dummy2DOverlay oldDelegate) => true;
}