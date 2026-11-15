import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../constants/app_strings.dart';
import '../models/product.dart';
import '../services/cart_manager.dart';
import '../services/product_service.dart';
import '../widgets/banner_widget.dart';
import '../widgets/cart_badge_button.dart';
import '../widgets/product_card.dart';

/// Keşfet ve Ana Katalog Ekranı.
/// Canlı arama, kategori sekmeleri, favori filtresi ve sıralama seçenekleriyle
/// özgün ve akıcı bir e-ticaret vitrini sunar.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ProductService _productService = ProductService();
  final TextEditingController _searchController = TextEditingController();

  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  bool _isLoading = true;
  String _selectedCategory = 'Tümü';
  String _sortBy = 'Varsayılan'; // 'Varsayılan', 'Fiyat: Düşük-Yüksek', 'En Yüksek Puan'

  final List<Map<String, dynamic>> _categories = [
    {'name': 'Tümü', 'icon': Icons.auto_awesome_rounded},
    {'name': 'iPhone', 'icon': Icons.phone_iphone_rounded},
    {'name': 'MacBook', 'icon': Icons.laptop_mac_rounded},
    {'name': 'iPad', 'icon': Icons.tablet_mac_rounded},
    {'name': 'Watch', 'icon': Icons.watch_rounded},
    {'name': 'Audio', 'icon': Icons.headphones_rounded},
    {'name': 'Favorilerim', 'icon': Icons.favorite_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadProducts({bool forceRefresh = false}) async {
    setState(() => _isLoading = true);
    final products =
        await _productService.fetchProducts(forceRefresh: forceRefresh);
    if (mounted) {
      setState(() {
        _allProducts = products;
        _isLoading = false;
        _applyFilterAndSort();
      });
    }
  }

  void _onSearchChanged() {
    _applyFilterAndSort();
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
      _applyFilterAndSort();
    });
  }

  void _applyFilterAndSort() {
    final query = _searchController.text.trim().toLowerCase();
    final cart = CartManager();

    List<Product> list = _allProducts.where((product) {
      // Metin araması
      final matchesQuery = query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.tagline.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query);

      // Kategori filtresi
      bool matchesCategory = true;
      if (_selectedCategory == 'Favorilerim') {
        matchesCategory = cart.isFavorite(product);
      } else if (_selectedCategory != 'Tümü') {
        matchesCategory = product.name
                .toLowerCase()
                .contains(_selectedCategory.toLowerCase()) ||
            product.tagline
                .toLowerCase()
                .contains(_selectedCategory.toLowerCase());
      }

      return matchesQuery && matchesCategory;
    }).toList();

    // Sıralama
    if (_sortBy == 'Fiyat: Düşük-Yüksek') {
      list.sort((a, b) => a.numericPrice.compareTo(b.numericPrice));
    } else if (_sortBy == 'Fiyat: Yüksek-Düşük') {
      list.sort((a, b) => b.numericPrice.compareTo(a.numericPrice));
    } else if (_sortBy == 'En Yüksek Puan') {
      list.sort((a, b) => b.rating.compareTo(a.rating));
    }

    setState(() {
      _filteredProducts = list;
    });
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ürünleri Sırala',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(ctx).pop(),
                  ),
                ],
              ),
              const Divider(),
              _buildSortOption(ctx, 'Varsayılan'),
              _buildSortOption(ctx, 'Fiyat: Düşük-Yüksek'),
              _buildSortOption(ctx, 'Fiyat: Yüksek-Düşük'),
              _buildSortOption(ctx, 'En Yüksek Puan'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSortOption(BuildContext ctx, String label) {
    final isSelected = _sortBy == label;
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? AppColors.accent : AppColors.textPrimary,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.accent)
          : null,
      onTap: () {
        setState(() => _sortBy = label);
        Navigator.of(ctx).pop();
        _applyFilterAndSort();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _loadProducts(forceRefresh: true),
          color: AppColors.accent,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              // Üst Karşılama ve Rozetli Sepet Butonu
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            AppStrings.discoverGreeting,
                            style: TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.w900,
                              color: AppColors.textPrimary,
                              letterSpacing: -0.6,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            AppStrings.discoverSubtitle,
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const CartBadgeButton(),
                    ],
                  ),
                ),
              ),

              // Arama Çubuğu ve Sıralama Butonu
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: TextField(
                            controller: _searchController,
                            style: const TextStyle(fontSize: 14),
                            decoration: InputDecoration(
                              hintText: AppStrings.searchHint,
                              hintStyle: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                              prefixIcon: const Icon(
                                Icons.search_rounded,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: const Icon(Icons.clear, size: 16),
                                      onPressed: () =>
                                          _searchController.clear(),
                                    )
                                  : null,
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: _showSortDialog,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: const Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Promosyon Banner'ı
              const SliverToBoxAdapter(
                child: BannerWidget(),
              ),

              // Kategori Seçici Çipler (İkonlu & Özgün)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 42,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _categories.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final cat = _categories[index];
                      final name = cat['name'] as String;
                      final icon = cat['icon'] as IconData;
                      final isSelected = name == _selectedCategory;

                      return ChoiceChip(
                        avatar: Icon(
                          icon,
                          size: 15,
                          color: isSelected ? Colors.white : AppColors.textSecondary,
                        ),
                        label: Text(
                          name,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : AppColors.textPrimary,
                          ),
                        ),
                        selected: isSelected,
                        onSelected: (_) => _onCategorySelected(name),
                        selectedColor: AppColors.primary,
                        backgroundColor: AppColors.chipBackground,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      );
                    },
                  ),
                ),
              ),

              // Bulunan Ürün Sayısı ve Sıralama Göstergesi
              SliverToBoxAdapter(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_filteredProducts.length} Cihaz Listelendi',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      if (_sortBy != 'Varsayılan')
                        Text(
                          'Sıralama: $_sortBy',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.accent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              // Ürünler GridView Izgarası (2 Sütunlu)
              if (_isLoading)
                const SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                )
              else if (_filteredProducts.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.devices_other,
                          size: 48,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Aramanıza uygun ürün bulunamadı.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () {
                            _searchController.clear();
                            _onCategorySelected('Tümü');
                          },
                          child: const Text('Filtreleri Sıfırla'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.69,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final product = _filteredProducts[index];
                        return ProductCard(product: product);
                      },
                      childCount: _filteredProducts.length,
                    ),
                  ),
                ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 24),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
