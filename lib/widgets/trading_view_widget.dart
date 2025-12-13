import 'package:flutter/material.dart';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
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
  late String viewId;

  @override
  void initState() {
    super.initState();
    viewId = 'tradingview-${widget.symbol}-${DateTime.now().millisecondsSinceEpoch}';
    _registerView();
  }

  void _registerView() {
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%'
          ..style.backgroundColor = '#0B0F1A';

        final widgetContainer = html.DivElement()
          ..className = 'tradingview-widget-container'
          ..style.height = '100%'
          ..style.width = '100%';

        final widgetDiv = html.DivElement()
          ..className = 'tradingview-widget-container__widget'
          ..style.height = '100%'
          ..style.width = '100%';

        widgetContainer.append(widgetDiv);

        final script = html.ScriptElement()
          ..type = 'text/javascript'
          ..src = 'https://s3.tradingview.com/external-embedding/embed-widget-advanced-chart.js'
          ..async = true
          ..text = '''
          {
            "autosize": true,
            "symbol": "${_formatSymbol(widget.symbol)}",
            "interval": "${widget.interval}",
            "timezone": "Etc/UTC",
            "theme": "dark",
            "style": "1",
            "locale": "en",
            "enable_publishing": false,
            "allow_symbol_change": true,
            "calendar": false,
            "hide_top_toolbar": false,
            "hide_legend": false,
            "save_image": false,
            "hide_volume": false,
            "support_host": "https://www.tradingview.com",
            "backgroundColor": "rgba(11, 15, 26, 1)",
            "gridColor": "rgba(45, 53, 85, 0.3)",
            "studies": [
              "RSI@tv-basicstudies",
              "MASimple@tv-basicstudies",
              "MACD@tv-basicstudies"
            ]
          }
          ''';

        widgetContainer.append(script);
        container.append(widgetContainer);
        return container;
      },
    );
  }

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
        child: HtmlElementView(viewType: viewId),
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
  late String viewId;

  @override
  void initState() {
    super.initState();
    viewId = 'tv-mini-${widget.symbol}-${DateTime.now().millisecondsSinceEpoch}';
    _registerView();
  }

  void _registerView() {
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%';

        final script = html.ScriptElement()
          ..type = 'text/javascript'
          ..src = 'https://s3.tradingview.com/external-embedding/embed-widget-mini-symbol-overview.js'
          ..async = true
          ..text = '''
          {
            "symbol": "${_formatSymbol(widget.symbol)}",
            "width": "100%",
            "height": "100%",
            "locale": "en",
            "dateRange": "1D",
            "colorTheme": "dark",
            "isTransparent": true,
            "autosize": true,
            "largeChartUrl": ""
          }
          ''';

        container.append(script);
        return container;
      },
    );
  }

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
      child: HtmlElementView(viewType: viewId),
    );
  }
}

class TradingViewTickerTape extends StatefulWidget {
  const TradingViewTickerTape({super.key});

  @override
  State<TradingViewTickerTape> createState() => _TradingViewTickerTapeState();
}

class _TradingViewTickerTapeState extends State<TradingViewTickerTape> {
  final String viewId = 'tv-ticker-${DateTime.now().millisecondsSinceEpoch}';

  @override
  void initState() {
    super.initState();
    _registerView();
  }

  void _registerView() {
    ui_web.platformViewRegistry.registerViewFactory(
      viewId,
      (int viewId) {
        final container = html.DivElement()
          ..style.width = '100%'
          ..style.height = '100%';

        final script = html.ScriptElement()
          ..type = 'text/javascript'
          ..src = 'https://s3.tradingview.com/external-embedding/embed-widget-ticker-tape.js'
          ..async = true
          ..text = '''
          {
            "symbols": [
              {"proName": "BINANCE:BTCUSDT", "title": "Bitcoin"},
              {"proName": "BINANCE:ETHUSDT", "title": "Ethereum"},
              {"proName": "BINANCE:SOLUSDT", "title": "Solana"},
              {"proName": "FX:EURUSD", "title": "EUR/USD"},
              {"proName": "FX:GBPUSD", "title": "GBP/USD"},
              {"proName": "TVC:GOLD", "title": "Gold"}
            ],
            "showSymbolLogo": true,
            "isTransparent": true,
            "displayMode": "adaptive",
            "colorTheme": "dark",
            "locale": "en"
          }
          ''';

        container.append(script);
        return container;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: HtmlElementView(viewType: viewId),
    );
  }
}
