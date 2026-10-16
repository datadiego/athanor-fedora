# Plan: modo oscuro en apps GTK3 (aplazado)

## Estado

Aplazado. El caso que nos trajo aquí (Nautilus, GTK4/libadwaita) **ya está
resuelto**. Esto queda por si en el futuro aparece una app GTK3 que se empeñe
en salir clara.

## Contexto

- Qué se arregló y por qué (resumen): Hyprland se lanza con `start-hyprland`
  (sin uwsm), así que `graphical-session.target` nunca se activaba y
  `xdg-desktop-portal.service` (que tiene `Requisite=graphical-session.target`)
  no arrancaba. Sin portal, las apps GTK4/libadwaita no reciben el
  `color-scheme` y se quedaban claras aunque `gsettings` dijera `prefer-dark`.
- Solución ya integrada:
  - `athanor/.config/systemd/user/hyprland-session.target` (nuevo, paquete stow).
    Arranca `graphical-session.target` como dependencia (lo único que permite
    systemd para un target con `RefuseManualStart`).
  - `athanor/.config/athanor/hypr/athanor.lua`, en `hl.on("hyprland.start")`:
    ```lua
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
    ```
- **Por qué GTK3 es distinto**: las apps GTK4/libadwaita leen `color-scheme`
  (vía portal o GSettings). Las GTK3 **no** lo respetan; miran `gtk-theme`. Por
  eso pueden seguir claras aunque el resto esté en oscuro.
- Problema añadido: en Fedora 44 `gnome-themes-extra` (que aportaba el tema
  `Adwaita-dark`) **ya no está en los repos** (`dnf list --available
  gnome-themes-extra` → "No matches found"). Así que no podemos simplemente
  poner `gtk-theme = 'Adwaita-dark'`.

## Opciones (a decidir si se ataja)

1. **`hl.env("GTK_THEME", "Adwaita:dark")` en `athanor.lua`.**
   GTK3 sí entiende la sintaxis `Tema:variante` y `Adwaita` va compilado en GTK3
   (no necesita `gnome-themes-extra`). Es la vía más limpia y vive en el paquete
   stow, así que `make install` la reproduce. Contra: afecta a GTK3 de forma
   global y puede chocar con apps que ya fijan su tema.
2. **`gsettings set org.gnome.desktop.interface gtk-theme ...` con un tema que
   exista.** Requiere instalar/añadir un paquete (p. ej. `adw-gtk3-theme`, que
   trae variante oscura y sigue libadwaita). Añadir a `scripts/desktop.sh`.
3. **`~/.config/gtk-3.0/settings.ini`** con `gtk-theme-name=Adwaita` +
   `gtk-application-prefer-dark-theme=1`. Contra: libadwaita avisa
   ("Using GtkSettings:gtk-application-prefer-dark-theme with libadwaita is
   unsupported"), así que solo como último recurso y sin tocar GTK4.

Recomendación si se retoma: empezar por la **opción 1** (una línea en el `.lua`,
reversible) y ver si realmente hay apps GTK3 que lo necesiten antes de meter
paquetes nuevos.

## Verificación (cuando se ataje)

- Abrir una app GTK3 concreta (p. ej. `transmission-gtk`, `gimp`, algún
  `*-gtk` de Flatpak) y comprobar que sale oscura.
- Confirmar que las GTK4/libadwaita (Nautilus, `gnome-calculator`…) siguen
  oscuras y sin warnings.
- `uv run pytest -q` si se toca `install.sh`/`scripts/*.sh`.
