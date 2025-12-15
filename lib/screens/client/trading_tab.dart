import 'package:flutter/material.dart';
import 'package:cryptex_trading/constants/app_colors.dart';
import 'package:cryptex_trading/models/crypto_asset.dart';
import 'package:cryptex_trading/models/trading_signal.dart';
import 'package:cryptex_trading/services/crypto_service.dart';
import 'package:cryptex_trading/services/trading_analysis_service.dart';
import 'package:cryptex_trading/services/ai_trading_service.dart';
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
  final AITradingService _aiService = AITradingService();
  
  String _selectedSymbol = 'BTC';
  String _selectedInterval = 'D';
  List<TradingSignal> _signals = [];
  MarketStructure? _structure;
  bool _isAnalyzing = false;
  String _aiAnalysis = '';
  bool _useAI = true;
  AISignalResult? _aiSignal;
  String _chatMessage = '';
  String _chatResponse = '';
  bool _isChatting = false;
  final TextEditingController _chatController = TextEditingController();

  final List<String> _symbols = ['BTC', 'ETH', 'SOL', 'XRP', 'XAUUSD', 'EURUSD', 'GBPUSD'];
  final List<String> _intervals = ['1', '5', '15', '60', 'D', 'W'];

  @override
  void initState() {
    super.initState();
    _runAnalysis();
  }

  @override
  void dispose() {
    _chatController.dispose();
    super.dispose();
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

    if (_useAI) {
      final aiAnalysisResult = await _aiService.getAIAnalysis(
        symbol: _selectedSymbol,
        price: candles.last.close,
        timeframe: _getTimeframeLabel(_selectedInterval),
        indicators: {
          'trend': structure.trend,
          'bias': structure.bias,
          'phase': structure.currentPhase,
          'bos': structure.breakOfStructure,
          'choch': structure.changeOfCharacter,
        },
      );

      final aiSignalResult = await _aiService.getAISignal(
        symbol: _selectedSymbol,
        currentPrice: candles.last.close,
        structure: structure.trend,
        recentCandles: candles.sublist(candles.length - 5).map((c) => {
          'open': c.open,
          'high': c.high,
          'low': c.low,
          'close': c.close,
        }).toList(),
      );

      if (mounted) {
        setState(() {
          _aiAnalysis = aiAnalysisResult.success ? aiAnalysisResult.analysis : signal.analysis;
          _aiSignal = aiSignalResult.success ? aiSignalResult : null;
        });
      }
    }

    if (mounted) {
      setState(() {
        _structure = structure;
        _signals = [signal];
        _isAnalyzing = false;
      });
    }
  }

  Future<void> _sendChatMessage() async {
    if (_chatController.text.trim().isEmpty) return;
    
    setState(() {
      _chatMessage = _chatController.text.trim();
      _isChatting = true;
      _chatResponse = '';
    });

    final result = await _aiService.chat(
      message: _chatMessage,
      context: {
        'symbol': _selectedSymbol,
        'timeframe': _getTimeframeLabel(_selectedInterval),
        'structure': _structure?.trend ?? 'Unknown',
        'bias': _structure?.bias ?? 'Neutral',
      },
    );

    if (mounted) {
      setState(() {
        _chatResponse = result.response;
        _isChatting = false;
        _chatController.clear();
      });
    }
  }

  String _getTimeframeLabel(String interval) {
    switch (interval) {
      case '1': return '1 Minute';
      case '5': return '5 Minutes';
      case '15': return '15 Minutes';
      case '60': return '1 Hour';
      case 'D': return 'Daily';
      case 'W': return 'Weekly';
      default: return interval;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkSurface,
        elevation: 0,
        title: Row(
          children: [
            const Icon(Icons.auto_awesome, color: AppColors.secondary, size: 24),
            const SizedBox(width: 8),
            const Text('AI Trading Analysis', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            child: Row(
              children: [
                Text('AI', style: TextStyle(color: _useAI ? AppColors.primary : Colors.grey, fontSize: 12)),
                Switch(
                  value: _useAI,
                  onChanged: (value) {
                    setState(() => _useAI = value);
                    _runAnalysis();
                  },
                  activeColor: AppColors.primary,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
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
                            _runAnalysis();
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
              height: 400,
            ),
            const SizedBox(height: 20),
            if (_isAnalyzing)
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _useAI ? 'AI analyzing market structure...' : 'Analyzing market structure...',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              )
            else ...[
              if (_structure != null)
                MarketStructureCard(structure: _structure!),
              const SizedBox(height: 16),
              
              if (_aiSignal != null && _aiSignal!.success) ...[
                _buildAISignalCard(_aiSignal!),
                const SizedBox(height: 16),
              ],
              
              const Text(
                'Trading Signals',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._signals.map((signal) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: SignalCard(signal: signal),
              )),
              
              if (_useAI && _aiAnalysis.isNotEmpty) ...[
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.psychology, color: AppColors.secondary, size: 20),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'AI Analysis (Powered by Groq)',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _aiAnalysis,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 14, height: 1.6),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 24),
              _buildChatSection(),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAISignalCard(AISignalResult signal) {
    Color signalColor;
    IconData signalIcon;
    
    switch (signal.signalType) {
      case 'BUY':
        signalColor = Colors.green;
        signalIcon = Icons.trending_up;
        break;
      case 'SELL':
        signalColor = Colors.red;
        signalIcon = Icons.trending_down;
        break;
      default:
        signalColor = Colors.orange;
        signalIcon = Icons.pause;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: signalColor.withValues(alpha: 0.5), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: signalColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(signalIcon, color: signalColor, size: 24),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'AI Signal: ${signal.signalType}',
                      style: TextStyle(color: signalColor, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Confidence: ${signal.confidence.toStringAsFixed(0)}%',
                      style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: signalColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'R:R ${signal.riskReward.toStringAsFixed(1)}',
                  style: TextStyle(color: signalColor, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildPriceLevel('Entry', signal.entry, Colors.white)),
              Expanded(child: _buildPriceLevel('Stop Loss', signal.stopLoss, Colors.red)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(child: _buildPriceLevel('TP1', signal.takeProfit1, Colors.green)),
              Expanded(child: _buildPriceLevel('TP2', signal.takeProfit2, Colors.green)),
              Expanded(child: _buildPriceLevel('TP3', signal.takeProfit3, Colors.green)),
            ],
          ),
          if (signal.reasoning.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              signal.reasoning,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13, height: 1.4),
            ),
          ],
          if (signal.warnings.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...signal.warnings.map((w) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber, color: Colors.orange, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(w, style: const TextStyle(color: Colors.orange, fontSize: 12)),
                  ),
                ],
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildPriceLevel(String label, double price, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11)),
        Text(
          price.toStringAsFixed(price > 1000 ? 2 : 4),
          style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildChatSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.chat, color: AppColors.primary, size: 20),
              SizedBox(width: 8),
              Text(
                'Ask the AI Trading Assistant',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _chatController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Ask about trading strategies, setups, analysis...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.4)),
                    filled: true,
                    fillColor: AppColors.darkBackground,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendChatMessage(),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: _isChatting ? null : _sendChatMessage,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.all(14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: _isChatting
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Icon(Icons.send, color: Colors.white),
              ),
            ],
          ),
          if (_chatResponse.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.darkBackground,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_chatMessage.isNotEmpty) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.person, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _chatMessage,
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.white24, height: 20),
                  ],
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.psychology, color: AppColors.secondary, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _chatResponse,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.85), height: 1.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
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
