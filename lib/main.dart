// In-Class Activity 06 — Drawing with Flutter
// Student: Brandon Walker
// Date: September 30, 2026

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(const SmileyApp());
}

class SmileyApp extends StatelessWidget {
  const SmileyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smiley Painter',
      theme: ThemeData(
        colorSchemeSeed: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DrawingPlayground(),
    );
  }
}

class DrawingPlayground extends StatelessWidget {
  const DrawingPlayground({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),
      body: Center(
        child: CustomPaint(
          size: const Size(300, 300),
          painter: SmileyPainter(),
        ),
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.4;

    // Face
    final facePaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      radius,
      facePaint,
    );

    // Border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(
      center,
      radius,
      borderPaint,
    );

    // Eyes
    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final eyeY = center.dy - radius * 0.25;
    final eyeDistance = radius * 0.35;
    final eyeRadius = radius * 0.10;

    canvas.drawCircle(
      Offset(center.dx - eyeDistance, eyeY),
      eyeRadius,
      eyePaint,
    );

    canvas.drawCircle(
      Offset(center.dx + eyeDistance, eyeY),
      eyeRadius,
      eyePaint,
    );

    // Smile
    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final mouthRect = Rect.fromCenter(
      center: Offset(
        center.dx,
        center.dy + radius * 0.20,
      ),
      width: radius,
      height: radius * 0.7,
    );

    canvas.drawArc(
      mouthRect,
      0.15 * pi,
      0.70 * pi,
      false,
      mouthPaint,
    );
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return false;
  }
}