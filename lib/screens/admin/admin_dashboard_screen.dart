import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import '../../providers/products_provider.dart';
import '../../providers/user_provider.dart';
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
    await adminProvider.fetchDashboardData();
    await productsProvider.fetchProducts();
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
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(IconlyLight.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitlesTextWidget(label: "Welcome Admin", fontSize: 24),
              const SizedBox(height: 8),
              const SubtitleTextWidget(label: "Manage your ecommerce store"),
              const SizedBox(height: 24),
              Consumer<AdminProvider>(
                builder: (context, adminProvider, child) {
                  return GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.5,
                    children: [
                      _buildStatCard(
                        title: "Total Products",
                        value: adminProvider.totalProducts.toString(),
                        icon: Icons.shopping_bag,
                        color: Colors.blue,
                      ),
                      _buildStatCard(
                        title: "Total Orders",
                        value: adminProvider.totalOrders.toString(),
                        icon: Icons.receipt,
                        color: Colors.green,
                      ),
                      _buildStatCard(
                        title: "Total Users",
                        value: adminProvider.totalUsers.toString(),
                        icon: Icons.people,
                        color: Colors.purple,
                      ),
                      _buildStatCard(
                        title: "Total Revenue",
                        value:
                            "\$${adminProvider.totalRevenue.toStringAsFixed(2)}",
                        icon: Icons.attach_money,
                        color: Colors.orange,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 32),
              const TitlesTextWidget(label: "Quick Actions", fontSize: 18),
              const SizedBox(height: 16),
              Column(
                children: [
                  _buildActionButton(
                    icon: Icons.add_circle_outline,
                    label: "Add New Product",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.list_alt,
                    label: "Manage Products",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProductsListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.receipt_long,
                    label: "View Orders",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminOrdersScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.people,
                    label: "Manage Users",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminUsersScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    icon: Icons.refresh,
                    label: "Refresh Dashboard",
                    onTap: _initializeData,
                  ),
                ],
              ),
              const SizedBox(height: 32),
              const TitlesTextWidget(label: "Recent Updates", fontSize: 18),
              const SizedBox(height: 16),
              Consumer<AdminProvider>(
                builder: (context, adminProvider, child) {
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: adminProvider.fetchRecentOrders(limit: 5),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: SubtitleTextWidget(
                            label: "No recent orders",
                            fontSize: 14,
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final order = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                child: Text("${index + 1}"),
                              ),
                              title: SubtitleTextWidget(
                                label: "Order #${order['orderId'] ?? 'N/A'}",
                                fontWeight: FontWeight.w600,
                              ),
                              subtitle: SubtitleTextWidget(
                                label: "Total: \$${order['totalPrice'] ?? 0}",
                                fontSize: 12,
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const SubtitleTextWidget(
                                  label: "Completed",
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 2,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [color.withOpacity(0.2), color.withOpacity(0.05)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, size: 32, color: color),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SubtitleTextWidget(label: title, fontSize: 12),
                  const SizedBox(height: 4),
                  TitlesTextWidget(label: value, fontSize: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, size: 28),
            const SizedBox(width: 16),
            TitlesTextWidget(label: label, fontSize: 16),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}

