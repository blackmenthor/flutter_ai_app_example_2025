class ApiConfig {
  // Load from environment variable
  static String get geminiApiKey => 'AIzaSyC_F0zFpGpIBShxPQ2WdBMiGBObA_4x7RA';
  // static String get geminiApiKey => dotenv.env['GEMINI_API_KEY'] ?? '';
  
  // Google Cloud configuration for Imagen API
  static String get googleCloudProjectId => 'your-project-id'; // Replace with your project ID
  static String get googleCloudLocation => 'us-central1'; // Or your preferred location
  static String get googleCloudAccessToken => ''; // This should be obtained through OAuth2
}
