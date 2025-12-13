class CryptoAsset {
  final String id;
  final String symbol;
  final String name;
  final String image;
  final double currentPrice;
  final double priceChange24h;
  final double priceChangePercentage24h;
  final double marketCap;
  final double volume24h;
  final double high24h;
  final double low24h;
  final double circulatingSupply;
  final List<double> sparklineData;
  final DateTime lastUpdated;

  CryptoAsset({
    required this.id,
    required this.symbol,
    required this.name,
    required this.image,
    required this.currentPrice,
    required this.priceChange24h,
    required this.priceChangePercentage24h,
    required this.marketCap,
    required this.volume24h,
    required this.high24h,
    required this.low24h,
    required this.circulatingSupply,
    required this.sparklineData,
    required this.lastUpdated,
  });

  factory CryptoAsset.fromJson(Map<String, dynamic> json) {
    return CryptoAsset(
      id: json['id'] ?? '',
      symbol: json['symbol']?.toUpperCase() ?? '',
      name: json['name'] ?? '',
      image: json['image'] ?? '',
      currentPrice: (json['current_price'] ?? 0).toDouble(),
      priceChange24h: (json['price_change_24h'] ?? 0).toDouble(),
      priceChangePercentage24h: (json['price_change_percentage_24h'] ?? 0).toDouble(),
      marketCap: (json['market_cap'] ?? 0).toDouble(),
      volume24h: (json['total_volume'] ?? 0).toDouble(),
      high24h: (json['high_24h'] ?? 0).toDouble(),
      low24h: (json['low_24h'] ?? 0).toDouble(),
      circulatingSupply: (json['circulating_supply'] ?? 0).toDouble(),
      sparklineData: json['sparkline_in_7d'] != null
          ? List<double>.from((json['sparkline_in_7d']['price'] ?? []).map((x) => x.toDouble()))
          : [],
      lastUpdated: DateTime.tryParse(json['last_updated'] ?? '') ?? DateTime.now(),
    );
  }

  bool get isPositive => priceChangePercentage24h >= 0;
}

class ForexPair {
  final String symbol;
  final String base;
  final String quote;
  final double bid;
  final double ask;
  final double change;
  final double changePercent;
  final double high;
  final double low;
  final DateTime timestamp;

  ForexPair({
    required this.symbol,
    required this.base,
    required this.quote,
    required this.bid,
    required this.ask,
    required this.change,
    required this.changePercent,
    required this.high,
    required this.low,
    required this.timestamp,
  });

  double get spread => ask - bid;
  bool get isPositive => change >= 0;
}

class Candle {
  final DateTime time;
  final double open;
  final double high;
  final double low;
  final double close;
  final double volume;

  Candle({
    required this.time,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
  });

  bool get isBullish => close >= open;
  double get body => (close - open).abs();
  double get upperWick => high - (isBullish ? close : open);
  double get lowerWick => (isBullish ? open : close) - low;
}
