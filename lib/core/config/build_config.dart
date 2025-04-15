class BuildConfig {
  static const bool debug = bool.fromEnvironment('DEBUG', defaultValue: false);
  static const String adsKey = String.fromEnvironment('FLUTTER_ADS_KEY', defaultValue: '');
  static const bool enableAds = bool.fromEnvironment('ENABLE_ADS', defaultValue: false);
}