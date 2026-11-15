import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog_uygulamasi/models/product.dart';
import 'package:mini_katalog_uygulamasi/services/cart_manager.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson parses valid JSON and assigns dynamic badges correctly', () {
      final json = {
        'id': 1,
        'name': 'iPhone 15 Pro',
        'tagline': 'Titanium. So strong. So light. So Pro.',
        'description': 'Aerospace-grade titanium design.',
        'price': '\$999',
        'currency': 'USD',
        'image': 'https://wantapi.com/assets/images/iphone.png',
        'specs': {
          'chip': 'A17 Pro',
          'material': 'Titanium',
        },
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'iPhone 15 Pro');
      expect(product.price, '\$999');
      expect(product.numericPrice, 999.0);
      expect(product.assetPath, 'assets/images/iphone.png');
      expect(product.specs['chip'], 'A17 Pro');
      expect(product.rating, greaterThanOrEqualTo(4.0));
      expect(product.badge, isNotNull);
    });

    test('Product.toJson converts back correctly', () {
      const product = Product(
        id: 20,
        name: 'HomePod Mini',
        tagline: 'Color-pop.',
        description: '360-degree audio.',
        price: '\$99',
        oldPrice: '\$119',
        currency: 'USD',
        image: 'https://wantapi.com/assets/images/homepod_mini.png',
        specs: {'size': '3.3 inches'},
      );

      final json = product.toJson();

      expect(json['id'], 20);
      expect(json['name'], 'HomePod Mini');
      expect(product.numericPrice, 99.0);
      expect(product.numericOldPrice, 119.0);
      expect(product.discountPercent, greaterThan(0));
    });
  });

  group('CartManager State & Promo & Favorites Tests', () {
    late CartManager cart;

    const testProduct1 = Product(
      id: 17,
      name: 'AirPods Pro',
      tagline: 'Adaptive Audio',
      description: 'Test description',
      price: '\$249',
      currency: 'USD',
      image: 'https://wantapi.com/assets/images/airpods.png',
      specs: {},
    );

    const testProduct2 = Product(
      id: 20,
      name: 'HomePod Mini',
      tagline: 'Color-pop',
      description: 'Test description',
      price: '\$99',
      currency: 'USD',
      image: 'https://wantapi.com/assets/images/homepod_mini.png',
      specs: {},
    );

    setUp(() {
      cart = CartManager();
      cart.clear();
    });

    test('Initial cart is empty', () {
      expect(cart.isEmpty, isTrue);
      expect(cart.totalQuantity, 0);
      expect(cart.totalAmount, 0.0);
    });

    test('Adding products increases quantity and updates total', () {
      cart.addToCart(testProduct1);
      cart.addToCart(testProduct2);
      expect(cart.isEmpty, isFalse);
      expect(cart.itemCount, 2);
      expect(cart.totalQuantity, 2);
      expect(cart.subtotalAmount, 348.0);

      // 200$ üzeri kargo ücretsizdir
      expect(cart.shippingFee, 0.0);
      expect(cart.totalAmount, 348.0);
    });

    test('Applying promo code NOVA10 discounts subtotal by 10%', () {
      cart.addToCart(testProduct1); // 249$
      final applied = cart.applyPromo('NOVA10');

      expect(applied, isTrue);
      expect(cart.appliedPromoCode, 'NOVA10');
      expect(cart.discountAmount, closeTo(24.9, 0.01));
      expect(cart.totalAmount, closeTo(224.1, 0.01));
    });

    test('Favorite management toggles correctly', () {
      expect(cart.isFavorite(testProduct1), isFalse);
      cart.toggleFavorite(testProduct1);
      expect(cart.isFavorite(testProduct1), isTrue);
      cart.toggleFavorite(testProduct1);
      expect(cart.isFavorite(testProduct1), isFalse);
    });

    test('Clearing cart resets items and promo', () {
      cart.addToCart(testProduct1);
      cart.applyPromo('NOVA10');
      cart.clear();

      expect(cart.isEmpty, isTrue);
      expect(cart.appliedPromoCode, isNull);
      expect(cart.totalAmount, 0.0);
    });
  });
}
