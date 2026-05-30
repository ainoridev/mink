import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:url_launcher/url_launcher.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/l10n/app_localizations.dart";

const _privacyPolicyUrl = "https://www.mink-app.com/politica-privacidad";

class TermsAcceptancePage extends ConsumerStatefulWidget {
  const TermsAcceptancePage({
    required this.userId,
    required this.onTermsAccepted,
    super.key,
  });

  final String userId;
  final VoidCallback onTermsAccepted;

  @override
  ConsumerState<TermsAcceptancePage> createState() =>
      _TermsAcceptancePageState();
}

class _TermsAcceptancePageState extends ConsumerState<TermsAcceptancePage> {
  bool _loading = false;
  bool _acceptedPolicy = false;
  bool _policyLinkOpened = false;

  Future<void> _openPrivacyPolicy() async {
    if (!_policyLinkOpened) {
      setState(() => _policyLinkOpened = true);
    }
    final launched = await launchUrl(
      Uri.parse(_privacyPolicyUrl),
      mode: LaunchMode.externalApplication,
    );
    if (!launched && mounted) {
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.operationFailed)));
    }
  }

  Future<void> _acceptAndContinue() async {
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase
          .from("profiles")
          .update({
            "terms_accepted_at": DateTime.now().toUtc().toIso8601String(),
          })
          .eq("user_id", widget.userId);
      widget.onTermsAccepted();
    } on AuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.operationFailed)));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  Future<void> _signOut() async {
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    final l10n = AppLocalizations.of(context)!;
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.auth.signOut();
    } on AuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(SnackBar(content: Text(l10n.operationFailed)));
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Image.asset("assets/images/mink_logo.png", width: 120),
              ),
              const SizedBox(height: 32),
              Text(
                l10n.termsAcceptanceDescription,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: _acceptedPolicy,
                    onChanged: _loading || !_policyLinkOpened
                        ? null
                        : (value) =>
                              setState(() => _acceptedPolicy = value ?? false),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: _loading ? null : _openPrivacyPolicy,
                      child: Text(
                        l10n.acceptPolicy,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _loading || !_acceptedPolicy
                    ? null
                    : _acceptAndContinue,
                child: _loading
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.acceptAndContinue),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _loading ? null : _signOut,
                child: Text(l10n.signOut),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
