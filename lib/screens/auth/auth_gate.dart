import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cryptex_trading/screens/auth/splash_screen.dart';
import 'package:cryptex_trading/screens/auth/login_screen.dart';
import 'package:cryptex_trading/screens/client/main_dashboard.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }
        
        if (snapshot.hasData && snapshot.data != null) {
          return const MainDashboard();
        }
        
        return const LoginScreen();
      },
    );
  }
}
