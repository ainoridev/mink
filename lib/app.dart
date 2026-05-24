import "package:flutter/material.dart";
import "package:flutter_localizations/flutter_localizations.dart";

import "package:mink/core/theme/app_theme.dart";
import "package:mink/features/auth/presentation/auth_gate.dart";
import "package:mink/l10n/app_localizations.dart";

/// Root widget: keep thin; composition and routing evolve here.
class MinkApp extends StatelessWidget {
  const MinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mink",
      theme: AppTheme.light(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale("en")],
      home: const AuthGate(),
    );
  }
}
