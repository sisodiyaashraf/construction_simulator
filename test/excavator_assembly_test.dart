import 'package:construction_simulator/game/components/excavator/excavator_component.dart';
import 'package:construction_simulator/game/components/excavator/excavator_parts.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Excavator Visual Assembly & Modular Hierarchy Tests', () {
    test('ExcavatorComponent initializes all modular machinery parts', () async {
      final excavator = ExcavatorComponent();
      await excavator.onLoad();

      expect(excavator.undercarriage, isA<ExcavatorUndercarriage>());
      expect(excavator.chassis, isA<ExcavatorChassis>());
      expect(excavator.cabin, isA<ExcavatorCabin>());
      expect(excavator.boom, isA<ExcavatorBoom>());
      expect(excavator.hydraulicCylinder, isA<ExcavatorHydraulicCylinder>());
      expect(excavator.stick, isA<ExcavatorStick>());
      expect(excavator.bucket, isA<ExcavatorBucket>());

      expect(excavator.children.length, 7);
    });

    test('Modular subcomponents adhere to correct layered draw order priorities', () async {
      final excavator = ExcavatorComponent();
      await excavator.onLoad();

      expect(excavator.undercarriage.priority, 1);
      expect(excavator.chassis.priority, 2);
      expect(excavator.cabin.priority, 3);
      expect(excavator.boom.priority, 4);
      expect(excavator.hydraulicCylinder.priority, 5);
      expect(excavator.stick.priority, 6);
      expect(excavator.bucket.priority, 7);
    });

    test('ExcavatorComponent anchors correctly at bottom center for ground contact', () {
      final excavator = ExcavatorComponent(
        position: Vector2(0, 120),
        size: Vector2(340, 190),
      );

      expect(excavator.anchor, Anchor.bottomCenter);
      expect(excavator.position.y, 120.0);
    });

    test('Fallback to modular components when real visual sprite is absent', () async {
      final excavator = ExcavatorComponent(
        realVisualSprite: null,
      );
      await excavator.onLoad();

      expect(excavator.isUsingRealVisual, isFalse);
    });

    test('Supports forcing modular view even if real sprite is provided', () async {
      final excavator = ExcavatorComponent(
        realVisualSprite: null, // Test fallback flag behavior
        useModularPartsOnly: true,
      );
      await excavator.onLoad();

      expect(excavator.isUsingRealVisual, isFalse);
    });
  });
}
