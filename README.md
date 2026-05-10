# Mink

Flutter app structured for Clean Architecture, Riverpod, SOLID, and TDD.

## Prerrequisitos

- [Flutter SDK](https://docs.flutter.dev/get-started/install) estable en tu `PATH`.

## Arranque del repositorio

Si faltan carpetas de plataforma (`android/`, `ios/`, etc.), genera el esqueleto oficial sin sobrescribir tu `lib/`:

```bash
flutter create . --project-name mink --org com.mink
```

Instala dependencias y ejecuta tests:

```bash
flutter pub get
flutter analyze
flutter test
```

## Documentación

- Convenciones y arquitectura: [docs/README.md](docs/README.md)
- Instrucciones para agentes e IA: [AGENTS.md](AGENTS.md)
