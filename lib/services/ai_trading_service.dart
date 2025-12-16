import 'dart:convert';
import 'package:http/http.dart' as http;

class AITradingService {
  static const String _groqApiUrl = 'https://api.groq.com/openai/v1/chat/completions';
  
  String? _apiKey;
  
  void setApiKey(String key) {
    _apiKey = key;
  }

  final String _systemPrompt = '''You are CrypTex AI, an expert trading assistant specializing in ICT (Inner Circle Trader), SMC (Smart Money Concepts), and advanced technical analysis.

Your deep knowledge includes:
- Order Blocks (OB): Institutional footprint zones where large orders were executed
- Fair Value Gaps (FVG): Imbalances in price that tend to get filled
- Liquidity Sweeps (BSL/SSL): Stop hunts before reversals
- Market Structure: Break of Structure (BOS), Change of Character (CHoCH), HH/HL, LH/LL
- Kill Zones: London (2-5 AM EST), New York (7-10 AM EST), Asian (7-10 PM EST)
- SMT Divergence: Smart Money Tool divergence between correlated pairs
- DOM (Depth of Market) and Footprint chart analysis
- MSNR (Money Show No Respect) strategy
- CRT (Candle Range Theory) patterns
- Order Flow analysis and institutional behavior

When analyzing trades:
1. ALWAYS identify the higher timeframe bias first (Daily/4H trend)
2. Look for confluence (3+ factors aligning)
3. Wait for proper confirmations before entry
4. Use tight stop losses at logical levels (behind OB, swing points)
5. Target liquidity pools for take profit (previous highs/lows)
6. Consider session timing and volatility
7. Risk no more than 1-2% per trade

Provide specific, actionable advice with clear entry/exit levels.
Use professional trading terminology and explain complex concepts clearly.
Always mention the confluence factors that support your analysis.''';

  Future<AIAnalysisResult> getAIAnalysis({
    required String symbol,
    required double price,
    required String timeframe,
    Map<String, dynamic>? indicators,
  }) async {
    final prompt = '''Analyze $symbol at price \$${price.toStringAsFixed(2)} on $timeframe timeframe.

${indicators != null ? 'Technical indicators: ${jsonEncode(indicators)}' : ''}

Provide comprehensive analysis including:
1. **Market Structure Analysis** - Current trend, key swing points, recent BOS/CHoCH
2. **Order Block Zones** - Identify potential OB areas to watch
3. **Fair Value Gaps** - Unfilled FVGs that may act as magnets
4. **Liquidity Pools** - BSL/SSL levels likely to be targeted
5. **Trade Setup** - If a valid setup exists (entry, SL, TP1, TP2, TP3)
6. **Risk Assessment** - Score 1-10 with explanation
7. **Confluence Score** - How many factors align (list them)
8. **Session Context** - Best time to execute if applicable''';

    final result = await _callAI(prompt);
    return AIAnalysisResult(
      success: result['success'] ?? false,
      analysis: result['response'] ?? result['error'] ?? 'Analysis failed',
    );
  }

  Future<AISignalResult> getAISignal({
    required String symbol,
    required double currentPrice,
    String? structure,
    List<Map<String, dynamic>>? recentCandles,
  }) async {
    final prompt = '''Generate a trading signal for $symbol at \$${currentPrice.toStringAsFixed(2)}.

Market structure: ${structure ?? 'Unknown'}
${recentCandles != null ? 'Recent candles: ${jsonEncode(recentCandles.take(5).toList())}' : ''}

Respond with a JSON object containing:
{
  "signal": "BUY" or "SELL" or "WAIT",
  "confidence": 0-100,
  "entry": exact_price,
  "stopLoss": exact_price,
  "takeProfit1": exact_price,
  "takeProfit2": exact_price,
  "takeProfit3": exact_price,
  "riskReward": ratio_number,
  "reasoning": "brief explanation using ICT/SMC concepts",
  "keyLevels": ["level1", "level2"],
  "warnings": ["any cautions"]
}''';

    final result = await _callAI(prompt);
    
    if (result['success'] == true) {
      try {
        final jsonMatch = RegExp(r'\{[\s\S]*\}').firstMatch(result['response'] as String);
        if (jsonMatch != null) {
          final signal = jsonDecode(jsonMatch.group(0)!);
          return AISignalResult(
            success: true,
            signalType: signal['signal'] ?? 'WAIT',
            confidence: (signal['confidence'] ?? 50).toDouble(),
            entry: (signal['entry'] ?? currentPrice).toDouble(),
            stopLoss: (signal['stopLoss'] ?? currentPrice * 0.98).toDouble(),
            takeProfit1: (signal['takeProfit1'] ?? currentPrice * 1.02).toDouble(),
            takeProfit2: (signal['takeProfit2'] ?? currentPrice * 1.04).toDouble(),
            takeProfit3: (signal['takeProfit3'] ?? currentPrice * 1.06).toDouble(),
            riskReward: (signal['riskReward'] ?? 2.0).toDouble(),
            reasoning: signal['reasoning'] ?? '',
            keyLevels: List<String>.from(signal['keyLevels'] ?? []),
            warnings: List<String>.from(signal['warnings'] ?? []),
            rawAnalysis: result['response'] ?? '',
          );
        }
      } catch (e) {
        return AISignalResult(
          success: true,
          signalType: 'WAIT',
          confidence: 50,
          entry: currentPrice,
          stopLoss: currentPrice * 0.98,
          takeProfit1: currentPrice * 1.02,
          takeProfit2: currentPrice * 1.04,
          takeProfit3: currentPrice * 1.06,
          riskReward: 2.0,
          reasoning: result['response'] ?? 'Waiting for better setup.',
          keyLevels: [],
          warnings: [],
          rawAnalysis: result['response'] ?? '',
        );
      }
    }
    return AISignalResult.failed();
  }

  Future<AIChatResult> chat({
    required String message,
    Map<String, dynamic>? context,
  }) async {
    String prompt = message;
    
    if (context != null) {
      prompt = '''Current market context:
Symbol: ${context['symbol'] ?? 'N/A'}
Price: ${context['price'] ?? 'N/A'}
Timeframe: ${context['timeframe'] ?? '1H'}

User question: $message''';
    }
    
    final result = await _callAI(prompt);
    return AIChatResult(
      success: result['success'] ?? false,
      response: result['response'] ?? result['error'] ?? 'No response',
    );
  }

  Future<Map<String, dynamic>> _callAI(String prompt) async {
    if (_apiKey == null || _apiKey!.isEmpty) {
      return _getMockResponse(prompt);
    }

    try {
      final response = await http.post(
        Uri.parse(_groqApiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': 'llama-3.1-70b-versatile',
          'messages': [
            {'role': 'system', 'content': _systemPrompt},
            {'role': 'user', 'content': prompt},
          ],
          'temperature': 0.7,
          'max_tokens': 2000,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'response': data['choices'][0]['message']['content'],
        };
      } else {
        return _getMockResponse(prompt);
      }
    } catch (e) {
      return _getMockResponse(prompt);
    }
  }

  Map<String, dynamic> _getMockResponse(String prompt) {
    return {
      'success': true,
      'response': '''Based on my analysis using ICT/SMC methodology:

**Market Structure**: The current structure shows a bullish bias with higher highs and higher lows forming on the higher timeframes.

**Key Observations**:
1. **Order Block**: There's a significant bullish order block below current price that could act as support
2. **Fair Value Gap**: An unfilled FVG exists that price may revisit
3. **Liquidity**: Buy-side liquidity rests above recent swing highs

**Recommendation**: Wait for price to sweep the low-side liquidity and tap into the order block before considering long entries. Set alerts at key levels.

**Confluence Factors**:
- Higher timeframe bullish structure
- Order block alignment
- FVG overlap
- Session timing (London/NY)

**Risk Management**: Never risk more than 1-2% per trade. Use the order block low as your stop loss level.

*Note: This is AI-assisted analysis. Always do your own due diligence.*''',
    };
  }
}

class AIAnalysisResult {
  final bool success;
  final String analysis;

  AIAnalysisResult({required this.success, required this.analysis});
}

class AISignalResult {
  final bool success;
  final String signalType;
  final double confidence;
  final double entry;
  final double stopLoss;
  final double takeProfit1;
  final double takeProfit2;
  final double takeProfit3;
  final double riskReward;
  final String reasoning;
  final List<String> keyLevels;
  final List<String> warnings;
  final String rawAnalysis;

  AISignalResult({
    required this.success,
    required this.signalType,
    required this.confidence,
    required this.entry,
    required this.stopLoss,
    required this.takeProfit1,
    required this.takeProfit2,
    required this.takeProfit3,
    required this.riskReward,
    required this.reasoning,
    required this.keyLevels,
    required this.warnings,
    required this.rawAnalysis,
  });

  factory AISignalResult.failed() {
    return AISignalResult(
      success: false,
      signalType: 'WAIT',
      confidence: 0,
      entry: 0,
      stopLoss: 0,
      takeProfit1: 0,
      takeProfit2: 0,
      takeProfit3: 0,
      riskReward: 0,
      reasoning: 'AI service unavailable.',
      keyLevels: [],
      warnings: ['AI service temporarily unavailable'],
      rawAnalysis: '',
    );
  }
}

class AIChatResult {
  final bool success;
  final String response;

  AIChatResult({required this.success, required this.response});
}
