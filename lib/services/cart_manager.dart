import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Zenginleştirilmiş Sepet ve Favori Durum Yöneticisi (State Management).
/// Harici paket kullanılmaksızın yerleşik [ChangeNotifier] ile reaktif çalışır.
class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];
  final Set<int> _favoriteIds = {};
  String? _appliedPromoCode;
  double _promoDiscountRate = 0.0;

  // Salt okunur koleksiyonlar
  List<CartItem> get items => List.unmodifiable(_items);
  Set<int> get favoriteIds => Set.unmodifiable(_favoriteIds);
  String? get appliedPromoCode => _appliedPromoCode;

  // Sepet Metrikleri
  int get itemCount => _items.length;
  int get totalQuantity =>
      _items.fold<int>(0, (sum, item) => sum + item.quantity);

  /// İndirimsiz ham toplam
  double get subtotalAmount =>
      _items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  /// Uygulanan promosyon indirim tutarı
  double get discountAmount => subtotalAmount * _promoDiscountRate;

  /// Kargo ücreti (200$ üzeri ÜCRETSİZ)
  double get shippingFee =>
      (subtotalAmount >= 200 || subtotalAmount == 0) ? 0.0 : 15.0;

  /// Nihai ödenecek genel toplam
  double get totalAmount => (subtotalAmount - discountAmount + shippingFee);

  /// Biçimlendirilmiş toplam tutar metni
  String formatCurrency(double amount) {
    if (amount == amount.truncateToDouble()) {
      return '\$${amount.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  String get formattedSubtotal => formatCurrency(subtotalAmount);
  String get formattedDiscount => formatCurrency(discountAmount);
  String get formattedTotal => formatCurrency(totalAmount);

  bool get isEmpty => _items.isEmpty;

  // --- SEPET İŞLEMLERİ ---

  bool containsProduct(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  int getQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    return index >= 0 ? _items[index].quantity : 0;
  }

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  void decreaseQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity -= 1;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    _appliedPromoCode = null;
    _promoDiscountRate = 0.0;
    notifyListeners();
  }

  // --- KUPON & PROMOSYON ---

  bool applyPromo(String code) {
    final clean = code.trim().toUpperCase();
    if (clean == 'NOVA10' || clean == 'FLUTTER10') {
      _appliedPromoCode = clean;
      _promoDiscountRate = 0.10; // %10 indirim
      notifyListeners();
      return true;
    } else if (clean == 'SUPER20') {
      _appliedPromoCode = clean;
      _promoDiscountRate = 0.20; // %20 indirim
      notifyListeners();
      return true;
    }
    return false;
  }

  void removePromo() {
    _appliedPromoCode = null;
    _promoDiscountRate = 0.0;
    notifyListeners();
  }

  // --- FAVORİ YÖNETİMİ ---

  bool isFavorite(Product product) => _favoriteIds.contains(product.id);

  void toggleFavorite(Product product) {
    if (_favoriteIds.contains(product.id)) {
      _favoriteIds.remove(product.id);
    } else {
      _favoriteIds.add(product.id);
    }
    notifyListeners();
  }
}
