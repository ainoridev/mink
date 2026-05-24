import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/features/auth/presentation/login_page.dart";
import "package:mink/features/home/presentation/home_page.dart";

/// Enruta entre sesión activa y pantalla de login según Supabase Auth.
class AuthGate extends ConsumerStatefulWidget {
  const AuthGate({super.key});

  @override
  ConsumerState<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends ConsumerState<AuthGate> {
  String? _activeUserId;
  bool _profileCheckDone = false;
  bool _profileCheckInFlight = false;

  Widget _loadingScreen() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Image.asset("assets/images/mink_logo.png", width: 160),
      ),
    );
  }

  Future<void> _ensureTermsAccepted(String userId) async {
    if (_profileCheckInFlight && _activeUserId == userId) {
      return;
    }

    setState(() {
      _activeUserId = userId;
      _profileCheckInFlight = true;
      _profileCheckDone = false;
    });

    final supabase = ref.read(supabaseClientProvider);
    try {
      final profile = await supabase
          .from("profiles")
          .select("terms_accepted_at")
          .eq("user_id", userId)
          .maybeSingle();

      if (!mounted || _activeUserId != userId) {
        return;
      }

      if (profile != null && profile["terms_accepted_at"] == null) {
        await supabase
            .from("profiles")
            .update({
              "terms_accepted_at": DateTime.now().toUtc().toIso8601String(),
            })
            .eq("user_id", userId);
      }
    } finally {
      if (mounted && _activeUserId == userId) {
        setState(() {
          _profileCheckInFlight = false;
          _profileCheckDone = true;
        });
      }
    }
  }

  void _resetProfileCheck() {
    setState(() {
      _activeUserId = null;
      _profileCheckDone = false;
      _profileCheckInFlight = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final authAsync = ref.watch(authStateProvider);

    return authAsync.when(
      loading: _loadingScreen,
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
      data: (state) {
        final session = state.session;
        if (session == null) {
          if (_activeUserId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _resetProfileCheck();
              }
            });
          }
          return const LoginPage();
        }

        final userId = session.user.id;
        if (_activeUserId != userId || !_profileCheckDone) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            _ensureTermsAccepted(userId);
          });
        }

        if (!_profileCheckDone) {
          return _loadingScreen();
        }

        return const HomePage();
      },
    );
  }
}
