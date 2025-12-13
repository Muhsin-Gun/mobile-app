import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/trading_signal.dart';
import 'package:intl/intl.dart';

class SignalCard extends StatelessWidget {
  final TradingSignal signal;
  final VoidCallback? onTap;

  const SignalCard({super.key, required this.signal, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isBuy = signal.type == SignalType.buy;
    final signalColor = isBuy ? AppColors.bullish : (signal.type == SignalType.sell ? AppColors.bearish : AppColors.neutral);
    final dateFormat = DateFormat('MMM dd, HH:mm');

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: signalColor.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: signalColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        signal.typeText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      signal.symbol,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStrengthColor(signal.strength).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        signal.strengthText,
                        style: TextStyle(
                          color: _getStrengthColor(signal.strength),
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(signal.confidence * 100).toInt()}% confidence',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkSurface,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildPriceRow('Entry', signal.entryPrice, Colors.white),
                  const SizedBox(height: 8),
                  _buildPriceRow('Stop Loss', signal.stopLoss, AppColors.bearish),
                  const SizedBox(height: 8),
                  _buildPriceRow('TP 1', signal.takeProfit1, AppColors.bullish),
                  const SizedBox(height: 8),
                  _buildPriceRow('TP 2', signal.takeProfit2, AppColors.bullish),
                  const SizedBox(height: 8),
                  _buildPriceRow('TP 3', signal.takeProfit3, AppColors.bullish),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'R:R ${signal.riskRewardRatio.toStringAsFixed(2)}:1',
                  style: const TextStyle(
                    color: AppColors.accent,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Text(
                  dateFormat.format(signal.timestamp),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: signal.strategies.map((s) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _getStrategyName(s),
                  style: const TextStyle(
                    color: AppColors.secondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, double price, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
        ),
        Text(
          price.toStringAsFixed(price > 100 ? 2 : 5),
          style: TextStyle(color: color, fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ],
    );
  }

  Color _getStrengthColor(SignalStrength strength) {
    switch (strength) {
      case SignalStrength.veryStrong: return AppColors.primary;
      case SignalStrength.strong: return AppColors.bullish;
      case SignalStrength.moderate: return AppColors.warning;
      case SignalStrength.weak: return AppColors.neutral;
    }
  }

  String _getStrategyName(StrategyType type) {
    switch (type) {
      case StrategyType.ict: return 'ICT';
      case StrategyType.smc: return 'SMC';
      case StrategyType.smt: return 'SMT';
      case StrategyType.orderFlow: return 'Order Flow';
      case StrategyType.priceAction: return 'Price Action';
      case StrategyType.fundamental: return 'Fundamental';
      case StrategyType.quant: return 'Quant';
    }
  }
}

class MarketStructureCard extends StatelessWidget {
  final MarketStructure structure;

  const MarketStructureCard({super.key, required this.structure});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Market Structure Analysis',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          _buildRow('Trend', structure.trend, _getTrendColor(structure.trend)),
          _buildRow('Bias', structure.bias, _getBiasColor(structure.bias)),
          _buildRow('Phase', structure.currentPhase, AppColors.accent),
          if (structure.breakOfStructure)
            _buildRow('BOS', 'Confirmed', AppColors.bullish),
          if (structure.changeOfCharacter)
            _buildRow('CHoCH', 'Detected', AppColors.warning),
          const SizedBox(height: 12),
          const Text(
            'Key Levels',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 8),
          if (structure.orderBlockHigh != null)
            _buildLevel('OB High', structure.orderBlockHigh!, AppColors.orderBlock),
          if (structure.orderBlockLow != null)
            _buildLevel('OB Low', structure.orderBlockLow!, AppColors.orderBlock),
          if (structure.fairValueGapHigh != null)
            _buildLevel('FVG High', structure.fairValueGapHigh!, AppColors.fairValueGap),
          if (structure.fairValueGapLow != null)
            _buildLevel('FVG Low', structure.fairValueGapLow!, AppColors.fairValueGap),
          if (structure.buySideLiquidity != null)
            _buildLevel('BSL', structure.buySideLiquidity!, AppColors.liquidity),
          if (structure.sellSideLiquidity != null)
            _buildLevel('SSL', structure.sellSideLiquidity!, AppColors.liquidity),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7))),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(value, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildLevel(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13)),
            ],
          ),
          Text(
            value.toStringAsFixed(value > 100 ? 2 : 5),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Color _getTrendColor(String trend) {
    if (trend == 'Bullish') return AppColors.bullish;
    if (trend == 'Bearish') return AppColors.bearish;
    return AppColors.neutral;
  }

  Color _getBiasColor(String bias) {
    if (bias == 'Long') return AppColors.bullish;
    if (bias == 'Short') return AppColors.bearish;
    return AppColors.neutral;
  }
}
