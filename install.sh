#!/bin/bash
set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Setting up dotfiles..."

# Symlink .config
if [ -L "$HOME/.config" ]; then
    echo "~/.config symlink already exists, skipping."
elif [ -d "$HOME/.config" ]; then
    echo "Backing up existing ~/.config to ~/.config.bak"
    mv "$HOME/.config" "$HOME/.config.bak"
    ln -s "$DOTFILES_DIR/config" "$HOME/.config"
else
    ln -s "$DOTFILES_DIR/config" "$HOME/.config"
fi

# Install and configure deno
curl -fsSL https://deno.land/install.sh | sh
sudo ln -s ~/.deno/bin/deno /usr/local/bin/deno

