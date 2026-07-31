import 'package:trading_app_021/util/exports.dart';

/// A badge showing price change amount and percentage.
///
/// Displays green for positive changes, red for negative,
/// with appropriate arrow icons.
class ChangeBadge extends StatelessWidget {
  /// Change amount in rupees.
  final double changeRupees;

  /// Change percentage.
  final double changePercent;

  /// Whether to show a compact version (no background).
  final bool compact;

  const ChangeBadge({
    super.key,
    required this.changeRupees,
    required this.changePercent,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isPositive = changeRupees > 0;
    final isNegative = changeRupees < 0;
    final color = isPositive
        ? AppColors.profitGreen
        : isNegative
        ? AppColors.lossRed
        : AppColors.textMuted;
    final bgColor = isPositive
        ? AppColors.profitGreenBg
        : isNegative
        ? AppColors.lossRedBg
        : Colors.transparent;
    final icon = isPositive
        ? Icons.arrow_drop_up_rounded
        : isNegative
        ? Icons.arrow_drop_down_rounded
        : null;

    final sign = isPositive ? '+' : '';
    final changeStr = '$sign${changeRupees.toStringAsFixed(2)}';
    final percentStr = '($sign${changePercent.toStringAsFixed(2)}%)';

    if (compact) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: color, size: Dimens.icon20),
          Text(
            '$changeStr $percentStr',
            style: TextStyle(
              color: color,
              fontSize: Dimens.font12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Dimens.pad8,
        vertical: Dimens.pad4,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(Dimens.radius6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) Icon(icon, color: color, size: Dimens.icon18),
          Text(
            '$changeStr $percentStr',
            style: TextStyle(
              color: color,
              fontSize: Dimens.font12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
