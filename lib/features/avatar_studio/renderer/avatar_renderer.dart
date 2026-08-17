import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../tracker/camera_tracker.dart';
import '../model/avatar_rig.dart';
import 'mesh_painter.dart';
import 'mesh_deformer.dart';
import '../../../core/math/avatar_physics.dart';

class AvatarRenderer extends StatefulWidget {
  final FaceData faceData;

  const AvatarRenderer({super.key, required this.faceData});

  @override
  State<AvatarRenderer> createState() => _AvatarRendererState();
}

class _AvatarRendererState extends State<AvatarRenderer> {
  AvatarRig? _rig;
  final Map<String, ui.Image> _images = {};
  bool _isLoading = true;
  
  // Physics engine for hair sway
  final PhysicsManager _physics = PhysicsManager();

  @override
  void initState() {
    super.initState();
    _physics.addGroup('hair', stiffness: 0.2, friction: 0.9);
    _loadAssets();
  }

  Future<void> _loadAssets() async {
    _rig = AvatarRig.prototype();
    
    try {
      for (var layer in _rig!.layers) {
        if (_images.containsKey(layer.assetPath)) continue;
        final data = await rootBundle.load(layer.assetPath);
        final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
        final frame = await codec.getNextFrame();
        _images[layer.assetPath] = frame.image;
      }
    } catch (e) {
      debugPrint("Asset load failed: $e. Prototype assets missing in folder.");
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Update Physics based on head rotation
    final double hairSway = _physics.updateGroup('hair', widget.faceData.headYaw * 0.01);

    return Stack(
      children: _rig!.layers.map((layer) {
        // Create a copy of vertices to deform
        final deformedVertices = Float32List.fromList(layer.vertices);

        // Apply Deformations based on type
        switch (layer.deformType) {
          case DeformType.head:
            MeshDeformer.applyHeadRotation(
              deformedVertices, 
              widget.faceData.headYaw, 
              widget.faceData.headPitch
            );
            break;
          case DeformType.mouth:
            MeshDeformer.deformMouth(deformedVertices, widget.faceData.mouthOpenRatio);
            break;
          case DeformType.eye:
            // Placeholder blink logic: link to head pitch or just stay open
            MeshDeformer.deformEye(deformedVertices, 1.0); 
            break;
          case DeformType.hair:
            MeshDeformer.applySway(deformedVertices, hairSway, 50.0);
            break;
          case DeformType.static:
            break;
        }

        return Positioned(
          left: MediaQuery.of(context).size.width / 2 + layer.basePosition.dx,
          top: MediaQuery.of(context).size.height / 2 + layer.basePosition.dy,
          child: CustomPaint(
            size: layer.size,
            painter: MeshPainter(
              image: _images[layer.assetPath],
              vertices: deformedVertices,
              textureCoordinates: layer.uvs,
              indices: layer.indices,
            ),
          ),
        );
      }).toList(),
    );
  }
}
