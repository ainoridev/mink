import "package:flutter/material.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";

import "package:mink/core/currency/currency_type.dart";
import "package:mink/core/theme/app_colors.dart";

/// Icono de un tipo de moneda (oro o diamante).
class CurrencyIcon extends StatelessWidget {
  const CurrencyIcon({
    required this.type,
    super.key,
    this.size = 20,
  });

  final CurrencyType type;
  final double size;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (type) {
      CurrencyType.coins => (PhosphorIconsFill.coin, AppColors.coinGold),
      CurrencyType.diamonds => (PhosphorIconsFill.diamond, AppColors.diamondBlue),
    };

    return Icon(icon, size: size, color: color);
  }
}
