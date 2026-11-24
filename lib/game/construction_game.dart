import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../core/config/game_config.dart';
import '../core/constants/game_constants.dart';
import '../data/repositories/game_asset_repository.dart';
import 'camera/game_camera.dart';
import 'world/construction_world.dart';

/// Main game engine controller for Construction Simulator.
///
/// Manages engine lifecycle, responsive 2D side-view camera, physics world,
/// real asset preloading, and debug overlay tools.
class ConstructionGame extends FlameGame<ConstructionWorld>
    with HasCollisionDetection, TapCallbacks {
  ConstructionGame({
    GameConfig? config,
    GameAssetRepository? assetRepository,
  })  : config = config ?? const GameConfig(),
        assetRepository = assetRepository ?? GameAssetRepository(),
        super(
          world: ConstructionWorld(),
          camera: GameCamera.create(),
        );

  GameConfig config;
  final GameAssetRepository assetRepository;

  /// Notifier exposing smoothed real-time FPS to debug widgets.
  final ValueNotifier<double> fpsNotifier = ValueNotifier<double>(60.0);

  /// Notifier exposing the active configuration to overlay UI controls.
  late final ValueNotifier<GameConfig> configNotifier;

  int _frameCount = 0;
  double _timeAccumulator = 0.0;

  @override
  Color backgroundColor() => GameConstants.skyColor;

  @override
  Future<void> onLoad() async {
    configNotifier = ValueNotifier<GameConfig>(config);

    // Preload approved game assets before world initialisation
    await assetRepository.preloadAssets(images);

    await super.onLoad();

    // Link camera world explicitly
    camera.world = world;
    camera.viewfinder.zoom = 1.0;

    // Apply initial debug mode if requested
    if (config.showComponentBounds) {
      debugMode = true;
    }
  }

  /// Updates game configuration at runtime (e.g. toggling pivots or modular view).
  void updateConfig(GameConfig newConfig) {
    config = newConfig;
    configNotifier.value = newConfig;
    debugMode = newConfig.showComponentBounds;
    world.applyConfig();
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
    configNotifier.dispose();
    super.onDispose();
  }
}
