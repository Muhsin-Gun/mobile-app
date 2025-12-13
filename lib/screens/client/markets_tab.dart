import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/crypto_asset.dart';
import 'package:cryptex_trading/services/crypto_service.dart';
import 'package:cryptex_trading/widgets/crypto_card.dart';

class MarketsTab extends StatefulWidget {
  const MarketsTab({super.key});

  @override
  State<MarketsTab> createState() => _MarketsTabState();
}

class _MarketsTabState extends State<MarketsTab> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final CryptoService _cryptoService = CryptoService();
  List<CryptoAsset> _cryptos = [];
  List<ForexPair> _forexPairs = [];
  bool _isLoading = true;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final cryptos = await _cryptoService.getTopCryptos(limit: 50);
    final forexPairs = _cryptoService.getForexPairs();
    if (mounted) {
      setState(() {
        _cryptos = cryptos;
        _forexPairs = forexPairs;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: const Text('Markets', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  onChanged: (value) => setState(() => _searchQuery = value.toLowerCase()),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search markets...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    prefixIcon: Icon(Icons.search, color: Colors.white.withValues(alpha: 0.5)),
                    filled: true,
                    fillColor: AppColors.darkCard,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: Colors.white.withValues(alpha: 0.5),
                indicatorColor: AppColors.primary,
                tabs: const [
                  Tab(text: 'Crypto'),
                  Tab(text: 'Forex'),
                  Tab(text: 'Watchlist'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildCryptoList(),
          _buildForexList(),
          _buildWatchlist(),
        ],
      ),
    );
  }

  Widget _buildCryptoList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    final filtered = _cryptos.where((c) =>
      c.name.toLowerCase().contains(_searchQuery) ||
      c.symbol.toLowerCase().contains(_searchQuery)
    ).toList();

    return RefreshIndicator(
      onRefresh: _loadData,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: filtered.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: CryptoCard(crypto: filtered[index]),
        ),
      ),
    );
  }

  Widget _buildForexList() {
    final filtered = _forexPairs.where((p) =>
      p.symbol.toLowerCase().contains(_searchQuery)
    ).toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ForexPairCard(pair: filtered[index]),
      ),
    );
  }

  Widget _buildWatchlist() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.star_border, size: 64, color: Colors.white.withValues(alpha: 0.3)),
          const SizedBox(height: 16),
          Text(
            'Your watchlist is empty',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 16),
          ),
          const SizedBox(height: 8),
          Text(
            'Add assets to track them here',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
