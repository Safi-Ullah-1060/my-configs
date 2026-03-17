# ~/.config/fish/config.fish

# Disable default fish greeting
set -g fish_greeting

# Initialize Starship
starship init fish | source
alias cls="clear"
alias update-grub="sudo grub2-mkconfig -o /boot/grub2/grub.cfg"
alias ls='eza --icons=always --color=always'
alias ll='eza -la --icons=always --color=always'
alias lt='eza --tree --icons=always --color=always'
set -Ux uni "$HOME/Uni Data/Sem IV"
set -Ux cfg "$HOME/.config"
alias cachyos-update-kernel 'sudo dracut -fv --kver $(ls /lib/modules | grep -i cachyos | tail -1) && sudo grubby --set-default $(ls /boot/vmlinuz-*cachyos* | tail -1)'
# Optional: Better vi-mode cursor (if you use it)
# fish_vi_key_bindings

# Optional: Enable faster directory history navigation
# set -g dirhscount 2000
