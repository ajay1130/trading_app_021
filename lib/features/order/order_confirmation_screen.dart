import 'package:trading_app_021/util/exports.dart';

/// Order confirmation screen shown after a successful order execution.
///
/// Displays animated success indicator and order details.
class OrderConfirmationScreen extends StatefulWidget {
  final Order order;

  const OrderConfirmationScreen({super.key, required this.order});

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final DateFormat _dateFormatter = DateFormat('dd MMM yyyy, hh:mm:ss a');

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.4, 1.0, curve: Curves.easeIn),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isBuy = widget.order.side == OrderSide.buy;
    final stockName =
        kStockMap[widget.order.symbol]?.name ?? widget.order.symbol;
    final themeColor = isBuy ? AppColors.buyGreen : AppColors.sellRed;

    return Scaffold(
      backgroundColor: c.scaffoldBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(Dimens.pad24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Success icon with scale animation
                            Center(
                              child: AnimatedBuilder(
                                animation: _controller,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _scaleAnimation.value,
                                    child: Opacity(
                                      opacity: _fadeAnimation.value.clamp(
                                        0.0,
                                        1.0,
                                      ),
                                      child: Container(
                                        width: Dimens.size120,
                                        height: Dimens.size120,
                                        decoration: BoxDecoration(
                                          color: AppColors.profitGreen
                                              .withValues(alpha: 0.1),
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.check_circle_rounded,
                                          color: AppColors.profitGreen,
                                          size: Dimens.size80,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: Dimens.pad32),

                            // Title
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Text(
                                AppStrings.orderPlacedSuccess,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontSize: Dimens.font24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: Dimens.size48),

                            // Order details card
                            FadeTransition(
                              opacity: _fadeAnimation,
                              child: Container(
                                padding: const EdgeInsets.all(Dimens.pad20),
                                decoration: BoxDecoration(
                                  color: c.cardBgElevated,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.radius16,
                                  ),
                                  border: Border.all(color: c.border),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.2,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: Dimens.pad12,
                                            vertical: Dimens.pad6,
                                          ),
                                          decoration: BoxDecoration(
                                            color: themeColor.withValues(
                                              alpha: 0.15,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              Dimens.radius6,
                                            ),
                                          ),
                                          child: Text(
                                            isBuy
                                                ? AppStrings.buy
                                                : AppStrings.sell,
                                            style: TextStyle(
                                              color: themeColor,
                                              fontSize: Dimens.font14,
                                              fontWeight: FontWeight.w800,
                                              letterSpacing: 1.2,
                                            ),
                                          ),
                                        ),
                                        Text(
                                          widget.order.symbol,
                                          style: TextStyle(
                                            color: c.textPrimary,
                                            fontSize: Dimens.font18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: Dimens.pad4),
                                    Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        stockName,
                                        style: TextStyle(
                                          color: c.textSecondary,
                                          fontSize: Dimens.font13,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: Dimens.pad16),
                                    Container(
                                      height: Dimens.size1,
                                      color: c.border,
                                    ),
                                    const SizedBox(height: Dimens.pad16),
                                    _buildDetailRow(
                                      AppStrings.qty,
                                      '${widget.order.quantity}',
                                    ),
                                    const SizedBox(height: Dimens.pad12),
                                    _buildDetailRow(
                                      AppStrings.price,
                                      '₹${AppFormatters.currency.format(widget.order.priceRupees)}',
                                    ),
                                    const SizedBox(height: Dimens.pad12),
                                    _buildDetailRow(
                                      AppStrings.totalValue,
                                      '₹${AppFormatters.currency.format(widget.order.totalRupees)}',
                                    ),
                                    const SizedBox(height: Dimens.pad12),
                                    _buildDetailRow(
                                      AppStrings.time,
                                      _dateFormatter.format(
                                        widget.order.timestamp,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: Dimens.pad16),

              // Done button
              FadeTransition(
                opacity: _fadeAnimation,
                child: SizedBox(
                  height: Dimens.size56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimens.radius12),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      AppStrings.done,
                      style: TextStyle(
                        fontSize: Dimens.font18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: c.textSecondary,
            fontSize: Dimens.font15,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: c.textPrimary,
            fontSize: Dimens.font15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
