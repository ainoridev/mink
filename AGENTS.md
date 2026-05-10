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

## Ramas y PRs (rellenar por el equipo)

<!-- RELLENAR: convención de ramas, ej. feature/, fix/, requisitos de revisión -->

## Dudas de producto o arquitectura

Si la decisión trasciende un PR, documenta un ADR en [docs/adr/](docs/adr/) usando la plantilla allí.
