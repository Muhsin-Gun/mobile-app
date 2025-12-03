// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:e_shop/screens/home_screen.dart';
import 'package:e_shop/providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build HomeScreen inside a Provider so it has the ThemeProvider available.
    await tester.pumpWidget(
      ChangeNotifierProvider<ThemeProvider>(
        create: (_) => ThemeProvider(),
        child: const MaterialApp(
          home: Scaffold(body: HomeScreen()),
        ),
      ),
    );

    // Verify HomeScreen shows the main title.
    expect(find.text('Duka Letu'), findsOneWidget);
  });
}
