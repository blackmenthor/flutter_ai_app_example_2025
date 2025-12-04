import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:mime/mime.dart';

import '../models/hairstyle_preference.dart';

class GeminiService {
  late final FirebaseAI _firebaseAI;
  late final ImagenModel _imagenModel;

  GeminiService() {
    // Initialize Firebase AI for Imagen
    _firebaseAI = FirebaseAI.vertexAI(location: 'us-central1');

    // Initialize the Vertex AI Gemini API backend service
    // Create a `GenerativeModel` instance with a model that supports your use case
    _imagenModel = FirebaseAI.vertexAI().imagenModel(
      model: 'imagen-3.0-capability-001',
      generationConfig: ImagenGenerationConfig(
        addWatermark: true,
        numberOfImages: 3,
      ),
      safetySettings: ImagenSafetySettings(
        ImagenSafetyFilterLevel.blockOnlyHigh,
        ImagenPersonFilterLevel.allowAll,
      ),
    );
  }

  String? getMimeType(File file) {
    return lookupMimeType(file.path);
  }

  Future<List<ImagenInlineImage>> generateHairstyleRecommendations({
    required File frontPhoto,
    required File sidePhoto,
    File? fullBodyPhoto,
    required HairstylePreference preferences,
  }) async {
    try {
      // Read image files as bytes
      final frontBytes = await frontPhoto.readAsBytes();
      final sideBytes = await sidePhoto.readAsBytes();

      final frontSubjectReference = ImagenSubjectReference(
        image: ImagenInlineImage(
            bytesBase64Encoded: frontBytes,
            mimeType: lookupMimeType(frontPhoto.path) ?? 'image/jpeg'),
        referenceId: 1,
        description: 'Front photo of a person',
        subjectType: ImagenSubjectReferenceType.person,
      );
      final sideSubjectReference = ImagenSubjectReference(
        image: ImagenInlineImage(
            bytesBase64Encoded: sideBytes,
            mimeType: lookupMimeType(sidePhoto.path) ?? 'image/jpeg'),
        referenceId: 2,
        description: 'Side photo of a person',
        subjectType: ImagenSubjectReferenceType.person,
      );

      final imageParts = [frontSubjectReference, sideSubjectReference];

      // Add full body photo if available
      if (fullBodyPhoto != null) {
        final fullBodyBytes = await fullBodyPhoto.readAsBytes();
        final fullBodySubjectReference = ImagenSubjectReference(
          image: ImagenInlineImage(
              bytesBase64Encoded: fullBodyBytes,
              mimeType: lookupMimeType(fullBodyPhoto.path) ?? 'image/jpeg'),
          referenceId: 2,
          description: 'Full body photo of a person',
          subjectType: ImagenSubjectReferenceType.person,
        );
        imageParts.add(fullBodySubjectReference);
      }

      // Build prompt for hairstyle analysis and recommendations
      final prompt = _buildAnalysisPrompt(preferences);

      // Generate content using Gemini API
      final response = await _imagenModel.editImage(
        imageParts,
        prompt,
        config: ImagenEditingConfig(
          editSteps:
              5, // Number of editing steps, a higher value can improve quality
        ),
      );

      if (response.images.isEmpty) {
        throw Exception('No response!');
      }

      return response.images;
    } catch (e) {
      throw Exception('Failed to generate hairstyle recommendations: $e');
    }
  }

  String _buildAnalysisPrompt(HairstylePreference prefs) {
    StringBuffer sb = StringBuffer();
    sb.write("Please edit photos of this person"
        ", based on images that this person supplied, see"
        " [1] and [2] and apply 3 different hairstyle recommendations "
        "based on the person's face shape, features, and the following preferences:\n\n");

    if (prefs.length != null) {
      sb.write(
          "Preferred length: ${prefs.length.toString().split('.').last}\n");
    }
    if (prefs.selectedStyles.isNotEmpty) {
      sb.write(
          "Style elements: ${prefs.selectedStyles.map((e) => e.toString().split('.').last).join(', ')}\n");
    }
    if (prefs.additionalPreferences.isNotEmpty) {
      sb.write(
          "Additional preferences: ${prefs.additionalPreferences.join(', ')}\n");
    }
    if (prefs.customRequest != null && prefs.customRequest!.isNotEmpty) {
      sb.write("Custom requests: ${prefs.customRequest}\n");
    }

    sb.write(
        "\nGenerate 3 variations showing the person with different hairstyles that:\n");
    sb.write("1. Complement their face shape and features\n");
    sb.write("2. Match the specified preferences\n");
    sb.write("3. Look natural and realistic\n");
    sb.write("4. Maintain the person's identity and facial features\n\n");
    sb.write(
        "5. Should always be front facing, avoid side facing generated image\n\n");
    sb.write(
        "Make subtle, realistic edits that show how each hairstyle would look on this specific person.");

    return sb.toString();
  }
}
