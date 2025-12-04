import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

import '../config/api_config.dart';
import '../models/hairstyle_preference.dart';

class GeminiService {
  late final GenerativeModel _imagenModel;

  GeminiService() {
    final apiKey = ApiConfig.geminiApiKey;
    if (apiKey.isEmpty) {
      print('Warning: GEMINI_API_KEY is not set');
    }

    // Initialize Imagen model
    // Note: Verify the model name for Imagen in the specific API version you are using.
    // As per instruction, using 'imagen-3.0-generate-002' or similar.
    _imagenModel = GenerativeModel(
      model: 'imagen-3.0-generate-002',
      apiKey: apiKey,
    );
  }

  Future<List<String>> generateHairstyleRecommendations({
    required File frontPhoto,
    required File sidePhoto,
    File? fullBodyPhoto,
    required HairstylePreference preferences,
  }) async {
    // This is a placeholder for the actual implementation.
    // Real implementation would involve uploading images or sending them as bytes
    // along with a prompt to the model.
    //
    // Since 'google_generative_ai' package primarily supports Gemini text/multimodal models,
    // and Imagen might require a different endpoint or specific usage within the package (if supported)
    // or REST API calls if the package doesn't fully cover Imagen yet.
    //
    // For this skeleton, we will simulate a delay and return mock URLs or handle it if the package supports it.

    // Constructing a prompt based on preferences
    final prompt = _buildPrompt(preferences);
    print('Generating with prompt: $prompt');

    // Simulate network delay
    await Future.delayed(const Duration(seconds: 3));

    // TODO: FULLY GENERATE
    // Return mock data for UI development until API is fully integrated
    return [
      'https://placeholder.com/1',
      'https://placeholder.com/2',
      'https://placeholder.com/3'
    ];
  }

  String _buildPrompt(HairstylePreference prefs) {
    StringBuffer sb = StringBuffer();
    sb.write(
        "Generate a photorealistic image of a person with the following hairstyle: ");
    if (prefs.length != null) {
      sb.write("${prefs.length.toString().split('.').last} length. ");
    }
    if (prefs.selectedStyles.isNotEmpty) {
      sb.write(
          "Style elements: ${prefs.selectedStyles.map((e) => e.toString().split('.').last).join(', ')}. ");
    }
    if (prefs.additionalPreferences.isNotEmpty) {
      sb.write("Vibe: ${prefs.additionalPreferences.join(', ')}. ");
    }
    if (prefs.customRequest != null && prefs.customRequest!.isNotEmpty) {
      sb.write("Additional details: ${prefs.customRequest}. ");
    }
    sb.write(
        "The image should maintain the facial features of the uploaded photos.");
    return sb.toString();
  }
}
