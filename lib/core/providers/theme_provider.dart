import 'package:trading_app_021/util/exports.dart';

/// Manages light/dark theme and persists across restarts.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode;

  ThemeProvider() : _mode = PersistenceService.instance.loadThemeMode();

  ThemeMode get mode => _mode;
  bool get isDark => _mode == ThemeMode.dark;

  void toggle() {
    _mode = isDark ? ThemeMode.light : ThemeMode.dark;
    PersistenceService.instance.saveThemeMode(_mode);
    notifyListeners();
  }
}
