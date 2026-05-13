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

## Supabase

1. Copia la plantilla y rellena credenciales (el archivo real no se versiona):

   ```bash
   cp assets/env/.env.example assets/env/.env
   ```

2. Habilita el proveedor **Email** en el dashboard si usas login email/contraseña.
3. Detalle y seguridad: [docs/SUPABASE.md](docs/SUPABASE.md).
