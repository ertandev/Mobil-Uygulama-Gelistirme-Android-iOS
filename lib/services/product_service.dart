import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/product.dart';

/// Ürün veri servisi.
/// Yerel JSON dosyasından (assets/data/products.json) veya
/// eğitim API'sinden (https://wantapi.com/products.php) veri yükler.
/// Ekstra paket kullanılmadan sadece Dart & Flutter SDK kütüphaneleriyle çalışır.
class ProductService {
  static const String _apiEndpoint = 'https://wantapi.com/products.php';
  static const String _localAssetPath = 'assets/data/products.json';

  List<Product>? _cachedProducts;

  /// Ürünleri yükler. Öncelikle yerel bundle'ı veya online API'yi dener.
  Future<List<Product>> fetchProducts({bool forceRefresh = false}) async {
    if (_cachedProducts != null && !forceRefresh) {
      return _cachedProducts!;
    }

    // 1. Yerel asset'ten yüklemeyi dene (offline-first & güvenilir)
    try {
      final jsonString = await rootBundle.loadString(_localAssetPath);
      final dynamic decoded = jsonDecode(jsonString);
      final List<dynamic> list = decoded is Map<String, dynamic>
          ? (decoded['data'] as List<dynamic>? ?? [])
          : (decoded as List<dynamic>);

      _cachedProducts = list
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList();

      return _cachedProducts!;
    } catch (assetError) {
      debugPrint('Yerel asset okuma hatası, API deneniyor: $assetError');
    }

    // 2. Yedek olarak yerel dart:io HttpClient ile API'yi dene
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(_apiEndpoint));
      final response = await request.close();

      if (response.statusCode == 200) {
        final body = await response.transform(utf8.decoder).join();
        final dynamic decoded = jsonDecode(body);
        final List<dynamic> list = decoded is Map<String, dynamic>
            ? (decoded['data'] as List<dynamic>? ?? [])
            : (decoded as List<dynamic>);

        _cachedProducts = list
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();

        return _cachedProducts!;
      }
    } catch (networkError) {
      debugPrint('Ağ isteği hatası: $networkError');
    }

    return _cachedProducts ?? [];
  }

  /// Arama ve kategori filtreleme
  List<Product> filterProducts(
    List<Product> products, {
    String query = '',
    String selectedCategory = 'All',
  }) {
    return products.where((product) {
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query.toLowerCase()) ||
          product.tagline.toLowerCase().contains(query.toLowerCase()) ||
          product.description.toLowerCase().contains(query.toLowerCase());

      final matchesCategory = selectedCategory == 'All' ||
          product.name.toLowerCase().contains(selectedCategory.toLowerCase()) ||
          product.tagline.toLowerCase().contains(selectedCategory.toLowerCase());

      return matchesQuery && matchesCategory;
    }).toList();
  }
}
