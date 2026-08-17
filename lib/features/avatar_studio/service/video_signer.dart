import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../../../core/security/enclave_service.dart';

/// Handles cryptographic signing of video content to ensure authenticity.
/// Interfaces with the Hardware Enclave (Ora) via EnclaveService.
class VideoSigner {
  final EnclaveService _enclave = EnclaveService();

  /// Signs the video bytes using a hardware-bound key.
  /// Requires biometric authentication from the user.
  Future<String?> signContent(Uint8List bytes) async {
    // We delegate the signing to the EnclaveService which handles
    // the hardware interactions and biometric gatekeeping.
    return await _enclave.signWithBiometrics(bytes);
  }

  /// Verifies a signature against the content.
  /// Note: In production, the backend platform would perform this verification.
  Future<bool> verifySignature(Uint8List bytes, String signature) async {
    // Mock verification for local testing
    final signed = await _enclave.signWithBiometrics(bytes);
    return signature == signed;
  }
}
