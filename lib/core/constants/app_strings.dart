/// Centralized application strings to avoid hardcoding in UI files.
class AppStrings {
  // Common / Shared
  static const String cancel = 'Cancel';
  static const String rename = 'Rename';
  static const String delete = 'Delete';
  static const String done = 'DONE';
  static const String noData = 'No Data';

  // Feature: Live Prices
  static const String marketOverview = 'Market Overview';
  static const String livePrice = 'Live Price';

  // Feature: Watchlist
  static const String watchlist = 'Watchlist';
  static const String watchlists = 'Watchlists';
  static const String newWatchlist = 'New Watchlist';
  static const String create = 'Create';
  static const String createWatchlist = 'Create Watchlist';
  static const String watchlistName = 'Watchlist name';
  static const String renameWatchlist = 'Rename Watchlist';
  static const String addStocks = 'Add Stocks';
  static const String searchStocks = 'Search stocks...';
  static const String noStocksFoundTitle = 'No Stocks Found';
  static const String noStocksFoundSubtitle =
      'Try searching for a different symbol';
  static const String deleteWatchlistConfirm = 'Delete this watchlist?';
  static const String emptyWatchlistTitle = 'Empty Watchlist';
  static const String emptyWatchlistSubtitle = 'Tap the + button to add stocks';
  static const String emptyWatchlistsTitle = 'No Watchlists';
  static const String emptyWatchlistsSubtitle =
      'Create a watchlist to track your favorite stocks';

  // Feature: Order
  static const String orderTicket = 'Order Entry';
  static const String buy = 'BUY';
  static const String sell = 'SELL';
  static const String quantity = 'Quantity';
  static const String quantityHint = 'Enter number of shares';
  static const String orderValue = 'Order Value';
  static const String availableBalance = 'Available Balance';
  static const String availableQty = 'Available Qty';
  static const String orderPlacedSuccess = 'Order Placed Successfully!';
  static const String price = 'Price';
  static const String totalValue = 'Total Value';
  static const String time = 'Time';

  // Feature: Holdings
  static const String holdings = 'Holdings';
  static const String noHoldingsTitle = 'No Holdings Yet';
  static const String noHoldingsSubtitle =
      'Buy stocks from the Market or Watchlist to build your portfolio';
  static const String sortBy = 'Sort by';
  static const String sortPnl = 'P&L';
  static const String sortSymbol = 'Symbol';
  static const String sortCurrentValue = 'Current Value';
  static const String totalPnl = 'Total P&L';
  static const String invested = 'Invested';
  static const String currentValue = 'Current Value';
  static const String qty = 'Qty';
  static const String avgCost = 'Avg Cost';

  // Feature: Order History
  static const String orderHistory = 'Order History';
  static const String orders = 'Orders';
  static const String noOrdersTitle = 'No Orders Yet';
  static const String noOrdersSubtitle =
      'Place your first order from Market or Watchlist';
  static const String market = 'Market';
  static const String appName = "021 Trading";

  // Feature: Wallet/Validation
  static const String errQtyGreaterThanZero =
      'Quantity must be greater than zero';
  static const String errInvalidQuantity =
      'Enter a valid quantity (positive integer)';
  static const String errLivePriceNotAvailable =
      'Live price not available. Please try again.';
  static String errInsufficientBalance(String req, String avail) =>
      'Insufficient balance. Required: ₹$req, Available: ₹$avail';
  static String errInsufficientHoldings(int held, String symbol) =>
      'Insufficient holdings. You hold $held shares of $symbol';

  // Feature: Watchlist Actions
  static const String undo = 'Undo';
  static const String watchlistNotFound = 'Watchlist not found';
  static const String deleteWatchlistTitle = 'Delete Watchlist';
  static String deleteWatchlistConfirmMsg(String name) =>
      'Are you sure you want to delete "$name"?';
  static String stockCountLabel(int count) =>
      '$count stock${count == 1 ? '' : 's'}';
  static String removedFromWatchlist(String symbol) =>
      '$symbol removed from watchlist';
  static String addedToWatchlist(String symbol) => '$symbol added to watchlist';
}
