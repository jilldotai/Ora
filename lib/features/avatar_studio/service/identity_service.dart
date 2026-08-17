import 'dart:convert';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/security/enclave_service.dart';

/// Manages the user's "Avatar Identity" and ensures asset cleanup for privacy and performance.
class IdentityService {
  final EnclaveService _enclave = EnclaveService();
  
  static const String _activeAvatarKey = 'active_avatar_id';
  static const String _userDIDKey = 'user_did';

  /// Generates the Decentralized Identity (DID) triad: FaceMesh + Avatar + HardwareKey.
  Future<String> generateUserDID({
    required List<double> faceMeshPoints,
    required String avatarId,
  }) async {
    // 1. Get the hardware-bound public key
    final pubKey = await _enclave.getOrCreatePublicKey();

    // 2. Normalize face mesh data to a hash
    final meshString = faceMeshPoints.join(',');
    final meshHash = sha256.convert(utf8.encode(meshString)).toString();

    // 3. Combine into the Identity Triad
    final triadData = "mesh:$meshHash|avatar:$avatarId|key:$pubKey";
    final did = "did:ora:${sha256.convert(utf8.encode(triadData))}";

    debugPrint("Generated Decentralized Identity: $did");
    
    // Store it persistently
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userDIDKey, did);
    await prefs.setString(_activeAvatarKey, avatarId);

    return did;
  }

  /// "Locks in" the chosen avatar and deletes all other prototype assets.
  Future<void> lockInIdentity(String avatarId) async {
    debugPrint("Locking in identity for avatar: $avatarId");
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeAvatarKey, avatarId);
    
    await _cleanupLocalAssets(avatarId);
  }

  Future<void> _cleanupLocalAssets(String keepId) async {
    try {
      final appDir = await getApplicationDocumentsDirectory();
      final avatarDir = Directory("${appDir.path}/avatars");
      
      if (await avatarDir.exists()) {
        final List<FileSystemEntity> entities = await avatarDir.list().toList();
        for (var entity in entities) {
          if (entity is Directory && !entity.path.endsWith(keepId)) {
            debugPrint("Deleting unused asset folder: ${entity.path}");
            await entity.delete(recursive: true);
          }
        }
      }
    } catch (e) {
      debugPrint("Asset cleanup failed: $e");
    }
  }

  Future<String?> getActiveAvatarId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeAvatarKey);
  }

  Future<String?> getUserDID() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userDIDKey);
  }
}
