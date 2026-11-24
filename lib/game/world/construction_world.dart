import 'package:flame/components.dart';
import '../../data/repositories/game_asset_repository.dart';
import '../components/environment/construction_backdrop.dart';
import '../components/environment/ground_component.dart';
import '../components/excavator/excavator_component.dart';
import '../components/excavator/excavator_pivot_config.dart';
import '../construction_game.dart';

/// The 2D side-view game world for Construction Simulator.
///
/// Integrates real imported assets (excavator illustration, backdrop, and terrain)
/// with graceful fallback to modular components and procedural visuals.
class ConstructionWorld extends World with HasGameReference<ConstructionGame> {
  late final ConstructionBackdrop backdrop;
  late final GroundComponent ground;
  late final ExcavatorComponent excavator;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // 1. Resolve optional real assets from the preloaded repository
    final repo = game.assetRepository;
    final images = game.images;

    Sprite? backdropSprite;
    Sprite? groundSprite;
    Sprite? excavatorSprite;

    final backdropImg = repo.getImage(images, 'construction_site_backdrop');
    if (backdropImg != null) {
      backdropSprite = Sprite(backdropImg);
    }

    final groundImg = repo.getImage(images, 'ground_terrain_surface');
    if (groundImg != null) {
      groundSprite = Sprite(groundImg);
    }

    final excavatorImg = repo.getImage(images, 'excavator_full_illustration');
    if (excavatorImg != null) {
      excavatorSprite = Sprite(excavatorImg);
    }

    // 2. Add background environment (real asset or procedural fallback)
    backdrop = ConstructionBackdrop(
      backdropSprite: backdropSprite,
    );
    await add(backdrop);

    // 3. Add ground surface (real terrain or procedural strata)
    ground = GroundComponent(
      groundSprite: groundSprite,
    );
    await add(ground);

    // 4. Add assembled excavator with configurable pivots and ground contact
    excavator = ExcavatorComponent(
      realVisualSprite: excavatorSprite,
      pivotConfig: ExcavatorPivotConfig(
        showDebugPivots: game.config.showDebugPivots,
      ),
      useModularPartsOnly: game.config.forceModularView,
    );
    await add(excavator);
  }

  /// Updates excavator visual display mode and pivot visibility dynamically.
  void applyConfig() {
    excavator.removeFromParent();
    final repo = game.assetRepository;
    final images = game.images;

    Sprite? excavatorSprite;
    final excavatorImg = repo.getImage(images, 'excavator_full_illustration');
    if (excavatorImg != null) {
      excavatorSprite = Sprite(excavatorImg);
    }

    excavator = ExcavatorComponent(
      realVisualSprite: excavatorSprite,
      pivotConfig: ExcavatorPivotConfig(
        showDebugPivots: game.config.showDebugPivots,
      ),
      useModularPartsOnly: game.config.forceModularView,
    );
    add(excavator);
  }
}
