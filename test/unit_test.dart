import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog_uygulamasi/models/product.dart';
import 'package:mini_katalog_uygulamasi/services/cart_manager.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson parses valid JSON correctly', () {
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
    });

    test('Product.toJson converts back correctly', () {
      const product = Product(
        id: 20,
        name: 'HomePod Mini',
        tagline: 'Color-pop.',
        description: '360-degree audio.',
        price: '\$99',
        currency: 'USD',
        image: 'https://wantapi.com/assets/images/homepod_mini.png',
        specs: {'size': '3.3 inches'},
      );

      final json = product.toJson();

      expect(json['id'], 20);
      expect(json['name'], 'HomePod Mini');
      expect(product.numericPrice, 99.0);
    });
  });

  group('CartManager State Tests', () {
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
      expect(cart.isEmpty, isFalse);
      expect(cart.itemCount, 1);
      expect(cart.totalQuantity, 1);
      expect(cart.totalAmount, 249.0);

      // Add same product again
      cart.addToCart(testProduct1);
      expect(cart.itemCount, 1);
      expect(cart.totalQuantity, 2);
      expect(cart.totalAmount, 498.0);

      // Add different product
      cart.addToCart(testProduct2);
      expect(cart.itemCount, 2);
      expect(cart.totalQuantity, 3);
      expect(cart.totalAmount, 597.0);
    });

    test('Decreasing product quantity removes it when reaching 0', () {
      cart.addToCart(testProduct1);
      cart.addToCart(testProduct1);
      expect(cart.totalQuantity, 2);

      cart.decreaseQuantity(testProduct1);
      expect(cart.totalQuantity, 1);

      cart.decreaseQuantity(testProduct1);
      expect(cart.isEmpty, isTrue);
    });

    test('Clearing cart resets all state', () {
      cart.addToCart(testProduct1);
      cart.addToCart(testProduct2);
      cart.clear();

      expect(cart.isEmpty, isTrue);
      expect(cart.totalQuantity, 0);
      expect(cart.totalAmount, 0.0);
    });
  });
}
