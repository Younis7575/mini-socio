 

import 'dart:ui' as ui;
import 'package:flutter/material.dart';

class PaintSquare extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path = Path();
    path.moveTo(size.width * 0.8796194, size.height * 0.003105590);
    path.lineTo(size.width * 0.9888664, size.height * 0.08030248);
    path.lineTo(size.width * 0.9888664, size.height * 0.9803313);
    path.lineTo(size.width * 0.08807652, size.height * 0.9803313);
    path.lineTo(size.width * 0.01113360, size.height * 0.9197950);
    path.lineTo(size.width * 0.01113360, size.height * 0.003105590);
    path.lineTo(size.width * 0.8796194, size.height * 0.003105590);
    path.close();

    Paint paintStroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.0020 // 🔽 thinner stroke
      ..color = Colors.white
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
