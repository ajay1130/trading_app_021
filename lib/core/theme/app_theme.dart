import 'package:trading_app_021/util/exports.dart';

/// App-wide color constants for a premium dark trading theme.
class AppColors {
  AppColors._();

  // ── Backgrounds ──
  static const Color scaffoldBg = Color(0xFF0A0E17);
  static const Color cardBg = Color(0xFF111827);
  static const Color cardBgElevated = Color(0xFF1A2332);
  static const Color surfaceBg = Color(0xFF0F1623);

  // ── Accent ──
  static const Color primary = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primaryLight = Color(0xFF60A5FA);

  // ── Profit / Loss ──
  static const Color profitGreen = Color(0xFF00C853);
  static const Color profitGreenBg = Color(0x1A00C853);
  static const Color lossRed = Color(0xFFFF1744);
  static const Color lossRedBg = Color(0x1AFF1744);

  // ── Flash colors (for price tick animations) ──
  static const Color flashGreen = Color(0x3300C853);
  static const Color flashRed = Color(0x33FF1744);

  // ── Text ──
  static const Color textPrimary = Color(0xFFF1F5F9);
  static const Color textSecondary = Color(0xFF94A3B8);
  static const Color textMuted = Color(0xFF64748B);

  // ── Borders ──
  static const Color border = Color(0xFF1E293B);
  static const Color borderLight = Color(0xFF334155);

  // ── Buy / Sell ──
  static const Color buyGreen = Color(0xFF00C853);
  static const Color sellRed = Color(0xFFFF1744);
}

/// Premium dark theme for the trading app.
class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.interTextTheme(
      ThemeData.dark().textTheme,
    );

    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldBg,
      primaryColor: AppColors.primary,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: AppColors.cardBg,
        error: AppColors.lossRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: AppColors.textPrimary,
        onError: Colors.white,
      ),
      textTheme: baseTextTheme.copyWith(
        headlineLarge: baseTextTheme.headlineLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w700,
        ),
        headlineMedium: baseTextTheme.headlineMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleLarge: baseTextTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: baseTextTheme.titleMedium?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: baseTextTheme.bodyLarge?.copyWith(
          color: AppColors.textPrimary,
        ),
        bodyMedium: baseTextTheme.bodyMedium?.copyWith(
          color: AppColors.textSecondary,
        ),
        bodySmall: baseTextTheme.bodySmall?.copyWith(
          color: AppColors.textMuted,
        ),
        labelLarge: baseTextTheme.labelLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w600,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: Dimens.font20,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius12),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: Dimens.pad16,
          vertical: Dimens.pad6,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceBg,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.cardBgElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: const BorderSide(color: AppColors.lossRed),
        ),
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        hintStyle: const TextStyle(color: AppColors.textMuted),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Dimens.pad16,
          vertical: Dimens.pad14,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(
            horizontal: Dimens.pad24,
            vertical: Dimens.pad14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Dimens.radius10),
          ),
          textStyle: GoogleFonts.inter(
            fontSize: Dimens.font16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius16),
        ),
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimens.radius20),
          ),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.border,
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.cardBgElevated,
        contentTextStyle: GoogleFonts.inter(color: AppColors.textPrimary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
