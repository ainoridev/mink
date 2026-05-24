import "package:flutter/material.dart";

import "package:mink/core/currency/currency_icon.dart";
import "package:mink/core/currency/currency_type.dart";
import "package:mink/core/theme/app_colors.dart";
import "package:mink/core/theme/app_fonts.dart";

/// Chip con icono y cantidad de una moneda (p. ej. saldo en cabecera).
class CurrencyBalanceChip extends StatelessWidget {
  const CurrencyBalanceChip({
    required this.type,
    required this.amount,
    super.key,
    this.label,
  });

  final CurrencyType type;
  final int amount;

  /// Texto opcional tras la cantidad (p. ej. «monedas»).
  final String? label;

  @override
  Widget build(BuildContext context) {
    final background = switch (type) {
      CurrencyType.coins => AppColors.coinChipBackground,
      CurrencyType.diamonds => AppColors.diamondChipBackground,
    };
    final textColor = switch (type) {
      CurrencyType.coins => Theme.of(context).colorScheme.primary,
      CurrencyType.diamonds => AppColors.diamondBlue,
    };

    final amountText = label == null ? "$amount" : "$amount $label";

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CurrencyIcon(type: type),
          const SizedBox(width: 8),
          Text(
            amountText,
            style: TextStyle(
              fontFamily: AppFonts.fredoka,
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
