/// Immutable price tick emitted by the mock market feed.
///
/// All monetary values are in paise for precision.
class PriceTick {
  final String symbol;

  /// Last traded price in paise.
  final int ltpPaise;

  /// Previous close price in paise (used for change calculation).
  final int previousClosePaise;

  /// Absolute change in paise: ltp - previousClose.
  final int changePaise;

  /// Percentage change from previous close.
  final double changePercent;

  /// Timestamp of this tick.
  final DateTime timestamp;

  const PriceTick({
    required this.symbol,
    required this.ltpPaise,
    required this.previousClosePaise,
    required this.changePaise,
    required this.changePercent,
    required this.timestamp,
  });

  /// LTP in rupees for display.
  double get ltpRupees => ltpPaise / 100.0;

  /// Absolute change in rupees for display.
  double get changeRupees => changePaise / 100.0;

  /// Whether this tick represents an upward price movement.
  bool get isUp => changePaise > 0;

  /// Whether this tick represents a downward price movement.
  bool get isDown => changePaise < 0;
}
