import 'dart:io';

import 'package:firebase_ai/firebase_ai.dart';
import 'package:gal/gal.dart';
import 'package:image_picker/image_picker.dart';

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImage(ImageSource source) async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: source,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (photo != null) {
        return File(photo.path);
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  Future<bool> saveImageToGallery(ImagenInlineImage pathOrUrl) async {
    try {
      // Check/Request permission using Gal
      // Gal handles the platform specific permissions (like add-only on iOS 14+)
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) return false;
      }

      await Gal.putImageBytes(
        pathOrUrl.bytesBase64Encoded,
        name: "hair_ai_${DateTime.now().millisecondsSinceEpoch}",
      );
      return true;
    } catch (e) {
      print('Error saving image: $e');
      return false;
    }
  }
}
