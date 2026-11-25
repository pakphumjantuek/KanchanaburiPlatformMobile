class ApiConfig {
  /// Backend API address, set at build time (never hardcoded):
  ///   flutter run --dart-define=API_BASE_URL=http://10.0.2.2:5123/api
  ///   flutter run --dart-define-from-file=env.json   (copy env.example.json to env.json)
  /// 10.0.2.2 is how the Android emulator reaches the host machine's localhost.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5123/api',
  );
  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}
