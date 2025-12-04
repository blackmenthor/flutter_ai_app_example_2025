import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../services/image_service.dart';
import '../services/permission_service.dart';

class CompletionScreen extends StatelessWidget {
  final String selectedImageUrl;
  final ImageService _imageService = ImageService();
  final PermissionService _permissionService = PermissionService();

  CompletionScreen({super.key, required this.selectedImageUrl});

  Future<void> _saveToGallery(BuildContext context) async {
    bool hasPermission = await _permissionService.requestStoragePermission();
    if (!hasPermission) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Storage permission denied')),
        );
      }
      return;
    }

    // Since it's a URL, we might need to download it first.
    // GallerySaver.saveImage usually takes a file path or URL.
    // The instructions mentioned GallerySaver.

    // Note: GallerySaver.saveImage handles URLs too.

    bool success = await _imageService.saveImageToGallery(selectedImageUrl);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success ? 'Saved to gallery!' : 'Failed to save image'),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Saved!')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 16),
            const Text(
              'Your new look is ready!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: selectedImageUrl,
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => _saveToGallery(context),
              icon: const Icon(Icons.download),
              label: const Text('Save to Gallery'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: () {
                // Navigate back to instructions or home
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('Start Over'),
            ),
          ],
        ),
      ),
    );
  }
}
