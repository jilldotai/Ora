import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// The high-performance core of our 2D VTuber.
/// Uses GPU-accelerated vertex drawing to deform PNG assets.
class MeshPainter extends CustomPainter {
  final ui.Image? image;
  
  // Flattened arrays for performance (X, Y, X, Y...)
  final Float32List vertices;
  final Float32List textureCoordinates;
  final Uint16List indices;

  MeshPainter({
    required this.image,
    required this.vertices,
    required this.textureCoordinates,
    required this.indices,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (image == null || vertices.isEmpty) return;

    final paint = Paint()
      ..filterQuality = FilterQuality.low; // Optimization for entry-level Androids

    // We use Vertices.raw to avoid copying data from Dart to the Engine
    final uiVertices = ui.Vertices.raw(
      ui.VertexMode.triangles,
      vertices,
      textureCoordinates: textureCoordinates,
      indices: indices,
    );

    // Create a shader from the image to map it onto the vertices
    paint.shader = ImageShader(
      image!,
      TileMode.clamp,
      TileMode.clamp,
      Float64List.fromList(Matrix4.identity().storage),
    );

    canvas.drawVertices(uiVertices, BlendMode.srcOver, paint);
  }

  @override
  bool shouldRepaint(covariant MeshPainter oldDelegate) {
    // We repaint whenever the vertices (movements) change
    return true; 
  }
}
