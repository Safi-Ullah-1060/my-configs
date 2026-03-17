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

echo "==> Installing CachyOS kernel and performance tweaks..."

# Enable COPR repos
sudo dnf copr enable bieszczaders/kernel-cachyos -y
sudo dnf copr enable bieszczaders/kernel-cachyos-addons -y

# Install kernel and addons
sudo dnf install -y kernel-cachyos{,-core,-devel{,-matched},-modules}
sudo dnf install -y cachyos-settings cachyos-ksm-settings scx-scheds --allowerasing

# Kernel cmdline
grep -q "skew_tick=1" /etc/kernel/cmdline || echo "skew_tick=1" | sudo tee -a /etc/kernel/cmdline

# Copy system configs
sudo cp "$DOTFILES_DIR/etc/sysctl/99-sysctl-custom.conf" /etc/sysctl.d/
sudo cp "$DOTFILES_DIR/etc/tmpfiles/system_config.conf" /etc/tmpfiles.d/
sudo cp "$DOTFILES_DIR/etc/scx_loader/config.toml" /etc/scx_loader/

# Enable services
sudo systemctl enable --now pci-latency.service
sudo systemctl enable --now scx_loader

# SELinux relabel
sudo fixfiles -F onboot

# Rebuild initramfs
sudo dracut -fv --kver $(ls /lib/modules | grep -i cachyos | head -n 1)

echo ""
echo "==> Done. Reboot and select CachyOS kernel in GRUB."
