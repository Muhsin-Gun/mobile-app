import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/crypto_asset.dart';
import 'package:cryptex_trading/services/crypto_service.dart';
import 'package:cryptex_trading/widgets/crypto_card.dart';
import 'package:cryptex_trading/widgets/trading_view_widget.dart';
import 'package:intl/intl.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final CryptoService _cryptoService = CryptoService();
  List<CryptoAsset> _cryptos = [];
  List<ForexPair> _forexPairs = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final cryptos = await _cryptoService.getTopCryptos(limit: 10);
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
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadData,
          color: AppColors.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome Back',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'CrypTex Trading',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppColors.darkCard,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.notifications_outlined, color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1E3A5F), Color(0xFF0D1B2A)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Portfolio Value',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.bullish.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.arrow_upward, color: AppColors.bullish, size: 14),
                                      SizedBox(width: 4),
                                      Text(
                                        '+12.5%',
                                        style: TextStyle(
                                          color: AppColors.bullish,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              currencyFormat.format(125430.50),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildStatCard('Today P/L', '+\$2,340', AppColors.bullish),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard('Win Rate', '68%', AppColors.accent),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: _buildStatCard('Trades', '24', AppColors.secondary),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      const TradingViewTickerTape(),
                      const SizedBox(height: 24),
                      const Text(
                        'Quick Analysis',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const TradingViewWidget(symbol: 'BTC', height: 400),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Top Cryptocurrencies',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('See All', style: TextStyle(color: AppColors.primary)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              if (_isLoading)
                const SliverFillRemaining(
                  child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _cryptos.length) return null;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CryptoCard(crypto: _cryptos[index]),
                        );
                      },
                      childCount: _cryptos.length > 5 ? 5 : _cryptos.length,
                    ),
                  ),
                ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Forex & Commodities',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ..._forexPairs.take(4).map((pair) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ForexPairCard(pair: pair),
                      )),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
