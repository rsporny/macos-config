# Variables
HOST_NAME ?= unset
SHELL_FILE           := /etc/shells
FISH_CONFIG_DIR      := ~/.config/fish
FISH_CONFIG_FILE     := $(FISH_CONFIG_DIR)/config.fish
GIT_REPOS_DIR        := ~/work/repos

# List of dotfiles to backup/restore (relative to $HOME)
DOTFILES = \
    .config/git/config \
    .config/ghostty/config \
    .config/fish/config.fish \
    .gnupg/gpg-agent.conf

BACKUP_DIR = dotfiles

# Targets
all: restore install shell defaults hostname settings

backup:
	@echo "🔄 Backing up dotfiles to '$(BACKUP_DIR)'..."
	@for file in $(DOTFILES); do \
		src="$(HOME)/$$file"; \
		dest="$(BACKUP_DIR)/$$file"; \
		mkdir -p "$$(dirname $$dest)"; \
		cp -v "$$src" "$$dest"; \
	done

restore:
	@echo "📦 Restoring dotfiles to $(HOME)..."
	@for file in $(DOTFILES); do \
		src="$(BACKUP_DIR)/$$file"; \
		dest="$(HOME)/$$file"; \
		if [ -f "$$src" ]; then \
			mkdir -p "$$(dirname $$dest)"; \
			cp -v "$$src" "$$dest"; \
		else \
			echo "⚠️  Warning: $$src not found. Skipping."; \
		fi \
	done

install:
	brew install ghostty fish neovim git gnupg pinentry-mac

shell:
	@echo "🐟 Configuring Fish shell..."
	@echo "➕ Ensuring Fish is in /etc/shells..."
	if ! grep -q "$(shell which fish)" $(SHELL_FILE); then \
		sudo tee -a $(SHELL_FILE) <<< "$(shell which fish)"; \
	fi
	@echo "⚙️ Setting Fish as default shell..."
	chsh -s "$(shell which fish)"
	mkdir -p $(FISH_CONFIG_DIR)

defaults:
	@echo "🧰 Applying macOS default settings..."
	./defaults.sh

	# Apply changes
	killall Dock || true
	killall Finder || true

	@echo "✅ macOS settings applied."

hostname:
	ifeq ($(HOST_NAME),unset)
		$(error ❌ HOST_NAME must be set)
	endif
	sudo scutil --set HostName $(HOST_NAME)
	sudo scutil --set LocalHostName $(HOST_NAME)
	sudo scutil --set ComputerName $(HOST_NAME)

settings:
	@echo "🔇 Disabling boot sound..."
	sudo nvram StartupMute=%01
	@echo "🔒 Setting immediate password requirement after screen saver begins..."
	sysadminctl -screenLock immediate -password -

clean: backup
	@echo "🧹 Removing configuration files..."
	@for file in $(DOTFILES); do \
		target="$$HOME/$$file"; \
		[ -f "$$target" ] && rm -v "$$target" || true; \
	done
	@echo "✅ All configuration files removed."

.PHONY: all backup restore install defaults hostname settings shell clean

