import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaintRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9357400, size.height * 0.002500000);
    path_0.lineTo(size.width * 0.9987500, size.height * 0.1260500);
    path_0.lineTo(size.width * 0.9987500, size.height * 0.9975000);
    path_0.lineTo(size.width * 0.06426025, size.height * 0.9975000);
    path_0.lineTo(size.width * 0.001250000, size.height * 0.8739450);
    path_0.lineTo(size.width * 0.001250000, size.height * 0.002500000);
    path_0.lineTo(size.width * 0.9357400, size.height * 0.002500000);
    path_0.close();

    // 🔹 Thin Stroke
    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 // 👈 reduced thickness
      ..isAntiAlias = true
      ..color = Colors.white;

    canvas.drawPath(path_0, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
