import 'dart:math';
import 'package:cryptex_trading/models/crypto_asset.dart';
import 'package:cryptex_trading/models/trading_signal.dart';

class TradingAnalysisService {
  final Random _random = Random();

  MarketStructure analyzeMarketStructure(List<Candle> candles) {
    if (candles.isEmpty) {
      return MarketStructure(
        trend: 'Unknown',
        bias: 'Neutral',
        breakOfStructure: false,
        changeOfCharacter: false,
        currentPhase: 'Unknown',
      );
    }

    final recentCandles = candles.length > 20 ? candles.sublist(candles.length - 20) : candles;
    
    List<double> highs = recentCandles.map((c) => c.high).toList();
    List<double> lows = recentCandles.map((c) => c.low).toList();
    
    bool hasHigherHighs = _hasHigherHighs(highs);
    bool hasHigherLows = _hasHigherLows(lows);
    bool hasLowerHighs = _hasLowerHighs(highs);
    bool hasLowerLows = _hasLowerLows(lows);
    
    String trend;
    String bias;
    
    if (hasHigherHighs && hasHigherLows) {
      trend = 'Bullish';
      bias = 'Long';
    } else if (hasLowerHighs && hasLowerLows) {
      trend = 'Bearish';
      bias = 'Short';
    } else {
      trend = 'Ranging';
      bias = 'Neutral';
    }

    double? orderBlockHigh = _findOrderBlockHigh(recentCandles);
    double? orderBlockLow = _findOrderBlockLow(recentCandles);
    double? fvgHigh = _findFVGHigh(recentCandles);
    double? fvgLow = _findFVGLow(recentCandles);
    double buySideLiquidity = highs.reduce(max);
    double sellSideLiquidity = lows.reduce(min);
    
    bool bos = _detectBOS(recentCandles);
    bool choch = _detectCHoCH(recentCandles);
    
    String phase = _determineMarketPhase(recentCandles);

    return MarketStructure(
      trend: trend,
      bias: bias,
      orderBlockHigh: orderBlockHigh,
      orderBlockLow: orderBlockLow,
      fairValueGapHigh: fvgHigh,
      fairValueGapLow: fvgLow,
      buySideLiquidity: buySideLiquidity,
      sellSideLiquidity: sellSideLiquidity,
      breakOfStructure: bos,
      changeOfCharacter: choch,
      currentPhase: phase,
    );
  }

  bool _hasHigherHighs(List<double> highs) {
    if (highs.length < 3) return false;
    int count = 0;
    for (int i = 2; i < highs.length; i += 3) {
      if (highs[i] > highs[i - 2]) count++;
    }
    return count >= (highs.length / 6);
  }

  bool _hasHigherLows(List<double> lows) {
    if (lows.length < 3) return false;
    int count = 0;
    for (int i = 2; i < lows.length; i += 3) {
      if (lows[i] > lows[i - 2]) count++;
    }
    return count >= (lows.length / 6);
  }

  bool _hasLowerHighs(List<double> highs) {
    if (highs.length < 3) return false;
    int count = 0;
    for (int i = 2; i < highs.length; i += 3) {
      if (highs[i] < highs[i - 2]) count++;
    }
    return count >= (highs.length / 6);
  }

  bool _hasLowerLows(List<double> lows) {
    if (lows.length < 3) return false;
    int count = 0;
    for (int i = 2; i < lows.length; i += 3) {
      if (lows[i] < lows[i - 2]) count++;
    }
    return count >= (lows.length / 6);
  }

  double? _findOrderBlockHigh(List<Candle> candles) {
    for (int i = candles.length - 1; i >= 2; i--) {
      if (candles[i].isBullish && !candles[i-1].isBullish && candles[i].body > candles[i-1].body * 1.5) {
        return candles[i-1].high;
      }
    }
    return null;
  }

  double? _findOrderBlockLow(List<Candle> candles) {
    for (int i = candles.length - 1; i >= 2; i--) {
      if (!candles[i].isBullish && candles[i-1].isBullish && candles[i].body > candles[i-1].body * 1.5) {
        return candles[i-1].low;
      }
    }
    return null;
  }

  double? _findFVGHigh(List<Candle> candles) {
    for (int i = candles.length - 1; i >= 2; i--) {
      if (candles[i].low > candles[i-2].high) {
        return candles[i].low;
      }
    }
    return null;
  }

  double? _findFVGLow(List<Candle> candles) {
    for (int i = candles.length - 1; i >= 2; i--) {
      if (candles[i].high < candles[i-2].low) {
        return candles[i].high;
      }
    }
    return null;
  }

  bool _detectBOS(List<Candle> candles) {
    if (candles.length < 5) return false;
    double recentHigh = candles.sublist(candles.length - 3).map((c) => c.high).reduce(max);
    double previousHigh = candles.sublist(candles.length - 5, candles.length - 3).map((c) => c.high).reduce(max);
    return recentHigh > previousHigh * 1.005;
  }

  bool _detectCHoCH(List<Candle> candles) {
    if (candles.length < 6) return false;
    var recent = candles.sublist(candles.length - 3);
    var previous = candles.sublist(candles.length - 6, candles.length - 3);
    bool recentBullish = recent.where((c) => c.isBullish).length >= 2;
    bool previousBearish = previous.where((c) => !c.isBullish).length >= 2;
    return (recentBullish && previousBearish) || (!recentBullish && !previousBearish);
  }

  String _determineMarketPhase(List<Candle> candles) {
    if (candles.length < 10) return 'Unknown';
    var recent = candles.sublist(candles.length - 5);
    double avgRange = recent.map((c) => c.high - c.low).reduce((a, b) => a + b) / 5;
    double overallRange = candles.map((c) => c.high - c.low).reduce((a, b) => a + b) / candles.length;
    
    if (avgRange < overallRange * 0.5) return 'Accumulation';
    if (avgRange > overallRange * 1.5) return 'Distribution';
    if (recent.every((c) => c.isBullish)) return 'Expansion (Bullish)';
    if (recent.every((c) => !c.isBullish)) return 'Expansion (Bearish)';
    return 'Consolidation';
  }

  TradingSignal generateSignal(String symbol, double currentPrice, MarketStructure structure) {
    final isBullish = structure.bias == 'Long';
    final signalType = isBullish ? SignalType.buy : (structure.bias == 'Short' ? SignalType.sell : SignalType.hold);
    
    double stopLoss = isBullish 
        ? currentPrice * (1 - 0.02 - _random.nextDouble() * 0.01)
        : currentPrice * (1 + 0.02 + _random.nextDouble() * 0.01);
    
    double tp1 = isBullish ? currentPrice * 1.03 : currentPrice * 0.97;
    double tp2 = isBullish ? currentPrice * 1.05 : currentPrice * 0.95;
    double tp3 = isBullish ? currentPrice * 1.08 : currentPrice * 0.92;
    
    double riskAmount = (currentPrice - stopLoss).abs();
    double rewardAmount = (tp2 - currentPrice).abs();
    double rrr = rewardAmount / riskAmount;
    
    List<String> confluences = [];
    List<StrategyType> strategies = [];
    
    if (structure.orderBlockHigh != null || structure.orderBlockLow != null) {
      confluences.add('Order Block identified');
      strategies.add(StrategyType.ict);
    }
    if (structure.fairValueGapHigh != null || structure.fairValueGapLow != null) {
      confluences.add('Fair Value Gap present');
      strategies.add(StrategyType.smc);
    }
    if (structure.breakOfStructure) {
      confluences.add('Break of Structure confirmed');
      strategies.add(StrategyType.priceAction);
    }
    if (structure.changeOfCharacter) {
      confluences.add('Change of Character detected');
    }
    confluences.add('Market Phase: ${structure.currentPhase}');
    confluences.add('Trend: ${structure.trend}');
    
    if (strategies.isEmpty) strategies.add(StrategyType.priceAction);
    
    double confidence = 0.5 + (confluences.length * 0.08);
    if (confidence > 0.95) confidence = 0.95;
    
    SignalStrength strength;
    if (confidence >= 0.85) strength = SignalStrength.veryStrong;
    else if (confidence >= 0.70) strength = SignalStrength.strong;
    else if (confidence >= 0.55) strength = SignalStrength.moderate;
    else strength = SignalStrength.weak;
    
    String analysis = _generateAnalysis(symbol, structure, signalType, confluences);

    return TradingSignal(
      id: '${symbol}_${DateTime.now().millisecondsSinceEpoch}',
      symbol: symbol,
      type: signalType,
      strength: strength,
      entryPrice: currentPrice,
      stopLoss: stopLoss,
      takeProfit1: tp1,
      takeProfit2: tp2,
      takeProfit3: tp3,
      riskRewardRatio: rrr,
      confidence: confidence,
      strategies: strategies,
      analysis: analysis,
      confluences: confluences,
      timestamp: DateTime.now(),
      expiresAt: DateTime.now().add(const Duration(hours: 4)),
    );
  }

  String _generateAnalysis(String symbol, MarketStructure structure, SignalType type, List<String> confluences) {
    String direction = type == SignalType.buy ? 'bullish' : (type == SignalType.sell ? 'bearish' : 'neutral');
    return '''
$symbol Analysis - ICT/SMC Framework

Market Structure: ${structure.trend}
Current Phase: ${structure.currentPhase}
Directional Bias: ${structure.bias}

Key Confluences:
${confluences.map((c) => '• $c').join('\n')}

Analysis Summary:
The current market structure shows a $direction bias with ${confluences.length} confluent factors supporting this view. ${structure.breakOfStructure ? 'A Break of Structure has been confirmed, indicating potential trend continuation.' : ''} ${structure.changeOfCharacter ? 'Change of Character detected suggests a possible reversal setup.' : ''}

${structure.orderBlockHigh != null || structure.orderBlockLow != null ? 'Order Blocks have been identified which may act as key support/resistance zones.' : ''}

${structure.fairValueGapHigh != null || structure.fairValueGapLow != null ? 'Fair Value Gaps present - price may revisit these imbalanced zones.' : ''}

Risk Management:
- Position size according to your risk tolerance (recommended: 1-2% per trade)
- Honor stop loss levels - no exceptions
- Consider scaling out at Take Profit levels

Disclaimer: This analysis is for educational purposes. Always conduct your own research.
''';
  }

  List<IndicatorValue> calculateIndicators(List<Candle> candles) {
    if (candles.isEmpty) return [];
    
    List<double> closes = candles.map((c) => c.close).toList();
    
    return [
      IndicatorValue(
        name: 'RSI (14)',
        value: _calculateRSI(closes, 14),
        signal: _getRSISignal(_calculateRSI(closes, 14)),
        description: 'Relative Strength Index measures momentum',
      ),
      IndicatorValue(
        name: 'EMA 20',
        value: _calculateEMA(closes, 20),
        signal: closes.last > _calculateEMA(closes, 20) ? 'Bullish' : 'Bearish',
        description: '20-period Exponential Moving Average',
      ),
      IndicatorValue(
        name: 'EMA 50',
        value: _calculateEMA(closes, 50),
        signal: closes.last > _calculateEMA(closes, 50) ? 'Bullish' : 'Bearish',
        description: '50-period Exponential Moving Average',
      ),
      IndicatorValue(
        name: 'MACD',
        value: _calculateMACD(closes),
        signal: _calculateMACD(closes) > 0 ? 'Bullish' : 'Bearish',
        description: 'Moving Average Convergence Divergence',
      ),
      IndicatorValue(
        name: 'ATR (14)',
        value: _calculateATR(candles, 14),
        signal: 'Volatility',
        description: 'Average True Range measures volatility',
      ),
    ];
  }

  double _calculateRSI(List<double> prices, int period) {
    if (prices.length < period + 1) return 50;
    
    double gainSum = 0, lossSum = 0;
    for (int i = prices.length - period; i < prices.length; i++) {
      double change = prices[i] - prices[i - 1];
      if (change > 0) gainSum += change;
      else lossSum += change.abs();
    }
    
    double avgGain = gainSum / period;
    double avgLoss = lossSum / period;
    
    if (avgLoss == 0) return 100;
    double rs = avgGain / avgLoss;
    return 100 - (100 / (1 + rs));
  }

  String _getRSISignal(double rsi) {
    if (rsi > 70) return 'Overbought';
    if (rsi < 30) return 'Oversold';
    if (rsi > 55) return 'Bullish';
    if (rsi < 45) return 'Bearish';
    return 'Neutral';
  }

  double _calculateEMA(List<double> prices, int period) {
    if (prices.length < period) return prices.last;
    
    double multiplier = 2 / (period + 1);
    double ema = prices.sublist(0, period).reduce((a, b) => a + b) / period;
    
    for (int i = period; i < prices.length; i++) {
      ema = (prices[i] - ema) * multiplier + ema;
    }
    return ema;
  }

  double _calculateMACD(List<double> prices) {
    if (prices.length < 26) return 0;
    return _calculateEMA(prices, 12) - _calculateEMA(prices, 26);
  }

  double _calculateATR(List<Candle> candles, int period) {
    if (candles.length < period + 1) return 0;
    
    double sum = 0;
    for (int i = candles.length - period; i < candles.length; i++) {
      double tr = max(
        candles[i].high - candles[i].low,
        max(
          (candles[i].high - candles[i-1].close).abs(),
          (candles[i].low - candles[i-1].close).abs(),
        ),
      );
      sum += tr;
    }
    return sum / period;
  }
}
