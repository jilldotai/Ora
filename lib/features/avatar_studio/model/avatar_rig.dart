import 'package:flutter/material.dart';
import 'dart:typed_data';

enum DeformType { static, head, eye, mouth, hair }

/// Defines how a 2D PNG layer should be "rigged" for movement.
class AvatarLayer {
  final String assetPath;
  final Offset basePosition;
  final Size size;
  final DeformType deformType;
  
  // Mesh Data
  final Float32List vertices;
  final Float32List uvs;
  final Uint16List indices;

  AvatarLayer({
    required this.assetPath,
    required this.basePosition,
    required this.size,
    required this.deformType,
    required this.vertices,
    required this.uvs,
    required this.indices,
  });

  /// Automatically generates a quad mesh for a layer
  factory AvatarLayer.quad({
    required String assetPath,
    required Offset basePosition,
    required Size size,
    DeformType deformType = DeformType.static,
  }) {
    final vertices = Float32List.fromList([
      -size.width / 2, -size.height / 2,
       size.width / 2, -size.height / 2,
      -size.width / 2,  size.height / 2,
       size.width / 2,  size.height / 2,
    ]);

    final uvs = Float32List.fromList([
      0, 0,
      1, 0,
      0, 1,
      1, 1,
    ]);

    final indices = Uint16List.fromList([0, 1, 2, 1, 2, 3]);

    return AvatarLayer(
      assetPath: assetPath,
      basePosition: basePosition,
      size: size,
      deformType: deformType,
      vertices: vertices,
      uvs: uvs,
      indices: indices,
    );
  }
}

/// The "Brain" of the Avatar. 
/// Translates AI Landmarks into Mesh deformations.
class AvatarRig {
  final List<AvatarLayer> layers;

  AvatarRig({required this.layers});

  /// Factory to create a more complete prototype rig using the uploaded assets
  factory AvatarRig.prototype() {
    return AvatarRig(
      layers: [
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/hair_back.png',
          basePosition: const Offset(0, -20),
          size: const Size(250, 300),
          deformType: DeformType.hair,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/body_base.png',
          basePosition: const Offset(0, 180),
          size: const Size(300, 450),
          deformType: DeformType.static,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/head_base.png',
          basePosition: const Offset(0, 0),
          size: const Size(200, 280),
          deformType: DeformType.head,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/eye_left.png',
          basePosition: const Offset(-45, -15),
          size: const Size(40, 40),
          deformType: DeformType.eye,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/eye_right.png',
          basePosition: const Offset(45, -15),
          size: const Size(40, 40),
          deformType: DeformType.eye,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/mouth_open.png',
          basePosition: const Offset(0, 50),
          size: const Size(50, 30),
          deformType: DeformType.mouth,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/hair_front.png',
          basePosition: const Offset(0, -60),
          size: const Size(220, 120),
          deformType: DeformType.hair,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/hand_left.png',
          basePosition: const Offset(-120, 200),
          size: const Size(80, 80),
          deformType: DeformType.static,
        ),
        AvatarLayer.quad(
          assetPath: 'assets/avatar/prototype/hand_right.png',
          basePosition: const Offset(120, 200),
          size: const Size(80, 80),
          deformType: DeformType.static,
        ),
      ],
    );
  }

  factory AvatarRig.placeholder() {
    return AvatarRig.prototype();
  }
}
