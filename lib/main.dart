// In-Class Activity 06 — Drawing with Flutter
// Student: Brandon Walker
// Date: September 30, 2026

import 'package:flutter/material.dart';
import 'dart:math' show pi;

void main() {
  runApp(const SmileyApp());
}

enum FaceType {
  classic,
  sleepy,
  surprised,
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

class DrawingPlayground extends StatefulWidget {
  const DrawingPlayground({super.key});

  @override
  State<DrawingPlayground> createState() => _DrawingPlaygroundState();
}

class _DrawingPlaygroundState extends State<DrawingPlayground> {
  double mood = 0.8;
  FaceType faceType = FaceType.classic;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CustomPainter Smiley Lab'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: CustomPaint(
                size: const Size(300, 300),
                painter: SmileyPainter(
                  mood: mood,
                  faceType: faceType,
                ),
              ),
            ),
          ),

          Text(
            'Mood: ${mood.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 20),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Slider(
              value: mood,
              min: 0,
              max: 1,
              onChanged: (double value) {
                setState(() {
                  mood = value;
                });
              },
            ),
          ),

          Wrap(
            spacing: 8,
            alignment: WrapAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    faceType = FaceType.classic;
                  });
                },
                child: const Text('Classic'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    faceType = FaceType.sleepy;
                  });
                },
                child: const Text('Sleepy'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    faceType = FaceType.surprised;
                  });
                },
                child: const Text('Surprised'),
              ),
            ],
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class SmileyPainter extends CustomPainter {
  SmileyPainter({
    required this.mood,
    required this.faceType,
  });

  final double mood;
  final FaceType faceType;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius = size.shortestSide * 0.4;

    // Face color based on mood
    Color faceColor;

    if (mood < 0.35) {
      faceColor = Colors.lightBlue;
    } else if (mood <= 0.7) {
      faceColor = Colors.yellow;
    } else {
      faceColor = Colors.orangeAccent;
    }

    final facePaint = Paint()
      ..color = faceColor
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, facePaint);

    // Border
    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    canvas.drawCircle(center, radius, borderPaint);

    final eyePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final eyeLinePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final eyeY = center.dy - radius * 0.25;
    final eyeDistance = radius * 0.35;
    final eyeRadius = radius * 0.10;

    // EYES

    if (faceType == FaceType.sleepy) {
      // Sleepy eyes are lines
      canvas.drawLine(
        Offset(center.dx - eyeDistance - 10, eyeY),
        Offset(center.dx - eyeDistance + 10, eyeY),
        eyeLinePaint,
      );

      canvas.drawLine(
        Offset(center.dx + eyeDistance - 10, eyeY),
        Offset(center.dx + eyeDistance + 10, eyeY),
        eyeLinePaint,
      );
    } else if (faceType == FaceType.surprised) {
      // Surprised eyes are larger
      canvas.drawCircle(
        Offset(center.dx - eyeDistance, eyeY),
        eyeRadius * 1.5,
        eyePaint,
      );

      canvas.drawCircle(
        Offset(center.dx + eyeDistance, eyeY),
        eyeRadius * 1.5,
        eyePaint,
      );
    } else {
      // Classic eyes
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
    }

    // MOUTH

    final mouthPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    if (faceType == FaceType.surprised) {
      // Surprised mouth
      final surprisedMouth = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.30,
        ),
        width: radius * 0.35,
        height: radius * 0.50,
      );

      canvas.drawOval(
        surprisedMouth,
        mouthPaint,
      );
    } else if (faceType == FaceType.sleepy) {
      // Sleepy mouth
      final sleepyMouth = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.20,
        ),
        width: radius * 0.70,
        height: radius * 0.30,
      );

      canvas.drawArc(
        sleepyMouth,
        0.15 * pi,
        0.70 * pi,
        false,
        mouthPaint,
      );
    } else {
      // Classic mouth changes with mood
      final mouthRect = Rect.fromCenter(
        center: Offset(
          center.dx,
          center.dy + radius * 0.20,
        ),
        width: radius,
        height: radius * 0.70,
      );

      if (mood < 0.35) {
        canvas.drawArc(
          mouthRect.translate(0, radius * 0.30),
          1.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      } else if (mood <= 0.7) {
        canvas.drawArc(
          mouthRect,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      } else {
        final bigSmile = Rect.fromCenter(
          center: Offset(
            center.dx,
            center.dy + radius * 0.10,
          ),
          width: radius * 1.20,
          height: radius,
        );

        canvas.drawArc(
          bigSmile,
          0.15 * pi,
          0.70 * pi,
          false,
          mouthPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant SmileyPainter oldDelegate) {
    return oldDelegate.mood != mood ||
        oldDelegate.faceType != faceType;
  }
}