import 'dart:ui' as ui;
import 'package:flame/cache.dart';
import 'package:flutter/foundation.dart';
import '../../core/utils/asset_path_resolver.dart';
import '../models/game_asset_definition.dart';

/// Exception thrown when a required game asset cannot be found or loaded.
class GameAssetNotFoundException implements Exception {
  const GameAssetNotFoundException(this.message);
  final String message;

  @override
  String toString() => 'GameAssetNotFoundException: $message';
}

/// Repository managing registered game asset definitions, manifests, and Flame preloading.
class GameAssetRepository {
  GameAssetRepository();

  /// Explicit manifest for Stage 12 approved asset batch.
  static final Map<String, GameAssetDefinition> _manifest = {
    'excavator_full_illustration': const GameAssetDefinition(
      id: 'excavator_full_illustration',
      sourceFilename: 'Gemini_Generated_Image_1pjuvw1pjuvw1pju.png',
      targetAssetPath: 'assets/images/excavator/Gemini_Generated_Image_1pjuvw1pjuvw1pju.png',
      assetType: GameAssetType.excavatorIllustration,
      width: 2752,
      height: 1536,
      hasAlpha: false,
      isTemporaryVisual: true,
      metadata: {
        'processor_asset_id': 1,
        'label': 'Complete Excavator Vehicle Illustration',
        'notes': 'Temporary complete vehicle graphic pending isolated component separation',
      },
    ),
    'construction_site_backdrop': const GameAssetDefinition(
      id: 'construction_site_backdrop',
      sourceFilename: 'Gemini_Generated_Image_cm9zpfcm9zpfcm9z.png',
      targetAssetPath: 'assets/images/environment/Gemini_Generated_Image_cm9zpfcm9zpfcm9z.png',
      assetType: GameAssetType.background,
      width: 2816,
      height: 1536,
      hasAlpha: false,
      isTemporaryVisual: false,
      metadata: {
        'processor_asset_id': 8,
        'label': 'Construction Site Panoramic Backdrop',
      },
    ),
    'ground_terrain_surface': const GameAssetDefinition(
      id: 'ground_terrain_surface',
      sourceFilename: 'Gemini_Generated_Image_3s83433s83433s83.png',
      targetAssetPath: 'assets/images/environment/Gemini_Generated_Image_3s83433s83433s83.png',
      assetType: GameAssetType.terrain,
      width: 2816,
      height: 1536,
      hasAlpha: false,
      isTemporaryVisual: false,
      metadata: {
        'processor_asset_id': 3,
        'label': 'Excavation Ground Terrain Surface',
      },
    ),
  };

  /// Returns all registered asset definitions.
  List<GameAssetDefinition> getAllDefinitions() => _manifest.values.toList();

  /// Retrieves an asset definition by unique identifier.
  GameAssetDefinition? getAsset(String id) => _manifest[id];

  /// Asynchronously preloads all manifest assets into Flame's image cache.
  ///
  /// Never reloads on each frame. Gracefully falls back if an asset is not yet on disk.
  Future<Map<String, ui.Image>> preloadAssets(Images images) async {
    final loadedImages = <String, ui.Image>{};

    for (final def in _manifest.values) {
      final key = AssetPathResolver.resolveFlameImageKey(def.targetAssetPath);
      try {
        final image = await images.load(key).timeout(const Duration(seconds: 2));
        loadedImages[def.id] = image;
      } catch (e) {
        debugPrint('Warning: Game asset "${def.id}" ($key) failed to preload: $e');
      }
    }

    return loadedImages;
  }

  /// Checks if an asset exists in Flame's cache.
  bool isLoaded(Images images, String assetId) {
    final def = _manifest[assetId];
    if (def == null) return false;
    final key = AssetPathResolver.resolveFlameImageKey(def.targetAssetPath);
    return images.containsKey(key);
  }

  /// Retrieves a loaded image from Flame's cache.
  ui.Image? getImage(Images images, String assetId) {
    final def = _manifest[assetId];
    if (def == null) return null;
    final key = AssetPathResolver.resolveFlameImageKey(def.targetAssetPath);
    return images.fromCache(key);
  }
}
