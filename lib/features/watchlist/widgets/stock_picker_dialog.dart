import 'package:trading_app_021/util/exports.dart';

/// Bottom sheet dialog for adding stocks to a watchlist.
class StockPickerDialog extends StatefulWidget {
  final String watchlistId;

  const StockPickerDialog({super.key, required this.watchlistId});

  @override
  State<StockPickerDialog> createState() => _StockPickerDialogState();
}

class _StockPickerDialogState extends State<StockPickerDialog> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistProvider>(
      builder: (context, provider, _) {
        final watchlist = provider.getWatchlist(widget.watchlistId);
        final existingSymbols = watchlist?.symbols ?? [];
        final filteredStocks = kStocks
            .where(
              (stock) =>
                  stock.symbol.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ||
                  stock.name.toLowerCase().contains(_searchQuery.toLowerCase()),
            )
            .toList();

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: Dimens.pad8),
                  width: Dimens.pad40,
                  height: Dimens.pad4,
                  decoration: BoxDecoration(
                    color: AppColors.textMuted,
                    borderRadius: BorderRadius.circular(Dimens.radius2),
                  ),
                ),
              ),
              const SizedBox(height: Dimens.pad16),
              // Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.pad20),
                child: Text(
                  AppStrings.addStocks,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              const SizedBox(height: Dimens.pad8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: Dimens.pad20),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) => setState(() => _searchQuery = value),
                  decoration: const InputDecoration(
                    hintText: AppStrings.searchStocks,
                    prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: Dimens.pad16,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Dimens.pad8),
              const Divider(),
              // Stock list
              Flexible(
                child: filteredStocks.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(vertical: Dimens.pad32),
                        child: EmptyStateWidget(
                          icon: Icons.search_off_rounded,
                          title: AppStrings.noStocksFoundTitle,
                          subtitle: AppStrings.noStocksFoundSubtitle,
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        padding: const EdgeInsets.only(bottom: Dimens.pad16),
                        itemCount: filteredStocks.length,
                        itemBuilder: (context, index) {
                          final stock = filteredStocks[index];
                          final isAdded = existingSymbols.contains(
                            stock.symbol,
                          );

                          return ListTile(
                            leading: Container(
                              width: Dimens.pad40,
                              height: Dimens.pad40,
                              decoration: BoxDecoration(
                                color: isAdded
                                    ? AppColors.profitGreen.withValues(
                                        alpha: 0.15,
                                      )
                                    : AppColors.cardBgElevated,
                                borderRadius: BorderRadius.circular(
                                  Dimens.radius10,
                                ),
                                border: Border.all(
                                  color: isAdded
                                      ? AppColors.profitGreen.withValues(
                                          alpha: 0.3,
                                        )
                                      : AppColors.border,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  stock.symbol.substring(0, 2),
                                  style: TextStyle(
                                    color: isAdded
                                        ? AppColors.profitGreen
                                        : AppColors.textSecondary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: Dimens.font14,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(
                              stock.symbol,
                              style: TextStyle(
                                color: isAdded
                                    ? AppColors.textMuted
                                    : AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            subtitle: Text(
                              stock.name,
                              style: TextStyle(
                                color: isAdded
                                    ? AppColors.textMuted.withValues(alpha: 0.6)
                                    : AppColors.textSecondary,
                                fontSize: Dimens.font12,
                              ),
                            ),
                            trailing: isAdded
                                ? const Icon(
                                    Icons.check_circle_rounded,
                                    color: AppColors.profitGreen,
                                    size: 22,
                                  )
                                : const Icon(
                                    Icons.add_circle_outline_rounded,
                                    color: AppColors.primary,
                                    size: 22,
                                  ),
                            onTap: isAdded
                                ? null
                                : () {
                                    provider.addStock(
                                      widget.watchlistId,
                                      stock.symbol,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '${stock.symbol} added to watchlist',
                                        ),
                                        duration: const Duration(seconds: 1),
                                      ),
                                    );
                                  },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
