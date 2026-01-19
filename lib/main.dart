import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:services_marketplace/firebase_options.dart';
import 'package:services_marketplace/constants/theme_data.dart';
import 'package:services_marketplace/providers/theme_provider.dart';
import 'package:services_marketplace/providers/auth_provider.dart';
import 'package:services_marketplace/providers/marketplace_provider.dart';
import 'package:services_marketplace/screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
      ],
      child: const ServicesMarketplaceApp(),
    ),
  );
}

class ServicesMarketplaceApp extends StatelessWidget {
  const ServicesMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Services Marketplace',
          debugShowCheckedModeBanner: false,
          theme: Styles.themeData(isDarkTheme: false, context: context),
          darkTheme: Styles.themeData(isDarkTheme: true, context: context),
          themeMode: themeProvider.getIsDarkTHeme
              ? ThemeMode.dark
              : ThemeMode.light,
          home: const AuthGate(),
        );
      },
    );
  }
}
