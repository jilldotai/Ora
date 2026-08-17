/// Represents a verified social media post created by a minor.
class Post {
  final String id;
  final String videoPath;
  final String userDID;
  final String signature;
  final DateTime timestamp;
  
  // Verifiable Credential (mocked as a string) that proves age/guardianship
  final String verifiableCredential;

  Post({
    required this.id,
    required this.videoPath,
    required this.userDID,
    required this.signature,
    required this.timestamp,
    required this.verifiableCredential,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'video_path': videoPath,
      'user_did': userDID,
      'signature': signature,
      'timestamp': timestamp.toIso8601String(),
      'vc': verifiableCredential,
    };
  }
}
