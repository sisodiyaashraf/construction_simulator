import 'package:construction_simulator/core/constants/game_constants.dart';
import 'package:construction_simulator/game/construction_game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Construction Simulator game widget mounts and displays overlay',
      (WidgetTester tester) async {
    final game = ConstructionGame();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GameWidget<ConstructionGame>(
            game: game,
            overlayBuilderMap: {
              GameConstants.debugOverlayKey: (context, g) {
                return const Text('DEBUG_OVERLAY_MOUNTED');
              },
            },
            initialActiveOverlays: const [
              GameConstants.debugOverlayKey,
            ],
          ),
        ),
      ),
    );

    await tester.pump();

    // Verify debug overlay is present
    expect(find.text('DEBUG_OVERLAY_MOUNTED'), findsOneWidget);
  });
}
