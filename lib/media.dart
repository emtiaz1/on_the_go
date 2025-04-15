import 'package:flutter/material.dart';

class MediaPage extends StatefulWidget {
  const MediaPage({super.key});

  @override
  State<MediaPage> createState() => _MediaPageState();
}

class _MediaPageState extends State<MediaPage> {
  // State variables for toggles
  bool _optimized = true;
  bool _dataSaver = false;
  String _autoplayOption = "On mobile data and Wi-Fi";
  bool _videosStartWithSound = false;
  bool _reduce3DPhotoMotion = false;
  bool _soundsInApp = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF3F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF104C91),
        title: const Text(
          'Media',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/back.png',
            color: Colors.white,
            height: 24,
          ),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          // Video Quality Section
          _buildSectionTitle("Video quality"),
          _buildSubtitle(
              "Manage your default video quality and the amount of cellular data you use with the following options."),
          _buildContainer(
            child: _buildCheckboxOption(
              title: "Optimized",
              subtitle: "Adjust videos to network conditions",
              value: _optimized,
              onChanged: (value) {
                setState(() {
                  _optimized = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildContainer(
            child: _buildCheckboxOption(
              title: "Data saver",
              subtitle: "Use up to 40% less data by reducing video quality",
              value: _dataSaver,
              onChanged: (value) {
                setState(() {
                  _dataSaver = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // Autoplay Section
          _buildSectionTitle("Autoplay"),
          _buildContainer(
            child: _buildRadioOption(
              title: "On mobile data and Wi-Fi",
              groupValue: _autoplayOption,
              onChanged: (value) {
                setState(() {
                  _autoplayOption = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildContainer(
            child: _buildRadioOption(
              title: "On Wi-Fi only",
              groupValue: _autoplayOption,
              onChanged: (value) {
                setState(() {
                  _autoplayOption = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildContainer(
            child: _buildRadioOption(
              title: "Never Autoplay Videos",
              groupValue: _autoplayOption,
              onChanged: (value) {
                setState(() {
                  _autoplayOption = value!;
                });
              },
            ),
          ),
          _buildSubtitle(
              "When your battery is low videos stop playing automatically."),
          const SizedBox(height: 16),

          // Other Settings Section
          _buildContainer(
            child: _buildCheckboxOption(
              title: "Videos start with sound",
              value: _videosStartWithSound,
              onChanged: (value) {
                setState(() {
                  _videosStartWithSound = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          _buildSectionTitle("Video and photo settings"),
          _buildContainer(
            child: _buildCheckboxOption(
              title: "Reduce 3D photo motion",
              value: _reduce3DPhotoMotion,
              onChanged: (value) {
                setState(() {
                  _reduce3DPhotoMotion = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 8),
          _buildContainer(
            child: _buildCheckboxOption(
              title: "Sounds in the app",
              value: _soundsInApp,
              onChanged: (value) {
                setState(() {
                  _soundsInApp = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 16),

          // App Updates Section
          _buildSectionTitle("App updates"),
          _buildSubtitle(
              "Open links in external browser. Links shared in messages will open externally."),
        ],
      ),
    );
  }

  // Helper to build section titles
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black87, // Darker blackish color for better contrast
        ),
      ),
    );
  }

  // Helper to build subtitles
  Widget _buildSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.black54, // Darker gray for better visibility
        ),
      ),
    );
  }

  // Helper to build containers
  Widget _buildContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, // Whitish background
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  // Helper to build checkbox options
  Widget _buildCheckboxOption({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool?> onChanged,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          activeColor: const Color(0xFF007AFF), // Bluish color
          checkColor: Colors.white,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87, // Darker blackish color
                ),
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 13,
                      color:
                          Colors.black54, // Darker gray for better visibility
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // Helper to build radio options
  Widget _buildRadioOption({
    required String title,
    required String groupValue,
    required ValueChanged<String?> onChanged,
  }) {
    return RadioListTile<String>(
      value: title,
      groupValue: groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: Colors.black87, // Darker blackish color
        ),
      ),
      activeColor: const Color(0xFF007AFF), // Bluish color
    );
  }
}
