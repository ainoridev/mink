import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

import "package:mink/app.dart";

void main() {
  testWidgets("Home counter increments", (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MinkApp()),
    );

    expect(find.text("0"), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text("1"), findsOneWidget);
  });
}
