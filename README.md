# IOkT - Privacy-Preserving VTuber Platform for Minors

**IOkT** is a decentralized, offline-first avatar creation and social media application designed specifically for children. It enables users to create high-quality "Anime" style VTuber content while maintaining absolute identity privacy through hardware-bound cryptographic security and decentralized verification.

## 🚀 Key Features

### 1. High-Performance 2D Mesh Engine
Unlike traditional heavy 3D engines, IOkT uses a custom-built, lightweight **2D Mesh Rendering Engine**.
- **GPU Accelerated**: Uses Flutter's low-level `canvas.drawVertices` for smooth 60fps performance on entry-level Android devices.
- **Dynamic Deformation**: Supports real-time mouth stretching for speech and smooth eye blinking.
- **Professional Physics**: Includes a pendulum-based physics system for natural hair sway and movement inertia, inspired by professional Live2D models.

### 2. Jitter-Free AI Tracking
- **MLKit Integration**: Optimized face tracking using Google MLKit for low battery consumption.
- **One Euro Filter**: Advanced signal processing that eliminates the "shaking" common in mobile face tracking, providing a premium, steady feel.
- **Tiered Tracking**: Automatically scales tracking complexity based on the device's hardware capabilities.

### 3. Decentralized Child Safety (Ora Framework)
Following the principles of the **Ora Framework**, IOkT implements a "Safety-by-Design" architecture.
- **Identity Triad**: A user's identity is a composite of their **3D Face Mesh**, **Avatar ID**, and a **Hardware-Bound Public Key**.
- **Hardware Enclave (TEE)**: Private keys are generated inside the phone's Secure Element (StrongBox/Keystore) and are non-exportable.
- **Biometric Gating**: All content signing requires local biometric authentication (Face ID or Fingerprint).
- **Privacy Pass (VOPRF)**: Anonymous token redemption ensures that a minor's network traffic cannot be correlated to their identity by ISPs or the platform.

### 4. Verified Content Creation
- **Video Signing**: Every video is cryptographically signed by the hardware enclave at the moment of recording. This proves the content was created live within the trusted app environment, preventing deepfakes or unauthorized uploads.
- **Identity Lock-In**: Upon first sign-up, the app "locks" the user's identity and cleans up unused assets to save space and ensure identity uniqueness.

---

## 🛠 Project Structure

- `lib/core/math/`: Smoothing filters (One Euro) and physics engine.
- `lib/core/security/`: Interfaces for the Hardware Enclave and biometric auth.
- `lib/features/avatar_studio/`: The core VTuber renderer and tracking logic.
- `lib/features/auth/`: Offline sign-up and identity generation.
- `lib/features/social_media/`: Verified upload services and Privacy Pass integration.
- `assets/avatar/prototype/`: Location for your layered PNG assets.

---

## 📋 Requirements to Run

### Environment
- **Flutter SDK**: `>= 3.12.0`
- **Dart SDK**: `>= 3.0.0`
- **Android SDK**: `compileSdk 34`, `minSdk 21`

### Hardware
- **Android Device**: Physical device recommended for Camera and Biometric features.
- **Biometrics**: Device must have a functioning Fingerprint or Face sensor.
- **Hardware Enclave**: Supports devices with TEE (Trusted Execution Environment) or StrongBox (Secure Element).

### Asset Setup
Ensure your character assets are placed in `assets/avatar/prototype/` with the following naming convention:
- `head_base.png`
- `body_base.png`
- `eye_left.png` / `eye_right.png`
- `mouth_open.png`
- `hair_front.png` / `hair_back.png`
- `hand_left.png` / `hand_right.png`

---

## 🛠 Setup & Installation

1.  **Clone the repository**.
2.  **Run Pub Get**:
    ```bash
    flutter pub get
    ```
3.  **Run the App**:
    ```bash
    flutter run
    ```

---

## 🔒 Security Note
This application never transmits raw biometric data or face mesh points. All identity verification is handled through cryptographic hashes and zero-knowledge principles, ensuring that children's data remains private and sovereign on their own devices.
