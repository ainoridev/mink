# `lib/` layout

- **`core/`** — Código compartido (errores, tema, utilidades). Sin lógica de un feature concreto.
- **`features/<feature>/domain/`** — Entidades, contratos de repositorio, casos de uso (puro Dart cuando sea posible).
- **`features/<feature>/data/`** — Implementaciones, DTOs, fuentes remotas/locales.
- **`features/<feature>/presentation/`** — UI, Riverpod (providers/notifiers), pantallas.

El feature **`home`** es un ejemplo mínimo; sustituye o añade features siguiendo la misma estructura.
