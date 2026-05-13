# Supabase (Flutter)

Documentación alineada con el cliente oficial **[supabase_flutter](https://pub.dev/packages/supabase_flutter)** y las guías actuales de Supabase. En el cliente móvil **no** se usa Prisma ni Drizzle (son ORMs de **Node/TypeScript** para Postgres); el acceso a datos remoto es **PostgREST + RLS** vía el SDK; un ORM local tipo **Drift** solo tendría sentido para caché/offline (véase [ADR 0001](adr/0001-supabase-cliente-sin-orm-prisma-drizzle.md)).

## Enlaces oficiales (referencia viva)

- [Use Supabase with Flutter](https://supabase.com/docs/guides/getting-started/quickstarts/flutter) — arranque y `Supabase.initialize`.
- [Flutter: autenticación y RLS](https://supabase.com/blog/flutter-authentication-and-authorization-with-rls) — modelo mental de seguridad.
- [Row Level Security](https://supabase.com/docs/guides/auth/row-level-security) — obligatorio para datos por usuario.
- [Auth (Flutter)](https://supabase.com/docs/reference/dart/introduction) — API Dart (`signInWithPassword`, `signUp`, etc.).
- [Deep linking / OAuth en Flutter](https://supabase.com/docs/guides/auth/native-mobile-deep-linking?platform=flutter) — cuando actives Google, Apple, etc.
- **ORM en backend (opcional)**: [Prisma + Supabase](https://supabase.com/docs/guides/database/prisma), [Drizzle + Supabase](https://supabase.com/docs/guides/database/drizzle) — solo en servicios **Node**, nunca en la app con la **service role** embebida.

## Qué hay configurado en Mink

| Pieza | Ubicación / comportamiento |
|-------|----------------------------|
| Inicialización | [lib/core/supabase/supabase_bootstrap.dart](../lib/core/supabase/supabase_bootstrap.dart) |
| Variables `SUPABASE_URL` y `SUPABASE_ANON_KEY` | [lib/core/config/env.dart](../lib/core/config/env.dart): prioridad `--dart-define` > [assets/env/.env](../assets/env/.env) vía `flutter_dotenv` |
| Sesión en disco (nativo) | [lib/core/supabase/secure_supabase_local_storage.dart](../lib/core/supabase/secure_supabase_local_storage.dart) — `FlutterSecureStorage` (Keychain / Keystore) |
| Web | Misma clave **anon**; sesión y PKCE usan almacenamiento por defecto de Supabase (SharedPreferences / web storage); el modelo de amenazas en navegador es distinto. |
| PKCE | `AuthFlowType.pkce` + almacenamiento del verificador en [secure_gotrue_async_storage.dart](../lib/core/supabase/secure_gotrue_async_storage.dart) (seguro en nativo). |
| UI login | [lib/features/auth/presentation/login_page.dart](../lib/features/auth/presentation/login_page.dart) |

## Seguridad (checklist)

1. **Solo anon key en el cliente** — la **service role** nunca en la app; operaciones admin vía Edge Functions o backend con secreto en servidor.
2. **RLS** en todas las tablas expuestas a PostgREST — políticas con `auth.uid()` (u otras claims en JWT).
3. **Claims sensibles** en `app_metadata` (solo servidor), no en `user_metadata` editable por el usuario.
4. **Secretos en CI/CD**: `--dart-define=SUPABASE_URL=...` y `--dart-define=SUPABASE_ANON_KEY=...` o `--dart-define-from-file=env.json` (archivo **no** versionado). La anon key está pensada para ser pública en el cliente; aun así, rotación y restricción por entorno siguen siendo buenas prácticas.
5. **Producción**: revisa [SSL y dominios](https://supabase.com/docs/guides/platform/custom-domains) si aplica; desactiva logs verbosos (`debug: false` en release; ya se usa `kDebugMode` en el bootstrap).

## Primer arranque local

1. Crea un proyecto en [Supabase Dashboard](https://supabase.com/dashboard).
2. Copia la plantilla y rellena (el archivo `assets/env/.env` **no** debe subirse a git):

   ```bash
   cp assets/env/.env.example assets/env/.env
   ```

3. Edita `assets/env/.env` con **Project URL** y clave **anon / publishable** (Settings → API).
4. O pasa defines al ejecutar (recomendado en CI):

```bash
flutter run \
  --dart-define=SUPABASE_URL=https://TU_REF.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=eyJ...
```

5. En el Dashboard, habilita el proveedor **Email** (Authentication → Providers) si usas email/contraseña.

## Próximos pasos recomendados

- Tablas y políticas RLS para tu dominio (gimnasio cognitivo, perfiles, etc.).
- Deep links / scheme de la app para OAuth (cuando añadas Google/Apple).
- Tests de integración contra un proyecto Supabase de **staging** (variables por flavor o `--dart-define-from-file`).
