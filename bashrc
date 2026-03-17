# ~/.bashrc

# If not running interactively, don't do anything

[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]$ '

# Default editor

export EDITOR=nano
export VISUAL=nano

# Add ~/.local/bin to PATH

export PATH="$HOME/.local/bin:$PATH"

# Auto-mount /dev/vdb if available

if [ -e /dev/vdb ]; then
sudo mkdir -p /mnt/vdb
if ! mountpoint -q /mnt/vdb; then
sudo mount /dev/vdb /mnt/vdb
fi
fi

# System info

clear
fastfetch
echo ""
echo "Package Manager: XBPS"
echo ""

alias cls="clear && fastfetch && echo ''"
alias neofetch="fastfetch && echo ''"

# Helper: enter full vdb environment

alias vdb="sudo xbps-uunshare -r /mnt/vdb"

# Optional: quick start X inside vdb

startx_vdb() {
sudo xbps-uunshare -r /mnt/vdb startx
}

# Tmux / X prompt

if command -v tmux >/dev/null 2>&1; then
if [ -z "$TMUX" ] && [[ $(tty) == /dev/tty* ]]; then
read -p "1. tmux ; 2. startx (vdb) ; anything else = shell: " choice
case $choice in
1)
exec tmux
;;
2)
exec sudo xbps-uunshare -r /mnt/vdb startx
;;
*)
echo "ok."
;;
esac
fi
fi

. "$HOME/.local/bin/env"
