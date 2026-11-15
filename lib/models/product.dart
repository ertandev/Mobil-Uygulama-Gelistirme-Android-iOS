/// Zenginleştirilmiş ve Özgün Ürün Veri Modeli.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String? oldPrice;
  final String currency;
  final String image;
  final String category;
  final Map<String, String> specs;
  final double rating;
  final int reviewCount;
  final String? badge;
  final List<String> colorNames;
  final List<int> colorHexes;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.currency,
    required this.image,
    this.category = 'Genel',
    required this.specs,
    this.rating = 4.8,
    this.reviewCount = 96,
    this.badge,
    this.colorNames = const ['Obsidyen Siyah', 'Gümüş Titanyum', 'Derin İndigo'],
    this.colorHexes = const [0xFF0F172A, 0xFF94A3B8, 0xFF4338CA],
  });

  /// Fiyat metninden sayısal değeri elde eder ($189 -> 189.0).
  double get numericPrice {
    final clean = price.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean) ?? 0.0;
  }

  /// Eski fiyat sayısal değeri
  double? get numericOldPrice {
    if (oldPrice == null) return null;
    final clean = oldPrice!.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(clean);
  }

  /// İndirim oranı yüzdesi hesaplar
  int? get discountPercent {
    if (numericOldPrice == null || numericOldPrice! <= numericPrice) return null;
    return (((numericOldPrice! - numericPrice) / numericOldPrice!) * 100).round();
  }

  /// Görsel URL'sinden yerel asset yolunu türetir.
  String get assetPath {
    if (image.startsWith('assets/')) return image;
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
      oldPrice: json['oldPrice'] as String?,
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      category: json['category'] as String? ?? 'Genel',
      specs: parsedSpecs,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.8,
      reviewCount: json['reviewCount'] as int? ?? 100,
      badge: json['badge'] as String?,
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
      'oldPrice': oldPrice,
      'currency': currency,
      'image': image,
      'category': category,
      'specs': specs,
      'rating': rating,
      'reviewCount': reviewCount,
      'badge': badge,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Product && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
