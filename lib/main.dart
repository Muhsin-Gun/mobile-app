import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/constants/theme_data.dart';
import 'package:cryptex_trading/providers/theme_provider.dart';
import 'package:cryptex_trading/screens/client/main_dashboard.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const CryptexApp(),
    ),
  );
}

class CryptexApp extends StatelessWidget {
  const CryptexApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return MaterialApp(
      title: 'CrypTex Trading',
      debugShowCheckedModeBanner: false,
      theme: Styles.themeData(isDarkTheme: false, context: context),
      darkTheme: Styles.themeData(isDarkTheme: true, context: context),
      themeMode: themeProvider.getIsDarkTHeme ? ThemeMode.dark : ThemeMode.light,
      home: const MainDashboard(),
    );
  }
}
