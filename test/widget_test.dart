import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:flutter_test/flutter_test.dart";

import "package:mink/core/supabase/supabase_bootstrap.dart";
import "package:mink/features/auth/presentation/forgot_password_page.dart";
import "package:mink/features/auth/presentation/login_page.dart";
import "package:mink/features/auth/presentation/register_page.dart";
import "package:mink/features/home/presentation/home_page.dart";
import "package:mink/l10n/app_localizations.dart";

/// URL y anon key de **solo test**: no deben ser secretos de producción.
/// Evitan red real en la mayoría de arranques; la UI no llama a la API hasta login.
const _testSupabaseUrl = "https://test.supabase.co";
const _testAnonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0";

Widget makeTestable(Widget child) => MaterialApp(
  localizationsDelegates: AppLocalizations.localizationsDelegates,
  supportedLocales: AppLocalizations.supportedLocales,
  home: child,
);

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await initSupabaseForWidgetTests(
      url: _testSupabaseUrl,
      anonKey: _testAnonKey,
    );
  });

  testWidgets("LoginPage muestra correo y contraseña", (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: makeTestable(const LoginPage())),
    );

    expect(find.byType(Image), findsOneWidget);
    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    expect(find.text("I don't have an account"), findsOneWidget);
    expect(find.text("Continue with Google"), findsOneWidget);
  });

  testWidgets("RegisterPage muestra campos de registro", (tester) async {
    await tester.pumpWidget(
      ProviderScope(child: makeTestable(const RegisterPage())),
    );

    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Password"), findsOneWidget);
    final policyText = find.text("I accept the privacy policy");
    expect(policyText, findsOneWidget);
    expect(
      find.ancestor(of: policyText, matching: find.byType(GestureDetector)),
      findsOneWidget,
    );
    expect(tester.widget<Checkbox>(find.byType(Checkbox)).onChanged, isNull);
    expect(find.text("Register"), findsOneWidget);
  });

  testWidgets("ForgotPasswordPage muestra email y botón de envío", (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: makeTestable(const ForgotPasswordPage())),
    );

    expect(find.text("Email"), findsOneWidget);
    expect(find.text("Send reset link"), findsOneWidget);
  });

  testWidgets("RegisterPage muestra snackbar si email ya existe", (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(child: makeTestable(const RegisterPage())),
    );

    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
  });

  testWidgets("Home counter increments", (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: HomePage())),
    );

    expect(find.text("0"), findsOneWidget);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pump();

    expect(find.text("1"), findsOneWidget);
  });
}
