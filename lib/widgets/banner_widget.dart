import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Özgün ve etkileyici promosyonel vitrin banner'ı.
/// İster yerel görseli gösterir ister zengin gradyan kart tasarımıyla öne çıkar.
class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  static const String _assetBanner = 'assets/images/banner.png';
  static const String _networkBanner = 'https://wantapi.com/assets/banner.png';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withValues(alpha: 0.15),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          alignment: Alignment.centerLeft,
          children: [
            AspectRatio(
              aspectRatio: 2118 / 474,
              child: Image.asset(
                _assetBanner,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.network(
                    _networkBanner,
                    fit: BoxFit.cover,
                    errorBuilder: (context, netError, netStack) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primary,
                              AppColors.accentGradientStart,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            // İnce degrade kaplama ile modern görünüm
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.25),
                      Colors.transparent,
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
