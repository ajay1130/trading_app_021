# 021 Trading App

A feature-rich simulated stock trading application built with **Flutter**, demonstrating clean architecture, real-time data handling, and production-quality UI.

> Built as a coding assignment for **021 Trade — Flutter Developer** position.

---

## ✨ Features

### 1. 📈 Live Market Prices
- Real-time price updates for 10 NSE stocks
- Green/red flash animations on price changes
- Smooth scrolling even under high tick rates (50+ ticks/sec)
- Per-stock `Selector` rebuilds — only the changed tile re-renders

### 2. 📋 Watchlists
- Create, rename, delete multiple watchlists
- Add stocks via a picker showing all 10 available stocks
- Drag-to-reorder stocks within a watchlist
- Swipe-to-dismiss to remove stocks
- Live prices update in place
- Data persists across app restarts

### 3. 💰 Buy/Sell Ticket
- Pre-fills stock when opened from watchlist or holdings
- Live LTP display with real-time updates
- Buy/Sell toggle with animated transitions
- Real-time order value calculation (qty × LTP)
- Inline validation: insufficient balance, insufficient holdings, invalid quantity
- Executes at the current LTP at moment of submission
- Animated order confirmation screen

### 4. 📊 Holdings / Portfolio
- Live P&L updates for all holdings as prices tick
- Aggregate portfolio summary (total invested, current value, total P&L)
- Sortable by P&L, symbol, or current value
- Tapping a holding opens Buy/Sell pre-filled

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (stable channel) — built with Flutter 3.38.3
- Android Studio / VS Code with Flutter plugin

### Run the App

```bash
flutter pub get && flutter run
```

**No backend, no API keys, no extra setup required.** The app uses a self-contained mock market data feed.

---

## 🏗️ Architecture

```
lib/
├── main.dart                       # App entry, providers, navigation
├── core/
│   ├── constants/stocks.dart       # 10 stock definitions + config
│   ├── models/                     # Data models (Stock, PriceTick, Order, Holding, Watchlist)
│   ├── services/
│   │   ├── mock_market_feed.dart   # Single-source-of-truth price feed
│   │   └── persistence_service.dart # SharedPreferences wrapper
│   ├── providers/                  # ChangeNotifier providers (state management)
│   └── theme/app_theme.dart        # Premium dark theme
├── features/
│   ├── live_prices/                # Market overview screen
│   ├── watchlist/                  # Watchlist management
│   ├── order/                      # Buy/Sell ticket + confirmation
│   └── holdings/                   # Portfolio view with P&L
└── shared/widgets/                 # Reusable UI components
```

### Key Decisions

| Decision | Rationale |
|----------|-----------|
| **Paise-based integer math** | All monetary values stored as `int` (paise). `1 ₹ = 100 paise`. Eliminates floating-point drift in P&L calculations. Display conversion only at UI layer. |
| **Provider + Selector** | Each stock tile uses `Selector<MarketDataProvider, PriceTick?>` to only rebuild when *its* stock's price changes. Critical for handling 50+ ticks/sec smoothly. |
| **Single broadcast stream** | `MockMarketFeedService` emits a single `Stream<PriceTick>`. `MarketDataProvider` fans out to a per-symbol map. Widgets select their stock. |
| **Immediate persistence** | Every mutation auto-persists to SharedPreferences. No manual "save" needed. |
| **IndexedStack navigation** | Preserves screen state across tab switches so prices stay current. |

### Mock Market Feed

- Random walk with mean-reversion: prices drift naturally but revert toward starting price
- Configurable tick interval (`kDefaultTickIntervalMs` in `stocks.dart`, default: 200ms)
- For stress testing: set to 20ms for 50+ ticks/sec total
- Prices clamped to ±30% of starting price for realism

---

## 📱 Stocks

| Symbol | Company | Starting Price |
|--------|---------|---------------|
| RELIANCE | Reliance Industries | ₹2,945.50 |
| TCS | Tata Consultancy Services | ₹3,825.00 |
| INFY | Infosys | ₹1,590.75 |
| HDFCBANK | HDFC Bank | ₹1,725.30 |
| ICICIBANK | ICICI Bank | ₹1,285.60 |
| SBIN | State Bank of India | ₹835.40 |
| ITC | ITC Limited | ₹465.20 |
| LT | Larsen & Toubro | ₹3,450.80 |
| BHARTIARTL | Bharti Airtel | ₹1,680.90 |
| AXISBANK | Axis Bank | ₹1,175.45 |

**Starting wallet balance:** ₹10,00,000 (10 lakh)

---

## 🛠️ Tech Stack

- **Flutter** 3.38.3 (stable channel)
- **Dart** 3.10.1
- **State Management:** Provider
- **Persistence:** SharedPreferences
- **Formatting:** intl (Indian number format)
- **Typography:** Google Fonts (Inter)
- **IDs:** uuid v4

---

## 📋 Assignment Checklist

- [x] **Feature 1:** Watchlist — CRUD, reorder, remove, live prices, persistence
- [x] **Feature 2:** Live Prices — 10 stocks, flash animations, configurable tick rate, smooth under load
- [x] **Feature 3:** Buy/Sell Ticket — validation, live LTP, balance/holdings checks, order execution
- [x] **Feature 4:** Holdings — live P&L, sortable, aggregate summary, persistence
- [x] Clean architecture with feature-based folder structure
- [x] Integer math for money (no floating-point drift)
- [x] Persistence across app restarts
- [x] Zero `flutter analyze` warnings
- [x] Runs with `flutter pub get && flutter run`
