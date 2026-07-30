import 'package:trading_app_021/util/exports.dart';

/// Provider that subscribes to the mock market feed and exposes
/// the latest price tick for each stock.
///
/// UI widgets use [Selector] to subscribe to specific stock prices,
/// ensuring only the affected tile rebuilds when a tick arrives.
class MarketDataProvider extends ChangeNotifier {
  final MockMarketFeedService _feed;
  StreamSubscription<PriceTick>? _subscription;

  /// Latest price tick per symbol.
  final Map<String, PriceTick> _prices = {};

  /// Previous LTP per symbol (for detecting direction changes / flash).
  final Map<String, int> _previousLtp = {};

  MarketDataProvider({MockMarketFeedService? feed})
    : _feed = feed ?? MockMarketFeedService.instance {
    _subscription = _feed.stream.listen(_onTick);
    if (!_feed.isRunning) {
      _feed.start();
    }
  }

  /// Get the latest price tick for a symbol. Returns null if no tick yet.
  PriceTick? getPrice(String symbol) => _prices[symbol];

  /// Get all current prices.
  Map<String, PriceTick> get allPrices => Map.unmodifiable(_prices);

  /// Get the previous LTP for flash direction detection.
  int? getPreviousLtp(String symbol) => _previousLtp[symbol];

  void _onTick(PriceTick tick) {
    // Track previous LTP before updating.
    final existing = _prices[tick.symbol];
    if (existing != null) {
      _previousLtp[tick.symbol] = existing.ltpPaise;
    }

    _prices[tick.symbol] = tick;
    notifyListeners();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
