# Construction Simulator

A 2D side-view construction machine simulation game for Android, built with Flutter and Flame.

---

## 1. Environment & Stack Information

- **Flutter SDK**: `3.38.5` (channel stable)
- **Dart SDK**: `3.10.4`
- **Flame Engine**: `^1.35.1`
- **Target Platform**: Android (Landscape)
- **JDK / Java**: OpenJDK 21.0.10 (bundled with Android Studio JBR)
- **Android SDK Version**: 37.0.0 (API 37 / Build-Tools 37.0.0)
- **Logical Resolution**: 1280 x 720 (16:9 fixed resolution responsive viewport)

---

## 2. Architecture Overview

```text
lib/
  main.dart                           # Entry point, landscape lock, immersive full screen
  game/
    construction_game.dart             # FlameGame subclass, engine lifecycle & HUD notifier
    camera/
      game_camera.dart                # Fixed-resolution 1280x720 side-view camera setup
    world/
      construction_world.dart         # Flame World managing environment & machinery
    components/
      excavator/
        excavator_placeholder.dart    # Modular geometric excavator with articulation pivots
      environment/
        construction_backdrop.dart    # Layered sky gradient, horizon & crane silhouette
        ground_component.dart         # Side-view terrain cross-section & topsoil surface
      vehicles/                       # Target directory for secondary vehicles (dump trucks, etc.)
      ui/
        debug_overlay.dart            # Flutter overlay displaying live FPS and viewport dimensions
  core/
    constants/
      game_constants.dart             # Viewport resolution, color palette, world coordinates
    config/
      game_config.dart                # Runtime debug & feature flags
    utils/                            # Utility extensions and helper functions
  features/                           # UI features (home menu, gameplay HUD, settings)
  systems/                            # Systems (input handling, Box2D/Forge2D physics, audio)
  data/                               # Data models and state repositories
assets/
  images/                             # Isolated asset imports
    excavator/                        # Excised excavator parts
    environment/                      # Terrain blocks, backdrops, signs
    vehicles/                         # Dump trucks, loaders
    objects/                          # Rocks, soil clods, pipes
  spritesheets/                       # Packed animation frames
  atlases/                            # Texture atlas definitions
  metadata/                           # Asset bounds, pivot points, physics hitboxes
  audio/                              # Machine sound effects and ambient tracks
  fonts/                              # Game typography
test/
  game_test.dart                      # Flame world & camera integration tests
  widget_test.dart                    # GameWidget mount & overlay smoke test
```

---

## 3. Asset Integration Pipeline from `construction_asset_processor`

The game project is intentionally separated from the Python asset processor (`construction_asset_processor`).

Approved assets from the asset processor will be imported using the following protocol:

### Asset Categories and Destination Folders
| Asset Type | Target Location | Description |
| :--- | :--- | :--- |
| **Excavator Components** | `assets/images/excavator/` | Modular parts (chassis, tracks, cab, boom, stick, bucket). |
| **Environment Props** | `assets/images/environment/` | Terrain tiles, rocks, construction signage, barriers. |
| **Secondary Vehicles** | `assets/images/vehicles/` | Dump trucks, bulldozers, cement mixers. |
| **Interactive Objects** | `assets/images/objects/` | Boulders, pipes, rubble, debris. |
| **Packed Atlases** | `assets/atlases/` | Flame texture atlases or sprite sheet PNGs. |
| **Animation Metadata** | `assets/metadata/` | JSON files detailing pivot coordinates, frame rates, and bounding boxes. |
| **Sound Effects** | `assets/audio/` | Engine rumble, hydraulic hiss, metal clank, digging SFX. |

### Atlas Import & Flame Format Guidelines
- **Texture Atlases**: Flame natively supports sprite sheets (`SpriteSheet`) with uniform frame sizes, or custom XML/JSON atlases via `flame_texturepacker`.
- **Pivot Metadata**: Articulation pivots (e.g. cabin rotation center, boom base pin, stick pin, bucket linkage pin) are defined in normalized or pixel offset format in `assets/metadata/`.
- **Pre-loading**: Assets should be preloaded during `ConstructionGame.onLoad()` or `ConstructionWorld.onLoad()` via `Flame.images.load(...)` to prevent runtime frame drops.

---

## 4. How to Run

### Run on connected Android device / emulator
```bash
flutter run -d android
```

### Run Automated Tests
```bash
flutter test
```

### Build Debug APK
```bash
flutter build apk --debug
```
The output APK will be placed at `build/app/outputs/flutter-apk/app-debug.apk`.
