import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog_uygulamasi/models/product.dart';
import 'package:mini_katalog_uygulamasi/services/cart_manager.dart';

void main() {
  group('Product Model Tests', () {
    test('Product.fromJson parses valid JSON and assigns dynamic badges correctly', () {
      final json = {
        'id': 1,
        'name': 'NovaBlade G75 Pro Mekanik Klavye',
        'tagline': 'Gasket-Mount & Hot-Swap Akustik Canavarı',
        'description': 'CNC işlenmiş yekpare alüminyum gövde ve Poron yalıtımı.',
        'price': r'$189',
        'oldPrice': r'$219',
        'currency': 'USD',
        'image': 'assets/images/keyboard.jpg',
        'category': 'Klavyeler',
        'badge': 'Çok Satan',
        'rating': 4.9,
        'reviewCount': 342,
        'specs': {
          'switch': 'Gateron Oil King',
          'gövde': 'CNC Alüminyum',
        },
      };

      final product = Product.fromJson(json);

      expect(product.id, 1);
      expect(product.name, 'NovaBlade G75 Pro Mekanik Klavye');
      expect(product.price, r'$189');
      expect(product.numericPrice, 189.0);
      expect(product.numericOldPrice, 219.0);
      expect(product.discountPercent, greaterThan(0));
      expect(product.assetPath, 'assets/images/keyboard.jpg');
      expect(product.category, 'Klavyeler');
      expect(product.specs['switch'], 'Gateron Oil King');
      expect(product.rating, 4.9);
      expect(product.badge, 'Çok Satan');
    });

    test('Product.toJson converts back correctly', () {
      const product = Product(
        id: 2,
        name: 'NovaGlide Karbon Mouse',
        tagline: '39 Gram Magnezyum Alaşım',
        description: 'PAW3395 26K sensör.',
        price: r'$119',
        oldPrice: r'$139',
        currency: 'USD',
        image: 'assets/images/mouse.jpg',
        category: 'Fareler',
        specs: {'sensör': 'PAW3395'},
      );

      final json = product.toJson();

      expect(json['id'], 2);
      expect(json['name'], 'NovaGlide Karbon Mouse');
      expect(product.numericPrice, 119.0);
      expect(product.numericOldPrice, 139.0);
      expect(product.discountPercent, greaterThan(0));
    });
  });

  group('CartManager State & Promo & Favorites Tests', () {
    late CartManager cart;

    const testProduct1 = Product(
      id: 1,
      name: 'NovaBlade G75 Pro Mekanik Klavye',
      tagline: 'Gasket-Mount & Hot-Swap',
      description: 'Test description',
      price: r'$200',
      currency: 'USD',
      image: 'assets/images/keyboard.jpg',
      category: 'Klavyeler',
      specs: {},
    );

    const testProduct2 = Product(
      id: 2,
      name: 'NovaGlide Karbon Mouse',
      tagline: '39 Gram Magnezyum',
      description: 'Test description',
      price: r'$100',
      currency: 'USD',
      image: 'assets/images/mouse.jpg',
      category: 'Fareler',
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
      expect(cart.subtotalAmount, 300.0);
      // 200$ üzeri kargo ücretsizdir
      expect(cart.shippingFee, 0.0);
      expect(cart.totalAmount, 300.0);
    });

    test('Applying promo code NOVA10 discounts subtotal by 10%', () {
      cart.addToCart(testProduct1); // 200$
      final applied = cart.applyPromo('NOVA10');

      expect(applied, isTrue);
      expect(cart.appliedPromoCode, 'NOVA10');
      expect(cart.discountAmount, closeTo(20.0, 0.01));
      expect(cart.totalAmount, closeTo(180.0, 0.01));
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
