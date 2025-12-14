// Conditional export for platform-specific implementations
export 'payment_screen_mobile.dart'
    if (dart.library.html) 'payment_screen_web.dart';