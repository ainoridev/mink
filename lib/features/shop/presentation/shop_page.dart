import "package:flutter/material.dart";

import "package:mink/core/currency/currency_balance_chip.dart";
import "package:mink/core/currency/currency_type.dart";

class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tienda"),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: CurrencyBalanceChip(
                    type: CurrencyType.coins,
                    amount: 340,
                    label: "monedas",
                  ),
                ),
                SizedBox(width: 12),
                CurrencyBalanceChip(
                  type: CurrencyType.diamonds,
                  amount: 15,
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text("Tienda"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
