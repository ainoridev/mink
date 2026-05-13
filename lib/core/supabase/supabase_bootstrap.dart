import "package:flutter/foundation.dart";
import "package:supabase_flutter/supabase_flutter.dart";

import "package:mink/core/config/env.dart";
import "package:mink/core/supabase/secure_gotrue_async_storage.dart";
import "package:mink/core/supabase/secure_supabase_local_storage.dart";

class _MemoryGotrueAsyncStorage extends GotrueAsyncStorage {
  final Map<String, String> _data = {};

  @override
  Future<String?> getItem({required String key}) async => _data[key];

  @override
  Future<void> removeItem({required String key}) async {
    _data.remove(key);
  }

  @override
  Future<void> setItem({required String key, required String value}) async {
    _data[key] = value;
  }
}

/// Inicializa el cliente Supabase antes de [runApp].
///
/// - Solo **anon key** en el cliente (nunca service role).
/// - **PKCE** para flujos que lo soporten.
/// - Sesión persistida de forma segura en nativo (véase [supabaseAuthLocalStorage]).
Future<void> initSupabase() async {
  final url = Env.supabaseUrl;
  final anonKey = Env.supabaseAnonKey;

  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    debug: kDebugMode,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      localStorage: supabaseAuthLocalStorage(url),
      pkceAsyncStorage: SecureGotrueAsyncStorage(),
      detectSessionInUri: true,
    ),
  );
}

/// Inicialización mínima para **tests de widget** (sin persistir sesión ni deep links).
Future<void> initSupabaseForWidgetTests({
  required String url,
  required String anonKey,
}) async {
  await Supabase.initialize(
    url: url,
    anonKey: anonKey,
    debug: false,
    authOptions: FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
      localStorage: const EmptyLocalStorage(),
      pkceAsyncStorage: _MemoryGotrueAsyncStorage(),
      detectSessionInUri: false,
    ),
  );
}
