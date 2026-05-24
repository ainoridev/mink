import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:phosphor_flutter/phosphor_flutter.dart";

import "package:mink/core/currency/currency_icon.dart";
import "package:mink/core/currency/currency_type.dart";
import "package:mink/core/theme/app_colors.dart";

void main() {
  testWidgets("CurrencyIcon muestra icono de oro", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CurrencyIcon(type: CurrencyType.coins),
        ),
      ),
    );

    expect(find.byIcon(PhosphorIconsFill.coin), findsOneWidget);
    final icon = tester.widget<Icon>(find.byIcon(PhosphorIconsFill.coin));
    expect(icon.color, AppColors.coinGold);
  });

  testWidgets("CurrencyIcon muestra icono de diamante", (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: CurrencyIcon(type: CurrencyType.diamonds),
        ),
      ),
    );

    expect(find.byIcon(PhosphorIconsFill.diamond), findsOneWidget);
    final icon = tester.widget<Icon>(find.byIcon(PhosphorIconsFill.diamond));
    expect(icon.color, AppColors.diamondBlue);
  });
}
