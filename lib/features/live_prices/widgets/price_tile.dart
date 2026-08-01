import 'package:trading_app_021/util/exports.dart';

/// Individual stock price tile with subtle LTP color flash on price change.
///
/// Mimics real trading apps (5paisa, Zerodha): only the price text briefly
/// turns green/red on change, then fades back to white. No card background
/// flash — keeps the UI calm and professional.
class PriceTile extends StatefulWidget {
  final String symbol;
  final VoidCallback? onTap;

  const PriceTile({super.key, required this.symbol, this.onTap});

  @override
  State<PriceTile> createState() => _PriceTileState();
}

class _PriceTileState extends State<PriceTile>
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
      duration: const Duration(milliseconds: Dimens.duration300ms),
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
    return Selector<MarketDataProvider, PriceTick?>(
      selector: (_, provider) => provider.getPrice(widget.symbol),
      builder: (context, tick, child) {
        final c = context.colors;
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

        final companyName = kStockMap[widget.symbol]?.name ?? '';

        return GestureDetector(
          onTap: widget.onTap,
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
                ? _buildShimmer()
                : Row(
                    children: [
                      // Left: Symbol + Company name
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.symbol,
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

                      // Right: LTP + Change
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          // LTP with subtle color flash
                          _AnimatedBuilder(
                            animation: _flashOpacity,
                            builder: (context, _) {
                              final c = context.colors;
                              // During flash: show green/red. After: normal text color.
                              final color = Color.lerp(
                                c.textPrimary,
                                _flashColor,
                                _flashOpacity.value,
                              )!;
                              return Text(
                                '₹${AppFormatters.currency.format(tick.ltpRupees)}',
                                style: TextStyle(
                                  color: color,
                                  fontSize: Dimens.font15,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: Dimens.pad4),
                          // Change — always colored green/red
                          _buildChangeText(tick),
                        ],
                      ),
                    ],
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

  Widget _buildShimmer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _shimmerBlock(60, 18),
            const SizedBox(height: Dimens.pad6),
            _shimmerBlock(100, 12),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _shimmerBlock(80, 18),
            const SizedBox(height: Dimens.pad6),
            _shimmerBlock(70, 12),
          ],
        ),
      ],
    );
  }

  Widget _shimmerBlock(double width, double height) {
    final c = context.colors;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: c.cardBgElevated,
        borderRadius: BorderRadius.circular(Dimens.radius4),
      ),
    );
  }
}

/// Lightweight AnimatedWidget wrapper for animation-driven rebuilds.
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
