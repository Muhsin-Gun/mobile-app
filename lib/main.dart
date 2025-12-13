import 'package:e_shop/providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:e_shop/constants/app_colors.dart';
import 'package:e_shop/screens/home_screen.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase initialization disabled on Windows due to linker compatibility issues.
  // Firebase works on Android and iOS. To enable, use:
  // import 'package:firebase_core/firebase_core.dart';
  // import 'firebase_options.dart';
  // Then: await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return ThemeProvider();
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          final themeProvider = Provider.of<ThemeProvider>(context);
          return MaterialApp(
            theme: ThemeData.light().copyWith(
              scaffoldBackgroundColor: AppColors.lightScaffoldColor,
            ),
            darkTheme: ThemeData.dark().copyWith(
              scaffoldBackgroundColor: AppColors.darkScaffoldColor,
            ),
            themeMode:
                themeProvider.getIsDarkTHeme ? ThemeMode.dark : ThemeMode.light,
            home: Scaffold(body: HomeScreen()),
          );
        },
      ),
    ),
  );
}
