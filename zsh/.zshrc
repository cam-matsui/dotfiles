# set up vim bindings
set -o vi

# set nvim as default editor
export EDITOR=nvim

# use eza as ls with linking for kitty
alias ls='eza --hyperlink'

# set up Node Version Manager (nvm)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='[\[\e[38;5;155;1;2;3m\]\u\[\e[0m\]] \w (${PS1_CMD1}) >'

autoload -Uz add-zsh-hook vcs_info
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

export PATH="$HOME/.local/bin:$PATH"

# basic auto/tab complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

profile() { export AWS_PROFILE="$1"; }
region() { export AWS_DEFAULT_REGION="$1"; }

# aws shit
aws_profile() {
    export AWS_PROFILE=$(grep profile ~/.aws/config \
    | awk '{print $2}' \
    | tr -d ']' \
    | fzf)
}

# terraform shit
if [[ "$OSTYPE" == "darwin"* ]]; then
    . $(brew --prefix asdf)/libexec/asdf.sh
fi

# direnv shit
eval "$(direnv hook zsh)"

# kubectl shit
function kube_from_cp() {
  if [[ $# -lt 2 || $# -gt 3 ]]; then
    echo "Usage: kube_from_cp <pod_name> <remote_file_path> [container_name]"
    return 1 
  fi

  local pod_name=$1
  local remote_file_path=$2
  local file_name=$(basename "$remote_file_path")

  if [[ -n $3 ]]; then
    local container_name=$3
    kubectl cp -c "$container_name" "$pod_name:$remote_file_path" "./$file_name"
  else
    kubectl cp "$pod_name:$remote_file_path" "./$file_name"
  fi
}
