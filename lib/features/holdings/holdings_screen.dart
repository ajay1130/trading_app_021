import 'package:trading_app_021/util/exports.dart';

/// Sorting options for the holdings list.
enum HoldingsSortBy { pnl, symbol, currentValue }

/// Portfolio view showing all currently held stocks with live P&L.
class HoldingsScreen extends StatefulWidget {
  const HoldingsScreen({super.key});

  @override
  State<HoldingsScreen> createState() => _HoldingsScreenState();
}

class _HoldingsScreenState extends State<HoldingsScreen> {
  HoldingsSortBy _sortBy = HoldingsSortBy.pnl;

  @override
  Widget build(BuildContext context) {
    return Consumer2<HoldingsProvider, MarketDataProvider>(
      builder: (context, holdingsProvider, marketProvider, _) {
        final holdings = holdingsProvider.holdings;
        final hasHoldings = holdings.isNotEmpty;

        return Scaffold(
          appBar: AppBar(
            title: const Text(AppStrings.holdings),
            actions: [
              if (hasHoldings)
                PopupMenuButton<HoldingsSortBy>(
                  icon: const Icon(Icons.sort_rounded, size: 22),
                  tooltip: AppStrings.sortBy,
                  onSelected: (value) => setState(() => _sortBy = value),
                  itemBuilder: (_) => [
                    _sortMenuItem(
                      HoldingsSortBy.pnl,
                      AppStrings.sortPnl,
                      Icons.trending_up,
                    ),
                    _sortMenuItem(
                      HoldingsSortBy.symbol,
                      AppStrings.sortSymbol,
                      Icons.sort_by_alpha,
                    ),
                    _sortMenuItem(
                      HoldingsSortBy.currentValue,
                      AppStrings.sortCurrentValue,
                      Icons.currency_rupee,
                    ),
                  ],
                ),
            ],
          ),
          body: hasHoldings
              ? _buildHoldingsList(holdings, marketProvider)
              : const EmptyStateWidget(
                  icon: Icons.account_balance_wallet_rounded,
                  title: AppStrings.noHoldingsTitle,
                  subtitle: AppStrings.noHoldingsSubtitle,
                ),
        );
      },
    );
  }

  Widget _buildHoldingsList(
    List<Holding> holdings,
    MarketDataProvider marketProvider,
  ) {
    final sorted = List<Holding>.from(holdings);
    _sortHoldings(sorted, marketProvider);

    return Column(
      children: [
        const PortfolioSummaryCard(),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: Dimens.pad16),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              final holding = sorted[index];
              return HoldingRow(
                holding: holding,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          BuySellTicketScreen(symbol: holding.symbol),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }

  void _sortHoldings(List<Holding> holdings, MarketDataProvider market) {
    switch (_sortBy) {
      case HoldingsSortBy.pnl:
        holdings.sort((a, b) {
          final ltpA = market.getPrice(a.symbol)?.ltpPaise ?? a.avgCostPaise;
          final ltpB = market.getPrice(b.symbol)?.ltpPaise ?? b.avgCostPaise;
          return b.pnlPaise(ltpB).compareTo(a.pnlPaise(ltpA));
        });
      case HoldingsSortBy.symbol:
        holdings.sort((a, b) => a.symbol.compareTo(b.symbol));
      case HoldingsSortBy.currentValue:
        holdings.sort((a, b) {
          final ltpA = market.getPrice(a.symbol)?.ltpPaise ?? a.avgCostPaise;
          final ltpB = market.getPrice(b.symbol)?.ltpPaise ?? b.avgCostPaise;
          return b.currentValuePaise(ltpB).compareTo(a.currentValuePaise(ltpA));
        });
    }
  }

  PopupMenuItem<HoldingsSortBy> _sortMenuItem(
    HoldingsSortBy value,
    String label,
    IconData icon,
  ) {
    final c = context.colors;
    final isSelected = _sortBy == value;
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppColors.primary : c.textSecondary,
          ),
          const SizedBox(width: Dimens.pad10),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? AppColors.primary : c.textPrimary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
          const Spacer(),
          if (isSelected)
            const Icon(Icons.check, size: Dimens.size16, color: AppColors.primary),
        ],
      ),
    );
  }
}
