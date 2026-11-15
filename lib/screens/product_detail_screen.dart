import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../constants/app_strings.dart';
import '../models/product.dart';
import '../services/cart_manager.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_image_view.dart';
import '../widgets/spec_chip.dart';

/// Zenginleştirilmiş ve Özgün Ürün Detay Sayfası.
/// Renk varyantı seçimi, garanti rozetleri, kullanıcı puanı ve
/// dinamik fiyat barıyla benzersiz bir deneyim sunar.
class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late int _selectedColorIndex;

  @override
  void initState() {
    super.initState();
    _selectedColorIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartManager();
    final product = widget.product;

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
            'Geri',
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
        actions: [
          AnimatedBuilder(
            animation: cart,
            builder: (context, _) {
              final isFav = cart.isFavorite(product);
              return IconButton(
                icon: Icon(
                  isFav ? Icons.favorite : Icons.favorite_border,
                  color: isFav ? AppColors.favorite : AppColors.textPrimary,
                ),
                onPressed: () => cart.toggleFavorite(product),
                tooltip: 'Favorilere Ekle',
              );
            },
          ),
          const CartBadgeButton(),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stok Durumu Rozeti
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.circle,
                                size: 8, color: AppColors.success),
                            SizedBox(width: 6),
                            Text(
                              'Stokta Var • Aynı Gün Kargo',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      if (product.badge != null)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            product.badge!,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.accent,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Büyük Ürün Görseli (Hero Animasyonlu)
                  Center(
                    child: Hero(
                      tag: 'product-img-${product.id}',
                      child: Container(
                        height: 250,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ProductImageView(
                          assetPath: product.assetPath,
                          networkUrl: product.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),

                  // Renk Seçenekleri Çipleri (Etkileşimli)
                  Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(product.colorHexes.length, (index) {
                          final isSelected = index == _selectedColorIndex;
                          final colorHex = product.colorHexes[index];
                          return GestureDetector(
                            onTap: () {
                              setState(() => _selectedColorIndex = index);
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.accent
                                      : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Color(colorHex),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Puan ve Başlık
                  Row(
                    children: [
                      const Icon(Icons.star_rounded,
                          size: 18, color: AppColors.warning),
                      const SizedBox(width: 4),
                      Text(
                        '${product.rating} ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        '(${product.reviewCount} Değerlendirme)',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),

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

                  Text(
                    product.tagline,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Güven & Garanti Rozetleri (3'lü Kart Sırası)
                  Row(
                    children: [
                      _buildGuaranteeItem(
                          Icons.local_shipping_outlined, 'Hızlı Kargo', '1-2 Gün'),
                      const SizedBox(width: 8),
                      _buildGuaranteeItem(
                          Icons.shield_outlined, '2 Yıl Garanti', 'Resmi'),
                      const SizedBox(width: 8),
                      _buildGuaranteeItem(
                          Icons.published_with_changes_rounded, 'İade Hakkı', '14 Gün'),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Ürün Açıklaması
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
                      height: 1.6,
                      color: AppColors.textPrimary.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Donanım Özellikleri
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

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // Alt Sabit Fiyat ve Satın Alma Çubuğu
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.cardBackground,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0F172A).withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (product.oldPrice != null)
                        Text(
                          product.oldPrice!,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      Text(
                        product.price,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cart.addToCart(product);
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.success,
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
                              textColor: AppColors.badgeNew,
                              onPressed: () {
                                Navigator.of(context).pushNamed(AppRoutes.cart);
                              },
                            ),
                            duration: const Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart_rounded,
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

  Widget _buildGuaranteeItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: AppColors.accent),
            const SizedBox(height: 4),
            Text(
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Text(
              subtitle,
              style: const TextStyle(fontSize: 9, color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
