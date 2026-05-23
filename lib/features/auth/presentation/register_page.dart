import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";
import "package:url_launcher/url_launcher.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/features/auth/presentation/email_confirmation_page.dart";
import "package:mink/l10n/app_localizations.dart";

const _privacyPolicyUrl = "https://www.mink-app.com/politica-privacidad";

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  bool _acceptedPolicy = false;
  bool _policyLinkOpened = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

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

  @override
  Widget build(BuildContext context) {
    final supabase = ref.watch(supabaseClientProvider);
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Align(
                  alignment: Alignment.centerLeft,
                  child: BackButton(),
                ),
                Center(
                  child: Image.asset("assets/images/mink_logo.png", width: 120),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  autocorrect: false,
                  decoration: InputDecoration(
                    labelText: l10n.emailLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.emailRequired;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: l10n.passwordLabel,
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return l10n.passwordRequired;
                    }
                    if (value.length < 6) {
                      return l10n.passwordMinLength;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: _acceptedPolicy,
                      onChanged: _loading || !_policyLinkOpened
                          ? null
                          : (value) => setState(
                              () => _acceptedPolicy = value ?? false,
                            ),
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
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loading || !_acceptedPolicy
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          setState(() => _loading = true);
                          final messenger = ScaffoldMessenger.of(context);
                          try {
                            final response = await supabase.auth.signUp(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            );
                            if (!context.mounted) {
                              return;
                            }
                            if (response.user?.identities?.isEmpty ?? true) {
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(l10n.emailAlreadyRegistered),
                                ),
                              );
                              return;
                            }
                            Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const EmailConfirmationPage(),
                              ),
                            );
                          } on AuthException catch (e) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(e.message)),
                            );
                          } catch (_) {
                            messenger.showSnackBar(
                              SnackBar(content: Text(l10n.operationFailed)),
                            );
                          } finally {
                            if (mounted) {
                              setState(() => _loading = false);
                            }
                          }
                        },
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.register),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
