import 'package:trading_app_021/util/exports.dart';

/// Buy/Sell ticket screen for placing simulated market orders.
///
/// Pre-fills stock from navigation. Validates against wallet balance (Buy)
/// or holdings (Sell). Order executes at current LTP at moment of submission.
class BuySellTicketScreen extends StatefulWidget {
  final String symbol;

  const BuySellTicketScreen({super.key, required this.symbol});

  @override
  State<BuySellTicketScreen> createState() => _BuySellTicketScreenState();
}

class _BuySellTicketScreenState extends State<BuySellTicketScreen> {
  bool _isBuy = true;
  String? _error;
  bool _isSubmitting = false;
  final TextEditingController _qtyController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    setState(() {
      _error = null;
    });

    final qty = int.tryParse(_qtyController.text);
    if (qty == null || qty <= 0) {
      return;
    }

    final marketProvider = context.read<MarketDataProvider>();
    final walletProvider = context.read<WalletProvider>();
    final holdingsProvider = context.read<HoldingsProvider>();

    final priceTick = marketProvider.getPrice(widget.symbol);
    if (priceTick == null) {
      setState(() {
        _error = 'Live price not available. Please try again.';
      });
      return;
    }

    // Capture LTP at moment of submission.
    final ltpPaise = priceTick.ltpPaise;

    if (_isBuy) {
      final validationError = walletProvider.validateBuyOrder(qty, ltpPaise);
      if (validationError != null) {
        setState(() => _error = validationError);
        return;
      }
    } else {
      final validationError = walletProvider.validateSellOrder(
        qty,
        widget.symbol,
        holdingsProvider,
      );
      if (validationError != null) {
        setState(() => _error = validationError);
        return;
      }
    }

    setState(() => _isSubmitting = true);

    // Execute order (async — writes to persistence).
    final Order executedOrder;
    if (_isBuy) {
      executedOrder = await walletProvider.executeBuyOrder(
        symbol: widget.symbol,
        quantity: qty,
        pricePaise: ltpPaise,
        holdings: holdingsProvider,
      );
    } else {
      executedOrder = await walletProvider.executeSellOrder(
        symbol: widget.symbol,
        quantity: qty,
        pricePaise: ltpPaise,
        holdings: holdingsProvider,
      );
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(order: executedOrder),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final stockName = kStockMap[widget.symbol]?.name ?? widget.symbol;

    return Scaffold(
      backgroundColor: AppColors.scaffoldBg,
      appBar: AppBar(
        title: const Text(AppStrings.orderTicket),
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Dimens.pad16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Text(
              widget.symbol,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: Dimens.font28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: Dimens.pad4),
            Text(
              stockName,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: Dimens.font16,
              ),
            ),
            const SizedBox(height: Dimens.pad24),

            // Live LTP display card
            Selector<MarketDataProvider, PriceTick?>(
              selector: (_, provider) => provider.getPrice(widget.symbol),
              builder: (context, priceTick, child) {
                if (priceTick == null) {
                  return Container(
                    padding: const EdgeInsets.all(Dimens.pad16),
                    decoration: BoxDecoration(
                      color: AppColors.cardBgElevated,
                      borderRadius: BorderRadius.circular(Dimens.radius12),
                    ),
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final ltpRupees = priceTick.ltpPaise / 100.0;
                final changeRupees = priceTick.changePaise / 100.0;
                final changePercent = priceTick.changePercent;
                final isPositive = changeRupees >= 0;
                final color = isPositive
                    ? AppColors.profitGreen
                    : AppColors.lossRed;

                return Container(
                  padding: const EdgeInsets.all(Dimens.pad16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBgElevated,
                    borderRadius: BorderRadius.circular(Dimens.radius12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            AppStrings.livePrice,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: Dimens.font12,
                            ),
                          ),
                          const SizedBox(height: Dimens.pad4),
                          Text(
                            '₹${AppFormatters.currency.format(ltpRupees)}',
                            style: TextStyle(
                              color: color,
                              fontSize: Dimens.font24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(
                            isPositive
                                ? Icons.arrow_drop_up_rounded
                                : Icons.arrow_drop_down_rounded,
                            color: color,
                            size: 22,
                          ),
                          Text(
                            '${isPositive ? '+' : ''}${changeRupees.toStringAsFixed(2)} (${changePercent.toStringAsFixed(2)}%)',
                            style: TextStyle(
                              color: color,
                              fontSize: Dimens.font13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: Dimens.pad24),

            // Side toggle: Buy / Sell
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _isBuy = true;
                      _error = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.pad16,
                      ),
                      decoration: BoxDecoration(
                        color: _isBuy
                            ? AppColors.buyGreen
                            : AppColors.cardBgElevated,
                        borderRadius: BorderRadius.circular(Dimens.radius10),
                        border: Border.all(
                          color: _isBuy ? AppColors.buyGreen : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.buy,
                          style: TextStyle(
                            color: _isBuy
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimens.font16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Dimens.pad12),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      _isBuy = false;
                      _error = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        vertical: Dimens.pad16,
                      ),
                      decoration: BoxDecoration(
                        color: !_isBuy
                            ? AppColors.sellRed
                            : AppColors.cardBgElevated,
                        borderRadius: BorderRadius.circular(Dimens.radius10),
                        border: Border.all(
                          color: !_isBuy ? AppColors.sellRed : AppColors.border,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          AppStrings.sell,
                          style: TextStyle(
                            color: !_isBuy
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimens.font16,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: Dimens.pad24),

            // Quantity input
            TextFormField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: Dimens.font18,
              ),
              onChanged: (_) => setState(() => _error = null),
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(labelText: AppStrings.quantity),
            ),
            const SizedBox(height: Dimens.pad24),

            // Order summary card
            Consumer3<MarketDataProvider, WalletProvider, HoldingsProvider>(
              builder: (context, market, wallet, holdings, child) {
                final priceTick = market.getPrice(widget.symbol);
                final ltpPaise = priceTick?.ltpPaise ?? 0;
                final qty = int.tryParse(_qtyController.text) ?? 0;
                // Integer math in paise for precision.
                final orderValuePaise = qty * ltpPaise;
                final orderValueRupees = orderValuePaise / 100.0;

                final availableBalance = wallet.balanceRupees;
                final availableQty = holdings.quantityHeld(widget.symbol);

                return Container(
                  padding: const EdgeInsets.all(Dimens.pad16),
                  decoration: BoxDecoration(
                    color: AppColors.cardBgElevated,
                    borderRadius: BorderRadius.circular(Dimens.radius12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      _summaryRow(
                        AppStrings.orderValue,
                        '₹${AppFormatters.currency.format(orderValueRupees)}',
                        bold: true,
                      ),
                      const SizedBox(height: Dimens.pad12),
                      Container(height: 1, color: AppColors.border),
                      const SizedBox(height: Dimens.pad12),
                      if (_isBuy)
                        _summaryRow(
                          AppStrings.availableBalance,
                          '₹${AppFormatters.currency.format(availableBalance)}',
                        )
                      else
                        _summaryRow(
                          AppStrings.availableQty,
                          '$availableQty shares',
                        ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: Dimens.pad16),

            // Validation error
            if (_error != null)
              Container(
                padding: const EdgeInsets.all(Dimens.pad12),
                margin: const EdgeInsets.only(bottom: Dimens.pad16),
                decoration: BoxDecoration(
                  color: AppColors.lossRedBg,
                  borderRadius: BorderRadius.circular(Dimens.radius10),
                  border: Border.all(
                    color: AppColors.lossRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: AppColors.lossRed,
                      size: 18,
                    ),
                    const SizedBox(width: Dimens.pad8),
                    Expanded(
                      child: Text(
                        _error!,
                        style: const TextStyle(
                          color: AppColors.lossRed,
                          fontSize: Dimens.font13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Submit button
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed:
                    (_isSubmitting ||
                        (int.tryParse(_qtyController.text) ?? 0) <= 0)
                    ? null
                    : _submitOrder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isBuy
                      ? AppColors.buyGreen
                      : AppColors.sellRed,
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: AppColors.cardBgElevated,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Dimens.radius12),
                  ),
                  elevation: 0,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: Dimens.pad24,
                        height: Dimens.pad24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(
                        '${_isBuy ? AppStrings.buy : AppStrings.sell} ${widget.symbol}',
                        style: const TextStyle(
                          fontSize: Dimens.font18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: Dimens.font14,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: Dimens.font14,
            fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
