import 'package:trading_app_021/util/exports.dart';

// The 10 stocks used throughout the app with realistic starting prices.
//
// All prices are stored in paise (1 ₹ = 100 paise) to avoid floating-point
// drift in monetary calculations.

// Configurable batch interval for the mock market feed.
// Every interval, 3-6 random stocks get a price update (like real broker feeds).
// Default 1000ms = 1 batch/sec. Lower = more frequent (stress test).
// Also changeable at runtime from Live Prices → tick-rate menu.
const int kDefaultTickIntervalMs = 1000;

/// Preset batch intervals for the Live Prices debug tick-rate control.
const List<int> kTickIntervalPresetsMs = [1000, 500, 200, 100];

/// Starting wallet balance: ₹10,00,000 (10 lakh) in paise.
const int kStartingBalancePaise = 1000000 * 100;

/// All 10 stocks available in the app.
const List<Stock> kStocks = [
  Stock(
    symbol: 'RELIANCE',
    name: 'Reliance Industries',
    startingPricePaise: 294550,
  ),
  Stock(
    symbol: 'TCS',
    name: 'Tata Consultancy Services',
    startingPricePaise: 382500,
  ),
  Stock(symbol: 'INFY', name: 'Infosys', startingPricePaise: 159075),
  Stock(symbol: 'HDFCBANK', name: 'HDFC Bank', startingPricePaise: 172530),
  Stock(symbol: 'ICICIBANK', name: 'ICICI Bank', startingPricePaise: 128560),
  Stock(symbol: 'SBIN', name: 'State Bank of India', startingPricePaise: 83540),
  Stock(symbol: 'ITC', name: 'ITC Limited', startingPricePaise: 46520),
  Stock(symbol: 'LT', name: 'Larsen & Toubro', startingPricePaise: 345080),
  Stock(
    symbol: 'BHARTIARTL',
    name: 'Bharti Airtel',
    startingPricePaise: 168090,
  ),
  Stock(symbol: 'AXISBANK', name: 'Axis Bank', startingPricePaise: 117545),
];

/// Quick lookup map: symbol → Stock.
final Map<String, Stock> kStockMap = {
  for (final stock in kStocks) stock.symbol: stock,
};
