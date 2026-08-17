import 'dart:math';
import 'dart:typed_data';
import 'package:vector_math/vector_math_64.dart';

/// Handles the math for "bending" 2D layers based on face tracking.
class MeshDeformer {
  /// Deforms a mouth mesh based on mouthOpenRatio (0.0 to 1.0)
  static void deformMouth(Float32List vertices, double ratio) {
    if (vertices.length < 8) return;
    
    // quad vertices: 0(TL), 1(TR), 2(BL), 3(BR)
    // vertices: [x0, y0, x1, y1, x2, y2, x3, y3]
    double stretch = ratio * 30.0; 
    vertices[5] += stretch; // BL Y
    vertices[7] += stretch; // BR Y
  }

  /// Silky smooth eye blink by scaling the mesh Y-axis
  static void deformEye(Float32List vertices, double openRatio) {
    if (vertices.length < 8) return;
    
    // Move top vertices down towards bottom vertices
    // openRatio 1.0 = Fully open, 0.0 = Closed
    double height = (vertices[5] - vertices[1]).abs();
    double offset = height * (1.0 - openRatio);
    
    vertices[1] += offset; // TL Y
    vertices[3] += offset; // TR Y
  }

  /// Applies sway to a mesh (hair/clothes) based on physics output
  static void applySway(Float32List vertices, double swayAmount, double intensity) {
    // Sway usually affects the bottom vertices more than the top
    // For a simple quad, move the bottom vertices left/right
    if (vertices.length >= 8) {
      double move = swayAmount * intensity;
      vertices[4] += move; // BL X
      vertices[6] += move; // BR X
    }
  }

  /// Applies 2.5D perspective to the head based on Yaw/Pitch
  static void applyHeadRotation(Float32List vertices, double yaw, double pitch) {
    final matrix = Matrix4.identity();
    
    // Convert degrees to radians
    double yawRad = yaw * pi / 180;
    double pitchRad = pitch * pi / 180;

    // Apply rotation
    matrix.rotateY(yawRad * 0.5); // Dampen for subtle effect
    matrix.rotateX(-pitchRad * 0.5);

    for (int i = 0; i < vertices.length; i += 2) {
      final v = Vector3(vertices[i], vertices[i + 1], 0);
      final transformed = matrix.transform3(v);
      vertices[i] = transformed.x;
      vertices[i + 1] = transformed.y;
    }
  }
}
