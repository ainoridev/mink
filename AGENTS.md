# Instrucciones para agentes (humanos e IA)

Este repositorio es una app **Flutter** con **Clean Architecture por feature**, **Riverpod** en presentation, enfoque **SOLID** y **TDD**.

## Lectura obligatoria antes de cambios amplios

- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — capas, dependencias y diagramas (completar según evolucione el producto).
- [docs/CONVENTIONS.md](docs/CONVENTIONS.md) — estilo, errores, i18n, etc.
- [docs/TESTING.md](docs/TESTING.md) — pirámide de tests y flujo TDD.
- Reglas en [.cursor/rules/](.cursor/rules/) — aplican en Cursor según alcance (`alwaysApply` / `globs`).

## Comandos habituales

```bash
flutter pub get
flutter pub upgrade --major-versions
flutter pub outdated
flutter analyze
flutter test
```

Mantén dependencias en la **última versión estable** compatible con el SDK; revisa `flutter pub outdated` tras upgrades del toolchain.

Codegen (cuando uses `riverpod_annotation` u otros generadores):

```bash
dart run build_runner build --delete-conflicting-outputs
```

## Nunca hacer

- Lógica de negocio importante directamente en widgets sin pasar por **casos de uso** en domain.
- Importar `presentation` o `data` desde `domain`.
- Importar Flutter o Riverpod desde `domain` (salvo excepciones documentadas en ADR).
- Editar a mano archivos `*.g.dart`.
- Refactors masivos no solicitados mezclados con una corrección pequeña.

## Ramas y PRs

Convención alineada con **GitFlow** (ajustar nombres de ramas base si el remoto usa otros nombres, p. ej. `main` en lugar de `develop`):

| Prefijo | Uso |
|--------|-----|
| `feature/<tema-corto>` | Nuevas capacidades o refactors de alcance acotado ligados a una historia o ticket. |
| `fix/<tema-corto>` | Correcciones en la línea de desarrollo habitual (bugs, regresiones). |
| `hotfix/<tema-corto>` | Parches urgentes sobre la rama de producción/release. |
| `release/<versión>` | Preparación de un corte (versiones, changelog, smoke); merge a producción tras validar. |
| `chore/<tema-corto>` | Mantenimiento sin cambio de comportamiento (CI, deps, formato). |

**PRs:** al menos una revisión cuando el cambio no sea trivial; enlazar issue o ticket si aplica.

**Correcciones pequeñas:** título y descripción del PR (o commits) breves: qué fallaba, qué se hizo y cómo comprobarlo en una o dos frases; sin narrar refactors colaterales no pedidos.

## Commits

Durante cada desarrollo, **commitear de forma incremental** con mensajes que se entiendan sin abrir el diff:

- Sigue **[Conventional Commits](https://www.conventionalcommits.org/)**: `feat:`, `fix:`, `docs:`, `test:`, `refactor:`, `chore:`, `perf:`, `ci:`, `build:` (y `scope` opcional, p. ej. `fix(auth): …`).
- **Título:** imperativo y breve (“Añade…”, “Corrige…”), una idea principal por commit cuando sea posible.
- **Cuerpo:** opcional; úsalo para el contexto o el “por qué” si el título no basta.
- **Idioma:** español o inglés, pero **consistente** en el historial del repo (como en [.cursor/rules/documentation-and-commits.mdc](.cursor/rules/documentation-and-commits.mdc)).

Evita commits genéricos (`cambios`, `wip`, `fix`) sin tipo ni objeto concreto.

## Dudas de producto o arquitectura

Si la decisión trasciende un PR, documenta un **ADR** (*Architecture Decision Record*, registro breve de una decisión de arquitectura y su contexto) en [docs/adr/](docs/adr/) usando la plantilla allí.
