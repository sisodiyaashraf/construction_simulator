import 'package:construction_simulator/game/construction_game.dart';
import 'package:construction_simulator/game/world/construction_world.dart';
import 'package:flame/camera.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ConstructionGame initialization tests', () {
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

    test('World loads backdrop, ground, and excavator placeholder', () async {
      final game = ConstructionGame();
      await game.onLoad();

      final world = game.world;
      await world.onLoad();

      expect(world.backdrop, isNotNull);
      expect(world.ground, isNotNull);
      expect(world.excavator, isNotNull);
      expect(world.children.length, greaterThanOrEqualTo(3));
    });

    test('FPS notifier emits reasonable metrics during update', () {
      final game = ConstructionGame();
      expect(game.fpsNotifier.value, 60.0);

      // Simulate 15 frames over 0.25 seconds (60 FPS)
      for (int i = 0; i < 15; i++) {
        game.update(0.25 / 15);
      }

      expect(game.fpsNotifier.value, closeTo(60.0, 1.0));
      game.onDispose();
    });
  });
}
