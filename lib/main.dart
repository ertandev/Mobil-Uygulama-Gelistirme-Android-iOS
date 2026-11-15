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
              name: 'NovaBlade G75 Pro Mekanik Klavye',
              tagline: 'Gasket-Mount & Hot-Swap',
              description: 'CNC Alüminyum gövde, Gateron Oil King lineer anahtarlar',
              price: '\$189',
              currency: 'USD',
              image: 'assets/images/keyboard.jpg',
              category: 'Klavyeler',
              specs: {},
            ));
            cart.addToCart(const Product(
              id: 2,
              name: 'NovaGlide Karbon Mouse',
              tagline: '39 Gram Magnezyum Alaşım',
              description: 'PAW3395 26K sensör ve 8000Hz polling',
              price: '\$119',
              currency: 'USD',
              image: 'assets/images/mouse.jpg',
              category: 'Fareler',
              specs: {},
            ));
            cart.addToCart(const Product(
              id: 3,
              name: 'NovaAcoustics Studio Pro',
              tagline: 'Planar Manyetik & Hibrit ANC',
              description: '50mm Planar sürücüler ve kayıpsız ses iletimi',
              price: '\$249',
              currency: 'USD',
              image: 'assets/images/headphones.jpg',
              category: 'Kulaklıklar',
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
                name: 'NovaBlade G75 Pro Mekanik Klavye',
                tagline: 'Gasket-Mount & Hot-Swap Akustik Canavarı',
                description:
                    'CNC işlenmiş yekpare alüminyum gövde, önceden yağlanmış Gateron Oil King lineer mekanik anahtarlar ve çok katmanlı Poron ses yalıtım köpüğü ile benzersiz bir thock yazım hissiyatı sunar. 4000 mAh bataryası ile kablosuz 2.4Ghz ve Bluetooth bağlantıda haftalarca kesintisiz kullanım sağlar.',
                price: '\$189',
                oldPrice: '\$219',
                currency: 'USD',
                image: 'assets/images/keyboard.jpg',
                category: 'Klavyeler',
                specs: {
                  'switch': 'Gateron Oil King',
                  'bağlantı': '2.4G / BT / Type-C',
                  'gövde': 'CNC Alüminyum',
                  'batarya': '4000 mAh Uzun Ömür',
                },
                badge: 'Çok Satan',
                rating: 4.9,
                reviewCount: 342,
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
