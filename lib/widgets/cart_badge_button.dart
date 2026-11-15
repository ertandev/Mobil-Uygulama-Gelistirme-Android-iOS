import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';
import '../services/cart_manager.dart';

/// Sağ üst köşede sepet simgesi ve anlık ürün adedi rozeti (Badge) gösteren bileşen.
class CartBadgeButton extends StatelessWidget {
  final Color iconColor;

  const CartBadgeButton({
    super.key,
    this.iconColor = AppColors.primary,
  });

  @override
  Widget build(BuildContext context) {
    final cart = CartManager();

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final count = cart.totalQuantity;

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              icon: Icon(
                Icons.shopping_bag_outlined,
                color: iconColor,
                size: 26,
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.cart);
              },
              tooltip: 'Sepeti Görüntüle',
            ),
            if (count > 0)
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 18,
                    minHeight: 18,
                  ),
                  child: Center(
                    child: Text(
                      count > 99 ? '99+' : count.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        height: 1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
