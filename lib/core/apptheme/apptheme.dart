import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Appcolors {
  const Appcolors._();

  // ── Brand colors ────────────────────────────────────────────────────────
  static const Color primary = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF1976D2);
  static const Color accent = Color(0xFF1E88E5);

  // ── Status colors ─────────────────────────────────────────────────────��─
  static const Color warn = Color(0xFFDC2626);
  static const Color ok = Color(0xFF15803D);
  static const Color error = Color(0xFFEF4444);
  static const Color success = Color(0xFF10B981);
  static const Color info = Color(0xFF3B82F6);
  static const Color warning = Color(0xFFF59E0B);

  // ── Common status chip colors ─────────────────────────────────────────
  static const Color statusDraft = Color(0xFF9E9E9E);
  static const Color statusCancelled = Color(0xFF94A3B8);
}

@immutable
class AppColors extends ThemeExtension<AppColors> {
  final Color background;
  final Color card;
  final Color surfaceLight;
  final Color border;
  final Color textPrimary;
  final Color textSecondary;
  final Color textTertiary;

  const AppColors({
    required this.background,
    required this.card,
    required this.surfaceLight,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
    required this.textTertiary,
  });

  static const AppColors light = AppColors(
    background: Color(0xFFF4F7F6),
    card: Colors.white,
    surfaceLight: Color(0xFFF8FAFC),
    border: Color(0xFFE2E8F0),
    textPrimary: Color(0xFF0F172A),
    textSecondary: Color(0xFF64748B),
    textTertiary: Color(0xFF94A3B8),
  );

  static const AppColors dark = AppColors(
    background: Color(0xFF0E1116),
    card: Color(0xFF1A1F27),
    surfaceLight: Color(0xFF232A34),
    border: Color(0xFF2C333E),
    textPrimary: Color(0xFFE8EDF3),
    textSecondary: Color(0xFF9AA6B2),
    textTertiary: Color(0xFF6C7684),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? card,
    Color? surfaceLight,
    Color? border,
    Color? textPrimary,
    Color? textSecondary,
    Color? textTertiary,
  }) {
    return AppColors(
      background: background ?? this.background,
      card: card ?? this.card,
      surfaceLight: surfaceLight ?? this.surfaceLight,
      border: border ?? this.border,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textTertiary: textTertiary ?? this.textTertiary,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      card: Color.lerp(card, other.card, t)!,
      surfaceLight: Color.lerp(surfaceLight, other.surfaceLight, t)!,
      border: Color.lerp(border, other.border, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textTertiary: Color.lerp(textTertiary, other.textTertiary, t)!,
    );
  }
}

/// Convenient access to the app's semantic colors: `context.colors.card`.
extension AppColorsContext on BuildContext {
  AppColors get colors => Theme.of(this).extension<AppColors>()!;
}

/// Builds the light and dark [ThemeData] used by the root [MaterialApp].
class AppTheme {
  const AppTheme._();

  static ThemeData get light => _build(Brightness.light, AppColors.light);
  static ThemeData get dark => _build(Brightness.dark, AppColors.dark);

  static ThemeData _build(Brightness brightness, AppColors colors) {
    final ColorScheme scheme =
        ColorScheme.fromSeed(
          seedColor: Appcolors.primary,
          brightness: brightness,
        ).copyWith(
          primary: Appcolors.primary,
          secondary: Appcolors.accent,
          surface: colors.card,
          onSurface: colors.textPrimary,
          error: Appcolors.error,
          outline: colors.border,
        );

    final base = ThemeData(brightness: brightness, useMaterial3: true);

    return base.copyWith(
      colorScheme: scheme,
      extensions: <ThemeExtension<dynamic>>[colors],
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      dividerColor: colors.border,
      textTheme: GoogleFonts.poppinsTextTheme(
        base.textTheme,
      ).apply(bodyColor: colors.textPrimary, displayColor: colors.textPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        surfaceTintColor: colors.background,
        foregroundColor: colors.textPrimary,
        elevation: 0,
      ),
      cardColor: colors.card,
      dialogTheme: DialogThemeData(backgroundColor: colors.card),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: colors.card),
      drawerTheme: DrawerThemeData(backgroundColor: colors.card),
      iconTheme: IconThemeData(color: colors.textPrimary),
      popupMenuTheme: PopupMenuThemeData(color: colors.card),
    );
  }
}
