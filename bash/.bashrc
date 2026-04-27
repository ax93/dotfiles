#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f "$HOME/.config/dircolors" ] && eval "$(dircolors -b "$HOME/.config/dircolors")"

alias ls='ls --color=auto'
alias grep='grep --color=auto'

alias palette='for i in {0..15}; do printf "\e[48;5;${i}m  %2d  \e[0m" $i; [ $((i % 8)) -eq 7 ] && echo; done'

alias sync='cd ~/dotfiles && git fetch origin && git reset --hard origin/main && ~/.config/theme/build.sh'

PS1='[\u@\h \W]\$ '

