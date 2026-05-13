# ADR 0001: Cliente Supabase en Flutter sin Prisma/Drizzle

- **Estado:** aceptado
- **Fecha:** 2026-05-10
- **Decisores:** equipo Mink

## Contexto

Se desea persistencia y login con **Supabase**. En el ecosistema web/backend, **Prisma** y **Drizzle** son ORMs habituales sobre Postgres. En **Flutter/Dart** no hay un port oficial de esos ORMs; además, la app cliente no debe ejecutar migraciones ni contener la **service role key**.

## Decisión

- Usar **`supabase_flutter`** como cliente único en la app: Auth, PostgREST, Realtime y Storage según necesidad.
- Persistencia remota modelada con **tablas Postgres + Row Level Security (RLS)**; acceso tipado vía el cliente Dart y capas `domain`/`data` del proyecto.
- Sesión local: **PKCE** y persistencia de tokens en **almacenamiento seguro** en plataformas nativas (`FlutterSecureStorage` integrado vía `LocalStorage` personalizado).
- Si en el futuro se necesita un ORM en **servidor** (Node), evaluar **Drizzle** o **Prisma** en ese backend según la [documentación oficial de Supabase](https://supabase.com/docs/guides/database/drizzle), sin exponer credenciales privilegiadas al móvil.

## Consecuencias

### Positivas

- Alineación con la documentación y ejemplos oficiales de Supabase para Flutter.
- Seguridad reforzada en servidor con RLS; superficie de ataque del cliente acotada a la anon key.

### Negativas / riesgos

- No hay “esquema ORM” compartido 1:1 entre app y un backend Drizzle/Prisma salvo que se genere código o contratos (OpenAPI, tipos manuales) de forma explícita.
- En **web**, el almacenamiento local de sesión es inherentemente menos fuerte que en iOS/Android.

## Notas

- Guía operativa: [docs/SUPABASE.md](../SUPABASE.md).
