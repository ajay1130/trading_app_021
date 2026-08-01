import 'package:trading_app_021/util/exports.dart';

/// Individual holding row with live P&L and subtle LTP flash.
class HoldingRow extends StatelessWidget {
  final Holding holding;
  final VoidCallback? onTap;

  const HoldingRow({super.key, required this.holding, this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stockInfo = kStockMap[holding.symbol];

    return Selector<MarketDataProvider, PriceTick?>(
      selector: (_, provider) => provider.getPrice(holding.symbol),
      builder: (context, tick, _) {
        final ltpPaise = tick?.ltpPaise ?? holding.avgCostPaise;
        final pnl = holding.pnlPaise(ltpPaise);
        final pnlPct = holding.pnlPercent(ltpPaise);
        final isProfit = pnl >= 0;

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: Dimens.pad16,
            vertical: Dimens.pad5,
          ),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(Dimens.radius12),
            child: Padding(
              padding: const EdgeInsets.all(Dimens.pad16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            holding.symbol,
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.w700,
                              fontSize: Dimens.font15,
                            ),
                          ),
                          if (stockInfo != null)
                            Text(
                              stockInfo.name,
                              style: TextStyle(
                                color: c.textMuted,
                                fontSize: Dimens.font12,
                              ),
                            ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlashingLtpText(ltpPaise: ltpPaise),
                          const SizedBox(height: Dimens.pad2),
                          Text(
                            AppStrings.livePrice,
                            style: TextStyle(
                              color: c.textMuted,
                              fontSize: Dimens.font10,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: Dimens.pad12),
                  Container(height: Dimens.size1, color: c.border),
                  const SizedBox(height: Dimens.pad12),
                  Row(
                    children: [
                      _DetailCell(
                        label: AppStrings.qty,
                        value: '${holding.quantity}',
                        flex: Dimens.flex2,
                      ),
                      _DetailCell(
                        label: AppStrings.avgCost,
                        value:
                            '₹${AppFormatters.currency.format(holding.avgCostRupees)}',
                        flex: Dimens.flex3,
                      ),
                      _DetailCell(
                        label: AppStrings.value,
                        value:
                            '₹${AppFormatters.currency.format(holding.currentValueRupees(ltpPaise))}',
                        flex: Dimens.flex3,
                      ),
                      Expanded(
                        flex: Dimens.flex3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${isProfit ? '+' : ''}₹${AppFormatters.currency.format(pnl / 100.0)}',
                                style: TextStyle(
                                  color: isProfit
                                      ? AppColors.profitGreen
                                      : AppColors.lossRed,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Dimens.font13,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              alignment: Alignment.centerRight,
                              child: Text(
                                '${isProfit ? '+' : ''}${pnlPct.toStringAsFixed(2)}%',
                                style: TextStyle(
                                  color: isProfit
                                      ? AppColors.profitGreen
                                      : AppColors.lossRed,
                                  fontSize: Dimens.font12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DetailCell extends StatelessWidget {
  final String label;
  final String value;
  final int flex;

  const _DetailCell({required this.label, required this.value, this.flex = 1});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Expanded(
      flex: flex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: c.textMuted,
              fontSize: Dimens.font10,
            ),
          ),
          const SizedBox(height: Dimens.pad2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: c.textSecondary,
                fontSize: Dimens.font12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
