import 'package:flutter/material.dart';
import '../../construction_game.dart';
import '../../../core/constants/game_constants.dart';

/// Debug HUD overlay showing real-time performance and viewport metrics.
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
      child: ValueListenableBuilder<double>(
        valueListenable: game.fpsNotifier,
        builder: (context, fps, _) {
          final screenSize = MediaQuery.of(context).size;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.black.withAlpha(200),
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
                    const Icon(Icons.videogame_asset, size: 14, color: Colors.amber),
                    const SizedBox(width: 4),
                    const Text(
                      'CONSTRUCTION SIMULATOR (DEBUG)',
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'FPS: ${fps.toStringAsFixed(1)}',
                  style: TextStyle(
                    color: fps >= 50
                        ? Colors.greenAccent
                        : (fps >= 30 ? Colors.orangeAccent : Colors.redAccent),
                    fontSize: 11,
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Logical Viewport: ${GameConstants.logicalWidth.toInt()} x ${GameConstants.logicalHeight.toInt()} (16:9)',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'Screen Size: ${screenSize.width.toInt()} x ${screenSize.height.toInt()} (${(screenSize.width / GameConstants.logicalWidth).toStringAsFixed(2)}x scale)',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
                Text(
                  'Camera: (${game.camera.viewfinder.position.x.toInt()}, ${game.camera.viewfinder.position.y.toInt()}) [Side-View 2D]',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 10,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
