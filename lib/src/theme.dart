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
}

ThemeData buildAppTheme() {
  final base = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.white,
    colorScheme: const ColorScheme.light(
      primary: AppColors.teal,
      onPrimary: AppColors.white,
      secondary: AppColors.sky,
      onSecondary: AppColors.deep,
      tertiary: AppColors.orange,
      onTertiary: AppColors.white,
      surface: AppColors.white,
      onSurface: AppColors.deep,
      error: AppColors.orange,
    ),
  );

  final text = GoogleFonts.nunitoTextTheme(base.textTheme).apply(
    bodyColor: AppColors.deep,
    displayColor: AppColors.deep,
  );

  return base.copyWith(
    textTheme: text,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.white,
      foregroundColor: AppColors.deep,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
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
        foregroundColor: AppColors.teal,
        minimumSize: const Size.fromHeight(54),
        side: const BorderSide(color: AppColors.teal, width: 1.6),
        shape: const StadiumBorder(),
        textStyle: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: AppColors.white,
      indicatorColor: AppColors.sky.withValues(alpha: 0.55),
      labelTextStyle: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return text.labelMedium?.copyWith(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
          color: selected ? AppColors.teal : AppColors.deep.withValues(alpha: 0.55),
        );
      }),
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final selected = states.contains(WidgetState.selected);
        return IconThemeData(
          color: selected ? AppColors.teal : AppColors.deep.withValues(alpha: 0.45),
        );
      }),
    ),
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.white;
        return AppColors.white;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) return AppColors.teal;
        return AppColors.line;
      }),
    ),
  );
}
