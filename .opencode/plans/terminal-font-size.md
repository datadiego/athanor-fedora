# Plan: tamaño de fuente del terminal + limpieza final de Arch

## Contexto

- El terminal se lanza con `foot --config ~/.config/athanor/current/foot/foot.ini`
  (en `hypr/athanor.lua` y `hypr/athanor.conf`).
- `foot.ini` se **genera** desde `src/athanor/templates/foot/foot.ini` con los
  valores que calcula `transmute.tokens()`.
- Fuente por defecto: `tandy` → `Px437 Tandy2K:pixelsize=16` (bitmap trazada,
  rejilla 8x16, `antialias=false` por `60-athanor.conf`). Solo queda nítida en
  múltiplos exactos (16/32/48).
- `Ctrl++` de foot sube 0.5pt y convierte `pixelsize`→puntos → rompe la rejilla.
- No existe hoy ningún ajuste de tamaño en `athanor.toml`.

Decisiones del usuario:
- Enfoque elegido: **tamaño configurable + zoom arreglado**.
- Fuente por defecto: **mantener pixel (tandy)**.
- Alcance: **solo terminal (foot)**; `fuzzel.ini` se queda a 16px.

## Cambios

### 1. `src/athanor/config.py`
- Tras `TERMINAL_FONTS`, añadir:
  ```python
  # Traced bitmap faces that only stay crisp on multiples of their native grid.
  PIXEL_FONTS = {"tandy", "compaq", "vga"}


  def terminal_px(font: str, size: int = 0) -> tuple[int, int]:
      face = TERMINAL_FONTS[font]
      if size <= 0:
          px = face.px
      elif font in PIXEL_FONTS:
          px = face.px * max(1, round(size / face.px))
      else:
          px = size
      return px, max(1, round(px * 3 / 4))
  ```
- `Config`: nuevo campo `terminal_size: int = 0`.
- `load()`: `terminal_size=int(display.get("terminal_size", 0)),`.

### 2. `src/athanor/transmute.py`
- `tokens(...)`: añadir parámetro `terminal_size: int = 0` (entre `font` y `name`).
- Dentro: `px, icon_px = config.terminal_px(font, terminal_size)`.
- `term_px` → `str(px)`; `term_icon_px` → `str(icon_px)`; usar `px` en
  `term_font_bold` / `term_font_italic`.
- Nuevo token `"font_size_adjustment": "100%" if font in config.PIXEL_FONTS else "0.5"`.
- `apply()` (L251): pasar `font=cfg.terminal_font, terminal_size=cfg.terminal_size, name=cfg.name`.

### 3. `src/athanor/templates/foot/foot.ini`
- Añadir tras las 4 líneas `font*`:
  `font-size-adjustment={{ font_size_adjustment }}`

### 4. `src/athanor/cli.py` (`cmd_font`, L347)
```python
def cmd_font(_args) -> None:
    cfg = config.load()
    face = config.TERMINAL_FONTS[cfg.terminal_font]
    px, _ = config.terminal_px(cfg.terminal_font, cfg.terminal_size)
    bold = f", with {face.bold} for bold" if face.bold else ""
    print(f"{face.family} at {px}px ({px * 72 / 96:g}pt at 96 dpi){bold}")
```

### 5. `athanor/.config/athanor/athanor.toml`
- L10: `# race = "Arch Linux"` → `# race = "Fedora Linux"`.
- Tras `terminal_font` (L27) documentar:
  ```toml
  # Terminal font size in px. 0 uses the face's native size. The pixel faces
  # (tandy, compaq, vga) snap to the nearest multiple of their grid; terminus
  # and cozette scale freely. Ctrl+plus zooms in crisp steps. Applies at the
  # next transmute.
  terminal_size = 0
  ```

### 6. Tests
- `tests/test_config.py`:
  - `terminal_size` por defecto 0 y se lee.
  - Snapping pixel: `terminal_px("tandy", 24) == (32, 24)`, `terminal_px("tandy", 8) == (16, 12)`.
  - Libre vectorial: `terminal_px("terminus", 24) == (24, 18)`.
- `tests/test_render.py`:
  - Con `terminal_size=32` y `tandy`: `pixelsize=32` en las 4 líneas, iconos
    `pixelsize=24`, y `font-size-adjustment=100%`.
  - Sin tamaño (0): sigue `=16` / iconos `=12` (tests actuales intactos).

### 7. Docs
- `README.md`: L3 `Arch and Hyprland` → `Fedora and Hyprland`; L97 `On Arch the
  same entry point still uses pacman.` → quitar/adaptar; añadir nota corta de
  `[display] terminal_size` + `make render` y del zoom `Ctrl++` con fuente pixel.

## Verificación
- `uv run pytest -q`
- `uv run ruff check src tests` y `uv run ruff format --check src tests`
- `make render` con `terminal_size = 32` y revisar
  `~/.config/athanor/current/foot/foot.ini`.
- En Fedora: comprobar `Ctrl++` 16→32→64 nítido. Si foot no respeta el
  porcentaje (según versión), fallback a `16px` con iconos.
