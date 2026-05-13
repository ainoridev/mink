import "package:flutter_dotenv/flutter_dotenv.dart";

/// Carga de variables de entorno para Supabase.
///
/// Prioridad: `--dart-define` (CI / release) > [assets/env/.env](mdc:assets/env/.env)
/// (asset versionado con claves vacías; rellena localmente o en tu copia sin subir secretos).
class Env {
  Env._();

  static Future<void> load() async {
    await dotenv.load(fileName: "assets/env/.env", isOptional: true);
  }

  static String get supabaseUrl {
    const fromDefine = String.fromEnvironment("SUPABASE_URL");
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    final fromFile = dotenv.env["SUPABASE_URL"]?.trim();
    if (fromFile != null && fromFile.isNotEmpty) {
      return fromFile;
    }
    throw StateError(
      "Falta SUPABASE_URL. Usa --dart-define=SUPABASE_URL=https://xxx.supabase.co "
      "o rellena SUPABASE_URL en assets/env/.env (véase docs/SUPABASE.md).",
    );
  }

  static String get supabaseAnonKey {
    const fromDefine = String.fromEnvironment("SUPABASE_ANON_KEY");
    if (fromDefine.isNotEmpty) {
      return fromDefine;
    }
    final fromFile = dotenv.env["SUPABASE_ANON_KEY"]?.trim();
    if (fromFile != null && fromFile.isNotEmpty) {
      return fromFile;
    }
    throw StateError(
      "Falta SUPABASE_ANON_KEY. Usa --dart-define=SUPABASE_ANON_KEY=eyJ... "
      "o rellena SUPABASE_ANON_KEY en assets/env/.env (véase docs/SUPABASE.md).",
    );
  }
}
