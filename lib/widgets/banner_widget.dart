import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// Keşfet (Discover) ekranı için promosyon banner bileşeni.
/// PDF raporunda gösterilen "GIFT STORE" banner'ını sunar.
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
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: AspectRatio(
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
                    color: AppColors.primary,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.all(16),
                    child: const Text(
                      'GIFT STORE • Special Offers',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
