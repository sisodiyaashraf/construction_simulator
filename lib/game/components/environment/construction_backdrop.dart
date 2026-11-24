import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

/// Temporary side-view backdrop component representing a construction site.
///
/// Draws a sky gradient, distant landscape, and crane silhouettes as placeholders
/// until final graphical assets from the processor pipeline are integrated.
class ConstructionBackdrop extends PositionComponent {
  ConstructionBackdrop()
      : super(
          position: Vector2(
            -GameConstants.logicalWidth / 2,
            -GameConstants.logicalHeight / 2,
          ),
          size: Vector2(
            GameConstants.logicalWidth,
            GameConstants.logicalHeight / 2 + GameConstants.groundSurfaceY,
          ),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final rect = Rect.fromLTWH(0, 0, size.x, size.y);

    // Sky gradient
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF64B5F6), // Top sky
          Color(0xFFBBDEFB), // Mid sky
          Color(0xFFFFECB3), // Horizon haze
        ],
      ).createShader(rect);
    canvas.drawRect(rect, skyPaint);

    // Distant sun
    final sunPaint = Paint()..color = const Color(0xFFFFF9C4).withAlpha(180);
    canvas.drawCircle(Offset(size.x * 0.8, size.y * 0.25), 45, sunPaint);

    // Distant mountains/hills silhouette
    final hillPaint = Paint()..color = const Color(0xFF90A4AE).withAlpha(140);
    final hillPath = Path()
      ..moveTo(0, size.y)
      ..lineTo(0, size.y * 0.75)
      ..quadraticBezierTo(size.x * 0.25, size.y * 0.55, size.x * 0.5, size.y * 0.72)
      ..quadraticBezierTo(size.x * 0.75, size.y * 0.85, size.x, size.y * 0.68)
      ..lineTo(size.x, size.y)
      ..close();
    canvas.drawPath(hillPath, hillPaint);

    // Distant crane silhouette placeholder
    final cranePaint = Paint()
      ..color = const Color(0xFF546E7A).withAlpha(120)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final craneX = size.x * 0.2;
    final craneBaseY = size.y * 0.85;
    final craneTopY = size.y * 0.2;

    // Tower
    canvas.drawLine(Offset(craneX, craneBaseY), Offset(craneX, craneTopY), cranePaint);
    canvas.drawLine(Offset(craneX + 14, craneBaseY), Offset(craneX + 14, craneTopY), cranePaint);
    // Jib
    canvas.drawLine(Offset(craneX - 35, craneTopY + 10), Offset(craneX + 120, craneTopY + 10), cranePaint);
    // Mast apex
    canvas.drawLine(Offset(craneX, craneTopY), Offset(craneX + 7, craneTopY - 20), cranePaint);
    canvas.drawLine(Offset(craneX + 14, craneTopY), Offset(craneX + 7, craneTopY - 20), cranePaint);

    // Watermark placeholder text
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'CONSTRUCTION SITE [PLACEHOLDER BACKDROP]',
        style: TextStyle(
          color: Color(0x33000000),
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 2.0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(size.x / 2 - textPainter.width / 2, size.y * 0.1),
    );
  }
}
