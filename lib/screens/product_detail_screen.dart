import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/product.dart';
import '../services/cart_manager.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_image_view.dart';
import '../widgets/spec_chip.dart';

/// Ürün Detay Sayfası (Screen 2).
/// Gün 3'teki Sayfalar arası veri taşıma (Route Arguments)
/// ve Gün 5'teki GridView'den detay sayfasına geçişi uygular.
class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 90,
        leading: TextButton.icon(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 16,
            color: AppColors.textPrimary,
          ),
          label: const Text(
            AppStrings.back,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.only(left: 12),
          ),
        ),
        actions: const [
          CartBadgeButton(),
          SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Kaydırılabilir Ürün Ayrıntıları
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Büyük Ürün Görseli (Hero Animasyonu ile)
                  Center(
                    child: Hero(
                      tag: 'product-img-${product.id}',
                      child: Container(
                        height: 240,
                        margin: const EdgeInsets.symmetric(vertical: 16),
                        child: ProductImageView(
                          assetPath: product.assetPath,
                          networkUrl: product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Ürün Başlığı
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: AppColors.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Tagline
                  Text(
                    product.tagline,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Description Bölümü
                  const Text(
                    AppStrings.description,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: TextStyle(
                      fontSize: 13,
                      height: 1.55,
                      color: AppColors.textPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Specifications Bölümü
                  if (product.specs.isNotEmpty) ...[
                    const Text(
                      AppStrings.specifications,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: product.specs.entries.map((entry) {
                        return SpecChip(
                          label: entry.key,
                          value: entry.value,
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Alt Sabit Eylem Çubuğu (Fiyat ve Sepete Ekle Butonu)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  // Fiyat Bilgisi
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Fiyat',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),

                  // Sepete Ekle Butonu
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        CartManager().addToCart(product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    '${product.name} sepete eklendi!',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            action: SnackBarAction(
                              label: 'SEPETE GİT',
                              textColor: Colors.amberAccent,
                              onPressed: () {
                                Navigator.of(context).pushNamed('/cart');
                              },
                            ),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.shopping_bag_outlined,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        AppStrings.addToCart,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
