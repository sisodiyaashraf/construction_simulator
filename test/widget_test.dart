import 'package:construction_simulator/game/components/ui/debug_overlay.dart';
import 'package:construction_simulator/game/construction_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('DebugOverlayWidget mounts and displays stage 12 controls',
      (WidgetTester tester) async {
    final game = ConstructionGame(autoPreload: false);
    await game.onLoad();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Stack(
            children: [
              DebugOverlayWidget(game: game),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    // Verify key elements of the debug overlay
    expect(find.text('CONSTRUCTION SIMULATOR (STAGE 12)'), findsOneWidget);
    expect(find.text('Show Pivots'), findsOneWidget);
    expect(find.text('Modular View'), findsOneWidget);
    expect(find.text('Show Bounds'), findsOneWidget);

    // Test toggle interaction
    await tester.tap(find.text('Show Pivots'));
    await tester.pump();

    expect(game.config.showDebugPivots, isTrue);
    expect(find.text('Hide Pivots'), findsOneWidget);

    game.onDispose();
  });
}
