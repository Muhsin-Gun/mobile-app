import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:web_socket_channel/web_socket_channel.dart';

class MarketDataService {
  static const String _binanceWsUrl = 'wss://stream.binance.com:9443/ws';
  static const String _binanceRestUrl = 'https://api.binance.com/api/v3';
  static const String _coingeckoUrl = 'https://api.coingecko.com/api/v3';
  
  WebSocketChannel? _channel;
  final StreamController<Map<String, dynamic>> _tickerController = StreamController.broadcast();
  final StreamController<List<Map<String, dynamic>>> _orderBookController = StreamController.broadcast();
  final Map<String, Map<String, dynamic>> _tickerCache = {};

  Stream<Map<String, dynamic>> get tickerStream => _tickerController.stream;
  Stream<List<Map<String, dynamic>>> get orderBookStream => _orderBookController.stream;
  Map<String, Map<String, dynamic>> get tickerCache => _tickerCache;

  void connectToTickers(List<String> symbols) {
    _channel?.sink.close();
    
    final streams = symbols.map((s) => '${s.toLowerCase()}@ticker').join('/');
    final url = '$_binanceWsUrl/$streams';
    
    try {
      _channel = WebSocketChannel.connect(Uri.parse(url));
      
      _channel!.stream.listen(
        (data) {
          final json = jsonDecode(data as String);
          _tickerCache[json['s']] = json;
          _tickerController.add(json);
        },
        onError: (error) {
          print('WebSocket error: $error');
        },
        onDone: () {
          Future.delayed(const Duration(seconds: 5), () {
            connectToTickers(symbols);
          });
        },
      );
    } catch (e) {
      print('WebSocket connection failed: $e');
    }
  }

  void subscribeToOrderBook(String symbol, {int depth = 10}) {
    final url = '$_binanceWsUrl/${symbol.toLowerCase()}@depth$depth@100ms';
    
    try {
      final channel = WebSocketChannel.connect(Uri.parse(url));
      
      channel.stream.listen(
        (data) {
          final json = jsonDecode(data as String);
          final bids = (json['b'] as List).map((b) => {
            'price': double.parse(b[0]),
            'quantity': double.parse(b[1]),
          }).toList();
          final asks = (json['a'] as List).map((a) => {
            'price': double.parse(a[0]),
            'quantity': double.parse(a[1]),
          }).toList();
          _orderBookController.add([...bids, ...asks]);
        },
        onError: (error) {
          print('OrderBook WebSocket error: $error');
        },
      );
    } catch (e) {
      print('OrderBook WebSocket failed: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getKlines(String symbol, String interval, {int limit = 100}) async {
    try {
      final response = await http.get(
        Uri.parse('$_binanceRestUrl/klines?symbol=$symbol&interval=$interval&limit=$limit'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((k) => {
          'openTime': k[0],
          'open': double.parse(k[1]),
          'high': double.parse(k[2]),
          'low': double.parse(k[3]),
          'close': double.parse(k[4]),
          'volume': double.parse(k[5]),
          'closeTime': k[6],
        }).toList();
      }
    } catch (e) {
      print('Failed to fetch klines: $e');
    }
    return [];
  }

  Future<Map<String, dynamic>?> get24hTicker(String symbol) async {
    try {
      final response = await http.get(
        Uri.parse('$_binanceRestUrl/ticker/24hr?symbol=$symbol'),
      );
      
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
    } catch (e) {
      print('Failed to fetch 24h ticker: $e');
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllTickers() async {
    try {
      final response = await http.get(
        Uri.parse('$_binanceRestUrl/ticker/24hr'),
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.where((t) => t['symbol'].toString().endsWith('USDT')).map((t) => {
          'symbol': t['symbol'],
          'price': double.parse(t['lastPrice']),
          'change': double.parse(t['priceChangePercent']),
          'volume': double.parse(t['volume']),
          'high': double.parse(t['highPrice']),
          'low': double.parse(t['lowPrice']),
        }).toList()..sort((a, b) => (b['volume'] as double).compareTo(a['volume'] as double));
      }
    } catch (e) {
      print('Failed to fetch all tickers: $e');
    }
    return [];
  }

  Future<List<Map<String, dynamic>>> getTrendingCoins() async {
    try {
      final response = await http.get(
        Uri.parse('$_coingeckoUrl/search/trending'),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['coins'] as List).map((c) => {
          'id': c['item']['id'],
          'symbol': c['item']['symbol'],
          'name': c['item']['name'],
          'thumb': c['item']['thumb'],
          'marketCapRank': c['item']['market_cap_rank'],
        }).toList();
      }
    } catch (e) {
      print('Failed to fetch trending: $e');
    }
    return [];
  }

  void dispose() {
    _channel?.sink.close();
    _tickerController.close();
    _orderBookController.close();
  }
}
