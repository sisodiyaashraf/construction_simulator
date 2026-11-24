import 'package:flutter/material.dart';

/// Core constants for Construction Simulator.
class GameConstants {
  GameConstants._();

  /// Target logical viewport resolution for landscape 2D side-view.
  static const double logicalWidth = 1280.0;
  static const double logicalHeight = 720.0;
  static const double aspectRatio = 16.0 / 9.0;

  /// Side-view ground level in world coordinates (Y = 0 is world vertical center).
  static const double groundSurfaceY = 120.0;
  static const double groundDepth = 240.0;

  /// Excavator initial placement in world coordinates.
  static const double defaultExcavatorX = 0.0;
  static const double defaultExcavatorY = groundSurfaceY;

  /// Default background sky color for construction site atmosphere.
  static const Color skyColor = Color(0xFF8AB4F8);
  static const Color horizonColor = Color(0xFFD3E3FD);
  static const Color groundSurfaceColor = Color(0xFF795548);
  static const Color groundSubsurfaceColor = Color(0xFF4E342E);
  static const Color constructionYellow = Color(0xFFFFB300);
  static const Color constructionDark = Color(0xFF263238);

  /// Overlay keys
  static const String debugOverlayKey = 'debug_overlay';
}
