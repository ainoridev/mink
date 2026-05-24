import "package:flutter/material.dart";

import "package:mink/core/theme/app_fonts.dart";

abstract final class AppTheme {
  static const Color brandPrimary = Color(0xFFA79BFF);

  static ThemeData light() {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: brandPrimary),
      useMaterial3: true,
      fontFamily: AppFonts.fredoka,
    );

    return base.copyWith(
      textTheme: base.textTheme.apply(fontFamily: AppFonts.fredoka),
      primaryTextTheme: base.primaryTextTheme.apply(fontFamily: AppFonts.fredoka),
      appBarTheme: base.appBarTheme.copyWith(
        titleTextStyle: base.textTheme.titleLarge?.copyWith(
          fontFamily: AppFonts.fredoka,
        ),
      ),
      navigationBarTheme: base.navigationBarTheme.copyWith(
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final style = base.textTheme.labelMedium?.copyWith(
            fontFamily: AppFonts.fredoka,
          );
          if (states.contains(WidgetState.selected)) {
            return style?.copyWith(fontWeight: FontWeight.w600);
          }
          return style;
        }),
      ),
    );
  }
}
