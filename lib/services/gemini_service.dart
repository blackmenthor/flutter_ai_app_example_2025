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
        numberOfImages: 8,
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
        description: 'Front photo of a person from the front of the face',
        subjectType: ImagenSubjectReferenceType.person,
      );
      final sideSubjectReference = ImagenSubjectReference(
        image: ImagenInlineImage(
            bytesBase64Encoded: sideBytes,
            mimeType: lookupMimeType(sidePhoto.path) ?? 'image/jpeg'),
        referenceId: 2,
        description: 'Side photo of a person from the side of the face',
        subjectType: ImagenSubjectReferenceType.person,
      );

      final imageParts = [frontSubjectReference, sideSubjectReference];

      // Build prompt for hairstyle analysis and recommendations
      final prompt = _buildAnalysisPrompt(preferences);

      // Generate content using Gemini API
      final response = await _imagenModel.editImage(
        imageParts,
        prompt,
        config: ImagenEditingConfig(
          editSteps:
              1, // Number of editing steps, a higher value can improve quality
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
    sb.write(
        "Edit the photos of this person ([1] and [2]) to apply a new hairstyle recommendation "
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

    sb.write("\nGenerate a hairstyle that:\n");
    sb.write("- Complements their face shape and features\n");
    sb.write("- Matches the specified preferences\n");
    sb.write("- Looks natural and realistic\n");
    sb.write("- Maintains the person's identity and facial features\n");
    sb.write("- Shows the person from a clear front view\n\n");
    
    sb.write("IMPORTANT CONSTRAINTS:\n");
    sb.write("- ONLY modify the hair/hairstyle - keep everything else identical to the reference photos\n");
    sb.write("- Preserve the EXACT same face, facial features, skin tone, and facial expression\n");
    sb.write("- Keep the EXACT same clothing, accessories, and background as shown in the reference images\n");
    sb.write("- Maintain the EXACT same camera angle, lighting, and photo composition\n");
    sb.write("- Do NOT change body posture, head position, or any aspect except the hair\n");
    sb.write("- The result should look like the same photo with only a different hairstyle\n\n");
    
    sb.write("Make subtle, realistic hair edits that show how this hairstyle would look on this specific person ");
    sb.write("while keeping everything else completely unchanged from the original reference images.");

    return sb.toString();
  }
}
