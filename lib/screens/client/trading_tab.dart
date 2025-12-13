import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/crypto_asset.dart';
import 'package:cryptex_trading/models/trading_signal.dart';
import 'package:cryptex_trading/services/crypto_service.dart';
import 'package:cryptex_trading/services/trading_analysis_service.dart';
import 'package:cryptex_trading/widgets/trading_view_widget.dart';
import 'package:cryptex_trading/widgets/signal_card.dart';

class TradingTab extends StatefulWidget {
  const TradingTab({super.key});

  @override
  State<TradingTab> createState() => _TradingTabState();
}

class _TradingTabState extends State<TradingTab> {
  final CryptoService _cryptoService = CryptoService();
  final TradingAnalysisService _analysisService = TradingAnalysisService();
  
  String _selectedSymbol = 'BTC';
  String _selectedInterval = 'D';
  List<TradingSignal> _signals = [];
  MarketStructure? _structure;
  bool _isAnalyzing = false;

  final List<String> _symbols = ['BTC', 'ETH', 'SOL', 'XRP', 'XAUUSD', 'EURUSD', 'GBPUSD'];
  final List<String> _intervals = ['1', '5', '15', '60', 'D', 'W'];

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  Future<void> _runAnalysis() async {
    setState(() => _isAnalyzing = true);

    await Future.delayed(const Duration(milliseconds: 500));
    
    final candles = List.generate(100, (i) {
      final base = 100000.0 + (i * 50) + (i % 10 * 100);
      return Candle(
        time: DateTime.now().subtract(Duration(hours: 100 - i)),
        open: base,
        high: base + 200 + (i % 5 * 50),
        low: base - 150 - (i % 3 * 30),
        close: base + 100 + (i % 7 * 40),
        volume: 1000000 + (i * 10000),
      );
    });

    final structure = _analysisService.analyzeMarketStructure(candles);
    final signal = _analysisService.generateSignal(_selectedSymbol, candles.last.close, structure);

    if (mounted) {
      setState(() {
        _structure = structure;
        _signals = [signal];
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: const Text('AI Trading Analysis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: _runAnalysis,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSymbol,
                        dropdownColor: AppColors.darkCard,
                        style: const TextStyle(color: Colors.white),
                        items: _symbols.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedSymbol = value);
                            _runAnalysis();
                          }
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedInterval,
                        dropdownColor: AppColors.darkCard,
                        style: const TextStyle(color: Colors.white),
                        items: _intervals.map((i) => DropdownMenuItem(
                          value: i,
                          child: Text(_getIntervalLabel(i)),
                        )).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            setState(() => _selectedInterval = value);
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TradingViewWidget(
              symbol: _selectedSymbol,
              interval: _selectedInterval,
              height: 450,
            ),
            const SizedBox(height: 24),
            if (_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                    SizedBox(width: 12),
                    Text('Analyzing market structure...', style: TextStyle(color: Colors.white)),
                  ],
                ),
              )
            else ...[
              if (_structure != null)
                MarketStructureCard(structure: _structure!),
              const SizedBox(height: 16),
              const Text(
                'AI Trading Signals',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._signals.map((signal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SignalCard(signal: signal),
              )),
              if (_signals.isNotEmpty) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.darkCard,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.auto_awesome, color: AppColors.secondary, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'AI Analysis',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _signals.first.analysis,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14, height: 1.5),
                      ),
                    ],
                  ),
                ),
              ],
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  String _getIntervalLabel(String interval) {
    switch (interval) {
      case '1': return '1 Min';
      case '5': return '5 Min';
      case '15': return '15 Min';
      case '60': return '1 Hour';
      case 'D': return 'Daily';
      case 'W': return 'Weekly';
      default: return interval;
    }
  }
}
