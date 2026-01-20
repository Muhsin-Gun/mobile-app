import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/user_provider.dart';
import '../../constants/app_colors.dart';
import '../../widgets/animated_section.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';
import 'add_product_screen.dart';
import 'admin_orders_screen.dart';
import 'admin_users_screen.dart';
import 'products_list_screen.dart';
import '../auth/login_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  static const routName = "/AdminDashboardScreen";

  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  bool _refreshing = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeData();
    });
  }

  Future<void> _initializeData() async {
    final adminProvider = Provider.of<AdminProvider>(context, listen: false);
    final productsProvider = Provider.of<ProductsProvider>(
      context,
      listen: false,
    );
    setState(() => _refreshing = true);
    try {
      await adminProvider.fetchDashboardData();
      await productsProvider.fetchProducts();
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _logout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.logout();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 148,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.surface,
            title: const Text("Admin Dashboard"),
            actions: [
              IconButton(
                onPressed: _refreshing ? null : _initializeData,
                icon: _refreshing
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(IconlyLight.refresh),
                tooltip: 'Refresh',
              ),
              IconButton(
                onPressed: _logout,
                icon: const Icon(IconlyLight.logout),
                tooltip: 'Logout',
              ),
              const SizedBox(width: 6),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  const DecoratedBox(
                    decoration: BoxDecoration(gradient: AppColors.primaryGradient),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: 34,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 52, 16, 18),
                    child: AnimatedSection(
                      dy: 0.06,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TitlesTextWidget(
                            label: "Welcome back",
                            fontSize: 22,
                            color: Colors.white,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            "Manage your store, orders and users in one place",
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.82),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  AnimatedSection(
                    child: Consumer<AdminProvider>(
                      builder: (context, adminProvider, child) {
                        return GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 1.45,
                          children: [
                            _buildStatCard(
                              title: "Products",
                              value: adminProvider.totalProducts.toString(),
                              icon: Icons.shopping_bag,
                              color: const Color(0xFF3B82F6),
                            ),
                            _buildStatCard(
                              title: "Orders",
                              value: adminProvider.totalOrders.toString(),
                              icon: Icons.receipt_long,
                              color: const Color(0xFF22C55E),
                            ),
                            _buildStatCard(
                              title: "Users",
                              value: adminProvider.totalUsers.toString(),
                              icon: Icons.people,
                              color: const Color(0xFF8B5CF6),
                            ),
                            _buildStatCard(
                              title: "Revenue",
                              value:
                                  "\$${adminProvider.totalRevenue.toStringAsFixed(2)}",
                              icon: Icons.attach_money,
                              color: const Color(0xFFF59E0B),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const TitlesTextWidget(label: "Quick actions", fontSize: 18),
                      TextButton.icon(
                        onPressed: _refreshing ? null : _initializeData,
                        icon: const Icon(IconlyLight.refresh, size: 18),
                        label: const Text("Refresh"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AnimatedSection(
                    dy: 0.08,
                    child: Column(
                      children: [
                        _buildActionTile(
                          icon: Icons.add_circle_outline,
                          label: "Add new product",
                          subtitle: "Create and upload product images",
                          color: const Color(0xFF22D3EE),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AddProductScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionTile(
                          icon: Icons.list_alt,
                          label: "Manage products",
                          subtitle: "Search, edit, delete, and inventory",
                          color: const Color(0xFF4ADE80),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const ProductsListScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionTile(
                          icon: Icons.receipt_long,
                          label: "View orders",
                          subtitle: "Track status, revenue, and delivery",
                          color: const Color(0xFF6366F1),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminOrdersScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 10),
                        _buildActionTile(
                          icon: Icons.people,
                          label: "Manage users",
                          subtitle: "Customer list and account actions",
                          color: const Color(0xFFEC4899),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AdminUsersScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  const TitlesTextWidget(label: "Recent updates", fontSize: 18),
                  const SizedBox(height: 12),
                  AnimatedSection(
                    dy: 0.1,
                    child: Consumer<AdminProvider>(
                      builder: (context, adminProvider, child) {
                        return FutureBuilder<List<Map<String, dynamic>>>(
                          future: adminProvider.fetchRecentOrders(limit: 5),
                          builder: (context, snapshot) {
                            final theme = Theme.of(context);
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return _buildRecentLoading();
                            }
                            if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return GlassCard(
                                child: Row(
                                  children: [
                                    Icon(
                                      IconlyLight.info_circle,
                                      color: theme.colorScheme.primary,
                                    ),
                                    const SizedBox(width: 10),
                                    const Expanded(
                                      child: SubtitleTextWidget(
                                        label: "No recent orders yet",
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Column(
                              children: List.generate(snapshot.data!.length,
                                  (index) {
                                final order = snapshot.data![index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _buildRecentOrderTile(
                                    index: index,
                                    orderId: "${order['orderId'] ?? 'N/A'}",
                                    totalPrice: (order['totalPrice'] ?? 0)
                                        .toString(),
                                  ),
                                );
                              }),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 26),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.96, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, s, child) => Transform.scale(scale: s, child: child),
      child: GlassCard(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [
                    color.withValues(alpha: 0.35),
                    color.withValues(alpha: 0.12),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.textTheme.bodySmall?.color
                          ?.withValues(alpha: 0.75),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    value,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return _buildActionTile(
      icon: icon,
      label: label,
      subtitle: "Open",
      color: Theme.of(context).colorScheme.primary,
      onTap: onTap,
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String label,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: GlassCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.35),
                      color.withValues(alpha: 0.12),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Icon(icon, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.textTheme.bodySmall?.color
                            ?.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: theme.iconTheme.color?.withValues(alpha: 0.6),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentLoading() {
    return Column(
      children: List.generate(3, (i) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: GlassCard(
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: AppColors.darkCard.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 12,
                        width: 160,
                        decoration: BoxDecoration(
                          color: AppColors.darkCard.withValues(alpha: 0.6),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 10,
                        width: 110,
                        decoration: BoxDecoration(
                          color: AppColors.darkCard.withValues(alpha: 0.45),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRecentOrderTile({
    required int index,
    required String orderId,
    required String totalPrice,
  }) {
    final theme = Theme.of(context);
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: AppColors.secondaryGradient,
            ),
            child: Text(
              "${index + 1}",
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SubtitleTextWidget(
                  label: "Order #$orderId",
                  fontWeight: FontWeight.w700,
                ),
                const SizedBox(height: 4),
                SubtitleTextWidget(
                  label: "Total: \$$totalPrice",
                  fontSize: 12,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.success.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.25),
              ),
            ),
            child: Text(
              "Completed",
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.success,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

