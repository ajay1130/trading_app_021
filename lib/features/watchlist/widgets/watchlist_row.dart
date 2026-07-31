import 'package:trading_app_021/util/exports.dart';

/// A stock row within a watchlist showing live price with subtle LTP flash.
///
/// Mimics real trading apps: only the price text briefly turns green/red
/// on change, then fades back to white. Card background stays static.
class WatchlistRow extends StatefulWidget {
  final String symbol;

  const WatchlistRow({super.key, required this.symbol});

  @override
  State<WatchlistRow> createState() => _WatchlistRowState();
}

class _WatchlistRowState extends State<WatchlistRow>
    with SingleTickerProviderStateMixin {
  late AnimationController _flashController;
  late Animation<double> _flashOpacity;
  int? _previousLtp;
  Color _flashColor = AppColors.profitGreen;

  @override
  void initState() {
    super.initState();
    _flashController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _flashOpacity = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _flashController, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _flashController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stockInfo = kStockMap[widget.symbol];

    return Selector<MarketDataProvider, PriceTick?>(
      selector: (_, provider) => provider.getPrice(widget.symbol),
      builder: (context, tick, _) {
        // Detect direction and trigger flash.
        if (tick != null &&
            _previousLtp != null &&
            _previousLtp != tick.ltpPaise) {
          _flashColor = tick.ltpPaise > _previousLtp!
              ? AppColors.profitGreen
              : AppColors.lossRed;
          _flashController.forward(from: 0.0);
        }
        if (tick != null) _previousLtp = tick.ltpPaise;

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
                  builder: (_) => BuySellTicketScreen(symbol: widget.symbol),
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
                  // Stock info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol,
                          style: const TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w700,
                            fontSize: Dimens.font15,
                          ),
                        ),
                        if (stockInfo != null) ...[
                          const SizedBox(height: 2),
                          Text(
                            stockInfo.name,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: Dimens.font12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Price info with subtle flash
                  if (tick != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // LTP with color flash
                        _AnimatedBuilder(
                          animation: _flashOpacity,
                          builder: (context, _) {
                            final color = Color.lerp(
                              AppColors.textPrimary,
                              _flashColor,
                              _flashOpacity.value,
                            )!;
                            return Text(
                              '₹${AppFormatters.currency.format(tick.ltpRupees)}',
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w600,
                                fontSize: Dimens.font15,
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 3),
                        // Change — always colored
                        _buildChangeText(tick),
                      ],
                    )
                  else
                    const Text(
                      '—',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: Dimens.font13,
                      ),
                    ),

                  // Drag handle
                  const SizedBox(width: Dimens.pad8),
                  const Icon(
                    Icons.drag_handle_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildChangeText(PriceTick tick) {
    final isPositive = tick.changePaise >= 0;
    final color = isPositive ? AppColors.profitGreen : AppColors.lossRed;
    final sign = isPositive ? '+' : '';
    final arrow = isPositive ? '▲' : '▼';

    return Text(
      '$arrow $sign${tick.changeRupees.toStringAsFixed(2)} (${tick.changePercent.toStringAsFixed(2)}%)',
      style: TextStyle(
        color: color,
        fontSize: Dimens.font12,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Lightweight AnimatedWidget wrapper.
class _AnimatedBuilder extends AnimatedWidget {
  final TransitionBuilder builder;

  const _AnimatedBuilder({
    required Animation<dynamic> animation,
    required this.builder,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    return builder(context, null);
  }
}
