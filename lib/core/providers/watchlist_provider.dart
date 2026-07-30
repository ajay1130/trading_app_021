import 'package:trading_app_021/util/exports.dart';

/// Provider for managing multiple watchlists.
///
/// Supports CRUD operations on watchlists, and add/remove/reorder
/// of stocks within each watchlist. Every mutation auto-persists.
class WatchlistProvider extends ChangeNotifier {
  final PersistenceService _persistence;
  final _uuid = const Uuid();

  List<Watchlist> _watchlists = [];

  /// All watchlists.
  List<Watchlist> get watchlists => List.unmodifiable(_watchlists);

  WatchlistProvider({PersistenceService? persistence})
    : _persistence = persistence ?? PersistenceService.instance {
    _loadFromDisk();
  }

  void _loadFromDisk() {
    _watchlists = _persistence.loadWatchlists();
    notifyListeners();
  }

  Future<void> _persist() async {
    await _persistence.saveWatchlists(_watchlists);
  }

  // ── Watchlist CRUD ─────────────────────────────────────────

  /// Create a new watchlist with the given name.
  Future<Watchlist> createWatchlist(String name) async {
    final watchlist = Watchlist(id: _uuid.v4(), name: name.trim());
    _watchlists.add(watchlist);
    notifyListeners();
    await _persist();
    return watchlist;
  }

  /// Rename a watchlist.
  Future<void> renameWatchlist(String id, String newName) async {
    final watchlist = _watchlists.firstWhere((w) => w.id == id);
    watchlist.name = newName.trim();
    notifyListeners();
    await _persist();
  }

  /// Delete a watchlist.
  Future<void> deleteWatchlist(String id) async {
    _watchlists.removeWhere((w) => w.id == id);
    notifyListeners();
    await _persist();
  }

  /// Get a watchlist by ID.
  Watchlist? getWatchlist(String id) {
    try {
      return _watchlists.firstWhere((w) => w.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Stock management within a watchlist ────────────────────

  /// Add a stock to a watchlist (no duplicates within the same list).
  Future<void> addStock(String watchlistId, String symbol) async {
    final watchlist = _watchlists.firstWhere((w) => w.id == watchlistId);
    if (!watchlist.symbols.contains(symbol)) {
      watchlist.symbols.add(symbol);
      notifyListeners();
      await _persist();
    }
  }

  /// Remove a stock from a watchlist.
  Future<void> removeStock(String watchlistId, String symbol) async {
    final watchlist = _watchlists.firstWhere((w) => w.id == watchlistId);
    watchlist.symbols.remove(symbol);
    notifyListeners();
    await _persist();
  }

  /// Reorder stocks within a watchlist.
  Future<void> reorderStocks(
    String watchlistId,
    int oldIndex,
    int newIndex,
  ) async {
    final watchlist = _watchlists.firstWhere((w) => w.id == watchlistId);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final symbol = watchlist.symbols.removeAt(oldIndex);
    watchlist.symbols.insert(newIndex, symbol);
    notifyListeners();
    await _persist();
  }
}
