# load colors & vcs info
autoload -Uz add-zsh-hook vcs_info
autoload -U colors && colors

# git integration & prompt
setopt prompt_subst
add-zsh-hook precmd vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*' formats '⎇ %b%u%c'
zstyle ':vcs_info:git*' actionformats '%F{14}⏱ %*%f'
zstyle ':vcs_info:git*' unstagedstr '*'
zstyle ':vcs_info:git*' stagedstr '+'
zstyle ':vcs_info:*:*' check-for-changes true

PROMPT=$'%F{yellow}[%f%F{8}%n%f%F{yellow}]%f %F{yellow}●%f %~ %F{yellow}> %f'
RPROMPT=' ${vcs_info_msg_0_}'

# basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# vim mode
bindkey -v
export KEYTIMEOUT=1

# vim keys in tab complete menu
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history

# change cursor shape for vim modes
function zle-keymap-select {
    if [[ ${KEYMAP} == vimcmd ]] ||
       [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
    elif [[ ${KEYMAP} == main ]] ||
         [[ ${KEYMAP} == viins ]] || 
         [[ ${KEYMAP} == '' ]]  ||
         [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
    fi
}
zle -N zle-keymap-select
zle-line-init() {
        zle -K viins
        echo -ne '\e[5 q'
}
zle -N zle-line-init
echo -ne '\e[5 q'
preexec() { echo -ne '\e[5 q' ;}

# aliases
alias ls="exa"
alias ..="cd .."
alias cp="cp -i"
alias mv="mv -i"
alias rm="rf -i"