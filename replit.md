# CrypTex Trading - Professional Crypto/Forex Trading Platform

## Overview
A professional cryptocurrency and forex trading platform built with Flutter Web and Firebase backend. The app provides real-time market data, AI-powered trading analysis, comprehensive trading education, and M-Pesa payment integration.

## Current State
- **Login/Signup Flow**: Shows FIRST before accessing any features (AuthGate pattern)
- **Firebase Backend**: Auth, Firestore, Storage, Messaging integrated
- **Real Market Data**: CoinGecko API + TradingView widgets
- **AI Trading Assistant**: Groq API integration for analysis and signals
- **Professional UI**: Dark theme inspired by JustMarkets, Exness, Quamatix

## Architecture
```
lib/
├── main.dart                    # App entry point, Firebase init
├── constants/                   # Colors, themes
├── models/                      # Data models (CryptoAsset, TradingSignal, etc)
├── providers/                   # State management (Auth, Theme)
├── screens/
│   ├── auth/                    # Login, Signup, AuthGate, Splash
│   └── client/                  # Main dashboard tabs
├── services/                    # Business logic (Auth, Market, AI, Education)
└── widgets/                     # Reusable components
```

## Key Features
1. **Authentication**: Email/password + Google Sign-In via Firebase
2. **Markets**: Real-time crypto prices from CoinGecko, forex pairs
3. **Trading**: TradingView charts, AI analysis, signal generation
4. **Education**: Trading courses (ICT, SMC, SMT, Order Flow, Price Action)
5. **Payments**: M-Pesa integration (Daraja API)
6. **Profile**: User settings, wallet, transaction history

## Technology Stack
- **Frontend**: Flutter 3.32.0 (Web)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **APIs**: CoinGecko, Groq AI, Daraja (M-Pesa)
- **Server**: Dart HTTP server on port 5000

## Running the App
```bash
flutter build web --release
dart run web_server.dart
```

## Environment Variables Needed
- `GROQ_API_KEY` - For AI trading analysis
- `MPESA_CONSUMER_KEY` - M-Pesa API
- `MPESA_CONSUMER_SECRET` - M-Pesa API

## Recent Changes (December 2024)
- Migrated from Node.js to Firebase backend
- Added AuthGate for login-first flow
- Integrated Groq AI for trading analysis
- Enhanced UI with professional trading app design
- Added comprehensive trading education courses
