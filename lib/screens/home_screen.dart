import 'package:e_shop/constants/app_colors.dart';
import 'package:e_shop/providers/theme_provider.dart';
import 'package:e_shop/screens/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.getIsDarkTHeme
          ? AppColors.darkScaffoldColor
          : AppColors.lightScaffoldColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            // Sample image from assets. Place your image at `assets/images/logo.png`.
            // The errorBuilder prevents a hard crash in debug if the image is missing.
            Image.asset(
              'assets/images/logo.png',
              width: 120,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => SizedBox(
                width: 120,
                height: 120,
                child: Placeholder(),
              ),
            ),

            Text(
              "Duka Letu",

              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 50),

            ElevatedButton(onPressed: () {}, child: Text("Buy Now")),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SignupScreen()),
                );
              },
              child: Text("Sign Up"),
            ),

            SwitchListTile(

              title: Text(themeProvider.getIsDarkTHeme ? "Dark Themee":"Light Theme"),
              value: themeProvider.getIsDarkTHeme,
              onChanged: (value) {
                themeProvider.setDarkTheme(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}
