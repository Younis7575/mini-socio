import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaintButton extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.9674153, size.height * 0.007042254);
    path.lineTo(size.width * 0.9988067, size.height * 0.1316434);
    path.lineTo(size.width * 0.9988067, size.height * 0.9929577);
    path.lineTo(size.width * 0.03976635, size.height * 0.9929577);
    path.lineTo(size.width * 0.001193317, size.height * 0.8277944);
    path.lineTo(size.width * 0.001193317, size.height * 0.007042254);
    path.lineTo(size.width * 0.9674153, size.height * 0.007042254);
    path.close();

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2 // 🔽 thinner than 2px
      ..color = const ui.Color.fromARGB(255, 255, 255, 255)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
