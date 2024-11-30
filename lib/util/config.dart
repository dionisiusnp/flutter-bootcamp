class Config {
  static final Config _instance = Config._internal();

  factory Config() => _instance;

  Config._internal();

  final String baseUrl = "http://127.0.0.1:8001/api";
}
