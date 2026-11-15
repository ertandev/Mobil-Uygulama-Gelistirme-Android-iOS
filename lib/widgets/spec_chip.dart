import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// İkonlu ve etiketli şık donanım özelliği kutucuğu.
class SpecChip extends StatelessWidget {
  final String label;
  final String value;

  const SpecChip({
    super.key,
    required this.label,
    required this.value,
  });

  IconData _getIconForLabel(String l) {
    final lower = l.toLowerCase();
    if (lower.contains('size') || lower.contains('boyut')) {
      return Icons.straighten_rounded;
    } else if (lower.contains('audio') || lower.contains('ses')) {
      return Icons.graphic_eq_rounded;
    } else if (lower.contains('color') || lower.contains('renk')) {
      return Icons.palette_outlined;
    } else if (lower.contains('chip') || lower.contains('işlemci')) {
      return Icons.memory_rounded;
    } else if (lower.contains('camera') || lower.contains('kamera')) {
      return Icons.photo_camera_outlined;
    } else if (lower.contains('material')) {
      return Icons.verified_outlined;
    }
    return Icons.tune_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final icon = _getIconForLabel(label);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: AppColors.accent),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
