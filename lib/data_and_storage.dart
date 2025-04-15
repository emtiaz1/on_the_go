import 'package:flutter/material.dart';

class StoragePage extends StatefulWidget {
  const StoragePage({super.key});

  @override
  State<StoragePage> createState() => _StoragePageState();
}

class _StoragePageState extends State<StoragePage> {
  Color lightSkyBlue = const Color(0xFFE6F7FF);
  Color primaryBlue = const Color(0xFF007AFF);
  Color accentBlue = const Color(0xFF4DA6FF);

  // State variables for switches
  bool _mobileData = false;
  bool _wifi = false;
  bool _roaming = false;
  bool _privateChats = false;
  bool _groups = false;
  bool _channels = false;

  // State variable for media upload quality
  String _mediaUploadQuality = "Standard quality";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightSkyBlue,
      appBar: AppBar(
        backgroundColor: primaryBlue,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Storage and Data',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Top Storage Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Storage Used",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("2.8 GB Used",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text("24 GB Free",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.75,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(accentBlue),
                    minHeight: 10,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: const [
                    Icon(Icons.circle, size: 12, color: Colors.green),
                    SizedBox(width: 6),
                    Text("On The Go (2.8 GB)"),
                    SizedBox(width: 16),
                    Icon(Icons.circle, size: 12, color: Colors.amber),
                    SizedBox(width: 6),
                    Text("Other apps (87 GB)"),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Media Upload Quality Section
          GestureDetector(
            onTap: () => _showMediaUploadQualityDialog(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.hd, color: Colors.black),
                      SizedBox(width: 12),
                      Text(
                        "Media upload quality",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _mediaUploadQuality,
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      const Icon(Icons.settings, size: 16, color: Colors.grey),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Data and Auto-download Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Data Usage",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text("Total Data Used"),
                    Text("14.58 GB", style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
                const Divider(height: 24),
                const Text("Automatic media download",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _rowSwitch("When using mobile data", _mobileData, (val) {
                  setState(() => _mobileData = val);
                }),
                _rowSwitch("When connected to Wi-Fi", _wifi, (val) {
                  setState(() => _wifi = val);
                }),
                _rowSwitch("When roaming", _roaming, (val) {
                  setState(() => _roaming = val);
                }),
                const SizedBox(height: 8),
                Center(
                  child: TextButton(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      backgroundColor: Colors.red[50],
                      foregroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    onPressed: () {
                      setState(() {
                        _mobileData = false;
                        _wifi = false;
                        _roaming = false;
                      });
                    },
                    child: const Text("Reset Auto-Download Settings"),
                  ),
                ),
                const Divider(height: 24),
                const Text("Save to Gallery",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _rowSwitch("Images", _privateChats, (val) {
                  setState(() => _privateChats = val);
                }),
                _rowSwitch("Videos", _groups, (val) {
                  setState(() => _groups = val);
                }),
                _rowSwitch("Files", _channels, (val) {
                  setState(() => _channels = val);
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rowSwitch(String title, bool currentValue, Function(bool) onChanged) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
            ),
            Switch(
              value: currentValue,
              onChanged: onChanged,
              activeColor: primaryBlue,
              inactiveThumbColor: Colors.grey[300],
              inactiveTrackColor: Colors.grey[200],
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
        const Divider(),
      ],
    );
  }

  void _showMediaUploadQualityDialog(BuildContext context) {
    String selectedQuality = _mediaUploadQuality; // Initialize with the current value

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFE6F7FF), // Whitish-blue background color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              title: const Text(
                "Media upload quality",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Select the quality for photos and videos to be sent in chats.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 16),
                  RadioListTile<String>(
                    value: "Standard quality",
                    groupValue: selectedQuality,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedQuality = value!; // Update the selected quality in the dialog
                      });
                    },
                    title: const Text("Standard quality"),
                    subtitle: const Text("Faster to send, smaller file size"),
                    activeColor: Colors.blue, // Active color for the radio button
                  ),
                  RadioListTile<String>(
                    value: "HD quality",
                    groupValue: selectedQuality,
                    onChanged: (value) {
                      setDialogState(() {
                        selectedQuality = value!; // Update the selected quality in the dialog
                      });
                    },
                    title: const Text("HD quality"),
                    subtitle: const Text("Slower to send, can be 6 times larger"),
                    activeColor: Colors.blue, // Active color for the radio button
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Cancel",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _mediaUploadQuality = selectedQuality; // Update the main state variable
                    });
                    Navigator.pop(context); // Close the dialog
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
