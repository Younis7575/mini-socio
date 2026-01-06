import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaintSquare extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9357325, size.height * 0.0008880995);
    path_0.lineTo(size.width * 0.9987500, size.height * 0.04566075);
    path_0.lineTo(size.width * 0.9987500, size.height * 0.9991119);
    path_0.lineTo(size.width * 0.06301750, size.height * 0.9991119);
    path_0.lineTo(size.width * 0.001250000, size.height * 0.9552274);
    path_0.lineTo(size.width * 0.001250000, size.height * 0.0008880995);
    path_0.lineTo(size.width * 0.9357325, size.height * 0.0008880995);
    path_0.close();
 
    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5 // 👈 decreased thickness
      ..isAntiAlias = true
      ..color = Colors.white;

    canvas.drawPath(path_0, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
