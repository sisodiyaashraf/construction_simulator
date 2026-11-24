/// Runtime configuration for Construction Simulator.
class GameConfig {
  const GameConfig({
    this.showDebugOverlay = true,
    this.showFps = true,
    this.showCoordinates = true,
    this.soundEnabled = false,
  });

  final bool showDebugOverlay;
  final bool showFps;
  final bool showCoordinates;
  final bool soundEnabled;

  GameConfig copyWith({
    bool? showDebugOverlay,
    bool? showFps,
    bool? showCoordinates,
    bool? soundEnabled,
  }) {
    return GameConfig(
      showDebugOverlay: showDebugOverlay ?? this.showDebugOverlay,
      showFps: showFps ?? this.showFps,
      showCoordinates: showCoordinates ?? this.showCoordinates,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }
}
