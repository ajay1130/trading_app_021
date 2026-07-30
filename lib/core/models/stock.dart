/// Immutable stock definition.
class Stock {
  final String symbol;
  final String name;

  /// Starting price in paise (1 ₹ = 100 paise).
  final int startingPricePaise;

  const Stock({
    required this.symbol,
    required this.name,
    required this.startingPricePaise,
  });

  /// Display price in rupees from paise.
  double get startingPriceRupees => startingPricePaise / 100.0;
}
