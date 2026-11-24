import 'package:flame/components.dart';
import '../../core/constants/game_constants.dart';

/// Camera configuration helper for scalable 2D side-view landscape display.
class GameCamera {
  GameCamera._();

  /// Creates a scalable 2D camera with a fixed logical resolution of 1280x720.
  ///
  /// This maintains aspect ratio and scales smoothly across varied Android
  /// screen sizes and densities.
  static CameraComponent create({World? world}) {
    final camera = CameraComponent.withFixedResolution(
      width: GameConstants.logicalWidth,
      height: GameConstants.logicalHeight,
      world: world,
    );

    // Default viewfinder centered at world origin (0, 0)
    camera.viewfinder.position = Vector2.zero();
    camera.viewfinder.anchor = Anchor.center;

    return camera;
  }
}
