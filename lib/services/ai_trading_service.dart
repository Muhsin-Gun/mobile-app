import 'dart:convert';
import 'package:http/http.dart' as http;

class AITradingService {
  static const String _baseUrl = 'https://374106e5-8487-4772-be80-e7dfd58f4ebc-00-2l4td8fqy7lcx.worf.replit.dev';

  Future<AIAnalysisResult> getAIAnalysis({
    required String symbol,
    required double price,
    required String timeframe,
    Map<String, dynamic>? indicators,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/ai/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'symbol': symbol,
          'price': price,
          'timeframe': timeframe,
          'indicators': indicators,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return AIAnalysisResult(
            success: true,
            analysis: data['response'] ?? 'Analysis complete.',
          );
        }
      }
      return AIAnalysisResult(
        success: false,
        analysis: 'Unable to get AI analysis. Using local analysis instead.',
      );
    } catch (e) {
      return AIAnalysisResult(
        success: false,
        analysis: 'AI service temporarily unavailable. Using local analysis.',
      );
    }
  }

  Future<AISignalResult> getAISignal({
    required String symbol,
    required double currentPrice,
    String? structure,
    List<Map<String, dynamic>>? recentCandles,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/ai/signal'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'symbol': symbol,
          'currentPrice': currentPrice,
          'structure': structure,
          'recentCandles': recentCandles,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          final signal = data['signal'];
          if (signal != null) {
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
              rawAnalysis: data['rawAnalysis'] ?? '',
            );
          }
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
            reasoning: data['rawAnalysis'] ?? 'Waiting for better setup.',
            keyLevels: [],
            warnings: [],
            rawAnalysis: data['rawAnalysis'] ?? '',
          );
        }
      }
      return AISignalResult.failed();
    } catch (e) {
      return AISignalResult.failed();
    }
  }

  Future<AIChatResult> chat({
    required String message,
    Map<String, dynamic>? context,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/api/ai/chat'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'message': message,
          'context': context,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return AIChatResult(
            success: true,
            response: data['response'] ?? 'No response from AI.',
          );
        }
      }
      return AIChatResult(
        success: false,
        response: 'Unable to get response from AI assistant.',
      );
    } catch (e) {
      return AIChatResult(
        success: false,
        response: 'AI assistant temporarily unavailable.',
      );
    }
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
