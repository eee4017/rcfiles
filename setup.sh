#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"
BACKUP_CREATED=false

# ---------------------------------------------------------------------------
# Colors & helpers
# ---------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

info() { echo -e "${BLUE}::${NC} $1"; }
ok()   { echo -e "${GREEN}ok${NC} $1"; }
warn() { echo -e "${YELLOW}!!${NC} $1"; }
err()  { echo -e "${RED}!!${NC} $1"; }

# ---------------------------------------------------------------------------
# Banner
# ---------------------------------------------------------------------------
echo ""
echo "  +------------------------------------------------+"
echo "  |                                                |\\"
echo "  |       Frank Lin's dotfiles install script      | \\"
echo "  |                                                | |"
echo "  +------------------------------------------------+ |"
echo "   \\______________________________________________\\|"
echo ""

# ---------------------------------------------------------------------------
# backup_and_link <source> <destination>
#   - skips if already correctly linked
#   - backs up any existing file/dir before linking
# ---------------------------------------------------------------------------
backup_and_link() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ] && [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
        ok "$dst (already linked)"
        return
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        if [ "$BACKUP_CREATED" = false ]; then
            mkdir -p "$BACKUP_DIR"
            BACKUP_CREATED=true
        fi
        mv "$dst" "$BACKUP_DIR/"
        warn "backed up $dst → $BACKUP_DIR/"
    fi

    mkdir -p "$(dirname "$dst")"
    ln -sf "$src" "$dst"
    ok "$dst → $src"
}

# ---------------------------------------------------------------------------
# oh-my-zsh
# ---------------------------------------------------------------------------
info "Checking oh-my-zsh ..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    info "Installing oh-my-zsh (unattended) ..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    ok "oh-my-zsh already installed"
fi

# ---------------------------------------------------------------------------
# zsh plugins
# ---------------------------------------------------------------------------
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

clone_if_missing() {
    local repo="$1"
    local dest="$2"
    if [ ! -d "$dest" ]; then
        info "Cloning $repo ..."
        git clone --depth 1 "$repo" "$dest"
    else
        ok "$(basename "$dest") plugin already installed"
    fi
}

info "Checking zsh plugins ..."
clone_if_missing "https://github.com/zsh-users/zsh-autosuggestions" \
    "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
clone_if_missing "https://github.com/peterhurford/up.zsh" \
    "$ZSH_CUSTOM/plugins/up"

# ---------------------------------------------------------------------------
# Shell configs
# ---------------------------------------------------------------------------
info "Linking shell configs ..."
backup_and_link "$DOTFILES_DIR/zsh/zshrc"     "$HOME/.zshrc"
backup_and_link "$DOTFILES_DIR/zsh/zshrc.sup" "$HOME/.zshrc.sup"

# ---------------------------------------------------------------------------
# Vim
# ---------------------------------------------------------------------------
info "Linking vim config ..."
backup_and_link "$DOTFILES_DIR/vim/vimrc" "$HOME/.vimrc"

# ---------------------------------------------------------------------------
# Tmux
# ---------------------------------------------------------------------------
info "Linking tmux config ..."
backup_and_link "$DOTFILES_DIR/tmux/tmux.conf" "$HOME/.tmux.conf"

# ---------------------------------------------------------------------------
# X11 / Xorg
# ---------------------------------------------------------------------------
info "Linking X11 configs ..."
backup_and_link "$DOTFILES_DIR/xorg/xinitrc"    "$HOME/.xinitrc"
backup_and_link "$DOTFILES_DIR/xorg/Xresources" "$HOME/.Xresources"

# ---------------------------------------------------------------------------
# XDG ~/.config/ entries
# ---------------------------------------------------------------------------
info "Linking XDG configs (~/.config/) ..."
backup_and_link "$DOTFILES_DIR/config/i3"                     "$HOME/.config/i3"
backup_and_link "$DOTFILES_DIR/config/dunst"                  "$HOME/.config/dunst"
backup_and_link "$DOTFILES_DIR/config/ranger"                 "$HOME/.config/ranger"
backup_and_link "$DOTFILES_DIR/config/fcitx"                  "$HOME/.config/fcitx"
backup_and_link "$DOTFILES_DIR/config/autostart"              "$HOME/.config/autostart"
backup_and_link "$DOTFILES_DIR/config/libinput-gestures.conf" "$HOME/.config/libinput-gestures.conf"
backup_and_link "$DOTFILES_DIR/config/mimeapps.list"          "$HOME/.config/mimeapps.list"

# ---------------------------------------------------------------------------
# Jupyter
# ---------------------------------------------------------------------------
info "Linking Jupyter config ..."
backup_and_link "$DOTFILES_DIR/jupyter/custom" "$HOME/.jupyter/custom"

# ---------------------------------------------------------------------------
# Git submodules (i3blocks, etc.)
# ---------------------------------------------------------------------------
info "Initializing git submodules ..."
(cd "$DOTFILES_DIR" && git submodule update --init --recursive 2>/dev/null) \
    && ok "submodules ready" \
    || warn "could not initialize submodules (not critical)"

# ---------------------------------------------------------------------------
# Summary
# ---------------------------------------------------------------------------
echo ""
echo -e "${GREEN}Done!${NC}"
if [ "$BACKUP_CREATED" = true ]; then
    warn "Existing files backed up to: $BACKUP_DIR"
fi
echo ""
