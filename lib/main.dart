import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cryptex_trading/firebase_options.dart';
import 'package:cryptex_trading/constants/theme_data.dart';
import 'package:cryptex_trading/providers/theme_provider.dart';
import 'package:cryptex_trading/providers/auth_provider.dart';
import 'package:cryptex_trading/screens/auth/auth_gate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
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
      home: const AuthGate(),
    );
  }
}
