import 'dart:io';
import 'package:flutter/material.dart';
import '../models/hairstyle_preference.dart';
import 'processing_screen.dart';

class PreferenceScreen extends StatefulWidget {
  final File frontPhoto;
  final File sidePhoto;
  final File? fullBodyPhoto;

  const PreferenceScreen({
    super.key,
    required this.frontPhoto,
    required this.sidePhoto,
    this.fullBodyPhoto,
  });

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  final HairstylePreference _preference = HairstylePreference();
  final TextEditingController _customRequestController =
      TextEditingController();

  @override
  void dispose() {
    _customRequestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Preferences')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle('Hair Length'),
            Wrap(
              spacing: 8.0,
              children: HairLength.values.map((length) {
                return ChoiceChip(
                  label: Text(length.toString().split('.').last),
                  selected: _preference.length == length,
                  onSelected: (selected) {
                    setState(() {
                      _preference.length = selected ? length : null;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Style Type (Select multiple)'),
            Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: StyleType.values.map((style) {
                final isSelected = _preference.selectedStyles.contains(style);
                return FilterChip(
                  label: Text(style.toString().split('.').last),
                  selected: isSelected,
                  onSelected: (selected) {
                    setState(() {
                      if (selected) {
                        _preference.selectedStyles.add(style);
                      } else {
                        _preference.selectedStyles.remove(style);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Additional Preferences'),
            _buildCheckboxList([
              'Clean/Professional Look',
              'Edgy/Modern',
              'Classic/Timeless',
              'Low Maintenance',
              'High Maintenance OK',
            ]),
            const SizedBox(height: 24),
            _buildSectionTitle('Specific Requests (Optional)'),
            TextField(
              controller: _customRequestController,
              decoration: const InputDecoration(
                hintText: 'Any specific requests or styles you like?',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _preference.customRequest = _customRequestController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProcessingScreen(
                        frontPhoto: widget.frontPhoto,
                        sidePhoto: widget.sidePhoto,
                        fullBodyPhoto: widget.fullBodyPhoto,
                        preferences: _preference,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Generate Hairstyles'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCheckboxList(List<String> options) {
    return Column(
      children: options.map((option) {
        return CheckboxListTile(
          title: Text(option),
          value: _preference.additionalPreferences.contains(option),
          onChanged: (bool? value) {
            setState(() {
              if (value == true) {
                _preference.additionalPreferences.add(option);
              } else {
                _preference.additionalPreferences.remove(option);
              }
            });
          },
          dense: true,
          contentPadding: EdgeInsets.zero,
        );
      }).toList(),
    );
  }
}
