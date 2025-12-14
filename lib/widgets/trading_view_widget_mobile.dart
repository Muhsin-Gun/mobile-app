import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';

class TradingViewWidget extends StatefulWidget {
  final String symbol;
  final String interval;
  final double height;

  const TradingViewWidget({
    super.key,
    required this.symbol,
    this.interval = 'D',
    this.height = 500,
  });

  @override
  State<TradingViewWidget> createState() => _TradingViewWidgetState();
}

class _TradingViewWidgetState extends State<TradingViewWidget> {
  String _formatSymbol(String symbol) {
    final cryptoSymbols = ['BTC', 'ETH', 'SOL', 'XRP', 'ADA', 'DOGE', 'DOT', 'AVAX', 'LINK', 'MATIC'];
    final upperSymbol = symbol.toUpperCase();
    
    if (cryptoSymbols.contains(upperSymbol)) {
      return 'BINANCE:${upperSymbol}USDT';
    }
    
    if (upperSymbol.contains('USD') || upperSymbol.contains('EUR') || 
        upperSymbol.contains('GBP') || upperSymbol.contains('JPY')) {
      return 'FX:$upperSymbol';
    }
    
    if (upperSymbol == 'XAUUSD' || upperSymbol == 'GOLD') {
      return 'TVC:GOLD';
    }
    
    return symbol;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        color: AppColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.darkBorder),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.candlestick_chart,
                size: 64,
                color: AppColors.primary.withOpacity(0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'TradingView Chart',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${_formatSymbol(widget.symbol)}',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Interactive charts available on web version',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TradingViewMiniChart extends StatefulWidget {
  final String symbol;
  final double height;

  const TradingViewMiniChart({
    super.key,
    required this.symbol,
    this.height = 200,
  });

  @override
  State<TradingViewMiniChart> createState() => _TradingViewMiniChartState();
}

class _TradingViewMiniChartState extends State<TradingViewMiniChart> {
  String _formatSymbol(String symbol) {
    final upperSymbol = symbol.toUpperCase();
    if (['BTC', 'ETH', 'SOL', 'XRP', 'ADA', 'DOGE'].contains(upperSymbol)) {
      return 'BINANCE:${upperSymbol}USDT';
    }
    return symbol;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.darkBorder),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.trending_up,
                color: AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatSymbol(widget.symbol),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'Mini chart on web',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.white.withOpacity(0.4),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class TradingViewTickerTape extends StatefulWidget {
  const TradingViewTickerTape({super.key});

  @override
  State<TradingViewTickerTape> createState() => _TradingViewTickerTapeState();
}

class _TradingViewTickerTapeState extends State<TradingViewTickerTape> {
  @override
  Widget build(BuildContext context) {
    final symbols = [
      {'symbol': 'BTC', 'name': 'Bitcoin', 'price': '\$45,230'},
      {'symbol': 'ETH', 'name': 'Ethereum', 'price': '\$2,890'},
      {'symbol': 'SOL', 'name': 'Solana', 'price': '\$98.50'},
    ];

    return SizedBox(
      height: 46,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkSurface,
          border: Border.all(color: AppColors.darkBorder),
        ),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: symbols.length,
          itemBuilder: (context, index) {
            final symbol = symbols[index];
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    symbol['symbol']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    symbol['price']!,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 14,
                    ),
                  ),
                  if (index < symbols.length - 1) 
                    Container(
                      margin: const EdgeInsets.only(left: 16),
                      width: 1,
                      height: 20,
                      color: AppColors.darkBorder,
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}