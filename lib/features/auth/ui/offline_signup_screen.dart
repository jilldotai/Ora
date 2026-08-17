import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../avatar_studio/service/identity_service.dart';
import '../../avatar_studio/tracker/camera_tracker.dart';
import '../../avatar_studio/ui/avatar_studio_screen.dart';

class OfflineSignupScreen extends StatefulWidget {
  const OfflineSignupScreen({super.key});

  @override
  State<OfflineSignupScreen> createState() => _OfflineSignupScreenState();
}

class _OfflineSignupScreenState extends State<OfflineSignupScreen> {
  final IdentityService _identityService = IdentityService();
  int _currentStep = 0;
  final String _selectedAvatar = "prototype";
  bool _isCapturing = false;
  FaceData? _capturedData;

  void _nextStep() {
    setState(() => _currentStep++);
  }

  Future<void> _finalizeIdentity() async {
    if (_capturedData == null) return;

    setState(() => _isCapturing = true);

    // Generate the triad identity
    await _identityService.generateUserDID(
      faceMeshPoints: _capturedData!.identityMesh,
      avatarId: _selectedAvatar,
    );

    // Lock in assets
    await _identityService.lockInIdentity(_selectedAvatar);

    if (mounted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const AvatarStudioScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: _currentStep == 1 ? CrossAxisAlignment.center : CrossAxisAlignment.start,
            children: [
              _buildProgressHeader(),
              const SizedBox(height: 40),
              Expanded(
                child: _currentStep == 0 ? _buildAvatarSelection() : _buildFaceCapture(),
              ),
              const SizedBox(height: 24),
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Row(
      children: [
        _progressDot(active: true),
        const SizedBox(width: 8),
        _progressDot(active: _currentStep >= 1),
        const Spacer(),
        Text(
          _currentStep == 0 ? "Step 1: Choose Avatar" : "Step 2: Secure Identity",
          style: const TextStyle(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _progressDot({required bool active}) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: active ? AppTheme.cyberCyan : Colors.white12,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Who will you be?",
          style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "Select your starting avatar. This will be your identity on the platform.",
          style: TextStyle(color: Colors.white60, fontSize: 16),
        ),
        const SizedBox(height: 40),
        Center(
          child: Container(
            width: 240,
            height: 320,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.cyberCyan, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.asset(
                'assets/avatar/prototype/body_base.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        const Center(
          child: Text(
            "Prototype Alpha",
            style: TextStyle(color: AppTheme.cyberCyan, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildFaceCapture() {
    return Column(
      children: [
        const Text(
          "Capture Your Unique Mesh",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        const Text(
          "Look directly at the camera. We use your face shape to create a unique ID that only works on this phone.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white60, fontSize: 14),
        ),
        const SizedBox(height: 32),
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: _capturedData != null ? Colors.greenAccent : Colors.white24),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: CameraTracker(
                onFaceTracked: (data) {
                  if (_capturedData == null || data.identityMesh.length > _capturedData!.identityMesh.length) {
                    setState(() => _capturedData = data);
                  }
                },
              ),
            ),
          ),
        ),
        if (_capturedData != null)
          const Padding(
            padding: EdgeInsets.only(top: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
                SizedBox(width: 8),
                Text("Identity Mesh Ready", style: TextStyle(color: Colors.greenAccent)),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFooter() {
    if (_isCapturing) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.cyberCyan));
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _currentStep == 0 
            ? _nextStep 
            : (_capturedData != null ? _finalizeIdentity : null),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.cyberCyan,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.white10,
        ),
        child: Text(
          _currentStep == 0 ? "SELECT AVATAR" : "SECURE MY IDENTITY",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }
}
