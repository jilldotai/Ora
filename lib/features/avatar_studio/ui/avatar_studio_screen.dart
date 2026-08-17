import 'package:flutter/material.dart';
import '../tracker/camera_tracker.dart';
import '../renderer/avatar_renderer.dart';

class AvatarStudioScreen extends StatefulWidget {
  const AvatarStudioScreen({super.key});

  @override
  State<AvatarStudioScreen> createState() => _AvatarStudioScreenState();
}

class _AvatarStudioScreenState extends State<AvatarStudioScreen> {
  FaceData? _currentFaceData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Bottom Layer: The live camera (Hidden or previewed)
          Opacity(
            opacity: 0.3, // Dim the camera so the avatar pops
            child: CameraTracker(
              onFaceTracked: (data) {
                setState(() {
                  _currentFaceData = data;
                });
              },
            ),
          ),

          // Middle Layer: The 2D Mesh Avatar
          if (_currentFaceData != null)
            AvatarRenderer(faceData: _currentFaceData!),

          // Top Layer: UI Controls (Record button, etc.)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Text(
                  "Face Tracked: Live",
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
