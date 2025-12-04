import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../models/hairstyle_preference.dart';
import '../services/gemini_service.dart';
import 'recommendations_screen.dart';

class ProcessingScreen extends StatefulWidget {
  final File frontPhoto;
  final File sidePhoto;
  final File? fullBodyPhoto;
  final HairstylePreference preferences;

  const ProcessingScreen({
    super.key,
    required this.frontPhoto,
    required this.sidePhoto,
    this.fullBodyPhoto,
    required this.preferences,
  });

  @override
  State<ProcessingScreen> createState() => _ProcessingScreenState();
}

class _ProcessingScreenState extends State<ProcessingScreen> {
  final GeminiService _geminiService = GeminiService();

  @override
  void initState() {
    super.initState();
    _startProcessing();
  }

  Future<void> _startProcessing() async {
    try {
      final imageUrls = await _geminiService.generateHairstyleRecommendations(
        frontPhoto: widget.frontPhoto,
        sidePhoto: widget.sidePhoto,
        fullBodyPhoto: widget.fullBodyPhoto,
        preferences: widget.preferences,
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => RecommendationsScreen(imageUrls: imageUrls),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        // Handle error (show dialog, go back, etc.)
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: Text('Failed to generate recommendations: $e'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Go back to preferences
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitPulse(
              color: Colors.blueAccent,
              size: 80.0,
            ),
            SizedBox(height: 24),
            Text(
              'AI is generating your hairstyle recommendations...',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8),
            Text(
              'This usually takes 30-60 seconds',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
