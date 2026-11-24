import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

/// Undercarriage and crawler tracks component for excavator.
class ExcavatorUndercarriage extends PositionComponent {
  ExcavatorUndercarriage({
    super.position,
    Vector2? size,
    this.sprite,
  }) : super(
          size: size ?? Vector2(160, 40),
          anchor: Anchor.bottomCenter,
          priority: 1,
        );

  final Sprite? sprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite != null) {
      sprite!.render(canvas, size: size);
      return;
    }

    // Modular fallback track rendering
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(12),
    );
    final trackPaint = Paint()..color = const Color(0xFF263238);
    canvas.drawRRect(trackRect, trackPaint);

    final borderPaint = Paint()
      ..color = const Color(0xFF455A64)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(trackRect, borderPaint);

    // Rollers / Wheels
    final wheelPaint = Paint()..color = const Color(0xFF78909C);
    final count = 4;
    final spacing = (size.x - 40) / (count - 1);
    for (int i = 0; i < count; i++) {
      final cx = 20 + i * spacing;
      final cy = size.y / 2;
      canvas.drawCircle(Offset(cx, cy), 11, wheelPaint);
      canvas.drawCircle(Offset(cx, cy), 4, Paint()..color = const Color(0xFF263238));
    }
  }
}

/// Rotating chassis and turntable slew ring component.
class ExcavatorChassis extends PositionComponent {
  ExcavatorChassis({
    super.position,
    Vector2? size,
  }) : super(
          size: size ?? Vector2(120, 14),
          anchor: Anchor.bottomCenter,
          priority: 2,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final paint = Paint()..color = const Color(0xFF37474F);
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.x, size.y),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, paint);
  }
}

/// Operator cabin and engine superstructure component.
class ExcavatorCabin extends PositionComponent {
  ExcavatorCabin({
    super.position,
    Vector2? size,
    this.sprite,
  }) : super(
          size: size ?? Vector2(120, 60),
          anchor: Anchor.bottomCenter,
          priority: 3,
        );

  final Sprite? sprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite != null) {
      sprite!.render(canvas, size: size);
      return;
    }

    // Main cab
    final cabPaint = Paint()..color = GameConstants.constructionYellow;
    final cabRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(0, 0, size.x, size.y),
      topLeft: const Radius.circular(8),
      topRight: const Radius.circular(16),
      bottomLeft: const Radius.circular(4),
      bottomRight: const Radius.circular(4),
    );
    canvas.drawRRect(cabRect, cabPaint);

    // Rear counterweight
    final weightPaint = Paint()..color = const Color(0xFF37474F);
    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0, 0, 32, size.y),
        topLeft: const Radius.circular(8),
        bottomLeft: const Radius.circular(4),
      ),
      weightPaint,
    );

    // Glass window
    final windowPaint = Paint()..color = const Color(0xFF80DEEA);
    final windowRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(size.x - 45, 8, 38, 30),
      topRight: const Radius.circular(10),
    );
    canvas.drawRRect(windowRect, windowPaint);
  }
}

/// Articulated main boom component.
class ExcavatorBoom extends PositionComponent {
  ExcavatorBoom({
    super.position,
    Vector2? size,
    this.sprite,
  }) : super(
          size: size ?? Vector2(90, 18),
          anchor: Anchor.centerLeft,
          priority: 4,
        );

  final Sprite? sprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite != null) {
      sprite!.render(canvas, size: size);
      return;
    }

    final paint = Paint()
      ..color = GameConstants.constructionYellow
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    final border = Paint()
      ..color = const Color(0xFF263238)
      ..strokeWidth = 16
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(6, size.y / 2), Offset(size.x - 6, size.y / 2), border);
    canvas.drawLine(Offset(6, size.y / 2), Offset(size.x - 6, size.y / 2), paint);
  }
}

/// Hydraulic cylinder component for arm actuation.
class ExcavatorHydraulicCylinder extends PositionComponent {
  ExcavatorHydraulicCylinder({
    super.position,
    Vector2? size,
  }) : super(
          size: size ?? Vector2(50, 10),
          anchor: Anchor.centerLeft,
          priority: 5,
        );

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Cylinder barrel
    final barrelPaint = Paint()..color = const Color(0xFF37474F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(0, 1, size.x * 0.6, size.y - 2), const Radius.circular(2)),
      barrelPaint,
    );

    // Chrome rod
    final rodPaint = Paint()..color = const Color(0xFFECEFF1);
    canvas.drawRect(
      Rect.fromLTWH(size.x * 0.6, 2.5, size.x * 0.38, size.y - 5),
      rodPaint,
    );
  }
}

/// Articulated forearm / stick component.
class ExcavatorStick extends PositionComponent {
  ExcavatorStick({
    super.position,
    Vector2? size,
    this.sprite,
  }) : super(
          size: size ?? Vector2(75, 14),
          anchor: Anchor.centerLeft,
          priority: 6,
        );

  final Sprite? sprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite != null) {
      sprite!.render(canvas, size: size);
      return;
    }

    final paint = Paint()
      ..color = GameConstants.constructionYellow
      ..strokeWidth = 11
      ..strokeCap = StrokeCap.round;
    final border = Paint()
      ..color = const Color(0xFF263238)
      ..strokeWidth = 13
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(5, size.y / 2), Offset(size.x - 5, size.y / 2), border);
    canvas.drawLine(Offset(5, size.y / 2), Offset(size.x - 5, size.y / 2), paint);
  }
}

/// Excavator digging bucket component.
class ExcavatorBucket extends PositionComponent {
  ExcavatorBucket({
    super.position,
    Vector2? size,
    this.sprite,
  }) : super(
          size: size ?? Vector2(36, 32),
          anchor: Anchor.topLeft,
          priority: 7,
        );

  final Sprite? sprite;

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    if (sprite != null) {
      sprite!.render(canvas, size: size);
      return;
    }

    final bucketPaint = Paint()..color = const Color(0xFF37474F);
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.x, size.y * 0.4)
      ..lineTo(size.x * 0.7, size.y)
      ..lineTo(-size.x * 0.2, size.y * 0.8)
      ..close();
    canvas.drawPath(path, bucketPaint);
  }
}
