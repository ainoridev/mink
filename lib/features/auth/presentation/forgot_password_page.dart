import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/l10n/app_localizations.dart";

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    final navigator = Navigator.of(context);
    final l10n = AppLocalizations.of(context)!;
    final supabase = ref.read(supabaseClientProvider);
    try {
      await supabase.auth.resetPasswordForEmail(_emailController.text.trim());
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.resetPasswordEmailSent)),
      );
      navigator.pop();
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
                Text(
                  l10n.forgotPasswordTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.forgotPasswordDescription,
                  textAlign: TextAlign.center,
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
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _loading ? null : _sendResetLink,
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.sendResetLink),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
