SHELL := /bin/bash

# Paquete de stow (el árbol de dotfiles athanor/)
PACKAGES := athanor

.PHONY: help check-sudo install shell common desktop notch packages stow unstow render uninstall purge test lint fmt clean

help: ## Mostrar esta ayuda
	@cat logo
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-12s\033[0m %s\n", $$1, $$2}'

check-sudo:
	@sudo -v

install: check-sudo ## Instalar Athanor completo (paquetes + app + stow)
	@./install.sh

shell: check-sudo ## Instalar solo la capa shell
	@./install.sh shell

common: shell ## Alias de shell

desktop: check-sudo ## Instalar la capa escritorio (incluye shell)
	@./install.sh desktop

notch: check-sudo ## Escritorio + compilar el plugin notch
	@./install.sh notch

packages: check-sudo ## Instalar solo los paquetes del sistema (dnf + COPR)
	@bash scripts/common.sh
	@bash scripts/desktop.sh

stow: ## Enlazar los dotfiles en $(HOME) con stow
	@bash scripts/stow.sh

unstow: ## Quitar los enlaces de stow
	@bash scripts/stow.sh -D

render: ## Redibujar paletas y wallpapers
	@uv run athanor transmute

uninstall: ## Quitar Athanor (deja config, fuentes y cache)
	@./install.sh --uninstall

purge: ## Quitar Athanor y también config, fuentes y cache
	@./install.sh --uninstall --purge

test: ## Ejecutar los tests
	@uv run pytest -q

lint: ## Lint de Python y shell
	@uv run ruff check src tests
	@uv run ruff format --check src tests
	@shellcheck install.sh scripts/*.sh docs/screenshots/shoot.sh docs/screenshots/palette.sh

fmt: ## Formatear Python
	@uv run ruff format src tests
	@uv run ruff check --fix src tests

clean: ## Borrar ficheros generados
	@rm -f *.zip
	@echo "Archivos generados eliminados"
