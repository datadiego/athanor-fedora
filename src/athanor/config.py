import tomllib
from dataclasses import dataclass, field
from typing import NamedTuple

from .paths import config_dir

DEFAULT_ROOM = "Dust hangs in the lamplight. A terminal hums on the desk."


class TerminalFont(NamedTuple):
    family: str
    px: int
    # foot puts bold on the regular face's baseline, so a taller bold face gets
    # its tops clipped.
    bold: str | None = None
    italic: str | None = None


TERMINAL_FONTS = {
    "tandy": TerminalFont("Px437 Tandy2K", 16, bold="Px437 AT&T PC6300", italic="Ttyp0"),
    "terminus": TerminalFont("Terminus (TTF)", 16, italic="Ttyp0"),
    "terminess": TerminalFont("Terminess Nerd Font Mono", 16),
    "cozette": TerminalFont("CozetteVector", 13),
    "compaq": TerminalFont("Px437 CompaqThin 8x16", 16, bold="Px437 CompaqThin Overstrike"),
    "vga": TerminalFont("PxPlus IBM VGA 8x16", 16, bold="PxPlus IBM VGA Overstrike"),
    "proggy": TerminalFont("ProggyClean Nerd Font Mono", 16),
    "proggyclean": TerminalFont("ProggyClean Nerd Font Mono", 16),
    "departure": TerminalFont("DepartureMono Nerd Font Mono", 11),
    "departuremono": TerminalFont("DepartureMono Nerd Font Mono", 11),
    "iosevka": TerminalFont("Iosevka Nerd Font Mono", 11),
    "iosevkaterm": TerminalFont("IosevkaTerm Nerd Font Mono", 11),
    "jetbrains": TerminalFont("JetBrains Mono Nerd Font Mono", 11),
    "jetbrainsmono": TerminalFont("JetBrains Mono Nerd Font Mono", 11),
}

# Traced bitmap faces that only stay crisp on multiples of their native grid.
PIXEL_FONTS = {"tandy", "compaq", "vga", "departure", "departuremono"}


def terminal_px(font: str, size: int = 0) -> tuple[int, int]:
    face = TERMINAL_FONTS[font]
    if size <= 0:
        px = face.px
    elif font in PIXEL_FONTS:
        px = face.px * max(1, round(size / face.px))
    else:
        px = size
    return px, max(1, round(px * 3 / 4))


@dataclass(frozen=True)
class Config:
    place: tuple[float, float] | None = None
    name: str = ""
    title: str = "the Wizard"
    race: str = ""
    room_name: str = "A Dim Chamber"
    room_description: str = DEFAULT_ROOM
    exits: dict[str, str] = field(default_factory=dict)
    pixel_scale: int = 0
    levels: bool = True
    terminal_font: str = "tandy"
    terminal_size: int = 0
    tarot_on_login: bool = True
    stages: bool = False


def load() -> Config:
    path = config_dir() / "athanor.toml"
    try:
        raw = tomllib.loads(path.read_text())
    except FileNotFoundError:
        return Config()
    place = raw.get("place", {})
    room = raw.get("room", {})
    character = raw.get("character", {})
    lat, lon = place.get("latitude"), place.get("longitude")
    display = raw.get("display", {})
    font = str(display.get("terminal_font", Config.terminal_font)).lower()
    if font not in TERMINAL_FONTS:
        font = Config.terminal_font
    return Config(
        place=(float(lat), float(lon)) if lat is not None and lon is not None else None,
        name=str(character.get("name", "")),
        title=character.get("title", Config.title),
        race=str(character.get("race", "")),
        room_name=room.get("name", Config.room_name),
        room_description=room.get("description", DEFAULT_ROOM),
        exits=dict(room.get("exits", {})),
        pixel_scale=int(display.get("pixel_scale", 0)),
        levels=bool(display.get("levels", True)),
        terminal_font=font,
        terminal_size=int(display.get("terminal_size", 0)),
        tarot_on_login=bool(raw.get("tarot", {}).get("on_login", True)),
        stages=bool(raw.get("transmute", {}).get("stages", False)),
    )
