import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';
  static String get key => dotenv.env['WC_KEY'] ?? '';
  static String get secret => dotenv.env['WC_SECRET'] ?? '';
}
