import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/constants/game_constants.dart';
import 'game/components/ui/debug_overlay.dart';
import 'game/construction_game.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Configure Android full-screen immersive mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Lock to landscape orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Flame device configuration helpers
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  runApp(const ConstructionSimulatorApp());
}

/// Root widget for Construction Simulator application.
class ConstructionSimulatorApp extends StatelessWidget {
  const ConstructionSimulatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Construction Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        useMaterial3: true,
      ),
      home: Scaffold(
        body: GameWidget<ConstructionGame>(
          game: ConstructionGame(),
          overlayBuilderMap: {
            GameConstants.debugOverlayKey: (context, game) {
              return DebugOverlayWidget(game: game);
            },
          },
          initialActiveOverlays: const [
            GameConstants.debugOverlayKey,
          ],
        ),
      ),
    );
  }
}
