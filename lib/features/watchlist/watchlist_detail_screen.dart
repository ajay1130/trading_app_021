import 'package:trading_app_021/util/exports.dart';

/// Detail view of a single watchlist with drag-to-reorder and live prices.
class WatchlistDetailScreen extends StatelessWidget {
  final String watchlistId;

  const WatchlistDetailScreen({super.key, required this.watchlistId});

  @override
  Widget build(BuildContext context) {
    return Consumer<WatchlistProvider>(
      builder: (context, provider, _) {
        final watchlist = provider.getWatchlist(watchlistId);

        if (watchlist == null) {
          return Scaffold(
            appBar: AppBar(title: const Text(AppStrings.watchlist)),
            body: const Center(child: Text(AppStrings.watchlistNotFound)),
          );
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(watchlist.name),
            actions: [
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'rename') {
                    _showRenameDialog(context, watchlist);
                  } else if (value == 'delete') {
                    _showDeleteDialog(context, provider);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'rename',
                    child: Text(AppStrings.rename),
                  ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Text(
                      AppStrings.delete,
                      style: TextStyle(color: AppColors.lossRed),
                    ),
                  ),
                ],
              ),
            ],
          ),
          body: watchlist.symbols.isEmpty
              ? EmptyStateWidget(
                  icon: Icons.list_alt_rounded,
                  title: AppStrings.emptyWatchlistTitle,
                  subtitle: AppStrings.emptyWatchlistSubtitle,
                  action: ElevatedButton.icon(
                    onPressed: () => _showStockPicker(context),
                    icon: const Icon(Icons.add, size: Dimens.icon18),
                    label: const Text(AppStrings.addStocks),
                  ),
                )
              : ReorderableListView.builder(
                  padding: const EdgeInsets.only(
                    top: Dimens.pad8,
                    bottom: Dimens.size80,
                  ),
                  itemCount: watchlist.symbols.length,
                  onReorder: (oldIndex, newIndex) {
                    provider.reorderStocks(watchlistId, oldIndex, newIndex);
                  },
                  proxyDecorator: (child, index, animation) {
                    return AnimatedBuilder(
                      animation: animation,
                      builder: (context, child) {
                        final elevation = Tween<double>(
                          begin: 0,
                          end: 8,
                        ).animate(animation).value;
                        return Material(
                          color: Colors.transparent,
                          elevation: elevation,
                          shadowColor: AppColors.primary.withValues(alpha: 0.3),
                          child: child,
                        );
                      },
                      child: child,
                    );
                  },
                  itemBuilder: (context, index) {
                    final symbol = watchlist.symbols[index];
                    return Dismissible(
                      key: ValueKey('dismiss_$symbol'),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: Dimens.pad20),
                        margin: const EdgeInsets.symmetric(
                          horizontal: Dimens.pad16,
                          vertical: Dimens.pad6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lossRed.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(Dimens.radius12),
                        ),
                        child: const Icon(
                          Icons.delete_rounded,
                          color: AppColors.lossRed,
                        ),
                      ),
                      onDismissed: (_) {
                        provider.removeStock(watchlistId, symbol);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppStrings.removedFromWatchlist(symbol),
                            ),
                            duration: const Duration(
                              seconds: Dimens.duration2s,
                            ),
                            action: SnackBarAction(
                              label: AppStrings.undo,
                              onPressed: () {
                                provider.addStock(watchlistId, symbol);
                              },
                            ),
                          ),
                        );
                      },
                      child: WatchlistRow(
                        key: ValueKey(symbol),
                        symbol: symbol,
                      ),
                    );
                  },
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _showStockPicker(context),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  void _showStockPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => StockPickerDialog(watchlistId: watchlistId),
    );
  }

  void _showRenameDialog(BuildContext context, Watchlist watchlist) {
    final controller = TextEditingController(text: watchlist.name);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.renameWatchlist),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: AppStrings.watchlistName),
          textCapitalization: TextCapitalization.words,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                context.read<WatchlistProvider>().renameWatchlist(
                  watchlistId,
                  newName,
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.rename),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, WatchlistProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteWatchlistConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.lossRed),
            onPressed: () {
              provider.deleteWatchlist(watchlistId);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Go back to watchlists list
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}
