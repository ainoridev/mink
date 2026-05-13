import "package:flutter/material.dart";

import "package:mink/features/auth/presentation/auth_gate.dart";

/// Root widget: keep thin; composition and routing evolve here.
class MinkApp extends StatelessWidget {
  const MinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Mink",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const AuthGate(),
    );
  }
}
