# Testing y TDD

## Principios

- **TDD** cuando sea viable: test → implementación mínima → refactor.
- Tests **rápidos y deterministas** en CI; sin llamadas de red reales en unit tests.

## Pirámide

<!-- RELLENAR: porcentajes orientativos del equipo -->

1. **Unitarios** — domain (casos de uso), validaciones, mappers.
2. **Widget** — interacción y ramas de UI relevantes.
3. **Integración** — flujos críticos (`integration_test`).

## Ubicación

- Tests junto al paquete: carpeta `test/` en la raíz del proyecto Flutter.
- Convención de nombres: `*_test.dart`.
- Mocks / fakes: `test/helpers/` o junto al test según tamaño.

<!-- RELLENAR: estructura exacta de carpetas bajo test/ -->

## Herramientas

- `flutter_test` para unit y widget.
- `mocktail` para mocks (ya en `pubspec.yaml`).

## Ejemplos (rellenar con snippets reales del proyecto)

### Caso de uso (unit)

<!-- RELLENAR: enlace a un test existente o pegar ejemplo mínimo -->

### Provider / notifier

<!-- RELLENAR: estrategia (ProviderContainer en test, overrides, etc.) -->

### Widget

<!-- RELLENAR: cuándo exigir widget test en PR -->

## CI deseado (checklist)

<!-- RELLENAR: marcar lo que apliquéis -->

- [ ] `flutter pub get`
- [ ] `flutter analyze`
- [ ] `flutter test`
- [ ] Cobertura mínima (opcional): <!-- RELLENAR: umbral % -->

## integration_test

<!-- RELLENAR: cuándo se añade, dónde viven los tests, cómo ejecutarlos localmente -->
