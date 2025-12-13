import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/crypto_asset.dart';
import 'package:intl/intl.dart';

class CryptoCard extends StatelessWidget {
  final CryptoAsset crypto;
  final VoidCallback? onTap;

  const CryptoCard({super.key, required this.crypto, this.onTap});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
    final isPositive = crypto.isPositive;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.darkSurface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      crypto.image,
                      width: 40,
                      height: 40,
                      errorBuilder: (_, __, ___) => Center(
                        child: Text(
                          crypto.symbol.substring(0, 1),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        crypto.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        crypto.symbol,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (isPositive ? AppColors.bullish : AppColors.bearish).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPositive ? Icons.arrow_upward : Icons.arrow_downward,
                        size: 14,
                        color: isPositive ? AppColors.bullish : AppColors.bearish,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${isPositive ? '+' : ''}${crypto.priceChangePercentage24h.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: isPositive ? AppColors.bullish : AppColors.bearish,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (crypto.sparklineData.isNotEmpty)
              SizedBox(
                height: 60,
                child: LineChart(
                  LineChartData(
                    gridData: const FlGridData(show: false),
                    titlesData: const FlTitlesData(show: false),
                    borderData: FlBorderData(show: false),
                    lineTouchData: const LineTouchData(enabled: false),
                    lineBarsData: [
                      LineChartBarData(
                        spots: crypto.sparklineData.asMap().entries
                            .map((e) => FlSpot(e.key.toDouble(), e.value))
                            .toList(),
                        isCurved: true,
                        color: isPositive ? AppColors.bullish : AppColors.bearish,
                        barWidth: 2,
                        isStrokeCapRound: true,
                        dotData: const FlDotData(show: false),
                        belowBarData: BarAreaData(
                          show: true,
                          color: (isPositive ? AppColors.bullish : AppColors.bearish).withValues(alpha: 0.1),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  currencyFormat.format(crypto.currentPrice),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      'Vol: ${_formatVolume(crypto.volume24h)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                    Text(
                      'MCap: ${_formatVolume(crypto.marketCap)}',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatVolume(double volume) {
    if (volume >= 1e12) return '${(volume / 1e12).toStringAsFixed(2)}T';
    if (volume >= 1e9) return '${(volume / 1e9).toStringAsFixed(2)}B';
    if (volume >= 1e6) return '${(volume / 1e6).toStringAsFixed(2)}M';
    if (volume >= 1e3) return '${(volume / 1e3).toStringAsFixed(2)}K';
    return volume.toStringAsFixed(2);
  }
}

class ForexPairCard extends StatelessWidget {
  final ForexPair pair;
  final VoidCallback? onTap;

  const ForexPairCard({super.key, required this.pair, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  pair.symbol,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (pair.isPositive ? AppColors.bullish : AppColors.bearish).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${pair.isPositive ? '+' : ''}${pair.changePercent.toStringAsFixed(2)}%',
                    style: TextStyle(
                      color: pair.isPositive ? AppColors.bullish : AppColors.bearish,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bid', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                      Text(
                        pair.bid.toStringAsFixed(pair.bid < 10 ? 5 : 3),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('Ask', style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 12)),
                      Text(
                        pair.ask.toStringAsFixed(pair.ask < 10 ? 5 : 3),
                        style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Spread: ${(pair.spread * 10000).toStringAsFixed(1)} pips',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                ),
                Text(
                  'H: ${pair.high.toStringAsFixed(pair.high < 10 ? 4 : 2)} L: ${pair.low.toStringAsFixed(pair.low < 10 ? 4 : 2)}',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
