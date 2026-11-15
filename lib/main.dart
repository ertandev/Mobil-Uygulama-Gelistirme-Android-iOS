import 'package:flutter/material.dart';
import 'constants/app_colors.dart';
import 'constants/app_routes.dart';
import 'constants/app_strings.dart';
import 'models/product.dart';
import 'screens/cart_screen.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'services/cart_manager.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MiniCatalogApp());
}

/// NovaStore Mini Katalog Uygulaması Ana Kök Widget'ı.
/// Android ve iOS mobil platformları için Flutter material.dart
/// üzerinde sıfır üçüncü parti paket bağımlılığı ile çalışır.
class MiniCatalogApp extends StatelessWidget {
  const MiniCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
          surface: AppColors.surface,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColors.textPrimary),
          titleTextStyle: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.4,
          ),
        ),
      ),
      initialRoute: AppRoutes.home,
      routes: {
        AppRoutes.home: (context) => const HomeScreen(),
        AppRoutes.cart: (context) => const CartScreen(),
        '/cart-demo': (context) {
          final cart = CartManager();
          if (cart.isEmpty) {
            cart.addToCart(const Product(
              id: 1,
              name: 'iPhone 15 Pro',
              tagline: 'Titanyum Pro',
              description: 'A17 Pro çipli amiral gemisi',
              price: '\$999',
              currency: 'USD',
              image: 'https://wantapi.com/assets/images/iphone.png',
              specs: {},
            ));
            cart.addToCart(const Product(
              id: 17,
              name: 'AirPods Pro (2. Nesil)',
              tagline: 'Aktif Gürültü Engelleme',
              description: 'Kusursuz ses deneyimi',
              price: '\$249',
              currency: 'USD',
              image: 'https://wantapi.com/assets/images/airpods.png',
              specs: {},
            ));
            cart.addToCart(const Product(
              id: 20,
              name: 'HomePod Mini',
              tagline: '360° Akıllı Hoparlör',
              description: 'Odayı dolduran net akustik',
              price: '\$99',
              currency: 'USD',
              image: 'https://wantapi.com/assets/images/homepod_mini.png',
              specs: {},
            ));
            cart.applyPromo('NOVA10');
          }
          return const CartScreen();
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == AppRoutes.productDetail) {
          final product = settings.arguments as Product? ??
              const Product(
                id: 1,
                name: 'iPhone 15 Pro',
                tagline: 'Titanyum. Çok güçlü. Çok hafif. Çok Pro.',
                description:
                    'iPhone 15 Pro, havacılık ve uzay sınıfı titanyum tasarımıyla şimdiye kadarki en hafif ve en dayanıklı Pro modelidir. A17 Pro çip ile üstün mobil oyun performansı ve profesyonel 48 MP kamera sistemi sunar.',
                price: '\$999',
                oldPrice: '\$1,099',
                currency: 'USD',
                image: 'https://wantapi.com/assets/images/iphone.png',
                specs: {
                  'chip': 'A17 Pro',
                  'material': 'Titanyum',
                  'camera': '48MP Pro',
                },
                badge: 'Öne Çıkan',
                rating: 4.9,
                reviewCount: 284,
              );
          return MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
