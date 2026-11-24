import 'package:construction_simulator/game/components/environment/construction_backdrop.dart';
import 'package:construction_simulator/game/components/environment/ground_component.dart';
import 'package:construction_simulator/game/components/excavator/excavator_component.dart';
import 'package:construction_simulator/game/construction_game.dart';
import 'package:construction_simulator/game/world/construction_world.dart';
import 'package:flame/camera.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConstructionGame and World Stage 12 Integration Tests', () {
    test('Game initializes with world and fixed resolution camera', () async {
      final game = ConstructionGame();
      await game.onLoad();

      expect(game.world, isA<ConstructionWorld>());
      expect(game.camera, isNotNull);
      expect(game.camera.viewport, isA<FixedResolutionViewport>());

      final viewport = game.camera.viewport as FixedResolutionViewport;
      expect(viewport.resolution.x, 1280.0);
      expect(viewport.resolution.y, 720.0);
    });

    test('World initializes backdrop, ground, and assembled excavator with real assets', () async {
      final game = ConstructionGame();
      await game.onLoad();

      final world = game.world;
      await world.onLoad();

      expect(world.backdrop, isA<ConstructionBackdrop>());
      expect(world.ground, isA<GroundComponent>());
      expect(world.excavator, isA<ExcavatorComponent>());

      // Verify excavator has ground contact alignment
      expect(world.excavator.position.y, 120.0);
    });

    test('FPS notifier and config update operate smoothly', () async {
      final game = ConstructionGame();
      await game.onLoad();

      expect(game.fpsNotifier.value, 60.0);
      expect(game.config.showDebugPivots, isFalse);

      game.updateConfig(game.config.copyWith(showDebugPivots: true));
      expect(game.config.showDebugPivots, isTrue);

      // Frame ticks
      game.update(0.1);
      game.onDispose();
    });
  });
}
