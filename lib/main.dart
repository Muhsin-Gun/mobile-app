import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:services_marketplace/firebase_options.dart';
import 'package:services_marketplace/constants/theme_data.dart';
import 'package:services_marketplace/providers/theme_provider.dart';
import 'package:services_marketplace/providers/auth_provider.dart';
import 'package:services_marketplace/providers/marketplace_provider.dart';
import 'package:services_marketplace/providers/admin_provider.dart';
import 'package:services_marketplace/providers/products_provider.dart';
import 'package:services_marketplace/providers/user_provider.dart';
import 'package:services_marketplace/screens/auth/auth_gate.dart';
import 'package:services_marketplace/screens/admin/admin_login_screen.dart';
import 'package:services_marketplace/screens/admin/admin_dashboard_screen.dart';
import 'package:services_marketplace/screens/admin/add_product_screen.dart';
import 'package:services_marketplace/screens/admin/admin_orders_screen.dart';
import 'package:services_marketplace/screens/admin/admin_users_screen.dart';
import 'package:services_marketplace/screens/admin/products_list_screen.dart';
import 'package:services_marketplace/screens/admin/employee_dashboard_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MarketplaceProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
          routes: {
            AdminLoginScreen.routName: (_) => const AdminLoginScreen(),
            AdminDashboardScreen.routName: (_) => const AdminDashboardScreen(),
            AddProductScreen.routName: (_) => const AddProductScreen(),
            AdminOrdersScreen.routName: (_) => const AdminOrdersScreen(),
            AdminUsersScreen.routName: (_) => const AdminUsersScreen(),
            ProductsListScreen.routName: (_) => const ProductsListScreen(),
            EmployeeDashboardScreen.routName: (_) =>
                const EmployeeDashboardScreen(),
          },
          home: const AuthGate(),
        );
      },
    );
  }
}
