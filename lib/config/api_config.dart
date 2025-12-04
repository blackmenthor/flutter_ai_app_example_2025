import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiConfig {
  // Load from environment variable
  static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
}
