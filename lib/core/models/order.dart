/// Order side: Buy or Sell.
enum OrderSide { buy, sell }

/// Completed order record with JSON serialization for persistence.
///
/// All monetary values are in paise for precision.
class Order {
  final String id;
  final String symbol;
  final OrderSide side;
  final int quantity;

  /// Execution price in paise.
  final int pricePaise;

  /// Total order value in paise: quantity × pricePaise.
  final int totalPaise;

  final DateTime timestamp;

  const Order({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.pricePaise,
    required this.totalPaise,
    required this.timestamp,
  });

  /// Display price in rupees.
  double get priceRupees => pricePaise / 100.0;

  /// Display total in rupees.
  double get totalRupees => totalPaise / 100.0;

  /// Create from JSON map.
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      symbol: json['symbol'] as String,
      side: json['side'] == 'buy' ? OrderSide.buy : OrderSide.sell,
      quantity: json['quantity'] as int,
      pricePaise: json['pricePaise'] as int,
      totalPaise: json['totalPaise'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  /// Serialize to JSON map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'symbol': symbol,
      'side': side == OrderSide.buy ? 'buy' : 'sell',
      'quantity': quantity,
      'pricePaise': pricePaise,
      'totalPaise': totalPaise,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
