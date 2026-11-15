import 'package:flutter/foundation.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// Sepet durum yönetimi (State Management).
/// Ekstra paket (Provider, Riverpod, Bloc vs.) kullanılmadan
/// Flutter'ın yerleşik [ChangeNotifier] sınıfı ile uygulanmıştır.
class CartManager extends ChangeNotifier {
  // Singleton deseni: Tüm uygulama boyunca tek sepet örneği
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<CartItem> _items = [];

  /// Sepetteki ürün kalemlerinin salt-okunur listesi
  List<CartItem> get items => List.unmodifiable(_items);

  /// Sepetteki toplam tekil ürün adedi
  int get itemCount => _items.length;

  /// Sepetteki toplam ürün miktarı (adet toplamı)
  int get totalQuantity =>
      _items.fold<int>(0, (sum, item) => sum + item.quantity);

  /// Sepet toplam tutarı ($)
  double get totalAmount =>
      _items.fold<double>(0.0, (sum, item) => sum + item.totalPrice);

  /// Biçimlendirilmiş toplam tutar metni ($1,299)
  String get formattedTotal {
    final amount = totalAmount;
    if (amount == amount.truncateToDouble()) {
      return '\$${amount.toInt().toString().replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (m) => '${m[1]},',
          )}';
    }
    return '\$${amount.toStringAsFixed(2)}';
  }

  /// Sepet boş mu kontrolü
  bool get isEmpty => _items.isEmpty;

  /// Sepette belirli bir ürün var mı kontrolü
  bool containsProduct(Product product) {
    return _items.any((item) => item.product.id == product.id);
  }

  /// Sepetteki bir ürünün miktarını verir
  int getQuantity(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    return index >= 0 ? _items[index].quantity : 0;
  }

  /// Ürünü sepete ekler (varsa adedini 1 artırır)
  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index >= 0) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    notifyListeners();
  }

  /// Ürünün miktarını bir azaltır; 0 olursa sepetten çıkarır
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

  /// Ürünü tamamen sepetten çıkarır
  void removeProduct(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    notifyListeners();
  }

  /// Sepeti sıfırlar / temizler
  void clear() {
    _items.clear();
    notifyListeners();
  }
}
