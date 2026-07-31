import 'package:trading_app_021/util/exports.dart';

/// Provider for managing wallet balance and order execution.
///
/// Validates orders against balance (Buy) or holdings (Sell),
/// executes them, and persists everything.
class WalletProvider extends ChangeNotifier {
  final PersistenceService _persistence;
  final _uuid = const Uuid();

  /// Current wallet balance in paise.
  int _balancePaise = 0;

  /// Order history (most recent first).
  List<Order> _orders = [];

  /// Current balance in paise.
  int get balancePaise => _balancePaise;

  /// Current balance in rupees.
  double get balanceRupees => _balancePaise / 100.0;

  /// Order history.
  List<Order> get orders => List.unmodifiable(_orders);

  WalletProvider({PersistenceService? persistence})
    : _persistence = persistence ?? PersistenceService.instance {
    _loadFromDisk();
  }

  void _loadFromDisk() {
    _balancePaise = _persistence.loadWalletBalance();
    _orders = _persistence.loadOrders();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _persistence.saveWalletBalance(_balancePaise);
    await _persistence.saveOrders(_orders);
  }

  // ── Validation ─────────────────────────────────────────────

  /// Check if a Buy order can be placed.
  /// Returns null if valid, or an error message if not.
  String? validateBuyOrder(int quantity, int pricePaise) {
    if (quantity <= 0) return AppStrings.errQtyGreaterThanZero;

    final totalPaise = quantity * pricePaise;
    if (totalPaise > _balancePaise) {
      final required = (totalPaise / 100.0).toStringAsFixed(2);
      final available = (_balancePaise / 100.0).toStringAsFixed(2);
      return AppStrings.errInsufficientBalance(required, available);
    }

    return null;
  }

  /// Check if a Sell order can be placed.
  /// Returns null if valid, or an error message if not.
  String? validateSellOrder(
    int quantity,
    String symbol,
    HoldingsProvider holdings,
  ) {
    if (quantity <= 0) return AppStrings.errQtyGreaterThanZero;

    final held = holdings.quantityHeld(symbol);
    if (quantity > held) {
      return AppStrings.errInsufficientHoldings(held, symbol);
    }

    return null;
  }

  // ── Order Execution ────────────────────────────────────────

  /// Execute a Buy order. Deducts from balance, creates holding.
  ///
  /// Returns the completed [Order].
  /// Caller must have validated with [validateBuyOrder] first.
  Future<Order> executeBuyOrder({
    required String symbol,
    required int quantity,
    required int pricePaise,
    required HoldingsProvider holdings,
  }) async {
    final totalPaise = quantity * pricePaise;

    // Deduct from balance.
    _balancePaise -= totalPaise;

    // Create order record.
    final order = Order(
      id: _uuid.v4(),
      symbol: symbol,
      side: OrderSide.buy,
      quantity: quantity,
      pricePaise: pricePaise,
      totalPaise: totalPaise,
      timestamp: DateTime.now(),
    );

    _orders.insert(0, order); // Most recent first.

    // Update holdings.
    await holdings.addHolding(symbol, quantity, pricePaise);

    notifyListeners();
    await _persist();

    return order;
  }

  /// Execute a Sell order. Adds to balance, reduces holding.
  ///
  /// Returns the completed [Order].
  /// Caller must have validated with [validateSellOrder] first.
  Future<Order> executeSellOrder({
    required String symbol,
    required int quantity,
    required int pricePaise,
    required HoldingsProvider holdings,
  }) async {
    final totalPaise = quantity * pricePaise;

    // Add to balance.
    _balancePaise += totalPaise;

    // Create order record.
    final order = Order(
      id: _uuid.v4(),
      symbol: symbol,
      side: OrderSide.sell,
      quantity: quantity,
      pricePaise: pricePaise,
      totalPaise: totalPaise,
      timestamp: DateTime.now(),
    );

    _orders.insert(0, order);

    // Update holdings.
    await holdings.reduceHolding(symbol, quantity);

    notifyListeners();
    await _persist();

    return order;
  }
}
