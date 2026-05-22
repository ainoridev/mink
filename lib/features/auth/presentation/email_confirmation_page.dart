import "package:flutter/material.dart";

class EmailConfirmationPage extends StatelessWidget {
  const EmailConfirmationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  "Revisa tu email",
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Te hemos enviado un enlace de confirmación. "
                  "Actívalo para poder iniciar sesión.",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                FilledButton(
                  onPressed: () =>
                      Navigator.of(context).popUntil((route) => route.isFirst),
                  child: const Text("Ya confirmé mi email"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
