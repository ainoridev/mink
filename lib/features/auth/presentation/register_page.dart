import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/features/auth/presentation/email_confirmation_page.dart";

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final supabase = ref.watch(supabaseClientProvider);

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
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Introduce tu correo";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Introduce la contraseña";
                    }
                    if (value.length < 6) {
                      return "Mínimo 6 caracteres";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _acceptedPolicy,
                      onChanged: _loading
                          ? null
                          : (value) => setState(
                              () => _acceptedPolicy = value ?? false,
                            ),
                    ),
                    const Text("Acepto la política"),
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
                                const SnackBar(
                                  content: Text(
                                    "Este email ya está registrado. Inicia sesión.",
                                  ),
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
                              const SnackBar(
                                content: Text(
                                  "No se pudo completar la operación.",
                                ),
                              ),
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
                      : const Text("Registrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
