/// Ürün veri modeli.
/// Gün 4 müfredatındaki JSON modelleme, fromJson ve toJson mantığını uygular.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String currency;
  final String image;
  final Map<String, String> specs;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    required this.currency,
    required this.image,
    required this.specs,
  });

  /// Fiyat metninden sayısal değeri elde eder ($999 -> 999.0).
  double get numericPrice {
    final clean = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  /// Görsel URL'sinden yerel asset yolunu türetir (offline kullanım için).
  String get assetPath {
    final filename = image.split('/').last;
    return 'assets/images/$filename';
  }

  /// JSON haritasından Product nesnesi üretir (Deserialization).
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawSpecs = json['specs'];
    final Map<String, String> parsedSpecs = {};

    if (rawSpecs is Map<String, dynamic>) {
      rawSpecs.forEach((key, value) {
        parsedSpecs[key] = value.toString();
      });
    }

    return Product(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '\$0',
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      specs: parsedSpecs,
    );
  }

  /// Product nesnesini JSON haritasına dönüştürür (Serialization).
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'tagline': tagline,
      'description': description,
      'price': price,
      'currency': currency,
      'image': image,
      'specs': specs,
    };
  }

  @override
  String toString() => 'Product(id: $id, name: $name, price: $price)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
