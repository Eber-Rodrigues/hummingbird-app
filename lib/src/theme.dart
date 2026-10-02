import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const white = Color(0xFFFFFFFF);
  static const sky = Color(0xFF8ECAE6);
  static const teal = Color(0xFF219EBC);
  static const deep = Color(0xFF023047);
  static const amber = Color(0xFFFFB703);
  static const orange = Color(0xFFFB8500);
  static const mist = Color(0xFFF3F7FA);
  static const line = Color(0xFFD7E4EC);
  static const deepCard = Color(0xFF0A4D68);
  static const deepLine = Color(0xFF3D8BA8);
  static const deepBar = Color(0xFF012636);
}

class AppSurfaces extends ThemeExtension<AppSurfaces> {
  const AppSurfaces({required this.card, required this.muted, required this.line, required this.bar});

  final Color card;
  final Color muted;
  final Color line;
  final Color bar;

  @override
  AppSurfaces copyWith({Color? card, Color? muted, Color? line, Color? bar}) {
    return AppSurfaces(
      card: card ?? this.card,
      muted: muted ?? this.muted,
      line: line ?? this.line,
      bar: bar ?? this.bar,
    );
  }

  @override
  AppSurfaces lerp(ThemeExtension<AppSurfaces>? other, double t) {
    if (other is! AppSurfaces) return this;
    return AppSurfaces(
      card: Color.lerp(card, other.card, t)!,
      muted: Color.lerp(muted, other.muted, t)!,
      line: Color.lerp(line, other.line, t)!,
      bar: Color.lerp(bar, other.bar, t)!,
    );
  }
}

Color appCard(BuildContext context) => Theme.of(context).extension<AppSurfaces>()!.card;

Color appMuted(BuildContext context) => Theme.of(context).extension<AppSurfaces>()!.muted;

Color appLine(BuildContext context) => Theme.of(context).extension<AppSurfaces>()!.line;

ThemeData buildAppTheme(Brightness brightness) {
  final dark = brightness == Brightness.dark;
  final onSurface = dark ? AppColors.white : AppColors.deep;
  final surface = dark ? AppColors.deep : AppColors.white;
  final card = dark ? AppColors.deepCard : AppColors.mist;
  final line = dark ? AppColors.deepLine : AppColors.line;
  final muted = dark ? AppColors.sky : AppColors.deep.withValues(alpha: 0.62);
  final bar = dark ? AppColors.deepBar : AppColors.white;

  final base = ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: surface,
    colorScheme: ColorScheme(
      brightness: brightness,
      primary: AppColors.teal,
      onPrimary: AppColors.white,
      secondary: AppColors.sky,
      onSecondary: AppColors.deep,
      tertiary: AppColors.orange,
      onTertiary: AppColors.white,
      error: AppColors.orange,
      onError: AppColors.white,
      surface: surface,
      onSurface: onSurface,
    ),
  );

  final text = GoogleFonts.nunitoTextTheme(base.textTheme).apply(
    bodyColor: onSurface,
    displayColor: onSurface,
  );

  return base.copyWith(
    textTheme: text,
    extensions: [
      AppSurfaces(card: card, muted: muted, line: line, bar: bar),
    ],
    appBarTheme: AppBarTheme(
      backgroundColor: surface,
      foregroundColor: onSurface,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w800, color: onSurface),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: AppColors.teal,
        foregroundColor: AppColors.white,
        minimumSize: const Size.fromHeight(54),
        shape: const StadiumBorder(),
        textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: dark ? AppColors.sky : AppColors.teal,
        minimumSize: const Size.fromHeight(54),
        side: BorderSide(color: dark ? AppColors.sky : AppColors.teal, width: 1.6),
        shape: const StadiumBorder(),
        textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: dark ? AppColors.sky : AppColors.teal),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: bar,
      indicatorColor: AppColors.sky.withValues(alpha: dark ? 0.28 : 0.55),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.labelMedium?.copyWith(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? (dark ? AppColors.sky : AppColors.teal) : muted,
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? (dark ? AppColors.sky : AppColors.teal) : muted,
        );
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        return AppColors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.teal;
        return line;
      }),
    ),
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.teal,
      contentTextStyle: text.bodyMedium?.copyWith(color: AppColors.white, fontWeight: FontWeight.w700),
      behavior: SnackBarBehavior.floating,
    ),
    inputDecorationTheme: InputDecorationTheme(
      labelStyle: text.bodyMedium?.copyWith(color: muted),
      enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: line)),
      focusedBorder: const OutlineInputBorder(borderSide: BorderSide(color: AppColors.teal, width: 1.6)),
      border: OutlineInputBorder(borderSide: BorderSide(color: line)),
    ),
    dividerColor: line,
  );
}
