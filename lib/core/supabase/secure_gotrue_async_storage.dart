import "package:flutter/foundation.dart";
import "package:flutter_secure_storage/flutter_secure_storage.dart";
import "package:supabase_flutter/supabase_flutter.dart";

/// Almacenamiento del verificador PKCE y datos relacionados de GoTrue.
///
/// En nativo usa [FlutterSecureStorage]. En web delega en [SharedPreferencesGotrueAsyncStorage]
/// (misma política que la sesión: el modelo de amenazas en navegador es distinto).
class SecureGotrueAsyncStorage extends GotrueAsyncStorage {
  SecureGotrueAsyncStorage()
    : _webDelegate = SharedPreferencesGotrueAsyncStorage();

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  final SharedPreferencesGotrueAsyncStorage _webDelegate;

  static String _key(String key) => "sb-gotrue-$key";

  @override
  Future<String?> getItem({required String key}) {
    if (kIsWeb) {
      return _webDelegate.getItem(key: key);
    }
    return _storage.read(key: _key(key));
  }

  @override
  Future<void> removeItem({required String key}) {
    if (kIsWeb) {
      return _webDelegate.removeItem(key: key);
    }
    return _storage.delete(key: _key(key));
  }

  @override
  Future<void> setItem({required String key, required String value}) {
    if (kIsWeb) {
      return _webDelegate.setItem(key: key, value: value);
    }
    return _storage.write(key: _key(key), value: value);
  }
}
