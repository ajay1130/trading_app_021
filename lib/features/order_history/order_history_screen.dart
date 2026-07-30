import 'package:trading_app_021/util/exports.dart';

/// Simple order history screen showing past orders.
class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.orderHistory)),
      body: Consumer<WalletProvider>(
        builder: (context, wallet, _) {
          final orders = wallet.orders;

          if (orders.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgElevated,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: const Icon(
                      Icons.receipt_long_rounded,
                      size: 48,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(height: Dimens.pad20),
                  Text(
                    AppStrings.noOrdersTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: Dimens.pad8),
                  const Text(
                    AppStrings.noOrdersSubtitle,
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: Dimens.font13,
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Wallet balance header
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      AppStrings.availableBalance,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: Dimens.font14,
                      ),
                    ),
                    Flexible(
                      child: Text(
                        '₹${AppFormatters.currency.format(wallet.balancePaise / 100.0)}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: Dimens.font18,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Orders list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    final isBuy = order.side == OrderSide.buy;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            // Side badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    (isBuy
                                            ? AppColors.buyGreen
                                            : AppColors.sellRed)
                                        .withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                isBuy ? AppStrings.buy : AppStrings.sell,
                                style: TextStyle(
                                  color: isBuy
                                      ? AppColors.buyGreen
                                      : AppColors.sellRed,
                                  fontWeight: FontWeight.w700,
                                  fontSize: Dimens.font12,
                                ),
                              ),
                            ),
                            const SizedBox(width: Dimens.pad12),

                            // Order info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    order.symbol,
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimens.font15,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${order.quantity} × ₹${AppFormatters.currency.format(order.priceRupees)}',
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: Dimens.font12,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: Dimens.pad12),

                            // Total and time
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '₹${AppFormatters.currency.format(order.totalRupees)}',
                                    style: const TextStyle(
                                      color: AppColors.textPrimary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: Dimens.font14,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    _formatTime(order.timestamp),
                                    style: const TextStyle(
                                      color: AppColors.textMuted,
                                      fontSize: Dimens.font11,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour.toString().padLeft(2, '0');
    final min = dt.minute.toString().padLeft(2, '0');
    final day = dt.day.toString().padLeft(2, '0');
    final month = dt.month.toString().padLeft(2, '0');
    return '$day/$month $hour:$min';
  }
}
