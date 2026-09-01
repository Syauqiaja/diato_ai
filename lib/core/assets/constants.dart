abstract class Constants {
  static const String appName = "Diato AI";
  static const String apiBaseUrl = "https://api.diatoai.com";

  /// Host serving uploaded files (`/storage/...`), i.e. the api base url
  /// without its `/api` suffix.
  static const String assetHost = "https://diato-ai.fajrsyauqi.com";
}

/// Turns a possibly root-relative path returned by the API (`/storage/foo.jpg`)
/// into an absolute url. Returns null for null/empty input.
String? resolveAssetUrl(String? path) {
  if (path == null || path.isEmpty) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  return '${Constants.assetHost}${path.startsWith('/') ? '' : '/'}$path';
}
