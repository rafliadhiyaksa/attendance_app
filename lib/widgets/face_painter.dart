import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';

class FacePainter extends CustomPainter {
  Size imageSize;
  Face? face;
  double? scaleX, scaleY;

  FacePainter({required this.imageSize, required this.face});

  @override
  void paint(Canvas canvas, Size size) {
    if (face == null) return;

    Paint paint;
    if (face!.headEulerAngleY! > 10 ||
        face!.headEulerAngleY! < -10 ||
        face!.headEulerAngleZ! < -10 ||
        face!.headEulerAngleZ! > 10) {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.red;
    } else {
      paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..color = Colors.green;
    }
    scaleX = size.width / imageSize.width;
    scaleY = size.height / imageSize.height;

    canvas.drawRRect(
      _scaleRect(
        rect: face!.boundingBox,
        imageSize: imageSize,
        widgetSize: size,
        scaleX: scaleX,
        scaleY: scaleY,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(FacePainter oldDelegate) {
    return oldDelegate.face != face;
  }
}

RRect _scaleRect({
  required Rect rect,
  required Size imageSize,
  required Size widgetSize,
  double? scaleX,
  double? scaleY,
}) {
  return RRect.fromLTRBR(
    widgetSize.width - rect.left.toDouble() * scaleX!,
    rect.top.toDouble() * scaleY!,
    widgetSize.width - rect.right.toDouble() * scaleX,
    rect.bottom.toDouble() * scaleY,
    const Radius.circular(20),
  );
}
