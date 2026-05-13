import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Persistencia de sesión Supabase en **Keychain / Keystore** (iOS, Android, desktop).
///
/// En **web** no se usa: el almacenamiento “seguro” del plugin es limitado; usa
/// [SharedPreferencesLocalStorage] vía [supabaseStorageForPlatform].
class SecureSupabaseLocalStorage extends LocalStorage {
  SecureSupabaseLocalStorage({required this.persistSessionKey});

  final String persistSessionKey;

  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> accessToken() => _storage.read(key: persistSessionKey);

  @override
  Future<bool> hasAccessToken() async {
    final token = await _storage.read(key: persistSessionKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<void> persistSession(String persistSessionString) =>
      _storage.write(key: persistSessionKey, value: persistSessionString);

  @override
  Future<void> removePersistedSession() =>
      _storage.delete(key: persistSessionKey);
}

/// Sesión: almacenamiento seguro en nativo; en web, [SharedPreferencesLocalStorage] de Supabase.
LocalStorage supabaseAuthLocalStorage(String supabaseUrl) {
  final persistSessionKey =
      "sb-${Uri.parse(supabaseUrl).host.split(".").first}-auth-token";
  if (kIsWeb) {
    return SharedPreferencesLocalStorage(persistSessionKey: persistSessionKey);
  }
  return SecureSupabaseLocalStorage(persistSessionKey: persistSessionKey);
}
