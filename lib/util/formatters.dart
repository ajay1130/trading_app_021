import 'package:trading_app_021/util/exports.dart';

/// Centralized formatters to ensure consistency and avoid recreating instances.
abstract class AppFormatters {
  /// Standard Indian Rupee formatter (e.g. 1,23,456.78)
  static final NumberFormat currency = NumberFormat('#,##,##0.00', 'en_IN');
}
