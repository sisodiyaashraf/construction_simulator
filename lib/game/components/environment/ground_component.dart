import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

/// Side-view ground and excavation terrain component.
///
/// Supports real imported ground textures with a fallback to procedural soil strata.
class GroundComponent extends PositionComponent {
  GroundComponent({
    this.groundSprite,
  }) : super(
          position: Vector2(
            -GameConstants.logicalWidth / 2,
            GameConstants.groundSurfaceY,
          ),
          size: Vector2(
            GameConstants.logicalWidth,
            GameConstants.groundDepth,
          ),
        );

  final Sprite? groundSprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    final groundRect = Rect.fromLTWH(0, 0, size.x, size.y);

    if (groundSprite != null) {
      groundSprite!.renderRect(canvas, groundRect);

      // Surface line on top of real texture for visual crispness
      final surfaceLine = Paint()
        ..color = const Color(0xFF6D4C41)
        ..strokeWidth = 4.0
        ..style = PaintingStyle.stroke;
      canvas.drawLine(const Offset(0, 0), Offset(size.x, 0), surfaceLine);

      final textPainter = TextPainter(
        text: const TextSpan(
          text: 'REAL ASSET: EXCAVATION TERRAIN [APPROVED BATCH]',
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            backgroundColor: Color(0x99000000),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

      textPainter.paint(
        canvas,
        Offset(size.x / 2 - textPainter.width / 2, 8),
      );
      return;
    }

    // Procedural Fallback Terrain Strata
    final dirtPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF8D6E63),
          Color(0xFF5D4037),
          Color(0xFF3E2723),
        ],
      ).createShader(groundRect);
    canvas.drawRect(groundRect, dirtPaint);

    final surfaceLinePaint = Paint()
      ..color = const Color(0xFF4CAF50)
      ..strokeWidth = 6.0
      ..style = PaintingStyle.stroke;
    canvas.drawLine(const Offset(0, 0), Offset(size.x, 0), surfaceLinePaint);

    final strataPaint = Paint()
      ..color = const Color(0x22FFFFFF)
      ..strokeWidth = 1.5;
    for (double y = 40; y < size.y; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.x, y), strataPaint);
    }
  }
}
