import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog_uygulamasi/constants/app_strings.dart';
import 'package:mini_katalog_uygulamasi/main.dart';
import 'package:mini_katalog_uygulamasi/screens/cart_screen.dart';

void main() {
  testWidgets('MiniCatalogApp builds and renders Discover screen',
      (WidgetTester tester) async {
    await tester.pumpWidget(const MiniCatalogApp());
    await tester.pump();

    // NovaStore Keşfet başlığı ve arama kutusu ekranda olmalıdır
    expect(find.text(AppStrings.discoverGreeting), findsOneWidget);
    expect(find.text(AppStrings.discoverSubtitle), findsOneWidget);
    expect(find.text(AppStrings.searchHint), findsOneWidget);
  });

  testWidgets('CartScreen renders empty state when cart is empty',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CartScreen(),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.cartEmptyTitle), findsOneWidget);
    expect(find.text(AppStrings.cartEmptySubtitle), findsOneWidget);
  });
}
