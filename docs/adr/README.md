# Architecture Decision Records (ADR)

Los ADR documentan **decisiones de arquitectura** con contexto y consecuencias, para que humanos e IA no tengan que “adivinar” el historial.

## Cómo numerar

- Usa prefijo de cuatro dígitos: `0001`, `0002`, …
- Título en el archivo: `0001-titulo-en-kebab-case.md`
- El archivo `0000-template.md` es solo plantilla; no cuenta como decisión.

## Cuándo crear un ADR

- Elección de librería central (navegación, DI, persistencia).
- Cambio de estructura de carpetas o límites entre features.
- Estrategia de errores, seguridad o sincronización offline.

## Plantilla

Copia [0000-template.md](0000-template.md) y rellena todas las secciones.

## Índice

| ADR | Título |
|-----|--------|
| [0001](0001-supabase-cliente-sin-orm-prisma-drizzle.md) | Cliente Supabase en Flutter sin Prisma/Drizzle |
