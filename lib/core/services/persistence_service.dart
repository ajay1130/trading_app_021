import 'package:trading_app_021/util/exports.dart';

/// Persistence layer wrapping Hive.
///
/// All data is stored as JSON strings. Uses synchronous reads
/// via Hive boxes for fast startup.
class PersistenceService {
  PersistenceService._();
  static final PersistenceService instance = PersistenceService._();

  static const _keyWatchlists = 'watchlists';
  static const _keyHoldings = 'holdings';
  static const _keyWalletBalance = 'wallet_balance';
  static const _keyOrders = 'orders';

  late Box _box;

  /// Initialize the persistence service. Must be called before any reads/writes.
  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('appBox');
  }

  // ── Watchlists ──────────────────────────────────────────────

  /// Save watchlists to disk.
  Future<void> saveWatchlists(List<Watchlist> watchlists) async {
    final json = jsonEncode(watchlists.map((w) => w.toJson()).toList());
    await _box.put(_keyWatchlists, json);
  }

  /// Load watchlists from disk.
  List<Watchlist> loadWatchlists() {
    final json = _box.get(_keyWatchlists);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list
        .map((e) => Watchlist.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Holdings ────────────────────────────────────────────────

  /// Save holdings to disk.
  Future<void> saveHoldings(List<Holding> holdings) async {
    final json = jsonEncode(holdings.map((h) => h.toJson()).toList());
    await _box.put(_keyHoldings, json);
  }

  /// Load holdings from disk.
  List<Holding> loadHoldings() {
    final json = _box.get(_keyHoldings);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list
        .map((e) => Holding.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  // ── Wallet Balance ──────────────────────────────────────────

  /// Save wallet balance (in paise) to disk.
  Future<void> saveWalletBalance(int balancePaise) async {
    await _box.put(_keyWalletBalance, balancePaise);
  }

  /// Load wallet balance (in paise) from disk.
  /// Returns [kStartingBalancePaise] if no balance was previously saved.
  int loadWalletBalance() {
    return _box.get(_keyWalletBalance) ?? kStartingBalancePaise;
  }

  // ── Orders ──────────────────────────────────────────────────

  /// Save order history to disk.
  Future<void> saveOrders(List<Order> orders) async {
    final json = jsonEncode(orders.map((o) => o.toJson()).toList());
    await _box.put(_keyOrders, json);
  }

  /// Load order history from disk.
  List<Order> loadOrders() {
    final json = _box.get(_keyOrders);
    if (json == null) return [];
    final list = jsonDecode(json) as List;
    return list.map((e) => Order.fromJson(e as Map<String, dynamic>)).toList();
  }
}
