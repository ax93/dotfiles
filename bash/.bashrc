#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#[ -f "$HOME/.config/dircolors" ] && eval "$(dircolors -b "$HOME/.config/dircolors")"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias palette='for i in {0..15}; do printf "\e[48;5;${i}m  %2d  \e[0m" $i; [ $((i % 8)) -eq 7 ] && echo; done'

alias sync='cd ~/dotfiles && git fetch origin && git reset --hard origin/main && ~/.config/theme/build.sh'

alias build='~/.config/theme/build.sh'


# theme switching
theme() {
    local name="$1"
    local theme_dir="$HOME/.config/theme"
    local target="palettes/${name}.env"
    local wallpaper="$HOME/Pictures/${name}.jpg"

    if [[ ! -f "$theme_dir/$target" ]]; then
        echo "no palette: $name" >&2
        echo "available: $(ls "$theme_dir/palettes/"*.env | xargs -n1 basename | sed 's/\.env$//' | tr '\n' ' ')" >&2
        return 1
    fi
    ln -sf "$target" "$theme_dir/palette.env"
    "$theme_dir/build.sh"
    [[ -f "$wallpaper" ]] && feh --bg-fill "$wallpaper"
    # reload running apps
    pgrep -x i3 >/dev/null && i3-msg restart >/dev/null

    echo "active: $name"
}

alias tactical='theme tactical'
alias neon='theme neon'

PS1='[\u@\h \W]\$ '

