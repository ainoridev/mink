# Diseño UI — `pencil-new.pen`

Fuente de verdad visual para implementar pantallas en Flutter. El archivo vive en la raíz del repo: [`pencil-new.pen`](../pencil-new.pen).

## Para agentes de IA

### Regla principal

**No edites ni leas la estructura del diseño con `Read` / `Grep` sobre nodos hijos del `.pen` como si fuera código Dart.** En Cursor, el archivo `.pen` se gestiona con el **servidor MCP de Pencil** (`user-highagency.pencildev-extension-pencil`). Usa las herramientas MCP para inspeccionar layout, colores, capturas y cambios.

Excepción acotada: `Grep` en `pencil-new.pen` solo para **inventario** (nombres de pantalla, `id` de frame raíz, URLs de assets), no para inferir medidas ni jerarquía completa.

### Flujo recomendado antes de implementar una vista

1. Abre `pencil-new.pen` en el editor (o pide al usuario que lo tenga abierto) para que MCP tenga acceso al documento.
2. `get_editor_state` — confirma el archivo activo y nodos visibles.
3. `get_variables` — tokens de color y tipografía (`$primary`, `$font-main`, …).
4. `batch_get` con el **node id** de la pantalla (tabla abajo) y `readDepth` 3–4 — árbol de composición.
5. `get_screenshot` con el mismo node id — referencia visual (validar alineación, no solo JSON).
6. `snapshot_layout` con `parentId` de la pantalla — posiciones y tamaños calculados.
7. `get_guidelines` con `topic: "mobile-app"` o `"code"` si vas a generar widgets Flutter.

Para **modificar** el diseño: `batch_design` (operaciones `I` / `U` / `M` / `D` / `R`). Revisa el esquema de cada herramienta en el descriptor MCP antes de llamarla.

### Herramientas MCP (Pencil)

| Herramienta | Uso |
|-------------|-----|
| `batch_get` | Leer propiedades y hijos por `nodeIds` o patrones. |
| `get_screenshot` | Export mental/visual de un frame (validación UI). |
| `get_variables` | Variables de diseño (`$primary`, etc.). |
| `snapshot_layout` | Caja y posición de nodos; `problemsOnly: true` para clipping. |
| `batch_design` | Crear o actualizar nodos (JS con `I`, `U`, `M`, `D`, `R`). |
| `get_guidelines` | Guías mobile / código desde `.pen`. |
| `replace_all_matching_properties` | Cambios masivos de color, padding, etc. en un subárbol. |

**Limitaciones de layout en Pencil:** los hijos en contenedores flex no usan `x`/`y`; define `layout`, `gap`, `padding` y `width`/`height` (`fill_container`, valores fijos). No existe `grid` en el esquema actual; filas con `layout: "horizontal"`.

---

## Estructura del canvas

Dos filas principales en el documento:

| Contenedor | Node id | Contenido |
|------------|---------|-----------|
| **Mink App Design** | `ii8h4` | Flujo de app, shell y modales (01–07, 02–06, 17, 15–16). |
| **Flujo sesión diaria** | `ZkWNE` | Pasos de una sesión (08–14). |

Orden visual en `ii8h4` (izquierda → derecha), alineado al flujo de producto:

`01 Welcome` → `07 Login` → `02 Home` → `03 Ejercicio` → `04 Resumen` → `05 Perfil` → `06 Shop` → `17 Armario` → `15 Selector mapa` → `16 Recompensas racha`

La fila `ZkWNE` mantiene el orden `08` … `14` (check-in → registro).

---

## Inventario de pantallas

Cada fila es un frame **390×844** con `cornerRadius: 40` salvo que se indique lo contrario.

| # | Nombre en Pencil | Node id | Shell / nav | Notas de implementación |
|---|------------------|---------|-------------|-------------------------|
| 01 | Welcome | `Y0hFA` | No | Onboarding; CTAs “Empezar” / “Ya tengo cuenta”. |
| 07 | Login | `imzDe` | No | Email, contraseña, Google; sin bottom nav. |
| 02 | Home · Sesión de hoy | `amcJo` | Sí · Main activo | Path, sesión del día, mascota; monedas/racha arriba. |
| 03 | Ejercicio · Bloque | `L83GZ9` | No | Pantalla de ejercicio (fondo `$surface`). |
| 04 | Resumen sesión | `CW5df` | No | Post-sesión. |
| 05 | Perfil | `Q15dFD` | Sí · Perfil activo | Cabecera morada, radar cognitivo. |
| 06 | Shop | `s1Xum` | Sí · Tienda activa | Tabs **Diaria \| Mensual** en una sola pantalla; grid de piezas. |
| 17 | Armario Mink | `L691ra` | Sí · Tienda activa | Ranuras Cabeza/Ojos/Color/Pies; lista equipada; CTA “Volver a la tienda”. |
| 15 | Selector mapa | `CtIdZ` | No (modal) | Cierre ✕; lista de mapas. |
| 16 | Recompensas racha | `eaEFw` | No (modal) | Cierre ✕; días de racha. |
| 08 | Check-in | `sIjEP` | No | Inicio de sesión. |
| 09 | Warm-up | `D3hbA5` | No | |
| 10 | Feedback | `bbLVX` | No | |
| 11 | Microhábito | `DnYlt` | No | |
| 12 | Descanso | `z9I2x` | No | Fondo `$tertiary-light`. |
| 13 | Progreso | `Q7zPCR` | No | |
| 14 | Registro | `klXSr` | No | Cierre de sesión. |

### Bottom navigation (patrón compartido)

Frames con `name: "Bottom Nav"`, altura **80**, padding `[8, 16, 24, 16]`, borde superior `$border-light`.

| Tab | Iconos (assets) | Estados |
|-----|-----------------|---------|
| Tienda | `images/icons/nav-store.png` / `nav-store-active.png` | Activo en Shop y Armario. |
| Main | `images/icons/nav-main.png` / `nav-main-active.png` | Activo en Home. |
| Perfil | `images/icons/nav-profile.png` / `nav-profile-active.png` | Activo en Perfil. |

Etiquetas: Fredoka 11px; activo `$primary` weight 700; inactivo `$text-secondary` weight 500.

---

## Tokens de diseño

Obtener valores actualizados con MCP `get_variables`. Resumen estable:

| Token | Uso típico |
|-------|------------|
| `$font-main` | **Fredoka** — toda la UI. |
| `$background` | Fondo de pantalla (`#F3F1FF`). |
| `$surface` | Cards, inputs, nav. |
| `$primary` / `$primary-dark` | Botones, tabs activos, acentos morados. |
| `$secondary` / `$secondary-light` / `$secondary-dark` | Naranja / melocotón (armario banner, racha). |
| `$tertiary` / `$tertiary-light` | Verde menta (badges “Rotativa”, ranuras). |
| `$text-primary` / `$text-secondary` / `$text-white` | Texto. |
| `$border-light` | Bordes suaves y nav. |
| `$coin-gold` / `$diamond-blue` | Monedas y diamantes. |
| `$cta-green` / `$cta-green-dark` | CTAs principales (welcome, login). |

En Flutter, centralizar en `ThemeData` / extensiones en `lib/core/theme/` (crear o ampliar cuando implementes).

---

## Espaciado y composición recurrentes

| Patrón | Valor |
|--------|--------|
| Ancho de pantalla diseño | 390 logical px |
| Padding horizontal contenido | **24** (headers, listas, grids) |
| Safe area superior en headers | **48** top padding habitual |
| Gap entre cards en lista | **8–12** |
| Corner radius cards | **14–20** |
| Corner radius botón primario | **16** |
| Altura bottom nav | **80** |
| Grid tienda | 2 columnas, `gap: 10` |

**Tienda (`s1Xum`):** cabecera en `vDmyQ` (monedas, tabs, banner Armario); contenido en `y962sK` (“Piezas del día” / mensual vía tab); no hay segunda pantalla duplicada.

**Armario (`L691ra`):** preview `Sv2wt` + fila `W1dQ1` (4 ranuras iguales, `layout: horizontal`); lista `aA8AK`; botón `qX6I6` entre contenido y nav.

---

## Assets referenciados en el diseño

Rutas relativas al repo (declaradas en `pubspec.yaml` bajo `assets/`):

```
assets/images/mink-*.png          # Mascota (hi, love, funny, …)
assets/images/icons/
  nav-store.png, nav-store-active.png
  nav-main.png, nav-main-active.png
  nav-profile.png, nav-profile-active.png
  currency-coin.png, currency-diamond.png
  star-done.png, star-empty.png
  streak-flame.png, streak-flame-white.png
  icon-check.png, icon-lock.png
  welcome-brain.png, welcome-habit.png, welcome-streak.png, …
assets/fonts/fredoka/             # Fredoka (OFL)
```

Al implementar, usa `Image.asset` con las mismas rutas bajo `assets/` (ajusta `pubspec` si falta algún archivo).

---

## De diseño a código Flutter

1. **Feature** bajo `lib/features/<nombre>/` según [ARCHITECTURE.md](ARCHITECTURE.md).
2. **Pantalla** = `Scaffold` + `backgroundColor: Theme` equivalente a `$background`.
3. **Shell con tabs** (Home, Shop, Perfil): un `MainShell` con `NavigationBar` o barra custom que replique iconos PNG y estados activos del diseño.
4. **Modales** (15, 16): rutas fullscreen o `showModalBottomSheet` / `go_router` según navegación acordada.
5. **Sesión** (08–14): flujo lineal o `PageView` con estado en un notifier de sesión.
6. Tras implementar, contrastar con `get_screenshot` del frame Pencil correspondiente.

Plantilla de especificación por feature: [templates/feature-spec.md](templates/feature-spec.md) — enlaza la fila de la tabla de pantallas y el node id.

---

## Mantenimiento del diseño

- Cambios de UI acordados en producto → actualizar `pencil-new.pen` vía MCP y luego este doc si cambian ids, flujo o tokens.
- No dejar variables escapadas tipo `\\$border-light`; deben ser `$border-light`.
- Una sola pantalla de tienda (`06 Shop`) con tabs; no duplicar frames “diaria” / “mensual”.
- Commits que solo toquen diseño: prefijo `docs:` o `design:` según [AGENTS.md](../AGENTS.md).

---

## Referencias

- [AGENTS.md](../AGENTS.md) — lectura obligatoria para agentes.
- [CONVENTIONS.md](CONVENTIONS.md) — estilo Dart e i18n.
- Regla Cursor: [.cursor/rules/pencil-design.mdc](../.cursor/rules/pencil-design.mdc).
