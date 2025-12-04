import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../services/image_service.dart';
import '../services/permission_service.dart';
import 'preference_screen.dart';

class PhotoCaptureScreen extends StatefulWidget {
  const PhotoCaptureScreen({super.key});

  @override
  State<PhotoCaptureScreen> createState() => _PhotoCaptureScreenState();
}

class _PhotoCaptureScreenState extends State<PhotoCaptureScreen> {
  final ImageService _imageService = ImageService();
  final PermissionService _permissionService = PermissionService();

  File? _frontPhoto;
  File? _sidePhoto;

  bool get _canProceed => _frontPhoto != null && _sidePhoto != null;

  Future<void> _pickImage(String type, ImageSource source) async {
    // Check permissions first? image_picker handles it mostly, but good to ensure.
    bool hasPermission = source == ImageSource.camera
        ? await _permissionService.requestCameraPermission()
        : await _permissionService.requestStoragePermission();

    if (!hasPermission) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Permission denied. Please enable in settings.')),
        );
      }
      return;
    }

    final File? image = await _imageService.pickImage(source);
    if (image != null) {
      setState(() {
        if (type == 'front')
          _frontPhoto = image;
        else if (type == 'side')
          _sidePhoto = image;
      });
    }
  }

  void _showImageSourceDialog(String type) {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(type, ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(type, ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Upload Photos')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'We need two photos to analyze your face shape and features.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            _buildPhotoSection('Front Face (Required)', 'front', _frontPhoto),
            _buildPhotoSection('Side Face (Required)', 'side', _sidePhoto),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _canProceed
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreferenceScreen(
                            frontPhoto: _frontPhoto!,
                            sidePhoto: _sidePhoto!,
                          ),
                        ),
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Next: Preferences'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotoSection(String title, String type, File? image) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        InkWell(
          onTap: () => _showImageSourceDialog(type),
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
              image: image != null
                  ? DecorationImage(image: FileImage(image), fit: BoxFit.cover)
                  : null,
            ),
            child: image == null
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                      SizedBox(height: 8),
                      Text('Tap to upload'),
                    ],
                  )
                : null,
          ),
        ),
        if (image != null)
          TextButton(
            onPressed: () => _showImageSourceDialog(type),
            child: const Text('Retake / Reselect'),
          ),
        const SizedBox(height: 16),
      ],
    );
  }
}
