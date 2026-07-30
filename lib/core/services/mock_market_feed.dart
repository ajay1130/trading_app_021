import 'package:trading_app_021/util/exports.dart';

/// Mock market data feed — the single source of truth for all price data.
///
/// Generates realistic price movements using a random walk with
/// mean-reversion. Emits [PriceTick] events via a broadcast stream
/// that all UI components subscribe to.
///
/// ## Behaviour (mimics real broker feeds like 5paisa / Zerodha)
/// - Every ~1 second, a batch of 3–6 random stocks receive a price update
/// - Not every stock updates every second (just like real markets)
/// - Price changes are small and realistic (±0.01% to ±0.15%)
/// - This produces a calm, professional feel — no Christmas-tree flashing
class MockMarketFeedService {
  MockMarketFeedService._();
  static final MockMarketFeedService instance = MockMarketFeedService._();

  final _random = Random();
  Timer? _timer;

  /// Current prices in paise, keyed by symbol.
  final Map<String, int> _currentPrices = {};

  /// Previous close prices in paise (set at initialization), keyed by symbol.
  final Map<String, int> _previousClosePrices = {};

  /// Broadcast stream controller for price ticks.
  final _controller = StreamController<PriceTick>.broadcast();

  /// The stream of price ticks. Subscribe to this from providers.
  Stream<PriceTick> get stream => _controller.stream;

  /// Current price snapshot for a given symbol (paise).
  int? currentPricePaise(String symbol) => _currentPrices[symbol];

  /// Whether the feed is currently running.
  bool get isRunning => _timer != null && _timer!.isActive;

  /// Start the mock feed. Initializes prices and begins emitting ticks.
  ///
  /// [batchIntervalMs] controls how often a batch of updates fires.
  /// Default 1000ms = 1 batch/sec (realistic broker feel).
  void start({int batchIntervalMs = kDefaultTickIntervalMs}) {
    if (isRunning) return;

    // Initialize prices from stock definitions.
    for (final stock in kStocks) {
      _currentPrices[stock.symbol] = stock.startingPricePaise;
      _previousClosePrices[stock.symbol] = stock.startingPricePaise;
    }

    // Emit initial ticks for all stocks so UI has data immediately.
    for (final stock in kStocks) {
      _emitTick(stock.symbol);
    }

    // Start periodic batch tick generation.
    _timer = Timer.periodic(
      Duration(milliseconds: batchIntervalMs),
      (_) => _generateBatch(),
    );
  }

  /// Stop the feed and clean up resources.
  void dispose() {
    _timer?.cancel();
    _timer = null;
    _controller.close();
  }

  /// Generate a batch of price ticks (3–6 random stocks per batch).
  ///
  /// This mimics how real broker WebSocket feeds work — not every stock
  /// updates every second. Some stocks are more active than others.
  void _generateBatch() {
    // Pick 3–6 random stocks to update in this batch.
    final count = 3 + _random.nextInt(4); // 3 to 6
    final indices = <int>{};
    while (indices.length < count) {
      indices.add(_random.nextInt(kStocks.length));
    }

    for (final idx in indices) {
      _generateTick(kStocks[idx].symbol, kStocks[idx].startingPricePaise);
    }
  }

  /// Generate a single price tick for a given stock.
  void _generateTick(String symbol, int startingPrice) {
    final currentPrice = _currentPrices[symbol]!;

    // Realistic small movements: ±0.01% to ±0.15% per tick.
    // Real intraday moves for large-cap NSE stocks are tiny per second.
    const maxChangePercent = 0.0015; // 0.15%
    const minChangePercent = 0.0001; // 0.01%

    final magnitude =
        minChangePercent +
        _random.nextDouble() * (maxChangePercent - minChangePercent);

    // Random direction: +1 or -1.
    var direction = _random.nextBool() ? 1.0 : -1.0;

    // Mean-reversion: if price has drifted far from start, bias back.
    final drift = (currentPrice - startingPrice) / startingPrice;
    if (drift.abs() > 0.05) {
      if (_random.nextDouble() < 0.7) {
        direction = drift > 0 ? -1.0 : 1.0;
      }
    }

    // Calculate new price.
    final changePaise = (currentPrice * magnitude * direction).round();
    var newPrice = currentPrice + changePaise;

    // Clamp: price must stay positive and within 20% of starting price.
    final minPrice = (startingPrice * 0.80).round();
    final maxPrice = (startingPrice * 1.20).round();
    newPrice = newPrice.clamp(minPrice, maxPrice);

    // Only emit if price actually changed (avoids unnecessary rebuilds).
    if (newPrice != currentPrice) {
      _currentPrices[symbol] = newPrice;
      _emitTick(symbol);
    }
  }

  /// Emit a price tick for the given symbol.
  void _emitTick(String symbol) {
    final ltp = _currentPrices[symbol]!;
    final prevClose = _previousClosePrices[symbol]!;
    final change = ltp - prevClose;
    final changePercent = prevClose > 0 ? (change / prevClose) * 100.0 : 0.0;

    _controller.add(
      PriceTick(
        symbol: symbol,
        ltpPaise: ltp,
        previousClosePaise: prevClose,
        changePaise: change,
        changePercent: changePercent,
        timestamp: DateTime.now(),
      ),
    );
  }
}
