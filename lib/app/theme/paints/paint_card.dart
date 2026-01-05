 
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaintCard extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.8858683, size.height * 0.003157895);
    path.lineTo(size.width * 0.9969136, size.height * 0.08165495);
    path.lineTo(size.width * 0.9969136, size.height * 0.9968421);
    path.lineTo(size.width * 0.08129588, size.height * 0.9968421);
    path.lineTo(size.width * 0.003086420, size.height * 0.9352863);
    path.lineTo(size.width * 0.003086420, size.height * 0.003157895);
    path.lineTo(size.width * 0.8858683, size.height * 0.003157895);
    path.close();

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.0020 // 🔽 thinner stroke
      ..color = const ui.Color.fromARGB(255, 255, 255, 255)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
