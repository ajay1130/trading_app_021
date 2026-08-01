import 'package:trading_app_021/util/exports.dart';

/// Aggregate portfolio summary card showing total invested, current value, and P&L.
///
/// Updates in real-time as price ticks arrive.
class PortfolioSummaryCard extends StatelessWidget {
  const PortfolioSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Consumer2<HoldingsProvider, MarketDataProvider>(
      builder: (context, holdingsProvider, marketProvider, _) {
        final holdings = holdingsProvider.holdings;
        if (holdings.isEmpty) {
          return const SizedBox.shrink();
        }

        int totalInvestedPaise = 0;
        int totalCurrentValuePaise = 0;

        for (final holding in holdings) {
          totalInvestedPaise += holding.investedPaise;
          final ltp =
              marketProvider.getPrice(holding.symbol)?.ltpPaise ??
              holding.avgCostPaise;
          totalCurrentValuePaise += holding.currentValuePaise(ltp);
        }

        final totalPnlPaise = totalCurrentValuePaise - totalInvestedPaise;
        final totalPnlPercent = totalInvestedPaise > 0
            ? (totalPnlPaise / totalInvestedPaise) * 100.0
            : 0.0;
        final isProfit = totalPnlPaise >= 0;

        return Container(
          margin: const EdgeInsets.all(Dimens.pad16),
          padding: const EdgeInsets.all(Dimens.pad20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                c.cardBg,
                c.cardBgElevated.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(Dimens.radius16),
            border: Border.all(
              color: isProfit
                  ? AppColors.profitGreen.withValues(alpha: 0.2)
                  : totalPnlPaise < 0
                  ? AppColors.lossRed.withValues(alpha: 0.2)
                  : c.border,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: (isProfit ? AppColors.profitGreen : AppColors.lossRed)
                    .withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              // P&L headline
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isProfit
                        ? Icons.trending_up_rounded
                        : Icons.trending_down_rounded,
                    color: isProfit ? AppColors.profitGreen : AppColors.lossRed,
                    size: Dimens.size24,
                  ),
                  const SizedBox(width: Dimens.pad8),
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${isProfit ? '+' : ''}₹${AppFormatters.currency.format(totalPnlPaise / 100.0)}',
                        style: TextStyle(
                          color: isProfit
                              ? AppColors.profitGreen
                              : AppColors.lossRed,
                          fontWeight: FontWeight.w800,
                          fontSize: Dimens.font24,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: Dimens.pad8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (isProfit ? AppColors.profitGreen : AppColors.lossRed)
                              .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(Dimens.radius6),
                    ),
                    child: Text(
                      '${isProfit ? '+' : ''}${totalPnlPercent.toStringAsFixed(2)}%',
                      style: TextStyle(
                        color: isProfit
                            ? AppColors.profitGreen
                            : AppColors.lossRed,
                        fontWeight: FontWeight.w600,
                        fontSize: Dimens.font13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: Dimens.pad4),
              Text(
                AppStrings.totalPnl,
                style: TextStyle(
                  color: c.textMuted,
                  fontSize: Dimens.font12,
                ),
              ),

              const SizedBox(height: Dimens.pad16),
              Container(height: Dimens.size1, color: c.border),
              const SizedBox(height: Dimens.pad16),

              // Details row
              Row(
                children: [
                  Expanded(
                    child: _SummaryCell(
                      label: AppStrings.invested,
                      value:
                          '₹${AppFormatters.currency.format(totalInvestedPaise / 100.0)}',
                    ),
                  ),
                  Container(
                    width: Dimens.size1,
                    height: Dimens.size36,
                    color: c.border,
                  ),
                  Expanded(
                    child: _SummaryCell(
                      label: AppStrings.currentValue,
                      value:
                          '₹${AppFormatters.currency.format(totalCurrentValuePaise / 100.0)}',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SummaryCell extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: c.textMuted,
            fontSize: Dimens.font12,
          ),
        ),
        const SizedBox(height: Dimens.pad4),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            value,
            style: TextStyle(
              color: c.textPrimary,
              fontWeight: FontWeight.w600,
              fontSize: Dimens.font15,
            ),
          ),
        ),
      ],
    );
  }
}
