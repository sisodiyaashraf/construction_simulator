import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/game_constants.dart';
import 'excavator_parts.dart';
import 'excavator_pivot_config.dart';

/// Main visual excavator assembly component.
///
/// Supports modular subcomponents (undercarriage, cabin, boom, stick, bucket)
/// and displays real vehicle illustration sprites when available from the asset pipeline.
class ExcavatorComponent extends PositionComponent {
  ExcavatorComponent({
    super.position,
    Vector2? size,
    this.realVisualSprite,
    this.pivotConfig = const ExcavatorPivotConfig(),
    this.useModularPartsOnly = false,
  }) : super(
          size: size ?? Vector2(340, 190),
          anchor: Anchor.bottomCenter,
        );

  /// Optional real vehicle illustration sprite imported from the asset processor.
  final Sprite? realVisualSprite;

  /// Kinematic pivot configuration for joint markers and articulation.
  final ExcavatorPivotConfig pivotConfig;

  /// Whether to force rendering modular parts instead of the full vehicle illustration.
  final bool useModularPartsOnly;

  late final ExcavatorUndercarriage undercarriage;
  late final ExcavatorChassis chassis;
  late final ExcavatorCabin cabin;
  late final ExcavatorBoom boom;
  late final ExcavatorHydraulicCylinder hydraulicCylinder;
  late final ExcavatorStick stick;
  late final ExcavatorBucket bucket;

  bool get isUsingRealVisual => realVisualSprite != null && !useModularPartsOnly;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Undercarriage at bottom center
    undercarriage = ExcavatorUndercarriage(
      position: Vector2(size.x * 0.35, size.y),
      size: Vector2(170, 42),
    );
    await add(undercarriage);

    // 2. Chassis turntable
    chassis = ExcavatorChassis(
      position: Vector2(size.x * 0.35, size.y - 40),
      size: Vector2(130, 14),
    );
    await add(chassis);

    // 3. Superstructure & Cabin
    cabin = ExcavatorCabin(
      position: Vector2(size.x * 0.35, size.y - 52),
      size: Vector2(130, 68),
    );
    await add(cabin);

    // 4. Main Boom
    boom = ExcavatorBoom(
      position: Vector2(size.x * 0.44, size.y - 85),
      size: Vector2(95, 20),
    )..angle = -0.65;
    await add(boom);

    // 5. Hydraulic Boom Cylinder
    hydraulicCylinder = ExcavatorHydraulicCylinder(
      position: Vector2(size.x * 0.38, size.y - 65),
      size: Vector2(55, 11),
    )..angle = -0.78;
    await add(hydraulicCylinder);

    // 6. Articulated Stick
    stick = ExcavatorStick(
      position: Vector2(size.x * 0.58, size.y - 142),
      size: Vector2(85, 16),
    )..angle = 1.05;
    await add(stick);

    // 7. Bucket
    bucket = ExcavatorBucket(
      position: Vector2(size.x * 0.70, size.y - 75),
      size: Vector2(40, 35),
    )..angle = 0.55;
    await add(bucket);
  }

  @override
  void render(Canvas canvas) {
    if (isUsingRealVisual) {
      _renderRealVehicleSprite(canvas);
    } else {
      super.render(canvas);
    }

    if (pivotConfig.showDebugPivots) {
      _renderDebugPivots(canvas);
    }
  }

  void _renderRealVehicleSprite(Canvas canvas) {
    // Preserve proportional aspect ratio of the imported illustration
    final spriteSize = realVisualSprite!.srcSize;
    final aspect = spriteSize.x / spriteSize.y;

    final targetHeight = size.y;
    final targetWidth = targetHeight * aspect;

    // Draw sprite aligned to bottom center
    final destRect = Rect.fromLTWH(
      (size.x - targetWidth) / 2,
      size.y - targetHeight,
      targetWidth,
      targetHeight,
    );

    realVisualSprite!.renderRect(canvas, destRect);

    // Render clear notice badge stating this is a temporary complete vehicle illustration
    final badgePainter = TextPainter(
      text: const TextSpan(
        text: 'REAL ASSET: EXCAVATOR [TEMPORARY COMPLETE VISUAL]',
        style: TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.bold,
          backgroundColor: Color(0xDD00796B),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    badgePainter.paint(
      canvas,
      Offset((size.x - badgePainter.width) / 2, 4),
    );
  }

  void _renderDebugPivots(Canvas canvas) {
    final undercarriagePos = pivotConfig.toLocalPixel(pivotConfig.undercarriageCenter, size);
    final cabinPos = pivotConfig.toLocalPixel(pivotConfig.cabinPivot, size);
    final boomBasePos = pivotConfig.toLocalPixel(pivotConfig.boomBaseJoint, size);
    final boomStickPos = pivotConfig.toLocalPixel(pivotConfig.boomToStickJoint, size);
    final stickBucketPos = pivotConfig.toLocalPixel(pivotConfig.stickToBucketJoint, size);
    final hydBoomPos = pivotConfig.toLocalPixel(pivotConfig.hydraulicBoomCylinder, size);
    final hydStickPos = pivotConfig.toLocalPixel(pivotConfig.hydraulicStickCylinder, size);

    ExcavatorPivotConfig.drawPivotMarker(canvas, undercarriagePos, 'Undercarriage Ground Contact', color: Colors.greenAccent);
    ExcavatorPivotConfig.drawPivotMarker(canvas, cabinPos, 'Cabin Slew Pivot', color: Colors.blueAccent);
    ExcavatorPivotConfig.drawPivotMarker(canvas, boomBasePos, 'Boom Base Joint', color: Colors.amberAccent);
    ExcavatorPivotConfig.drawPivotMarker(canvas, boomStickPos, 'Boom-Stick Joint', color: Colors.orangeAccent);
    ExcavatorPivotConfig.drawPivotMarker(canvas, stickBucketPos, 'Stick-Bucket Joint', color: Colors.redAccent);
    ExcavatorPivotConfig.drawPivotMarker(canvas, hydBoomPos, 'Hydraulic Boom Mount', color: Colors.purpleAccent);
    ExcavatorPivotConfig.drawPivotMarker(canvas, hydStickPos, 'Hydraulic Stick Mount', color: Colors.cyanAccent);
  }
}
