# Variables
HOST_NAME ?= mac
SHELL_FILE := /etc/shells

# List of dotfiles to backup/restore
DOTFILES = \
    .config/git/config \
    .config/ghostty/config \
    .config/fish/config.fish \
    .gnupg/gpg-agent.conf \
    .config/direnv/direnv.toml \
    .config/nvim

BACKUP_DIR = dotfiles


# Print section header
define print_header
	@echo ""
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "$(1)"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
endef


# Targets
all: restore install settings preferences

backup:
	$(call print_header,💾 Backing up dotfiles to '$(BACKUP_DIR)'...)
	@for file in $(DOTFILES); do \
		src="$(HOME)/$$file"; \
		dest="$(BACKUP_DIR)/$$file"; \
		if [ -e "$$src" ]; then \
			mkdir -p "$$(dirname $$dest)"; \
			if [ -d "$$src" ]; then \
				cp -av "$$src" "$$(dirname $$dest)"; \
			else \
				cp -v "$$src" "$$dest"; \
			fi \
		else \
			echo "⚠️  Warning: $$src not found. Skipping."; \
		fi \
	done
	@echo "✅ Backup finished."

restore:
	$(call print_header,🚚 Restoring dotfiles to $(HOME)...)
	@for file in $(DOTFILES); do \
		src="$(BACKUP_DIR)/$$file"; \
		dest="$(HOME)/$$file"; \
		if [ -e "$$src" ]; then \
			mkdir -p "$$(dirname $$dest)"; \
			if [ -d "$$src" ]; then \
				cp -av "$$src" "$$(dirname $$dest)"; \
			else \
				cp -v "$$src" "$$dest"; \
			fi \
		else \
			echo "⚠️  Warning: $$src not found. Skipping."; \
		fi \
	done
	@echo "✅ Dotfiles restored successfully."

install:
	$(call print_header,✨ Installing cool apps...)
	brew install ghostty fish neovim git gnupg pinentry-mac
	brew install direnv ripgrep fd
	brew install delta lazygit tig fzf gh
	@echo "✅ Apps installed sucessfully."

settings:
	$(call print_header,🚓 Setting up shell, hostname, etc...)
	@echo "🐟 Ensuring Fish is in /etc/shells..."
	if ! grep -q "$(shell which fish)" $(SHELL_FILE); then \
		sudo tee -a $(SHELL_FILE) <<< "$(shell which fish)"; \
	fi
	@echo "⚙️ Setting Fish as default shell..."
	chsh -s "$(shell which fish)"

	@echo "⚙️ Setting host name to $(HOST_NAME)..."
	sudo scutil --set HostName $(HOST_NAME)
	sudo scutil --set LocalHostName $(HOST_NAME)
	sudo scutil --set ComputerName $(HOST_NAME)

	@echo "🔇 Disabling boot sound..."
	sudo nvram StartupMute=%01
	@echo "🔒 Setting immediate password requirement after screen saver begins..."
	sysadminctl -screenLock immediate -password -
	@echo "✅ macOS system settings applied."

preferences:
	$(call print_header,🧙‍♂️ Applying macOS preferences...)
	./preferences.sh
	@echo "🔄 Restart Dock and Finder"
	killall Dock || true
	killall Finder || true
	@echo "✅ macOS preferences applied."

clean: backup
	$(call print_header,🧹 Removing configuration files...)
	@for file in $(DOTFILES); do \
		target="$$HOME/$$file"; \
		[ -f "$$target" ] && rm -v "$$target" || true; \
	done
	@echo "✅ All configuration files removed."

.PHONY: all backup restore install settings preferences clean

