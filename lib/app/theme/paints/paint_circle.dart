import 'dart:ui' as ui;

import 'package:flutter/material.dart';

 
//Copy this CustomPainter code to the Bottom of the File
class PaintCircle extends CustomPainter {
    @override
    void paint(Canvas canvas, Size size) {
            
Path path_0 = Path();
    path_0.moveTo(size.width*0.8171383,size.height*0.003440367);
    path_0.lineTo(size.width*0.9959920,size.height*0.2752317);
    path_0.lineTo(size.width*0.9959920,size.height*0.7531674);
    path_0.lineTo(size.width*0.8173186,size.height*0.9587913);
    path_0.lineTo(size.width*0.2275772,size.height*0.9964817);
    path_0.lineTo(size.width*0.003006012,size.height*0.7531055);
    path_0.lineTo(size.width*0.003006012,size.height*0.2754495);
    path_0.lineTo(size.width*0.2277475,size.height*0.003440367);
    path_0.lineTo(size.width*0.8171383,size.height*0.003440367);
    path_0.close();

Paint paint_0_stroke = Paint()..style=PaintingStyle.stroke..strokeWidth=size.width*0.006012024;
paint_0_stroke.color=ui.Color.fromARGB(255, 255, 255, 255).withOpacity(1.0);
canvas.drawPath(path_0,paint_0_stroke);

 

}

@override
bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
}
}