import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Ürün görselini hem yerel asset hem de online URL desteğiyle
/// güvenli şekilde yükleyen görsel bileşeni.
class ProductImageView extends StatelessWidget {
  final String assetPath;
  final String networkUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const ProductImageView({
    super.key,
    required this.assetPath,
    required this.networkUrl,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: width,
      height: height,
      fit: fit,
      errorBuilder: (context, error, stackTrace) {
        // Yerel asset bulunamazsa veya hata verirse ağ URL'sini dener
        if (networkUrl.isNotEmpty) {
          return Image.network(
            networkUrl,
            width: width,
            height: height,
            fit: fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return SizedBox(
                width: width,
                height: height,
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
            },
            errorBuilder: (context, netError, netStack) => _buildPlaceholder(),
          );
        }
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.devices_other,
          color: AppColors.secondary,
          size: 32,
        ),
      ),
    );
  }
}
