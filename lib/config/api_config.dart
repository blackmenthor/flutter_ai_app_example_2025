class ApiConfig {
  // Load from environment variable
  static String get geminiApiKey => const String.fromEnvironment('GEMINI_API_KEY', defaultValue: '');
  
  // Google Cloud configuration for Imagen API
  static String get googleCloudProjectId => const String.fromEnvironment('GOOGLE_CLOUD_PROJECT_ID', defaultValue: '');
  static String get googleCloudLocation => 'us-central1'; // Or your preferred location
  static String get googleCloudAccessToken => ''; // This should be obtained through OAuth2
}
