import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// Configurable pivot points for excavator machinery joints.
///
/// Stores normalized coordinates (0.0 to 1.0) relative to component bounds.
/// Converts normalized coordinates into local pixel coordinates without modifying source files.
class ExcavatorPivotConfig {
  const ExcavatorPivotConfig({
    this.undercarriageCenter = const Point2D(0.5, 1.0),
    this.cabinPivot = const Point2D(0.35, 0.65),
    this.boomBaseJoint = const Point2D(0.52, 0.58),
    this.boomToStickJoint = const Point2D(0.72, 0.32),
    this.stickToBucketJoint = const Point2D(0.88, 0.55),
    this.hydraulicBoomCylinder = const Point2D(0.44, 0.62),
    this.hydraulicStickCylinder = const Point2D(0.62, 0.42),
    this.showDebugPivots = false,
  });

  /// Normalized pivot of undercarriage contact on ground (center-bottom).
  final Point2D undercarriageCenter;

  /// Normalized slew pivot where cabin rotates on undercarriage.
  final Point2D cabinPivot;

  /// Normalized joint where main boom attaches to machine superstructure.
  final Point2D boomBaseJoint;

  /// Normalized articulated joint connecting boom and stick (arm).
  final Point2D boomToStickJoint;

  /// Normalized wrist joint connecting stick and bucket.
  final Point2D stickToBucketJoint;

  /// Hydraulic cylinder connection point for boom lifting.
  final Point2D hydraulicBoomCylinder;

  /// Hydraulic cylinder connection point for stick curling.
  final Point2D hydraulicStickCylinder;

  /// Whether to render visual crosshair markers at joint pivots.
  final bool showDebugPivots;

  /// Converts a normalized pivot point into component-local pixel coordinates.
  Vector2 toLocalPixel(Point2D normalized, Vector2 size) {
    return Vector2(
      normalized.x * size.x,
      normalized.y * size.y,
    );
  }

  /// Copies config with optional overrides.
  ExcavatorPivotConfig copyWith({
    Point2D? undercarriageCenter,
    Point2D? cabinPivot,
    Point2D? boomBaseJoint,
    Point2D? boomToStickJoint,
    Point2D? stickToBucketJoint,
    Point2D? hydraulicBoomCylinder,
    Point2D? hydraulicStickCylinder,
    bool? showDebugPivots,
  }) {
    return ExcavatorPivotConfig(
      undercarriageCenter: undercarriageCenter ?? this.undercarriageCenter,
      cabinPivot: cabinPivot ?? this.cabinPivot,
      boomBaseJoint: boomBaseJoint ?? this.boomBaseJoint,
      boomToStickJoint: boomToStickJoint ?? this.boomToStickJoint,
      stickToBucketJoint: stickToBucketJoint ?? this.stickToBucketJoint,
      hydraulicBoomCylinder:
          hydraulicBoomCylinder ?? this.hydraulicBoomCylinder,
      hydraulicStickCylinder:
          hydraulicStickCylinder ?? this.hydraulicStickCylinder,
      showDebugPivots: showDebugPivots ?? this.showDebugPivots,
    );
  }

  /// Renders a debug pivot marker on canvas.
  static void drawPivotMarker(Canvas canvas, Vector2 position, String label, {Color color = Colors.redAccent}) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    // Crosshair
    canvas.drawLine(Offset(position.x - 6, position.y), Offset(position.x + 6, position.y), paint);
    canvas.drawLine(Offset(position.x, position.y - 6), Offset(position.x, position.y + 6), paint);
    canvas.drawCircle(Offset(position.x, position.y), 4, paint);

    // Label
    final textPainter = TextPainter(
      text: TextSpan(
        text: label,
        style: TextStyle(
          color: color,
          fontSize: 9,
          fontWeight: FontWeight.bold,
          backgroundColor: const Color(0xCC000000),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    textPainter.paint(canvas, Offset(position.x + 8, position.y - 6));
  }
}

/// Simple 2D point structure for normalized coordinates.
class Point2D {
  const Point2D(this.x, this.y);
  final double x;
  final double y;
}
