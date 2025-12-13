# CrypTex Trading Platform

## Overview

CrypTex is a cross-platform cryptocurrency and forex trading dashboard built with Flutter. The application provides users with real-time crypto price tracking, interactive charts via TradingView integration, demo wallet management, and educational crypto content. The project targets web deployment primarily, with support for Android, iOS, Linux, Windows, and macOS platforms.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture

**Framework**: Flutter (Dart)
- Cross-platform UI framework targeting web, mobile (Android/iOS), and desktop (Linux/Windows/macOS)
- Web build uses CanvasKit renderer for high-fidelity graphics
- Dark mode first design with neon accent colors (#4ADE80 green, #6366F1 indigo)

**State Management**: Provider pattern
- Uses the `provider` package for reactive state management across the app

**Key UI Dependencies**:
- `cached_network_image` - Efficient image loading and caching
- `fl_chart` - Native Flutter charting for price visualization
- `flutter_svg` - SVG asset rendering
- `google_fonts` - Custom typography
- `shimmer` - Loading state animations

### Backend Architecture

**Web Server**: Node.js (server.js)
- Serves the Flutter web build from `./build/web` directory
- Runs on port 5000
- Handles M-Pesa payment integration endpoints

**Payment Integration**: Safaricom M-Pesa
- Supports sandbox and production environments
- OAuth token generation for API authentication
- STK Push for mobile payment initiation
- Configurable via environment variables:
  - `MPESA_CONSUMER_KEY`
  - `MPESA_CONSUMER_SECRET`
  - `MPESA_PASSKEY`
  - `MPESA_SHORTCODE`
  - `MPESA_ENV` (sandbox/production)

### Data & Real-time Features

**Market Data**:
- `web_socket_channel` - WebSocket connections for real-time price feeds
- `http` package for REST API calls to crypto exchanges

**Charts**:
- TradingView widget integration via JavaScript library loaded in web/index.html
- Native `fl_chart` for in-app chart components

**Local Storage**:
- `shared_preferences` - Persisting user settings and demo wallet state

## External Dependencies

### Third-Party Services

**Firebase**
- Project ID: `eshop-be005`
- Android app configured with google-services.json
- Used for backend services (specific features TBD based on Firebase console setup)

**TradingView**
- Embedded charting widgets via `https://s3.tradingview.com/tv.js`
- Professional-grade financial charts for crypto/forex visualization

**M-Pesa API (Safaricom)**
- Mobile money payment processing for Kenyan market
- Sandbox: `sandbox.safaricom.co.ke`
- Production: `api.safaricom.co.ke`

### Key Flutter Packages

| Package | Purpose |
|---------|---------|
| provider | State management |
| http | HTTP client for APIs |
| web_socket_channel | Real-time data streams |
| shared_preferences | Local persistence |
| cached_network_image | Image caching |
| fl_chart | Native charts |
| crypto | Cryptographic utilities |
| uuid | Unique identifier generation |
| url_launcher | External link handling |
| intl | Internationalization/formatting |

### Build Outputs

The web build is pre-compiled to `build/web/` and served by the Node.js server. The Flutter web build uses:
- CanvasKit renderer (WebAssembly-based)
- Service worker for offline caching
- PWA manifest for installability