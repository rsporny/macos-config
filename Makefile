# Variables
SHELL_FILE = /etc/shells
GHOSTTY_CONFIG_DIR := ~/.config/ghostty
GHOSTTY_CONFIG_FILE := $(GHOSTTY_CONFIG_DIR)/config
FISH_CONFIG_DIR := ~/.config/fish
FISH_CONFIG_FILE := $(FISH_CONFIG_DIR)/config.fish
GIT_CONFIG_DIR := ~/.config/git
GIT_CONFIG_FILE := $(GIT_CONFIG_DIR)/config
GIT_REPOS_DIR := ~/work/repos
GPG_AGENT_CONF_DIR := ~/.gnupg
GPG_AGENT_CONF_FILE := $(GPG_AGENT_CONF_DIR)/gpg-agent.conf
BACKUP_DIR := ~/config_backups/$(shell date +%Y-%m-%d_%H-%M-%S)


# Targets
install:
	brew install ghostty fish neovim git gnupg pinentry-mac

terminal: $(GHOSTTY_CONFIG_FILE)
$(GHOSTTY_CONFIG_FILE):
	mkdir -p $(GHOSTTY_CONFIG_DIR)
	@echo "Creating Ghostty configuration in $(GHOSTTY_CONFIG_FILE)..."
	@echo "font-size = 18" > $(GHOSTTY_CONFIG_FILE)
	@echo "theme = rose-pine" >> $(GHOSTTY_CONFIG_FILE)

shell: $(FISH_CONFIG_FILE)
$(FISH_CONFIG_FILE):
	@echo "Adding Fish to /etc/shells (if not already present)..."
	if ! grep -q "$(shell which fish)" $(SHELL_FILE); then \
		sudo tee -a $(SHELL_FILE) <<< "$(shell which fish)" || \
			(echo "Error: Failed to append Fish to /etc/shells." && exit 1); \
	fi
	@echo "Setting Fish as default shell..."
	chsh -s "$(shell which fish)" || \
		(echo "Error: Failed to set Fish as default shell." && exit 1)
	mkdir -p $(FISH_CONFIG_DIR)
	@echo "Creating Fish shell configuration in $(FISH_CONFIG_FILE)..."
	@echo 'if status is-interactive' > $(FISH_CONFIG_FILE)
	@echo '    abbr --add -- ll "ls -lha"' >> $(FISH_CONFIG_FILE)
	@echo '    abbr --add -- vim nvim' >> $(FISH_CONFIG_FILE)
	@echo 'end' >> $(FISH_CONFIG_FILE)
	@echo "Fish shell configuration has been set up successfully!"

git: $(GIT_CONFIG_FILE)
$(GIT_CONFIG_FILE):
	mkdir -p $(GIT_REPOS_DIR)
	mkdir -p $(GIT_CONFIG_DIR)
	@echo "Creating Git configuration in $(GIT_CONFIG_FILE)..."
	@echo "[commit]" > $@
	@echo "    gpgSign = true" >> $@
	@echo "" >> $@
	@echo "[tag]" >> $@
	@echo "    gpgSign = true" >> $@
	@echo "" >> $@
	@echo "[user]" >> $@
	@echo "    email = \"404@rspo.dev\"" >> $@
	@echo "    name = \"Radosław Sporny\"" >> $@
	@echo "    signingKey = \"15AC8EA84FC2A5AE768FFD753CEBBA453DE5BCFD\"" >> $@

gpg: $(GPG_AGENT_CONF_FILE)
$(GPG_AGENT_CONF_FILE):
	mkdir -p $(GPG_AGENT_CONF_DIR)
	@echo "Creating GPG agent configuration in $(GPG_AGENT_CONF_FILE)..."
	@echo "pinentry-program /opt/homebrew/bin/pinentry-mac" > $@

plist:
	gpg -d preferences.tar.gz.gpg > preferences.tar.gz
	tar -xzf preferences.tar.gz
	defaults import .GlobalPreferences.plist ./preferences/global.plist
	defaults import com.apple.finder.plist ./preferences/finder.plist
	defaults import com.apple.dock.plist ./preferences/dock.plist
	defaults import com.apple.AppleMultitouchTrackpad.plist ./preferences/trackpad.plist
	defaults import com.apple.driver.AppleBluetoothMultitouch.trackpad.plist ./preferences/trackpad-bluetooth.plist

all: install terminal shell git gpg plist

backup:
	@echo "Creating backup in $(BACKUP_DIR)..."
	mkdir -p $(BACKUP_DIR)
	cp -r $(GHOSTTY_CONFIG_FILE) $(BACKUP_DIR)/
	cp -r $(FISH_CONFIG_FILE) $(BACKUP_DIR)/
	cp -r $(GIT_CONFIG_FILE) $(BACKUP_DIR)/
	cp -r $(GPG_AGENT_CONF_FILE) $(BACKUP_DIR)/
	@echo "Backup completed successfully!"

clean: backup
	@echo "Removing configurations..."
	rm -f $(GHOSTTY_CONFIG_FILE)
	rm -f $(FISH_CONFIG_FILE)
	rm -f $(GIT_CONFIG_FILE)
	rm -f $(GPG_AGENT_CONF_FILE)
	@echo "All configuration files removed."

.PHONY: all install clean backup

