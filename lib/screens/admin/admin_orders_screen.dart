import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../../providers/admin_provider.dart';
import '../../widgets/subtitle_text.dart';
import '../../widgets/title_text.dart';

class AdminOrdersScreen extends StatefulWidget {
  static const routName = "/AdminOrdersScreen";

  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Orders Management')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitlesTextWidget(label: "All Orders", fontSize: 20),
            const SizedBox(height: 16),
            Expanded(
              child: Consumer<AdminProvider>(
                builder: (context, adminProvider, child) {
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: adminProvider.fetchRecentOrders(limit: 1000),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                IconlyLight.bag,
                                size: 64,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 16),
                              SubtitleTextWidget(label: 'No orders yet'),
                            ],
                          ),
                        );
                      }
                      final orders = snapshot.data!;
                      return ListView.builder(
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            child: ExpansionTile(
                              title: TitlesTextWidget(
                                label: "Order #${order['orderId'] ?? 'N/A'}",
                                fontSize: 16,
                              ),
                              subtitle: SubtitleTextWidget(
                                label: "Total: \$${order['totalPrice'] ?? 0}",
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SubtitleTextWidget(
                                        label:
                                            "Customer: ${order['customerName'] ?? 'Unknown'}",
                                        fontWeight: FontWeight.w600,
                                      ),
                                      const SizedBox(height: 8),
                                      SubtitleTextWidget(
                                        label:
                                            "Email: ${order['customerEmail'] ?? 'N/A'}",
                                      ),
                                      const SizedBox(height: 8),
                                      SubtitleTextWidget(
                                        label:
                                            "Address: ${order['shippingAddress'] ?? 'N/A'}",
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 8,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: const SubtitleTextWidget(
                                          label: "Status: Completed",
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

