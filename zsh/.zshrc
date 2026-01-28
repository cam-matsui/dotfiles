# set up vim bindings
set -o vi

# set nvim as default editor
export EDITOR=nvim

# use eza as ls with linking for kitty
alias ls='eza --hyperlink'

# git shortcuts
alias ga='git add'
alias gc='git commit'
alias gco='git checkout'
alias gpush='git push'
alias gpull='git pull'
alias gs='git status'
alias gb='git branch'

# ghostty list keybinds
alias keybinds='ghostty +list-keybinds --default'

start_dbt() {
    export $(grep -v '^#' .env | xargs)
    source .venv/bin/activate
    dbt compile
}

# for mbe tests
test_domain() {
  local domain=""
  local make_target="qtest"
  local args=()

  # Parse arguments
  for arg in "$@"; do
    case $arg in
      -p|--parallel)
        make_target="qtest-parallel"
        ;;
      --*)
        args+=("$arg")
        ;;
      *)
        if [[ -z $domain ]]; then
          domain=$arg
        else
          args+=("$arg")
        fi
        ;;
    esac
  done

  if [[ -z $domain ]]; then
    echo "usage: qtest <domain> [--pytest-flags...] [-p|--parallel]"
    return 1
  fi

  make "$make_target" t="tests/pytest/large/${domain} tests/pytest/small_medium/${domain} ${args[@]}"
}

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

alias dmi-all-hands='git game \
  --include-author-file=/Users/cameron.matsui/Documents/team-members.csv \
  --repo=/Users/cameron.matsui/Documents/dbt/ \
  --repo=/Users/cameron.matsui/Documents/whatnot_backend \
  --repo=/Users/cameron.matsui/Documents/admin2-retool/ \
  --repo=/Users/cameron.matsui/Documents/dagster-workflows-core/ \
  --repo=/Users/cameron.matsui/Documents/whatnot-ml/ \
  --repo=/Users/cameron.matsui/Documents/whatnot-android/ \
  --repo=/Users/cameron.matsui/Documents/iac_infra_snowflake/ \
  --repo=/Users/cameron.matsui/Documents/iac_infra_runtime/ \
  --repo=/Users/cameron.matsui/Documents/whatnot_web/ \
  --repo=/Users/cameron.matsui/Documents/iac_service_chalk/ \
  --repo=/Users/cameron.matsui/Documents/event-schema-registry/ \
  --repo=/Users/cameron.matsui/Documents/whatnot-ios/ \
  --repo=/Users/cameron.matsui/Documents/kafka_connect_deploy/ \
  --repo=/Users/cameron.matsui/Documents/shopify-sync/ \
  --repo=/Users/cameron.matsui/Documents/whatnot_backend_deploy/'
