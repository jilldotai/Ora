import 'package:flutter/material.dart';
import '../service/social_upload_service.dart';
import '../../../core/theme/app_theme.dart';

class PostCreationScreen extends StatefulWidget {
  final String videoPath;
  final String userDID;
  final String vc;

  const PostCreationScreen({
    super.key,
    required this.videoPath,
    required this.userDID,
    required this.vc,
  });

  @override
  State<PostCreationScreen> createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  final SocialUploadService _uploadService = SocialUploadService();
  bool _isUploading = false;

  Future<void> _handleUpload() async {
    setState(() => _isUploading = true);

    // This triggers the real system Biometric Prompt
    final success = await _uploadService.uploadPost(
      videoPath: widget.videoPath,
      userDID: widget.userDID,
      verifiableCredential: widget.vc,
    );

    if (mounted) {
      setState(() => _isUploading = false);
      if (success) {
        _showSuccessDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Upload Failed. Authentication is required to sign content."),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.greenAccent),
            SizedBox(width: 10),
            Text("Content Verified", style: TextStyle(color: Colors.white)),
          ],
        ),
        content: const Text(
          "Your video has been cryptographically signed by your device and uploaded anonymously. Your privacy is safe.",
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Back to studio
            },
            child: const Text("Awesome", style: TextStyle(color: AppTheme.cyberCyan)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Hardware Identity Check"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Security Visualization
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: _isUploading ? null : 1.0,
                    color: _isUploading ? AppTheme.cyberCyan : Colors.greenAccent.withValues(alpha: 0.3),
                    strokeWidth: 2,
                  ),
                ),
                Icon(
                  _isUploading ? Icons.fingerprint : Icons.shield_rounded,
                  color: _isUploading ? AppTheme.cyberCyan : Colors.greenAccent,
                  size: 80,
                ),
              ],
            ),
            const SizedBox(height: 48),
            Text(
              _isUploading ? "Authenticating with Enclave..." : "Ready to Sign",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              "We use your phone's Secure Element to prove you are the real creator without revealing who you are.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 48),
            if (!_isUploading)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _handleUpload,
                  icon: const Icon(Icons.lock_open_rounded),
                  label: const Text("USE BIOMETRICS TO SIGN"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.cyberCyan,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
