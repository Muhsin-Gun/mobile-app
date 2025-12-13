enum SignalType { buy, sell, hold }
enum SignalStrength { weak, moderate, strong, veryStrong }
enum StrategyType { ict, smc, smt, orderFlow, priceAction, fundamental, quant }

class TradingSignal {
  final String id;
  final String symbol;
  final SignalType type;
  final SignalStrength strength;
  final double entryPrice;
  final double stopLoss;
  final double takeProfit1;
  final double takeProfit2;
  final double takeProfit3;
  final double riskRewardRatio;
  final double confidence;
  final List<StrategyType> strategies;
  final String analysis;
  final List<String> confluences;
  final DateTime timestamp;
  final DateTime? expiresAt;

  TradingSignal({
    required this.id,
    required this.symbol,
    required this.type,
    required this.strength,
    required this.entryPrice,
    required this.stopLoss,
    required this.takeProfit1,
    required this.takeProfit2,
    required this.takeProfit3,
    required this.riskRewardRatio,
    required this.confidence,
    required this.strategies,
    required this.analysis,
    required this.confluences,
    required this.timestamp,
    this.expiresAt,
  });

  String get strengthText {
    switch (strength) {
      case SignalStrength.weak: return 'Weak';
      case SignalStrength.moderate: return 'Moderate';
      case SignalStrength.strong: return 'Strong';
      case SignalStrength.veryStrong: return 'Very Strong';
    }
  }

  String get typeText {
    switch (type) {
      case SignalType.buy: return 'BUY';
      case SignalType.sell: return 'SELL';
      case SignalType.hold: return 'HOLD';
    }
  }
}

class MarketStructure {
  final String trend;
  final String bias;
  final double? orderBlockHigh;
  final double? orderBlockLow;
  final double? fairValueGapHigh;
  final double? fairValueGapLow;
  final double? buySideLiquidity;
  final double? sellSideLiquidity;
  final bool breakOfStructure;
  final bool changeOfCharacter;
  final String currentPhase;

  MarketStructure({
    required this.trend,
    required this.bias,
    this.orderBlockHigh,
    this.orderBlockLow,
    this.fairValueGapHigh,
    this.fairValueGapLow,
    this.buySideLiquidity,
    this.sellSideLiquidity,
    required this.breakOfStructure,
    required this.changeOfCharacter,
    required this.currentPhase,
  });
}

class IndicatorValue {
  final String name;
  final double value;
  final String signal;
  final String description;

  IndicatorValue({
    required this.name,
    required this.value,
    required this.signal,
    required this.description,
  });
}
