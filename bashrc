# .bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

# Set default editor to nano
export EDITOR=nano
export VISUAL=nano

export XAUTHORITY=/mnt/vdb/home/void/.Xauthority

# Add ~/.local/bin to path
export PATH="$HOME/.local/bin:$PATH"

# Auto-mount /dev/vdb if available and add its bin directory to PATH
if [ -e /dev/vdb ]; then
    sudo mkdir -p /mnt/vdb
    if ! mountpoint -q /mnt/vdb; then
        sudo mount /dev/vdb /mnt/vdb
    fi
    if [ -e /mnt/vdb/bin ]; then
        export PATH="/mnt/vdb/bin:/mnt/vdb/usr/bin:$PATH"
    fi
fi

# GitHub Personal Access Token (public repos only. Expires April 15 2026)
export PAT="redacted"

clear
fastfetch
echo ""
echo "Package Manager: XBPS"
echo ""

alias cls="clear && fastfetch && echo ''"
alias neofetch="fastfetch && echo ''"
alias startx="sudo mount --bind /dev /mnt/vdb/dev && sudo mount --bind /proc /mnt/vdb/proc && sudo mount --bind /sys /mnt/vdb/sys && sudo mount --bind /run /mnt/vdb/run && sudo chroot /mnt/vdb startx"

if command -v tmux >/dev/null 2>&1; then
	if [ -z "$TMUX" ] && [ "$(tty)" != "not a tty" ] && [[ $(tty) == /dev/tty* ]]; then
		read -p "1. tmux ; 2. startx" choice
		case $choice in
			1)
				exec tmux
				;;
			2)
				sudo mount --bind /dev /mnt/vdb/dev
				sudo mount --bind /proc /mnt/vdb/proc
				sudo mount --bind /sys /mnt/vdb/sys
				sudo mount --bind /run /mnt/vdb/run
				exec sudo chroot /mnt/vdb startx
				;;
			*)
				echo "ok."
				;;
		esac
	fi
fi

. "$HOME/.local/bin/env"
