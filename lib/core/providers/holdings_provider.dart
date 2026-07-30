import 'package:trading_app_021/util/exports.dart';

/// Provider for managing stock holdings (portfolio).
///
/// Handles creating/updating holdings on Buy, reducing/removing on Sell.
/// Uses weighted average cost calculation for buys.
/// Auto-persists every mutation.
class HoldingsProvider extends ChangeNotifier {
  final PersistenceService _persistence;

  List<Holding> _holdings = [];

  /// All current holdings.
  List<Holding> get holdings => List.unmodifiable(_holdings);

  HoldingsProvider({PersistenceService? persistence})
    : _persistence = persistence ?? PersistenceService.instance {
    _loadFromDisk();
  }

  void _loadFromDisk() {
    _holdings = _persistence.loadHoldings();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _persistence.saveHoldings(_holdings);
  }

  /// Get holding for a specific symbol, or null if not held.
  Holding? getHolding(String symbol) {
    try {
      return _holdings.firstWhere((h) => h.symbol == symbol);
    } catch (_) {
      return null;
    }
  }

  /// Get the quantity held for a specific symbol.
  int quantityHeld(String symbol) {
    return getHolding(symbol)?.quantity ?? 0;
  }

  /// Add to a holding (Buy order executed).
  ///
  /// If the stock is already held, updates using weighted average cost:
  /// newAvgCost = (oldQty * oldAvg + newQty * buyPrice) / (oldQty + newQty)
  ///
  /// All values in paise.
  Future<void> addHolding(String symbol, int quantity, int pricePaise) async {
    final existing = getHolding(symbol);

    if (existing != null) {
      // Weighted average cost calculation (in paise, integer math).
      final totalCost =
          existing.quantity * existing.avgCostPaise + quantity * pricePaise;
      final totalQty = existing.quantity + quantity;
      existing.avgCostPaise = (totalCost / totalQty).round();
      existing.quantity = totalQty;
    } else {
      _holdings.add(
        Holding(symbol: symbol, quantity: quantity, avgCostPaise: pricePaise),
      );
    }

    notifyListeners();
    await _persist();
  }

  /// Reduce a holding (Sell order executed).
  ///
  /// If quantity reaches zero, the holding is removed entirely.
  /// Average cost is not changed on sells.
  Future<void> reduceHolding(String symbol, int quantity) async {
    final existing = getHolding(symbol);
    if (existing == null) return;

    existing.quantity -= quantity;
    if (existing.quantity <= 0) {
      _holdings.removeWhere((h) => h.symbol == symbol);
    }

    notifyListeners();
    await _persist();
  }
}
