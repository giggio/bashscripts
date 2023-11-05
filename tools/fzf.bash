if ! [ -d "$HOME/.fzf" ]; then return; fi

# Setup fzf
if [[ ! "$PATH" == */$HOME/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/$HOME/.fzf/bin"
fi

# Auto-completion
# shellcheck source=/dev/null
[[ $- == *i* ]] && source "$HOME/.fzf/shell/completion.bash" 2> /dev/null

# Key bindings
# shellcheck source=/dev/null
source "$HOME/.fzf/shell/key-bindings.bash"

# Use fd if available
if hash fd 2>/dev/null; then
  export FZF_DEFAULT_COMMAND="fd --type file --color=always --exclude .git"
  export FZF_DEFAULT_OPTS="--ansi"
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
fi
