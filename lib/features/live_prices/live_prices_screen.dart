import 'package:trading_app_021/util/exports.dart';

/// Live market overview screen showing all 10 stocks with live prices.
class LivePricesScreen extends StatefulWidget {
  const LivePricesScreen({super.key});

  @override
  State<LivePricesScreen> createState() => _LivePricesScreenState();
}

class _LivePricesScreenState extends State<LivePricesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _onTickRateSelected(int ms) {
    context.read<MarketDataProvider>().setBatchIntervalMs(ms);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppStrings.tickRateSnack(ms)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Scaffold(
      backgroundColor: c.scaffoldBg,
      appBar: AppBar(
        backgroundColor: c.scaffoldBg,
        elevation: 0,
        title: Row(
          children: [
            Text(
              AppStrings.marketOverview,
              style: TextStyle(
                color: c.textPrimary,
                fontSize: Dimens.font20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: Dimens.pad8),
            FadeTransition(
              opacity: _pulseAnimation,
              child: Container(
                width: Dimens.pad8,
                height: Dimens.pad8,
                decoration: const BoxDecoration(
                  color: AppColors.profitGreen,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, tp, _) => IconButton(
              icon: Icon(tp.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
              onPressed: tp.toggle,
              tooltip: 'Toggle theme',
            ),
          ),
          Selector<MarketDataProvider, int>(
            selector: (_, provider) => provider.batchIntervalMs,
            builder: (context, intervalMs, _) {
              final c = context.colors;
              return PopupMenuButton<int>(
                icon: const Icon(Icons.speed_rounded, size: Dimens.size22),
                tooltip: AppStrings.tickRateTooltip,
                initialValue: intervalMs,
                onSelected: _onTickRateSelected,
                itemBuilder: (_) => [
                  PopupMenuItem<int>(
                    enabled: false,
                    child: Text(
                      AppStrings.tickRate,
                      style: TextStyle(
                        color: c.textMuted,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  ...kTickIntervalPresetsMs.map(
                    (ms) => CheckedPopupMenuItem<int>(
                      value: ms,
                      checked: ms == intervalMs,
                      child: Text(AppStrings.tickIntervalLabel(ms)),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(
          vertical: Dimens.pad8,
          horizontal: Dimens.pad0,
        ),
        itemCount: kStocks.length,
        itemBuilder: (context, index) {
          final stock = kStocks[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: Dimens.pad4),
            child: PriceTile(
              symbol: stock.symbol,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        BuySellTicketScreen(symbol: stock.symbol),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
