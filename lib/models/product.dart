/// Zenginleştirilmiş Ürün Veri Modeli.
/// Temel JSON isterlerini karşılarken dinamik rozetler, puanlama,
/// eski fiyat karşılaştırması ve renk varyantlarıyla özgün bir e-ticaret deneyimi sunar.
class Product {
  final int id;
  final String name;
  final String tagline;
  final String description;
  final String price;
  final String? oldPrice;
  final String currency;
  final String image;
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
    required this.specs,
    this.rating = 4.8,
    this.reviewCount = 96,
    this.badge,
    this.colorNames = const ['Uzay Grisi', 'Gümüş', 'Gece Yarısı'],
    this.colorHexes = const [0xFF1F2937, 0xFFE2E8F0, 0xFF0F172A],
  });

  /// Fiyat metninden sayısal değeri elde eder ($999 -> 999.0).
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

    final id = json['id'] is int
        ? json['id'] as int
        : int.tryParse(json['id'].toString()) ?? 0;

    // Ürüne göre dinamik özgün rozetler ve puanlar
    String? badge;
    double rating = 4.8;
    int reviewCount = 94;
    String? oldPrice;

    if (id == 1 || id == 6) {
      badge = 'Öne Çıkan';
      rating = 4.9;
      reviewCount = 284;
      oldPrice = '\$1,099';
    } else if (id == 17 || id == 18) {
      badge = 'Çok Satan';
      rating = 4.9;
      reviewCount = 412;
      oldPrice = '\$279';
    } else if (id == 20) {
      badge = 'Fırsat';
      rating = 4.7;
      reviewCount = 156;
      oldPrice = '\$119';
    } else if (id % 3 == 0) {
      badge = 'Yeni';
      rating = 4.8;
      reviewCount = 88;
    }

    return Product(
      id: id,
      name: json['name'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      description: json['description'] as String? ?? '',
      price: json['price'] as String? ?? '\$0',
      oldPrice: json['oldPrice'] as String? ?? oldPrice,
      currency: json['currency'] as String? ?? 'USD',
      image: json['image'] as String? ?? '',
      specs: parsedSpecs,
      rating: (json['rating'] as num?)?.toDouble() ?? rating,
      reviewCount: json['reviewCount'] as int? ?? reviewCount,
      badge: json['badge'] as String? ?? badge,
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
