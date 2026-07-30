import 'package:trading_app_021/util/exports.dart';

/// Formatted price display widget with ₹ symbol.
///
/// Shows price in Indian Rupee format with 2 decimal places.
/// Optionally colorizes based on positive/negative values.
class PriceText extends StatelessWidget {
  /// Price in rupees (already converted from paise).
  final double priceRupees;

  /// Text style override.
  final TextStyle? style;

  /// Whether to show the ₹ prefix.
  final bool showSymbol;

  /// Whether to show + sign for positive values.
  final bool showSign;

  /// If true, colorize green for positive, red for negative.
  final bool colorize;

  const PriceText({
    super.key,
    required this.priceRupees,
    this.style,
    this.showSymbol = true,
    this.showSign = false,
    this.colorize = false,
  });

  static final _formatter = NumberFormat('#,##,##0.00', 'en_IN');

  @override
  Widget build(BuildContext context) {
    final formatted = _formatter.format(priceRupees.abs());
    final prefix = StringBuffer();

    if (showSign && priceRupees > 0) prefix.write('+');
    if (priceRupees < 0) prefix.write('-');
    if (showSymbol) prefix.write('₹');

    Color? textColor;
    if (colorize) {
      if (priceRupees > 0) {
        textColor = const Color(0xFF00C853);
      } else if (priceRupees < 0) {
        textColor = const Color(0xFFFF1744);
      }
    }

    return Text(
      '$prefix$formatted',
      style: (style ?? Theme.of(context).textTheme.bodyMedium)?.copyWith(
        color: textColor ?? style?.color,
      ),
    );
  }
}
