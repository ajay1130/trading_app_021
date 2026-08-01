import 'package:trading_app_021/util/exports.dart';

/// A stock row within a watchlist showing live price with subtle LTP flash.
class WatchlistRow extends StatelessWidget {
  final String symbol;

  const WatchlistRow({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final stockInfo = kStockMap[symbol];

    return Selector<MarketDataProvider, PriceTick?>(
      selector: (_, provider) => provider.getPrice(symbol),
      builder: (context, tick, _) {
        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: Dimens.pad16,
            vertical: Dimens.pad4,
          ),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BuySellTicketScreen(symbol: symbol),
                ),
              );
            },
            borderRadius: BorderRadius.circular(Dimens.radius12),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: Dimens.pad16,
                vertical: Dimens.pad14,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          symbol,
                          style: TextStyle(
                            color: c.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: Dimens.font15,
                          ),
                        ),
                        if (stockInfo != null) ...[
                          const SizedBox(height: Dimens.size2),
                          Text(
                            stockInfo.name,
                            style: TextStyle(
                              color: c.textMuted,
                              fontSize: Dimens.font12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (tick != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FlashingLtpText(ltpPaise: tick.ltpPaise),
                        const SizedBox(height: Dimens.size3),
                        ChangeBadge(
                          changeRupees: tick.changeRupees,
                          changePercent: tick.changePercent,
                          compact: true,
                        ),
                      ],
                    )
                  else
                    Text(
                      '—',
                      style: TextStyle(
                        color: c.textMuted,
                        fontSize: Dimens.font13,
                      ),
                    ),
                  const SizedBox(width: Dimens.pad8),
                  Icon(
                    Icons.drag_handle_rounded,
                    color: c.textMuted,
                    size: Dimens.size20,
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
