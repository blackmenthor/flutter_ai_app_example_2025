import 'dart:io';
import 'dart:typed_data';

import 'package:gal/gal.dart';
import 'package:http/http.dart' as http;
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

  Future<bool> saveImageToGallery(String pathOrUrl) async {
    try {
      // Check/Request permission using Gal
      // Gal handles the platform specific permissions (like add-only on iOS 14+)
      if (!await Gal.hasAccess()) {
        final granted = await Gal.requestAccess();
        if (!granted) return false;
      }

      if (pathOrUrl.startsWith('http')) {
        // Download image
        final response = await http.get(Uri.parse(pathOrUrl));
        if (response.statusCode == 200) {
          await Gal.putImageBytes(
            Uint8List.fromList(response.bodyBytes),
            name: "hair_ai_${DateTime.now().millisecondsSinceEpoch}",
          );
          return true;
        } else {
          return false;
        }
      } else {
        // Local file
        await Gal.putImage(pathOrUrl);
        return true;
      }
    } catch (e) {
      print('Error saving image: $e');
      return false;
    }
  }
}
