from athanor import config


def _load(tmp_path, monkeypatch, text):
    monkeypatch.setenv("XDG_CONFIG_HOME", str(tmp_path))
    (tmp_path / "athanor").mkdir()
    (tmp_path / "athanor" / "athanor.toml").write_text(text)
    return config.load()


def test_terminal_font_defaults_to_tandy(tmp_path, monkeypatch):
    assert _load(tmp_path, monkeypatch, "").terminal_font == "tandy"


def test_terminal_font_is_read(tmp_path, monkeypatch):
    cfg = _load(tmp_path, monkeypatch, '[display]\nterminal_font = "Compaq"\n')
    assert cfg.terminal_font == "compaq"


def test_unknown_terminal_font_falls_back(tmp_path, monkeypatch):
    cfg = _load(tmp_path, monkeypatch, '[display]\nterminal_font = "comic sans"\n')
    assert cfg.terminal_font == "tandy"


def test_terminal_size_defaults_to_native(tmp_path, monkeypatch):
    assert _load(tmp_path, monkeypatch, "").terminal_size == 0


def test_terminal_size_is_read(tmp_path, monkeypatch):
    cfg = _load(tmp_path, monkeypatch, "[display]\nterminal_size = 32\n")
    assert cfg.terminal_size == 32


def test_terminal_size_snaps_to_the_pixel_grid(tmp_path, monkeypatch):
    assert config.terminal_px("tandy", 24) == (32, 24)
    assert config.terminal_px("tandy", 8) == (16, 12)
    assert config.terminal_px("tandy", 0) == (16, 12)


def test_terminal_size_scales_a_vector_face_freely(tmp_path, monkeypatch):
    assert config.terminal_px("terminus", 24) == (24, 18)


def test_the_character_defaults_to_who_and_where_you_are(tmp_path, monkeypatch):
    cfg = _load(tmp_path, monkeypatch, "")
    assert (cfg.name, cfg.title, cfg.race) == ("", "the Wizard", "")


def test_the_character_can_be_named(tmp_path, monkeypatch):
    text = '[character]\nname = "Prospero"\ntitle = "the Magus"\nrace = "Fedora Linux"\n'
    cfg = _load(tmp_path, monkeypatch, text)
    assert (cfg.name, cfg.title, cfg.race) == ("Prospero", "the Magus", "Fedora Linux")


def test_levels_default_on_and_can_be_turned_off(tmp_path, monkeypatch):
    assert _load(tmp_path, monkeypatch, "").levels is True
    (tmp_path / "athanor" / "athanor.toml").write_text("[display]\nlevels = false\n")
    assert config.load().levels is False
