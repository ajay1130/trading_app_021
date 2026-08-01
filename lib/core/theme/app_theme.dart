import 'package:trading_app_021/util/exports.dart';

// ─── Theme-Varying Color Tokens ─────────────────────────────────────────────

/// Semantic colors that change between dark and light themes.
/// Access via `context.colors` extension.
class AppColorsExt extends ThemeExtension<AppColorsExt> {
  final Color scaffoldBg, cardBg, cardBgElevated, surfaceBg;
  final Color textPrimary, textSecondary, textMuted;
  final Color border, borderLight;

  const AppColorsExt({
    required this.scaffoldBg,
    required this.cardBg,
    required this.cardBgElevated,
    required this.surfaceBg,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderLight,
  });

  static const dark = AppColorsExt(
    scaffoldBg: Color(0xFF0A0E17),
    cardBg: Color(0xFF111827),
    cardBgElevated: Color(0xFF1A2332),
    surfaceBg: Color(0xFF0F1623),
    textPrimary: Color(0xFFF1F5F9),
    textSecondary: Color(0xFF94A3B8),
    textMuted: Color(0xFF64748B),
    border: Color(0xFF1E293B),
    borderLight: Color(0xFF334155),
  );

  static const light = AppColorsExt(
    scaffoldBg: Color(0xFFF8FAFC),
    cardBg: Color(0xFFFFFFFF),
    cardBgElevated: Color(0xFFF1F5F9),
    surfaceBg: Color(0xFFFFFFFF),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF475569),
    textMuted: Color(0xFF94A3B8),
    border: Color(0xFFE2E8F0),
    borderLight: Color(0xFFCBD5E1),
  );

  @override
  AppColorsExt copyWith() => this;

  @override
  AppColorsExt lerp(AppColorsExt? other, double t) {
    if (other is! AppColorsExt) return this;
    return AppColorsExt(
      scaffoldBg: Color.lerp(scaffoldBg, other.scaffoldBg, t)!,
      cardBg: Color.lerp(cardBg, other.cardBg, t)!,
      cardBgElevated: Color.lerp(cardBgElevated, other.cardBgElevated, t)!,
      surfaceBg: Color.lerp(surfaceBg, other.surfaceBg, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textMuted: Color.lerp(textMuted, other.textMuted, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderLight: Color.lerp(borderLight, other.borderLight, t)!,
    );
  }
}

/// Quick access: `context.colors.cardBg`, `context.colors.textPrimary`, etc.
extension AppColorsX on BuildContext {
  AppColorsExt get colors => Theme.of(this).extension<AppColorsExt>()!;
}

// ─── Static Colors (same in both themes) ────────────────────────────────────

/// Colors that don't change between dark/light (accents, profit/loss).
class AppColors {
  AppColors._();

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

  // ── Buy / Sell ──
  static const Color buyGreen = Color(0xFF00C853);
  static const Color sellRed = Color(0xFFFF1744);
}

// ─── Theme Builder ──────────────────────────────────────────────────────────

/// Builds dark and light [ThemeData] from a shared helper.
class AppTheme {
  AppTheme._();

  static ThemeData _build(AppColorsExt c, Brightness brightness) {
    final base =
        brightness == Brightness.dark ? ThemeData.dark() : ThemeData.light();
    final txt = GoogleFonts.interTextTheme(base.textTheme);

    return ThemeData(
      brightness: brightness,
      scaffoldBackgroundColor: c.scaffoldBg,
      primaryColor: AppColors.primary,
      extensions: [c],
      colorScheme: (brightness == Brightness.dark
              ? const ColorScheme.dark()
              : const ColorScheme.light())
          .copyWith(
        primary: AppColors.primary,
        secondary: AppColors.primaryLight,
        surface: c.cardBg,
        error: AppColors.lossRed,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: c.textPrimary,
        onError: Colors.white,
      ),
      textTheme: txt.copyWith(
        headlineLarge: txt.headlineLarge?.copyWith(
            color: c.textPrimary, fontWeight: FontWeight.w700),
        headlineMedium: txt.headlineMedium?.copyWith(
            color: c.textPrimary, fontWeight: FontWeight.w600),
        titleLarge: txt.titleLarge?.copyWith(
            color: c.textPrimary, fontWeight: FontWeight.w600),
        titleMedium: txt.titleMedium?.copyWith(
            color: c.textPrimary, fontWeight: FontWeight.w500),
        bodyLarge: txt.bodyLarge?.copyWith(color: c.textPrimary),
        bodyMedium: txt.bodyMedium?.copyWith(color: c.textSecondary),
        bodySmall: txt.bodySmall?.copyWith(color: c.textMuted),
        labelLarge: txt.labelLarge?.copyWith(
            color: c.textPrimary, fontWeight: FontWeight.w600),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: c.scaffoldBg,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.inter(
          fontSize: Dimens.font20,
          fontWeight: FontWeight.w700,
          color: c.textPrimary,
        ),
        iconTheme: IconThemeData(color: c.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: c.cardBg,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius12),
          side: BorderSide(color: c.border, width: 1),
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: Dimens.pad16,
          vertical: Dimens.pad6,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: c.surfaceBg,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: c.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.cardBgElevated,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: BorderSide(color: c.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: BorderSide(color: c.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(Dimens.radius10),
          borderSide: const BorderSide(color: AppColors.lossRed),
        ),
        labelStyle: TextStyle(color: c.textSecondary),
        hintStyle: TextStyle(color: c.textMuted),
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
        backgroundColor: c.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius16),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.cardBg,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(Dimens.radius20),
          ),
        ),
      ),
      dividerTheme: DividerThemeData(
        color: c.border,
        thickness: 1,
        space: 0,
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.cardBgElevated,
        contentTextStyle: GoogleFonts.inter(color: c.textPrimary),
        actionTextColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius8),
        ),
        behavior: SnackBarBehavior.floating,
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.cardBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimens.radius12),
        ),
      ),
    );
  }

  static ThemeData get darkTheme => _build(AppColorsExt.dark, Brightness.dark);
  static ThemeData get lightTheme =>
      _build(AppColorsExt.light, Brightness.light);
}
