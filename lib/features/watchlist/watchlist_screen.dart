import 'package:trading_app_021/util/exports.dart';

/// Main watchlist management screen.
///
/// Shows all watchlists as cards. Supports create, rename, delete.
class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.watchlists)),
      body: Consumer<WatchlistProvider>(
        builder: (context, provider, _) {
          if (provider.watchlists.isEmpty) {
            return EmptyStateWidget(
              icon: Icons.list_alt_rounded,
              title: AppStrings.emptyWatchlistsTitle,
              subtitle: AppStrings.emptyWatchlistsSubtitle,
              action: ElevatedButton.icon(
                onPressed: () => _showCreateDialog(context),
                icon: const Icon(Icons.add, size: Dimens.icon18),
                label: const Text(AppStrings.createWatchlist),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: Dimens.pad8,
              bottom: Dimens.size80,
            ),
            itemCount: provider.watchlists.length,
            itemBuilder: (context, index) {
              final watchlist = provider.watchlists[index];
              return _WatchlistCard(
                name: watchlist.name,
                stockCount: watchlist.symbols.length,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          WatchlistDetailScreen(watchlistId: watchlist.id),
                    ),
                  );
                },
                onLongPress: () =>
                    _showOptionsSheet(context, watchlist.id, watchlist.name),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.newWatchlist),
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
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<WatchlistProvider>().createWatchlist(name);
                Navigator.pop(ctx);
              }
            },
            child: const Text(AppStrings.create),
          ),
        ],
      ),
    );
  }

  void _showOptionsSheet(
    BuildContext context,
    String watchlistId,
    String currentName,
  ) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: Dimens.pad8),
              width: Dimens.pad40,
              height: Dimens.pad4,
              decoration: BoxDecoration(
                color: AppColors.textMuted,
                borderRadius: BorderRadius.circular(Dimens.radius2),
              ),
            ),
            const SizedBox(height: Dimens.pad16),
            ListTile(
              leading: const Icon(Icons.edit_rounded, color: AppColors.primary),
              title: const Text(AppStrings.rename),
              onTap: () {
                Navigator.pop(ctx);
                _showRenameDialog(context, watchlistId, currentName);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_rounded,
                color: AppColors.lossRed,
              ),
              title: const Text(
                AppStrings.delete,
                style: TextStyle(color: AppColors.lossRed),
              ),
              onTap: () {
                Navigator.pop(ctx);
                _showDeleteConfirmation(context, watchlistId, currentName);
              },
            ),
            const SizedBox(height: Dimens.pad8),
          ],
        ),
      ),
    );
  }

  void _showRenameDialog(
    BuildContext context,
    String watchlistId,
    String currentName,
  ) {
    final controller = TextEditingController(text: currentName);
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
              final name = controller.text.trim();
              if (name.isNotEmpty) {
                context.read<WatchlistProvider>().renameWatchlist(
                  watchlistId,
                  name,
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

  void _showDeleteConfirmation(
    BuildContext context,
    String watchlistId,
    String name,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text(AppStrings.deleteWatchlistTitle),
        content: Text(AppStrings.deleteWatchlistConfirmMsg(name)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text(AppStrings.cancel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.lossRed),
            onPressed: () {
              context.read<WatchlistProvider>().deleteWatchlist(watchlistId);
              Navigator.pop(ctx);
            },
            child: const Text(AppStrings.delete),
          ),
        ],
      ),
    );
  }
}

class _WatchlistCard extends StatelessWidget {
  final String name;
  final int stockCount;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const _WatchlistCard({
    required this.name,
    required this.stockCount,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: Dimens.pad16,
        vertical: Dimens.pad6,
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(Dimens.radius12),
        child: Padding(
          padding: const EdgeInsets.all(Dimens.pad16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(Dimens.pad10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(Dimens.radius10),
                ),
                child: const Icon(
                  Icons.bookmark_rounded,
                  color: AppColors.primary,
                  size: Dimens.icon22,
                ),
              ),
              const SizedBox(width: Dimens.pad14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: Dimens.pad4),
                    Text(
                      AppStrings.stockCountLabel(stockCount),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppColors.textMuted,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
