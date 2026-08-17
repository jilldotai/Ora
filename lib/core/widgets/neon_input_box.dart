// lib/core/widgets/neon_input_box.dart
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class NeonInputBox extends StatelessWidget {
  final String hintText;

  const NeonInputBox({super.key, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppTheme.holographicGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.neonGlow,
      ),
      padding: const EdgeInsets.all(2), // 2px glowing border
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.backgroundCharcoal,
          borderRadius: BorderRadius.circular(10),
        ),
        child: TextField(
          style: const TextStyle(color: AppTheme.textPrimary),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            hintText: hintText,
            hintStyle: const TextStyle(color: AppTheme.textSecondary),
          ),
        ),
      ),
    );
  }
}
