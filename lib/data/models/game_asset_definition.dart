/// Categorization of game assets for Construction Simulator.
enum GameAssetType {
  excavatorIllustration,
  excavatorComponent,
  background,
  terrain,
  spritesheet,
  metadata,
}

/// Immutable definition of a validated game asset.
class GameAssetDefinition {
  const GameAssetDefinition({
    required this.id,
    required this.sourceFilename,
    required this.targetAssetPath,
    required this.assetType,
    required this.width,
    required this.height,
    this.hasAlpha = true,
    this.isTemporaryVisual = false,
    this.metadata = const {},
  });

  final String id;
  final String sourceFilename;
  final String targetAssetPath;
  final GameAssetType assetType;
  final int width;
  final int height;
  final bool hasAlpha;
  final bool isTemporaryVisual;
  final Map<String, dynamic> metadata;

  double get aspectRatio => height == 0 ? 1.0 : width / height;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'sourceFilename': sourceFilename,
      'targetAssetPath': targetAssetPath,
      'assetType': assetType.name,
      'width': width,
      'height': height,
      'hasAlpha': hasAlpha,
      'isTemporaryVisual': isTemporaryVisual,
      'metadata': metadata,
    };
  }

  factory GameAssetDefinition.fromMap(Map<String, dynamic> map) {
    return GameAssetDefinition(
      id: map['id'] as String,
      sourceFilename: map['sourceFilename'] as String,
      targetAssetPath: map['targetAssetPath'] as String,
      assetType: GameAssetType.values.firstWhere(
        (e) => e.name == map['assetType'],
        orElse: () => GameAssetType.excavatorIllustration,
      ),
      width: map['width'] as int? ?? 0,
      height: map['height'] as int? ?? 0,
      hasAlpha: map['hasAlpha'] as bool? ?? true,
      isTemporaryVisual: map['isTemporaryVisual'] as bool? ?? false,
      metadata: Map<String, dynamic>.from(map['metadata'] as Map? ?? {}),
    );
  }
}
