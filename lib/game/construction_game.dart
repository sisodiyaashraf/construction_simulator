import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../core/config/game_config.dart';
import '../core/constants/game_constants.dart';
import 'camera/game_camera.dart';
import 'world/construction_world.dart';

/// Main game engine controller for Construction Simulator.
///
/// Manages lifecycle, responsive 2D side-view camera, physics world,
/// and debug overlays.
class ConstructionGame extends FlameGame<ConstructionWorld>
    with HasCollisionDetection, TapCallbacks {
  ConstructionGame({
    this.config = const GameConfig(),
  }) : super(
          world: ConstructionWorld(),
          camera: GameCamera.create(),
        );

  final GameConfig config;

  /// Notifier exposing smoothed real-time FPS to debug widgets.
  final ValueNotifier<double> fpsNotifier = ValueNotifier<double>(60.0);

  int _frameCount = 0;
  double _timeAccumulator = 0.0;

  @override
  Color backgroundColor() => GameConstants.skyColor;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Link the world explicitly to camera
    camera.world = world;

    // Viewfinder defaults for side-view landscape
    camera.viewfinder.zoom = 1.0;
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Compute FPS metrics periodically (every 0.25s) to avoid UI thrashing
    _frameCount++;
    _timeAccumulator += dt;
    if (_timeAccumulator >= 0.25) {
      final currentFps = _frameCount / _timeAccumulator;
      fpsNotifier.value = currentFps;
      _frameCount = 0;
      _timeAccumulator = 0.0;
    }
  }

  @override
  void onDispose() {
    fpsNotifier.dispose();
    super.onDispose();
  }
}
