import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/providers/theme_provider.dart';
import 'package:cryptex_trading/screens/client/payment_screen.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: const Text('Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Text('CT', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'CrypTex Trader',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'trader@cryptex.com',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Premium Member',
                      style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.darkCard,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem('Total Trades', '124'),
                      _buildStatItem('Win Rate', '68%'),
                      _buildStatItem('Profit', '+\$12,450'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildMenuSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(color: AppColors.primary, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    
    return Container(
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          _buildMenuItem(Icons.account_balance_wallet, 'Wallet & Payments', () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const PaymentScreen()),
            );
          }),
          _buildDivider(),
          _buildMenuItem(Icons.history, 'Transaction History', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.notifications_outlined, 'Notifications', () {}),
          _buildDivider(),
          SwitchListTile(
            secondary: Icon(Icons.dark_mode, color: Colors.white.withValues(alpha: 0.7)),
            title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
            value: themeProvider.getIsDarkTHeme,
            activeColor: AppColors.primary,
            onChanged: (value) => themeProvider.setDarkTheme(value),
          ),
          _buildDivider(),
          _buildMenuItem(Icons.help_outline, 'Help & Support', () {}),
          _buildDivider(),
          _buildMenuItem(Icons.logout, 'Logout', () {}, isDestructive: true),
        ],
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap, {bool isDestructive = false}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? AppColors.bearish : Colors.white.withValues(alpha: 0.7)),
      title: Text(
        title,
        style: TextStyle(color: isDestructive ? AppColors.bearish : Colors.white),
      ),
      trailing: Icon(Icons.chevron_right, color: Colors.white.withValues(alpha: 0.3)),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return Divider(color: AppColors.darkBorder, height: 1, indent: 56);
  }
}
