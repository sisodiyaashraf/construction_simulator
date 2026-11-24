import 'package:construction_simulator/core/utils/asset_path_resolver.dart';
import 'package:construction_simulator/data/models/game_asset_definition.dart';
import 'package:construction_simulator/data/repositories/game_asset_repository.dart';
import 'package:construction_simulator/game/components/excavator/excavator_pivot_config.dart';
import 'package:flame/cache.dart';
import 'package:flame/components.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Asset Path Resolution & Safety Tests', () {
    test('Validates safe relative paths with supported extensions', () {
      expect(
        AssetPathResolver.isValidPath('assets/images/excavator/vehicle.png'),
        isTrue,
      );
      expect(
        AssetPathResolver.isValidPath('assets/images/environment/backdrop.webp'),
        isTrue,
      );
      expect(
        AssetPathResolver.isValidPath('assets/metadata/excavator_meta.json'),
        isTrue,
      );
    });

    test('Rejects directory traversal and invalid paths', () {
      expect(
        AssetPathResolver.isValidPath('../assets/secret.png'),
        isFalse,
      );
      expect(
        AssetPathResolver.isValidPath('/root/file.png'),
        isFalse,
      );
      expect(
        AssetPathResolver.isValidPath('assets/images/vehicle.exe'),
        isFalse,
      );
      expect(
        AssetPathResolver.isValidPath(''),
        isFalse,
      );
    });

    test('Resolves Flame image cache keys correctly', () {
      expect(
        AssetPathResolver.resolveFlameImageKey('assets/images/excavator/test.png'),
        'excavator/test.png',
      );
      expect(
        AssetPathResolver.resolveFlameImageKey('custom/path.png'),
        'custom/path.png',
      );
      expect(
        () => AssetPathResolver.resolveFlameImageKey('../forbidden.png'),
        throwsArgumentError,
      );
    });
  });

  group('Game Asset Definition & Manifest Parsing Tests', () {
    test('GameAssetDefinition parses and serializes correctly', () {
      const def = GameAssetDefinition(
        id: 'test_asset',
        sourceFilename: 'test.png',
        targetAssetPath: 'assets/images/test.png',
        assetType: GameAssetType.excavatorIllustration,
        width: 1000,
        height: 500,
        hasAlpha: false,
        isTemporaryVisual: true,
        metadata: {'author': 'Gemini'},
      );

      expect(def.aspectRatio, 2.0);
      final map = def.toMap();
      expect(map['id'], 'test_asset');
      expect(map['isTemporaryVisual'], isTrue);

      final fromMap = GameAssetDefinition.fromMap(map);
      expect(fromMap.id, def.id);
      expect(fromMap.assetType, GameAssetType.excavatorIllustration);
      expect(fromMap.aspectRatio, 2.0);
    });

    test('GameAssetRepository contains approved Stage 12 initial batch', () {
      final repo = GameAssetRepository();
      final allDefs = repo.getAllDefinitions();

      expect(allDefs.length, 3);
      final excavatorDef = repo.getAsset('excavator_full_illustration');
      expect(excavatorDef, isNotNull);
      expect(excavatorDef!.width, 2752);
      expect(excavatorDef.isTemporaryVisual, isTrue);

      final backdropDef = repo.getAsset('construction_site_backdrop');
      expect(backdropDef, isNotNull);
      expect(backdropDef!.width, 2816);

      final groundDef = repo.getAsset('ground_terrain_surface');
      expect(groundDef, isNotNull);
    });

    test('Handles missing assets safely without crashing', () {
      final repo = GameAssetRepository();
      final images = Images();

      expect(repo.isLoaded(images, 'non_existent_asset'), isFalse);
      expect(repo.getImage(images, 'non_existent_asset'), isNull);
    });
  });

  group('Pivot Configuration & Kinematics Coordinate Tests', () {
    test('Converts normalized coordinates to component-local pixels accurately', () {
      const config = ExcavatorPivotConfig();
      final componentSize = Vector2(340, 190);

      final undercarriagePos = config.toLocalPixel(config.undercarriageCenter, componentSize);
      expect(undercarriagePos.x, 170.0);
      expect(undercarriagePos.y, 190.0);

      final cabinPos = config.toLocalPixel(config.cabinPivot, componentSize);
      expect(cabinPos.x, closeTo(119.0, 0.1));
      expect(cabinPos.y, closeTo(123.5, 0.1));

      final boomPos = config.toLocalPixel(config.boomBaseJoint, componentSize);
      expect(boomPos.x, closeTo(176.8, 0.1));
      expect(boomPos.y, closeTo(110.2, 0.1));
    });

    test('ExcavatorPivotConfig supports overrides via copyWith', () {
      const config = ExcavatorPivotConfig();
      final updated = config.copyWith(
        showDebugPivots: true,
        undercarriageCenter: const Point2D(0.4, 0.9),
      );

      expect(updated.showDebugPivots, isTrue);
      expect(updated.undercarriageCenter.x, 0.4);
      expect(updated.undercarriageCenter.y, 0.9);
      expect(config.showDebugPivots, isFalse); // Immutable original
    });
  });
}
