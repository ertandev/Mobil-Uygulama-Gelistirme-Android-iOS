import 'product.dart';

/// Sepetteki tek bir ürün kaydı ve miktar bilgisi.
class CartItem {
  final Product product;
  int quantity;

  CartItem({
    required this.product,
    this.quantity = 1,
  });

  /// Bu kalemin toplam tutarını hesaplar.
  double get totalPrice => product.numericPrice * quantity;

  /// JSON serileştirme
  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  /// JSON'dan nesne oluşturma
  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product'] as Map<String, dynamic>),
        quantity: json['quantity'] as int? ?? 1,
      );
}
