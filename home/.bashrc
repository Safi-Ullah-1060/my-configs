#!/bin/bash

#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias cls="clear"
alias update-boot="sudo bootctl update"
alias ls='eza --icons'
alias grep='grep --color=auto'
export km="$HOME/dotfiles/Keymaps.md"
export uni="$HOME/Uni-Data/Sem-IV"
export cfg="$HOME/.config"
export EDITOR="nvim"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
source "$HOME/.fzf-tab-completion/bash/fzf-bash-completion.sh"
bind -x '"\t": fzf_bash_completion'
_fzf_bash_completion_loading_msg() { echo "${PS1@P}${READLINE_LINE}" | tail -n1; }
export FZF_COMPLETION_AUTO_COMMON_PREFIX=true
export FZF_COMPLETION_AUTO_COMMON_PREFIX_PART=true
eval "$(zoxide init bash)"
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
PS1="\[$(tput setaf 2)\]\u\[$(tput sgr0)\] in \[$(tput setaf 2)\]\h \[$(tput setaf 3)\]\e[1m\W\e[23m \[$(tput setaf 4)\]$\[$(tput sgr0)\] "
PS2="\[$(tput setaf 4)\]$\[$(tput sgr0)\] "
. "/home/safi/.deno/env"
. "$HOME/.cargo/env"
