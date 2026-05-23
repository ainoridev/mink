import "package:flutter/material.dart";

import "package:mink/l10n/app_localizations.dart";

class EmailConfirmationPage extends StatelessWidget {
  const EmailConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/mink_logo.png", width: 120),
                const SizedBox(height: 32),
                Text(
                  l10n.checkYourEmail,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(l10n.confirmationSent, textAlign: TextAlign.center),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: Text(l10n.alreadyConfirmed),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
