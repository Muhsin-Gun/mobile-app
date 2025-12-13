import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cryptex_trading/models/crypto_asset.dart';

class CryptoService {
  static const String _baseUrl = 'https://api.coingecko.com/api/v3';

  Future<List<CryptoAsset>> getTopCryptos({int limit = 50}) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=$limit&page=1&sparkline=true&price_change_percentage=24h'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CryptoAsset.fromJson(json)).toList();
      }
      return _getMockCryptos();
    } catch (e) {
      return _getMockCryptos();
    }
  }

  Future<CryptoAsset?> getCryptoDetails(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/coins/markets?vs_currency=usd&ids=$id&sparkline=true'),
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          return CryptoAsset.fromJson(data.first);
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  List<CryptoAsset> _getMockCryptos() {
    final now = DateTime.now();
    return [
      CryptoAsset(
        id: 'bitcoin', symbol: 'BTC', name: 'Bitcoin',
        image: 'https://assets.coingecko.com/coins/images/1/large/bitcoin.png',
        currentPrice: 104250.0, priceChange24h: 2150.0, priceChangePercentage24h: 2.11,
        marketCap: 2060000000000, volume24h: 45000000000, high24h: 105500, low24h: 101200,
        circulatingSupply: 19500000, sparklineData: List.generate(168, (i) => 102000 + (i * 15) + (i % 20) * 50),
        lastUpdated: now,
      ),
      CryptoAsset(
        id: 'ethereum', symbol: 'ETH', name: 'Ethereum',
        image: 'https://assets.coingecko.com/coins/images/279/large/ethereum.png',
        currentPrice: 3920.0, priceChange24h: 85.0, priceChangePercentage24h: 2.22,
        marketCap: 472000000000, volume24h: 18000000000, high24h: 3980, low24h: 3800,
        circulatingSupply: 120400000, sparklineData: List.generate(168, (i) => 3800 + (i * 0.8) + (i % 15) * 5),
        lastUpdated: now,
      ),
      CryptoAsset(
        id: 'solana', symbol: 'SOL', name: 'Solana',
        image: 'https://assets.coingecko.com/coins/images/4128/large/solana.png',
        currentPrice: 228.5, priceChange24h: 12.3, priceChangePercentage24h: 5.69,
        marketCap: 108000000000, volume24h: 5200000000, high24h: 235, low24h: 215,
        circulatingSupply: 472000000, sparklineData: List.generate(168, (i) => 210 + (i * 0.12) + (i % 10) * 2),
        lastUpdated: now,
      ),
      CryptoAsset(
        id: 'ripple', symbol: 'XRP', name: 'XRP',
        image: 'https://assets.coingecko.com/coins/images/44/large/xrp-symbol-white-128.png',
        currentPrice: 2.45, priceChange24h: 0.18, priceChangePercentage24h: 7.93,
        marketCap: 140000000000, volume24h: 12000000000, high24h: 2.55, low24h: 2.22,
        circulatingSupply: 57100000000, sparklineData: List.generate(168, (i) => 2.20 + (i * 0.002) + (i % 8) * 0.02),
        lastUpdated: now,
      ),
      CryptoAsset(
        id: 'cardano', symbol: 'ADA', name: 'Cardano',
        image: 'https://assets.coingecko.com/coins/images/975/large/cardano.png',
        currentPrice: 1.12, priceChange24h: 0.08, priceChangePercentage24h: 7.69,
        marketCap: 39500000000, volume24h: 1800000000, high24h: 1.18, low24h: 1.02,
        circulatingSupply: 35300000000, sparklineData: List.generate(168, (i) => 1.0 + (i * 0.001) + (i % 12) * 0.01),
        lastUpdated: now,
      ),
      CryptoAsset(
        id: 'dogecoin', symbol: 'DOGE', name: 'Dogecoin',
        image: 'https://assets.coingecko.com/coins/images/5/large/dogecoin.png',
        currentPrice: 0.42, priceChange24h: 0.015, priceChangePercentage24h: 3.70,
        marketCap: 62000000000, volume24h: 4500000000, high24h: 0.435, low24h: 0.395,
        circulatingSupply: 147000000000, sparklineData: List.generate(168, (i) => 0.38 + (i * 0.0003) + (i % 6) * 0.005),
        lastUpdated: now,
      ),
    ];
  }

  List<ForexPair> getForexPairs() {
    final now = DateTime.now();
    return [
      ForexPair(symbol: 'EURUSD', base: 'EUR', quote: 'USD', bid: 1.0525, ask: 1.0527, change: 0.0032, changePercent: 0.30, high: 1.0560, low: 1.0485, timestamp: now),
      ForexPair(symbol: 'GBPUSD', base: 'GBP', quote: 'USD', bid: 1.2745, ask: 1.2748, change: 0.0018, changePercent: 0.14, high: 1.2780, low: 1.2710, timestamp: now),
      ForexPair(symbol: 'USDJPY', base: 'USD', quote: 'JPY', bid: 152.35, ask: 152.38, change: -0.45, changePercent: -0.29, high: 153.20, low: 151.80, timestamp: now),
      ForexPair(symbol: 'XAUUSD', base: 'XAU', quote: 'USD', bid: 2655.50, ask: 2656.20, change: 28.30, changePercent: 1.08, high: 2668.00, low: 2625.00, timestamp: now),
      ForexPair(symbol: 'AUDUSD', base: 'AUD', quote: 'USD', bid: 0.6385, ask: 0.6388, change: -0.0012, changePercent: -0.19, high: 0.6420, low: 0.6365, timestamp: now),
      ForexPair(symbol: 'USDCAD', base: 'USD', quote: 'CAD', bid: 1.4185, ask: 1.4188, change: 0.0045, changePercent: 0.32, high: 1.4210, low: 1.4125, timestamp: now),
    ];
  }
}
