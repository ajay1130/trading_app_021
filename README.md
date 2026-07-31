# 021 Trading App

A high-performance Flutter trading application built for the 021 Trading assignment. Features a mock real-time market data feed, local Hive persistence, robust order validation, and a scalable Provider-based architecture.

## Features Completed
1. **Watchlist**: Create, rename, delete, and reorder multiple watchlists. Swipe to delete. Live prices update in place.
2. **Live Prices**: Real-time market feed with configurable tick rates. Prices flash green/red on updates.
3. **Buy/Sell Ticket**: Simulated market orders with precise margin checks (implemented in integer paise to prevent floating-point drift).
4. **Holdings**: Portfolio view showing live P&L and aggregate summaries. Sortable dynamically by P&L, Symbol, or Current Value as ticks arrive.

## Tech Stack
* **Flutter** (Stable Channel)
* **Provider** (State Management)
* **Hive** (Local Storage / Persistence)
* **Google Fonts & Cupertino Icons** (UI/UX)

## Run Instructions

This app is designed to run perfectly with zero extra setup required. No code generation (`build_runner`) or backend configuration is needed.

1. Ensure you are on the Flutter stable channel (`flutter channel stable`).
2. Clone this repository and open the directory.
3. Fetch the dependencies:
   ```bash
   flutter pub get
   ```
4. Run the app on your preferred emulator or device:
   ```bash
   flutter run
   ```

## Architecture Notes
* **Feature-First Structure**: Code is organized logically into `lib/features/` (home, holdings, order, etc.) rather than technical layers.
* **Money Handling**: All internal financial values are strictly calculated in integer `paise` (cents) and only converted to `double` at the UI layer. This eliminates floating-point rounding errors.
* **Performance**: The app uses `Selector` widgets instead of full `Consumer` widgets in heavy lists to ensure that only the specific text widget of a stock updates when its price ticks, keeping the app buttery smooth even under heavy load.
