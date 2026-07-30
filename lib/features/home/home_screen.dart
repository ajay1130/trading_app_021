import 'package:trading_app_021/util/exports.dart';

/// Main home screen with bottom navigation for the 4 features.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // Use IndexedStack to preserve state across tab switches,
  // so live prices stay current when navigating back.
  static const List<Widget> _screens = [
    LivePricesScreen(),
    WatchlistScreen(),
    HoldingsScreen(),
    OrderHistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NavigationProvider>(
        builder: (context, nav, child) {
          return IndexedStack(index: nav.currentIndex, children: _screens);
        },
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.border, width: 1)),
        ),
        child: Consumer<NavigationProvider>(
          builder: (context, nav, child) {
            return BottomNavigationBar(
              currentIndex: nav.currentIndex,
              onTap: (index) => nav.updateIndex(index),
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.candlestick_chart_rounded),
                  label: AppStrings.market,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.bookmark_rounded),
                  label: AppStrings.watchlist,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.account_balance_wallet_rounded),
                  label: AppStrings.holdings,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_rounded),
                  label: AppStrings.orders,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
