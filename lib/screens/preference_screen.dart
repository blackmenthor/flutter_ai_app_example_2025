import 'dart:io';
import 'package:flutter/material.dart';
import '../models/hairstyle_preference.dart';
import 'processing_screen.dart';

class PreferenceScreen extends StatefulWidget {
  final File frontPhoto;
  final File sidePhoto;

  const PreferenceScreen({
    super.key,
    required this.frontPhoto,
    required this.sidePhoto,
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
            _buildHairLengthGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('Style Type (Select multiple)'),
            _buildStyleTypeGrid(),
            const SizedBox(height: 24),
            _buildSectionTitle('Additional Preferences'),
            _buildEnhancedCheckboxList([
              {'title': 'Clean/Professional Look', 'desc': 'Neat, business-appropriate styles', 'icon': Icons.business_center},
              {'title': 'Edgy/Modern', 'desc': 'Trendy, contemporary cuts', 'icon': Icons.auto_awesome},
              {'title': 'Classic/Timeless', 'desc': 'Traditional, never goes out of style', 'icon': Icons.history},
              {'title': 'Low Maintenance', 'desc': 'Minimal styling required', 'icon': Icons.schedule},
              {'title': 'High Maintenance OK', 'desc': 'Willing to style daily', 'icon': Icons.style},
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

  Widget _buildEnhancedCheckboxList(List<Map<String, dynamic>> options) {
    return Column(
      children: options.map((option) {
        final title = option['title'] as String;
        final desc = option['desc'] as String;
        final icon = option['icon'] as IconData;
        final isSelected = _preference.additionalPreferences.contains(title);
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: InkWell(
            onTap: () {
              setState(() {
                if (isSelected) {
                  _preference.additionalPreferences.remove(title);
                } else {
                  _preference.additionalPreferences.add(title);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[50],
                border: Border.all(
                  color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    icon,
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600],
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          desc,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Theme.of(context).primaryColor : Colors.grey[400]!,
                        width: 2,
                      ),
                      color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 12)
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildHairLengthGrid() {
    final lengthData = {
      HairLength.veryShort: {'name': 'Very Short', 'image': 'assets/images/hair_lengths/very_short.jpg', 'desc': 'Buzz cut style'},
      HairLength.short: {'name': 'Short', 'image': 'assets/images/hair_lengths/short.jpg', 'desc': 'Classic short cut'},
      HairLength.medium: {'name': 'Medium', 'image': 'assets/images/hair_lengths/medium.jpg', 'desc': 'Versatile length'},
      HairLength.long: {'name': 'Long', 'image': 'assets/images/hair_lengths/long.jpg', 'desc': 'Shoulder length'},
      HairLength.veryLong: {'name': 'Very Long', 'image': 'assets/images/hair_lengths/very_long.jpg', 'desc': 'Past shoulders'},
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: HairLength.values.length,
      itemBuilder: (context, index) {
        final length = HairLength.values[index];
        final data = lengthData[length]!;
        final isSelected = _preference.length == length;
        
        return InkWell(
          onTap: () {
            setState(() {
              _preference.length = isSelected ? null : length;
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[100],
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.asset(
                      data['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          data['desc'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[600],
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStyleTypeGrid() {
    final styleData = {
      StyleType.fade: {'name': 'Fade', 'image': 'assets/images/hair_styles/fade.jpg', 'desc': 'Gradual length transition'},
      StyleType.undercut: {'name': 'Undercut', 'image': 'assets/images/hair_styles/undercut.jpg', 'desc': 'Short sides, long top'},
      StyleType.buzzCut: {'name': 'Buzz Cut', 'image': 'assets/images/hair_styles/buzz_cut.jpg', 'desc': 'Very short all over'},
      StyleType.crewCut: {'name': 'Crew Cut', 'image': 'assets/images/hair_styles/crew_cut.jpg', 'desc': 'Short, neat style'},
      StyleType.pompadour: {'name': 'Pompadour', 'image': 'assets/images/hair_styles/pompadour.jpg', 'desc': 'Swept back volume'},
      StyleType.quiff: {'name': 'Quiff', 'image': 'assets/images/hair_styles/quiff.jpg', 'desc': 'Upward styled front'},
      StyleType.slickedBack: {'name': 'Slicked Back', 'image': 'assets/images/hair_styles/slicked_back.jpg', 'desc': 'Smooth, back-combed'},
      StyleType.textured: {'name': 'Textured', 'image': 'assets/images/hair_styles/textured.jpg', 'desc': 'Layered with movement'},
      StyleType.curlyWavy: {'name': 'Curly/Wavy', 'image': 'assets/images/hair_styles/curly_wavy.jpg', 'desc': 'Natural curl pattern'},
      StyleType.naturalMessy: {'name': 'Natural/Messy', 'image': 'assets/images/hair_styles/natural_messy.jpg', 'desc': 'Casual, tousled look'},
    };

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: StyleType.values.length,
      itemBuilder: (context, index) {
        final style = StyleType.values[index];
        final data = styleData[style]!;
        final isSelected = _preference.selectedStyles.contains(style);
        
        return InkWell(
          onTap: () {
            setState(() {
              if (isSelected) {
                _preference.selectedStyles.remove(style);
              } else {
                _preference.selectedStyles.add(style);
              }
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.1) : Colors.grey[100],
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: Image.asset(
                      data['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.image_not_supported, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          data['name'] as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Theme.of(context).primaryColor : Colors.black87,
                            fontSize: 11,
                          ),
                        ),
                        Text(
                          data['desc'] as String,
                          style: TextStyle(
                            fontSize: 9,
                            color: Colors.grey[600],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
