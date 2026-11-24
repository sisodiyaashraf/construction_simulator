/// Utility for verifying and resolving Flutter and Flame game asset paths.
class AssetPathResolver {
  AssetPathResolver._();

  static const List<String> supportedExtensions = ['.png', '.webp', '.json'];

  /// Validates whether a file path conforms to Flutter asset requirements.
  ///
  /// Checks for forbidden directory traversals, unsupported file extensions,
  /// and invalid character encodings.
  static bool isValidPath(String path) {
    if (path.isEmpty) return false;
    if (path.contains('..')) return false; // Prevent traversal attacks
    if (path.startsWith('/') || path.startsWith('\\')) return false; // Must be relative

    final lower = path.toLowerCase();
    final hasValidExt = supportedExtensions.any(lower.endsWith);
    if (!hasValidExt) return false;

    // Check for valid URI characters
    final validChars = RegExp(r'^[a-zA-Z0-9_\-\./ ()]+$');
    return validChars.hasMatch(path);
  }

  /// Resolves an asset path for Flame's [Images] cache.
  ///
  /// Flame's `images.load(...)` by default searches inside `assets/images/`.
  /// If the path already begins with `assets/images/`, strips the prefix
  /// so Flame resolves correctly without duplicating directories.
  static String resolveFlameImageKey(String declaredAssetPath) {
    if (!isValidPath(declaredAssetPath)) {
      throw ArgumentError('Invalid asset path format: $declaredAssetPath');
    }

    const prefix = 'assets/images/';
    if (declaredAssetPath.startsWith(prefix)) {
      return declaredAssetPath.substring(prefix.length);
    }
    return declaredAssetPath;
  }
}
