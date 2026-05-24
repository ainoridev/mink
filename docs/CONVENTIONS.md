# Convenciones de código

## Estilo Dart

- Cumplir `analysis_options.yaml` del repo (`flutter_lints` + reglas extra).
- `require_trailing_commas` activada: formatea con `dart format .`.

## Nombres

- Archivos: `snake_case.dart`.
- Clases y tipos: `UpperCamelCase`.
- Variables y parámetros: `lowerCamelCase`.
- Casos de uso: verbo + contexto, ej. `GetUserProfile`, `SubmitOrder`.

## Capas y prefijos

- Entidades en `domain`: sin sufijo obligatorio; evitar nombres idénticos a DTOs.
- DTOs en `data`: sufijo `Dto` o carpeta `models/` si el equipo lo define aquí.

<!-- RELLENAR: convención exacta para DTOs y mappers -->

## Errores y fallos

<!-- RELLENAR: `sealed class Failure`, excepciones vs `Either`/`Result`, cómo mapear errores de red -->

## Logging

<!-- RELLENAR: paquete (logger, talker), niveles, datos sensibles prohibidos en logs -->

## Internacionalización (i18n)

<!-- RELLENAR: `flutter gen-l10n`, ARB, idiomas soportados -->

## Comentarios

- Comenta el “por qué”, no el “qué” obvio.
- Documenta APIs públicas de paquetes compartidos o casos de uso complejos.

## UI y diseño

- La referencia visual está en [`pencil-new.pen`](../pencil-new.pen); ver [DESIGN.md](DESIGN.md) para inventario de pantallas, tokens, assets y **lectura del diseño con MCP Pencil** (no inferir layout solo desde el JSON del `.pen`).
- Fuente: **Fredoka** (`assets/fonts/fredoka/`). Colores y espaciado: tokens `$primary`, `$background`, etc. en DESIGN.md.
- Iconos y mascota: `assets/images/icons/`, `assets/images/mink-*.png` (mismas rutas que en el diseño).
