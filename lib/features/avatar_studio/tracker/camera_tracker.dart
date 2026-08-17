// lib/features/avatar_studio/tracker/camera_tracker.dart
import 'package:flutter/material.dart' show BuildContext, Center, CircularProgressIndicator, Offset, Size, State, StatefulWidget, Widget;
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/math/one_euro_filter.dart';

class FaceData {
  final Offset nose;
  final Offset leftEye;
  final Offset rightEye;
  final double mouthOpenRatio;
  final double headYaw; 
  final double headPitch; 
  final List<double> identityMesh; // Captured landmarks for unique identity triad

  FaceData({
    required this.nose,
    required this.leftEye,
    required this.rightEye,
    this.mouthOpenRatio = 0.0,
    this.headYaw = 0.0,
    this.headPitch = 0.0,
    this.identityMesh = const [],
  });
}

class CameraTracker extends StatefulWidget {
  final Function(FaceData)? onFaceTracked;

  const CameraTracker({super.key, this.onFaceTracked});

  @override
  State<CameraTracker> createState() => _CameraTrackerState();
}

class _CameraTrackerState extends State<CameraTracker> {
  CameraController? _controller;
  
  // Smoothing Filters
  final OffsetFilter _noseFilter = OffsetFilter(mincutoff: 0.5, beta: 0.01);
  final OneEuroFilter _mouthFilter = OneEuroFilter(mincutoff: 1.0, beta: 0.1);

  final FaceDetector _faceDetector = FaceDetector(
    options: FaceDetectorOptions(
      enableLandmarks: true,
      enableClassification: true, // For blinking
      performanceMode: FaceDetectorMode.fast,
    ),
  );

  bool _isBusy = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _controller = CameraController(frontCamera, ResolutionPreset.low, enableAudio: false);

    await _controller!.initialize();
    if (!mounted) return;

    final controller = _controller;
    if (controller == null) return;

    // THE BRIDGE: Start streaming frames to the AI
    controller.startImageStream((CameraImage image) {
      if (_isBusy) return;
      _isBusy = true;
      _processCameraFrame(image);
    });

    setState(() {});
  }

  Future<void> _processCameraFrame(CameraImage image) async {
    // Note: Converting CameraImage to InputImage for MLKit requires rotation math.
    // For this quick prototype, we assume default portrait orientation.
    final inputImage = InputImage.fromBytes(
      bytes: image.planes[0].bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: InputImageRotation.rotation270deg, // Standard front camera rotation
        format: InputImageFormat.nv21,
        bytesPerRow: image.planes[0].bytesPerRow,
      ),
    );

    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isNotEmpty) {
      final face = faces.first;
      final nose = face.landmarks[FaceLandmarkType.noseBase];
      final leftEye = face.landmarks[FaceLandmarkType.leftEye];
      final rightEye = face.landmarks[FaceLandmarkType.rightEye];
      
      // Calculate Mouth Opening (Simplified for now)
      // On mid-range Androids, we'll use the bounding box or specific lip landmarks
      double mouthRatio = 0.0;
      if (face.smilingProbability != null) {
        mouthRatio = 1.0 - face.smilingProbability!;
      }

      if (nose != null && leftEye != null && rightEye != null) {
        final rawNose = Offset(nose.position.x.toDouble(), nose.position.y.toDouble());
        
        // APPLY SMOOTHING
        final smoothNose = _noseFilter.filter(rawNose);
        final smoothMouth = _mouthFilter.filter(mouthRatio);

        // Captured landmarks for the Identity Triad
        final List<double> mesh = face.landmarks.values
            .whereType<FaceLandmark>()
            .expand((l) => [l.position.x.toDouble(), l.position.y.toDouble()])
            .toList();

        widget.onFaceTracked?.call(FaceData(
          nose: smoothNose,
          leftEye: Offset(leftEye.position.x.toDouble(), leftEye.position.y.toDouble()),
          rightEye: Offset(rightEye.position.x.toDouble(), rightEye.position.y.toDouble()),
          mouthOpenRatio: smoothMouth,
          headYaw: face.headEulerAngleY ?? 0.0,
          headPitch: face.headEulerAngleX ?? 0.0,
          identityMesh: mesh,
        ));
      }
    }

    _isBusy = false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(color: AppTheme.cyberCyan));
    }

    return CameraPreview(controller);
  }
}
