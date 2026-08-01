import 'package:trading_app_021/util/exports.dart';

/// Individual stock price tile with subtle LTP color flash on price change.
class PriceTile extends StatelessWidget {
  final String symbol;
  final VoidCallback? onTap;

  const PriceTile({super.key, required this.symbol, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Selector<MarketDataProvider, PriceTick?>(
      selector: (_, provider) => provider.getPrice(symbol),
      builder: (context, tick, _) {
        final c = context.colors;
        final companyName = kStockMap[symbol]?.name ?? '';

        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: const EdgeInsets.symmetric(
              horizontal: Dimens.pad16,
              vertical: Dimens.pad3,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: Dimens.pad16,
              vertical: Dimens.pad14,
            ),
            decoration: BoxDecoration(
              color: c.cardBg,
              borderRadius: BorderRadius.circular(Dimens.radius12),
              border: Border.all(color: c.border),
            ),
            child: tick == null
                ? _buildShimmer(context)
                : Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              symbol,
                              style: TextStyle(
                                color: c.textPrimary,
                                fontSize: Dimens.font15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: Dimens.pad3),
                            Text(
                              companyName,
                              style: TextStyle(
                                color: c.textMuted,
                                fontSize: Dimens.font12,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          FlashingLtpText(ltpPaise: tick.ltpPaise),
                          const SizedBox(height: Dimens.pad4),
                          ChangeBadge(
                            changeRupees: tick.changeRupees,
                            changePercent: tick.changePercent,
                            compact: true,
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildShimmer(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBlock(context, Dimens.size60, Dimens.size18),
            const SizedBox(height: Dimens.pad6),
            _shimmerBlock(context, Dimens.size100, Dimens.size12),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _shimmerBlock(context, Dimens.size80, Dimens.size18),
            const SizedBox(height: Dimens.pad6),
            _shimmerBlock(context, Dimens.size70, Dimens.size12),
          ],
        ),
      ],
    );
  }

  Widget _shimmerBlock(BuildContext context, double width, double height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.cardBgElevated,
        borderRadius: BorderRadius.circular(Dimens.radius4),
      ),
    );
  }
}
