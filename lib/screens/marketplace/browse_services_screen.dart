import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:services_marketplace/constants/app_colors.dart';
import 'package:services_marketplace/providers/marketplace_provider.dart';
import 'package:iconly/iconly.dart';

class BrowseServicesScreen extends StatefulWidget {
  final String category;

  const BrowseServicesScreen({super.key, required this.category});

  @override
  State<BrowseServicesScreen> createState() => _BrowseServicesScreenState();
}

class _BrowseServicesScreenState extends State<BrowseServicesScreen> {
  late String _selectedSort;

  @override
  void initState() {
    super.initState();
    _selectedSort = 'rating';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.category != 'all') {
        Provider.of<MarketplaceProvider>(
          context,
          listen: false,
        ).fetchServices(category: widget.category);
      } else {
        Provider.of<MarketplaceProvider>(
          context,
          listen: false,
        ).fetchServices();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category == 'all' ? 'All Services' : widget.category,
        ),
        elevation: 0,
        backgroundColor: AppColors.darkBackground,
      ),
      body: Column(
        children: [
          // Filter and Sort
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.2),
                      ),
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        prefixIcon: const Icon(IconlyLight.search),
                        contentPadding: const EdgeInsets.all(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.2),
                    ),
                  ),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      setState(() => _selectedSort = value);
                    },
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'rating',
                        child: Text('Top Rated'),
                      ),
                      const PopupMenuItem(
                        value: 'price_low',
                        child: Text('Price: Low to High'),
                      ),
                      const PopupMenuItem(
                        value: 'price_high',
                        child: Text('Price: High to Low'),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Icon(
                        IconlyLight.setting,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Services List
          Expanded(
            child: Consumer<MarketplaceProvider>(
              builder: (context, marketplace, _) {
                if (marketplace.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (marketplace.services.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          IconlyLight.search,
                          size: 64,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No services found',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: marketplace.services.length,
                  itemBuilder: (context, index) {
                    final service = marketplace.services[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: AppColors.darkCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 150,
                            decoration: const BoxDecoration(
                              color: Color(0xFF1F2937),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: Icon(
                              IconlyLight.image_2,
                              color: AppColors.primary,
                              size: 48,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  service.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withValues(alpha: 0.6),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '\$${service.price.toStringAsFixed(2)}',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary,
                                          ),
                                        ),
                                        Text(
                                          'Delivery: ${service.deliveryDays} days',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.white.withValues(
                                              alpha: 0.5,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: AppColors.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          service.rating.toStringAsFixed(1),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.2,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Text(
                                            'View',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: AppColors.primary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
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
            ),
          ),
        ],
      ),
    );
  }
}
