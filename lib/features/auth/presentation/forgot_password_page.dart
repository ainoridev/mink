import "package:flutter/material.dart";

import "package:mink/l10n/app_localizations.dart";

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: Text(l10n.forgotPasswordTitle),
      ),
    );
  }
}
