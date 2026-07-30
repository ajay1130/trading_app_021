/// Watchlist model with JSON serialization for persistence.
class Watchlist {
  final String id;
  String name;
  List<String> symbols;

  Watchlist({required this.id, required this.name, List<String>? symbols})
    : symbols = symbols ?? [];

  /// Create from JSON map (persistence deserialization).
  factory Watchlist.fromJson(Map<String, dynamic> json) {
    return Watchlist(
      id: json['id'] as String,
      name: json['name'] as String,
      symbols: List<String>.from(json['symbols'] as List),
    );
  }

  /// Serialize to JSON map for persistence.
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'symbols': symbols};
  }
}
