import "dart:async";

import "package:app_links/app_links.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:mink/core/navigation/app_navigator.dart";
import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/features/auth/presentation/login_page.dart";
import "package:mink/features/auth/presentation/reset_password_page.dart";
import "package:mink/features/auth/presentation/terms_acceptance_page.dart";
import "package:mink/features/shell/presentation/main_shell.dart";

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
  bool _termsAccepted = false;
  late final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _appLinks = AppLinks();
    _linkSubscription = _appLinks.uriLinkStream.listen(_handleDeepLink);
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> _handleDeepLink(Uri uri) async {
    if (uri.scheme != "com.mink.app") {
      return;
    }

    final isRecovery =
        uri.host == "reset-callback" ||
        uri.queryParameters["type"] == "recovery" ||
        uri.host != "login-callback";

    final supabase = ref.read(supabaseClientProvider);
    await supabase.auth.getSessionFromUrl(uri);

    if (isRecovery) {
      rootNavigatorKey.currentState?.push<void>(
        MaterialPageRoute<void>(builder: (_) => const ResetPasswordPage()),
      );
    }
  }

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

      final termsAccepted = profile?["terms_accepted_at"] != null;

      if (!mounted || _activeUserId != userId) {
        return;
      }

      setState(() {
        _termsAccepted = termsAccepted;
      });
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
      _termsAccepted = false;
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

        if (!_termsAccepted) {
          return TermsAcceptancePage(
            userId: userId,
            onTermsAccepted: () => _ensureTermsAccepted(userId),
          );
        }

        return const MainShell();
      },
    );
  }
}
