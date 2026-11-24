/// Runtime configuration for Construction Simulator.
class GameConfig {
  const GameConfig({
    this.showDebugOverlay = true,
    this.showFps = true,
    this.showCoordinates = true,
    this.showDebugPivots = false,
    this.showComponentBounds = false,
    this.showComponentNames = false,
    this.showGroundContact = false,
    this.forceModularView = false,
    this.soundEnabled = false,
  });

  final bool showDebugOverlay;
  final bool showFps;
  final bool showCoordinates;
  final bool showDebugPivots;
  final bool showComponentBounds;
  final bool showComponentNames;
  final bool showGroundContact;
  final bool forceModularView;
  final bool soundEnabled;

  GameConfig copyWith({
    bool? showDebugOverlay,
    bool? showFps,
    bool? showCoordinates,
    bool? showDebugPivots,
    bool? showComponentBounds,
    bool? showComponentNames,
    bool? showGroundContact,
    bool? forceModularView,
    bool? soundEnabled,
  }) {
    return GameConfig(
      showDebugOverlay: showDebugOverlay ?? this.showDebugOverlay,
      showFps: showFps ?? this.showFps,
      showCoordinates: showCoordinates ?? this.showCoordinates,
      showDebugPivots: showDebugPivots ?? this.showDebugPivots,
      showComponentBounds: showComponentBounds ?? this.showComponentBounds,
      showComponentNames: showComponentNames ?? this.showComponentNames,
      showGroundContact: showGroundContact ?? this.showGroundContact,
      forceModularView: forceModularView ?? this.forceModularView,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}
