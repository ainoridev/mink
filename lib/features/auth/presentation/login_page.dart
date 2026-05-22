import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "package:mink/features/auth/presentation/auth_providers.dart";
import "package:mink/features/auth/presentation/forgot_password_page.dart";
import "package:mink/features/auth/presentation/register_page.dart";

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit(Future<void> Function() action) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await action();
    } on AuthException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text("No se pudo completar la operación.")),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
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
                Center(
                  child: Image.asset(
                    "assets/images/mink_logo.png",
                    width: 120,
                  ),
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
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _loading
                        ? null
                        : () => Navigator.push<void>(
                              context,
                              MaterialPageRoute<void>(
                                builder: (_) => const ForgotPasswordPage(),
                              ),
                            ),
                    child: const Text("¿Olvidaste la contraseña?"),
                  ),
                ),
                const SizedBox(height: 8),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text("o"),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 16),
                const OutlinedButton(
                  onPressed: null,
                  child: Text("Login con Google"),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => Navigator.push<void>(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => const RegisterPage(),
                            ),
                          ),
                  child: const Text("No tengo usuario"),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _loading
                      ? null
                      : () => _submit(
                            () => supabase.auth.signInWithPassword(
                              email: _emailController.text.trim(),
                              password: _passwordController.text,
                            ),
                          ),
                  child: _loading
                      ? const SizedBox(
                          height: 22,
                          width: 22,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Entrar"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
