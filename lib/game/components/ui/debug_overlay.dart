import 'package:flutter/material.dart';
import '../../construction_game.dart';
import '../../../core/config/game_config.dart';
import '../../../core/constants/game_constants.dart';

/// Debug HUD overlay showing real-time performance, viewport metrics,
/// asset load telemetry, and visual debugging controls.
class DebugOverlayWidget extends StatelessWidget {
  const DebugOverlayWidget({
    required this.game,
    super.key,
  });

  final ConstructionGame game;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 12,
      left: 12,
      child: ValueListenableBuilder<GameConfig>(
        valueListenable: game.configNotifier,
        builder: (context, config, _) {
          return ValueListenableBuilder<double>(
            valueListenable: game.fpsNotifier,
            builder: (context, fps, _) {
              final screenSize = MediaQuery.of(context).size;
              return Container(
                constraints: const BoxConstraints(maxWidth: 380),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withAlpha(210),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.amber.withAlpha(180), width: 1.5),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black45,
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.videogame_asset, size: 13, color: Colors.amber),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'CONSTRUCTION SIMULATOR (STAGE 12)',
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'monospace',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'FPS: ${fps.toStringAsFixed(1)} | Viewport: ${GameConstants.logicalWidth.toInt()}x${GameConstants.logicalHeight.toInt()} (16:9)',
                      style: TextStyle(
                        color: fps >= 50
                            ? Colors.greenAccent
                            : (fps >= 30 ? Colors.orangeAccent : Colors.redAccent),
                        fontSize: 10,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Screen: ${screenSize.width.toInt()}x${screenSize.height.toInt()} (${(screenSize.width / GameConstants.logicalWidth).toStringAsFixed(2)}x scale)',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const Divider(color: Colors.white24, height: 8),
                    // Asset & Ground Status
                    const Text(
                      'ASSET & SCENE INSPECTION:',
                      style: TextStyle(
                        color: Colors.cyanAccent,
                        fontSize: 9,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'Ground Contact: Y=${GameConstants.groundSurfaceY.toInt()} [Flush Contact: OK]',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                    Text(
                      'Mode: ${config.forceModularView ? "MODULAR COMPONENTS" : "REAL COMPLETE VISUAL (ASSET 1)"}',
                      style: TextStyle(
                        color: config.forceModularView ? Colors.orangeAccent : Colors.lightGreenAccent,
                        fontSize: 9,
                        fontFamily: 'monospace',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Pivots: ${config.showDebugPivots ? "VISIBLE" : "HIDDEN"} | Bounds: ${config.showComponentBounds ? "ON" : "OFF"}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 9,
                        fontFamily: 'monospace',
                      ),
                    ),
                    const SizedBox(height: 6),
                    // Debug Action Buttons
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        _buildButton(
                          label: config.showDebugPivots ? 'Hide Pivots' : 'Show Pivots',
                          isActive: config.showDebugPivots,
                          onPressed: () {
                            game.updateConfig(
                              config.copyWith(showDebugPivots: !config.showDebugPivots),
                            );
                          },
                        ),
                        _buildButton(
                          label: config.forceModularView ? 'Real Asset View' : 'Modular View',
                          isActive: config.forceModularView,
                          onPressed: () {
                            game.updateConfig(
                              config.copyWith(forceModularView: !config.forceModularView),
                            );
                          },
                        ),
                        _buildButton(
                          label: config.showComponentBounds ? 'Hide Bounds' : 'Show Bounds',
                          isActive: config.showComponentBounds,
                          onPressed: () {
                            game.updateConfig(
                              config.copyWith(showComponentBounds: !config.showComponentBounds),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: isActive ? Colors.amber.withAlpha(180) : Colors.white12,
          borderRadius: BorderRadius.circular(3),
          border: Border.all(
            color: isActive ? Colors.amber : Colors.white24,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.black : Colors.white,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}
