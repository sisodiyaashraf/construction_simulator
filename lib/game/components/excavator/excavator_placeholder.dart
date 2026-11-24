import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';

/// Modular geometric placeholder representing the excavator.
///
/// Designed with articulated joint pivots so it can be swapped cleanly
/// with modular components (tracks, cab, boom, stick, bucket) when
/// asset exports from the processor are ready.
class ExcavatorPlaceholder extends PositionComponent {
  ExcavatorPlaceholder({
    Vector2? position,
  }) : super(
          position: position ??
              Vector2(
                GameConstants.defaultExcavatorX,
                GameConstants.defaultExcavatorY,
              ),
          size: Vector2(300, 160),
          anchor: Anchor.bottomCenter,
        );

  // Future animation / articulation angles (radians)
  double cabinRotation = 0.0;
  double boomAngle = -0.6;
  double stickAngle = 1.1;
  double bucketAngle = 0.8;

  @override
  void render(Canvas canvas) {
    super.render(canvas);

    // Coordinate system: (0,0) is top-left of component (size: 300 x 160)
    // Bottom edge at Y = 160 touches the ground.

    _renderTracks(canvas);
    _renderCabin(canvas);
    _renderArm(canvas);
    _renderPlaceholderBadge(canvas);
  }

  void _renderTracks(Canvas canvas) {
    const trackWidth = 140.0;
    const trackHeight = 36.0;
    const trackLeft = 30.0;
    final trackTop = size.y - trackHeight;

    // Track outer frame
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight),
      const Radius.circular(14),
    );
    final trackPaint = Paint()..color = const Color(0xFF263238);
    canvas.drawRRect(trackRect, trackPaint);

    // Tread border
    final treadBorder = Paint()
      ..color = const Color(0xFF455A64)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;
    canvas.drawRRect(trackRect, treadBorder);

    // Wheels / Rollers
    final wheelPaint = Paint()..color = const Color(0xFF78909C);
    for (int i = 0; i < 4; i++) {
      final cx = trackLeft + 22 + (i * 32);
      final cy = trackTop + trackHeight / 2;
      canvas.drawCircle(Offset(cx, cy), 10, wheelPaint);
      canvas.drawCircle(
        Offset(cx, cy),
        3,
        Paint()..color = const Color(0xFF263238),
      );
    }
  }

  void _renderCabin(Canvas canvas) {
    const cabLeft = 45.0;
    final cabTop = size.y - 36.0 - 55.0;
    const cabWidth = 110.0;
    const cabHeight = 55.0;

    // Turntable / slew ring
    final ringPaint = Paint()..color = const Color(0xFF37474F);
    canvas.drawRect(
      Rect.fromLTWH(cabLeft + 15, cabTop + cabHeight - 6, cabWidth - 30, 8),
      ringPaint,
    );

    // Main cabin body (construction yellow)
    final cabPaint = Paint()..color = GameConstants.constructionYellow;
    final cabRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(cabLeft, cabTop, cabWidth, cabHeight),
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
        Rect.fromLTWH(cabLeft, cabTop, 30, cabHeight),
        topLeft: const Radius.circular(8),
        bottomLeft: const Radius.circular(4),
      ),
      weightPaint,
    );

    // Operator window
    final windowPaint = Paint()..color = const Color(0xFF80DEEA);
    final windowRect = RRect.fromRectAndCorners(
      Rect.fromLTWH(cabLeft + 65, cabTop + 8, 38, 28),
      topRight: const Radius.circular(10),
    );
    canvas.drawRRect(windowRect, windowPaint);

    // Warning / hazard stripe
    final stripePaint = Paint()
      ..color = Colors.black87
      ..strokeWidth = 3;
    for (double x = cabLeft + 2; x < cabLeft + 28; x += 6) {
      canvas.drawLine(
        Offset(x, cabTop + cabHeight - 12),
        Offset(x + 6, cabTop + cabHeight - 4),
        stripePaint,
      );
    }
  }

  void _renderArm(Canvas canvas) {
    // Boom pivot joint on cabin
    const boomPivotX = 140.0;
    final boomPivotY = size.y - 65.0;

    final jointPaint = Paint()..color = const Color(0xFFD32F2F);
    final armPaint = Paint()
      ..color = GameConstants.constructionYellow
      ..strokeWidth = 10
      ..strokeCap = StrokeCap.round;
    final armBorderPaint = Paint()
      ..color = const Color(0xFF263238)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    // Boom
    const boomLength = 70.0;
    const boomAngle = -0.55; // Angle upwards-right
    final stickPivotX = boomPivotX + boomLength * 0.85;
    final stickPivotY = boomPivotY + boomLength * boomAngle;

    canvas.drawLine(
      Offset(boomPivotX, boomPivotY),
      Offset(stickPivotX, stickPivotY),
      armBorderPaint,
    );
    canvas.drawLine(
      Offset(boomPivotX, boomPivotY),
      Offset(stickPivotX, stickPivotY),
      armPaint,
    );
    canvas.drawCircle(Offset(boomPivotX, boomPivotY), 6, jointPaint);

    // Stick / Arm
    const stickLength = 65.0;
    final bucketPivotX = stickPivotX + stickLength * 0.7;
    final bucketPivotY = stickPivotY + stickLength * 0.75;

    canvas.drawLine(
      Offset(stickPivotX, stickPivotY),
      Offset(bucketPivotX, bucketPivotY),
      armBorderPaint,
    );
    canvas.drawLine(
      Offset(stickPivotX, stickPivotY),
      Offset(bucketPivotX, bucketPivotY),
      armPaint,
    );
    canvas.drawCircle(Offset(stickPivotX, stickPivotY), 5, jointPaint);

    // Bucket
    final bucketPaint = Paint()..color = const Color(0xFF37474F);
    final bucketPath = Path()
      ..moveTo(bucketPivotX, bucketPivotY)
      ..lineTo(bucketPivotX + 22, bucketPivotY + 14)
      ..lineTo(bucketPivotX + 16, bucketPivotY + 28)
      ..lineTo(bucketPivotX - 6, bucketPivotY + 22)
      ..close();
    canvas.drawPath(bucketPath, bucketPaint);
    canvas.drawCircle(Offset(bucketPivotX, bucketPivotY), 4, jointPaint);
  }

  void _renderPlaceholderBadge(Canvas canvas) {
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'EXCAVATOR [TEMPORARY PLACEHOLDER]',
        style: TextStyle(
          color: Color(0xFFD32F2F),
          fontSize: 11,
          fontWeight: FontWeight.bold,
          backgroundColor: Color(0xDDFFFFFF),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(
      canvas,
      Offset(15, 0),
    );
  }
}
