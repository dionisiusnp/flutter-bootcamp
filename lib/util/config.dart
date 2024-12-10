class Config {
  static final Config _instance = Config._internal();

  factory Config() => _instance;

  Config._internal();

  final String baseUrl = "https://9a06-202-51-113-149.ngrok-free.app/api";
}
