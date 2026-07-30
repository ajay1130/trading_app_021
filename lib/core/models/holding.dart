/// Holding model representing a stock position in the portfolio.
///
/// All monetary values are in paise for precision.
class Holding {
  final String symbol;
  int quantity;

  /// Average cost per share in paise (weighted average on buys).
  int avgCostPaise;

  Holding({
    required this.symbol,
    required this.quantity,
    required this.avgCostPaise,
  });

  /// Total invested amount in paise.
  int get investedPaise => quantity * avgCostPaise;

  /// Current value in paise given the current LTP.
  int currentValuePaise(int ltpPaise) => quantity * ltpPaise;

  /// Profit/Loss in paise given the current LTP.
  int pnlPaise(int ltpPaise) => currentValuePaise(ltpPaise) - investedPaise;

  /// P&L percentage given the current LTP.
  double pnlPercent(int ltpPaise) {
    if (investedPaise == 0) return 0.0;
    return (pnlPaise(ltpPaise) / investedPaise) * 100.0;
  }

  /// Display average cost in rupees.
  double get avgCostRupees => avgCostPaise / 100.0;

  /// Display invested amount in rupees.
  double get investedRupees => investedPaise / 100.0;

  /// Display current value in rupees.
  double currentValueRupees(int ltpPaise) =>
      currentValuePaise(ltpPaise) / 100.0;

  /// Display P&L in rupees.
  double pnlRupees(int ltpPaise) => pnlPaise(ltpPaise) / 100.0;

  /// Create from JSON map.
  factory Holding.fromJson(Map<String, dynamic> json) {
    return Holding(
      symbol: json['symbol'] as String,
      quantity: json['quantity'] as int,
      avgCostPaise: json['avgCostPaise'] as int,
    );
  }

  /// Serialize to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'symbol': symbol,
      'quantity': quantity,
      'avgCostPaise': avgCostPaise,
    };
  }
}
