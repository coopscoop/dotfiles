# ── Antigen ────────────────────────────────────────────────────────────────────
source ~/dotfiles/zsh/plugins/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting
antigen apply

# ── Antigen Binds ────────────────────────────────────────────────────────────────────
bindkey '^Y' autosuggest-accept # Ctrl-y

# ── Environment ────────────────────────────────────────────────────────────────
export EDITOR=nvim
export OLLAMA_API_BASE=http://localhost:11434
export PATH="/home/coop/.opencode/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# ── HISTFILE setup ─────────────────────────────────────────────────────────────────
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt SHARE_HISTORY

# ── NVM ────────────────────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]]          && source "$NVM_DIR/nvm.sh"
[[ -s "$NVM_DIR/bash_completion" ]] && source "$NVM_DIR/bash_completion"

# ── Google Cloud SDK ───────────────────────────────────────────────────────────
[[ -f '/home/coop/Downloads/google-cloud-sdk/path.zsh.inc' ]]       && source '/home/coop/Downloads/google-cloud-sdk/path.zsh.inc'
[[ -f '/home/coop/Downloads/google-cloud-sdk/completion.zsh.inc' ]] && source '/home/coop/Downloads/google-cloud-sdk/completion.zsh.inc'

# ── Aliases ────────────────────────────────────────────────────────────────────
alias ll="ls -la"
alias vim="nvim"
alias tkill="tmux kill-server"

# ── On Boot Check For Tmux ─────────────────────────────────────────────────────────────────
if [ -z "$TMUX" ]; then
  tmux new-session -A -s main
fi

# ── Shell Init ─────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# remove vi mode in shell but keep vim type copy mode movements
bindkey -e
