import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaintRectangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.9358930, size.height * 0.005813953);
    path.lineTo(size.width * 0.9969136, size.height * 0.1301818);
    path.lineTo(size.width * 0.9969136, size.height * 0.9941860);
    path.lineTo(size.width * 0.05828436, size.height * 0.9941860);
    path.lineTo(size.width * 0.003086420, size.height * 0.8297093);
    path.lineTo(size.width * 0.003086420, size.height * 0.005813953);
    path.lineTo(size.width * 0.9358930, size.height * 0.005813953);
    path.close();

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.0020 // 🔽 thinner line
      ..color = const ui.Color.fromARGB(255, 255, 254, 254)
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
