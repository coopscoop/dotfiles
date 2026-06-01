# default editor to nvim
export EDITOR=nvim

# alias
alias ll="ls -la"
alias devhobo="~/.local/bin/devhobo/start-dev"
alias vim="nvim"

# nvm init
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# ollama api
export OLLAMA_API_BASE=http://localhost:11434

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/home/coop/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/home/coop/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/home/coop/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/home/coop/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# opencode
export PATH=/home/coop/.opencode/bin:$PATH

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
