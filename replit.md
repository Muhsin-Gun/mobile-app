# CrypTex Trading Platform

## Overview

CrypTex is a cross-platform cryptocurrency and forex trading dashboard built with Flutter. The application provides users with real-time crypto price tracking, interactive charts via TradingView integration, demo wallet management, and educational crypto content. The project targets web deployment primarily, with support for Android, iOS, Linux, Windows, and macOS platforms.

## User Preferences

Preferred communication style: Simple, everyday language.

## Recent Changes (December 15, 2025)

### Authentication System
- Email/password registration and login
- Google OAuth integration ready (requires GOOGLE_CLIENT_ID/SECRET)
- JWT token-based authentication
- PostgreSQL database for user storage

### AI Trading Assistant
- Powered by Groq API (llama-3.1-70b-versatile model)
- ICT/SMC-focused analysis capabilities
- Real-time market structure analysis
- Signal generation with entry/SL/TP levels
- Interactive chat for trading questions

### Expanded Education Courses
New course categories added:
- MSNR (Market Structure Narrative)
- CRT (Candle Range Theory)
- DOM & Footprint Charts
- Sniper Entry Strategies
- Exit Strategies

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
- Authentication endpoints: /api/auth/*
- AI endpoints: /api/ai/*
- M-Pesa payment endpoints: /api/mpesa/*

**Database**: PostgreSQL
- Users table with auth info
- Sessions, trading history, AI conversations

**AI Integration**: Groq API
- Environment variable: GROQ_API_KEY
- Model: llama-3.1-70b-versatile
- Endpoints:
  - POST /api/ai/chat - Chat with AI assistant
  - POST /api/ai/analyze - Get market analysis
  - POST /api/ai/signal - Generate trading signals

**Payment Integration**: Safaricom M-Pesa
- Supports sandbox and production environments
- OAuth token generation for API authentication
- STK Push for mobile payment initiation

### Data & Real-time Features

**Market Data**:
- `web_socket_channel` - WebSocket connections for real-time price feeds
- `http` package for REST API calls to crypto exchanges

**Charts**:
- TradingView widget integration via JavaScript library loaded in web/index.html
- Native `fl_chart` for in-app chart components

**Local Storage**:
- `shared_preferences` - Persisting user settings and demo wallet state

## Key Files

### Backend
- `server.js` - Node.js server with auth, AI, and payment endpoints

### Flutter Services
- `lib/services/ai_trading_service.dart` - AI API client
- `lib/services/education_service.dart` - Trading courses (14 courses)
- `lib/services/trading_analysis_service.dart` - Local market analysis

### Flutter Screens
- `lib/screens/client/trading_tab.dart` - AI trading analysis with chat
- `lib/screens/client/education_tab.dart` - Course listings

### Flutter Models
- `lib/models/education.dart` - Course/Lesson models with 14 categories

## Build & Deploy

The web build is pre-compiled to `build/web/` and served by the Node.js server.

To rebuild Flutter web:
```bash
flutter build web --release
```

## Environment Variables

Required:
- `DATABASE_URL` - PostgreSQL connection string
- `GROQ_API_KEY` - For AI features

Optional:
- `GOOGLE_CLIENT_ID`, `GOOGLE_CLIENT_SECRET` - For Google OAuth
- `MPESA_CONSUMER_KEY`, `MPESA_CONSUMER_SECRET` - For M-Pesa
- `JWT_SECRET` - Custom JWT signing key
