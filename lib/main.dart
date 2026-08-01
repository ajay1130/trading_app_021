import 'package:trading_app_021/util/exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Use bundled Inter fonts; do not fetch from fonts.gstatic.com at runtime.
  GoogleFonts.config.allowRuntimeFetching = false;

  // Initialize persistence before providers read from it.
  await PersistenceService.instance.init();

  runApp(const TradingApp());
}

/// Root widget. Wraps the app in [MultiProvider] for state management.
class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => MarketDataProvider()),
        ChangeNotifierProvider(create: (_) => WatchlistProvider()),
        ChangeNotifierProvider(create: (_) => HoldingsProvider()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) => MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeProvider.mode,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
