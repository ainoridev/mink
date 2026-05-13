import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/features/auth/presentation/login_page.dart";
import "package:mink/features/home/presentation/home_page.dart";

/// Enruta entre sesión activa y pantalla de login según Supabase Auth.
class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      data: (state) =>
          state.session != null ? const HomePage() : const LoginPage(),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, _) => Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              "Error al comprobar la sesión: $error",
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
