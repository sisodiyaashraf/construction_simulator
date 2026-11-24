import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

/// Side-view ground and excavation terrain component.
///
/// Provides a visible ground surface and subsurface strata for excavating
/// and vehicle movement.
class GroundComponent extends PositionComponent {
  GroundComponent()
      : super(
          position: Vector2(
            -GameConstants.logicalWidth / 2,
            GameConstants.groundSurfaceY,
          ),
          size: Vector2(
            GameConstants.logicalWidth,
            GameConstants.groundDepth,
          ),
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final groundRect = Rect.fromLTWH(0, 0, size.x, size.y);

    // Deep soil gradient
    final dirtPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF8D6E63), // Surface topsoil
          Color(0xFF5D4037), // Dense dirt
          Color(0xFF3E2723), // Bedrock / deep rock
        ],
      ).createShader(groundRect);
    canvas.drawRect(groundRect, dirtPaint);

    // Top surface line
    final surfaceLinePaint = Paint()
      ..color = const Color(0xFF4CAF50) // Grass/top edge
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.x, 0), surfaceLinePaint);

    // Subtle strata / soil texture markings
    final strataPaint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 1.5;
    for (double y = 40; y < size.y; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), strataPaint);
    }

    // Label on ground cross-section
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'GROUND SURFACE [TERRAIN STRATA PLACEHOLDER]',
        style: TextStyle(
          color: Color(0x88FFFFFF),
          fontSize: 14,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(size.x / 2 - textPainter.width / 2, 20),
    );
  }
}
