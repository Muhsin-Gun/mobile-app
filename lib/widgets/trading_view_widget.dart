// Conditional export for platform-specific implementations
export 'trading_view_widget_mobile.dart'
    if (dart.library.html) 'trading_view_widget_web.dart';