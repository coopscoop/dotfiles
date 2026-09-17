# ── Antigen ────────────────────────────────────────────────────────────────────
source ~/dotfiles/zsh/plugins/antigen.zsh

antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-syntax-highlighting

antigen apply

# ── Environment ────────────────────────────────────────────────────────────────
export EDITOR=nvim
export PATH="/home/coop/.opencode/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/src/llama.cpp/build/bin:$PATH"
export PATH="$HOME/Apps/deepseek-harness/node_modules/.bin:$PATH"

# AI api bases
export OLLAMA_API_BASE=http://localhost:11434
export OPENAI_API_BASE=http://127.0.0.1:8080
export OPENAI_API_KEY=1234

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
alias qwen="llama-server \
  -m ~/models/qwen3.5/Qwen3.5-9B-IQ4_XS-MTP.gguf \
  -ngl 99 \
  -c 24576 \
  -fa on \
  -np 1 \
  --spec-type draft-mtp \
  --spec-draft-n-max 3 \
  --reasoning off"

# # ── On Boot Check For Tmux ─────────────────────────────────────────────────────────────────
# if [ -z "$TMUX" ]; then
#   tmux new-session -A -s main
# fi

# ── Shell Init ─────────────────────────────────────────────────────────────────
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"
eval "$(starship init zsh)"

# remove vi mode in shell but keep vim type copy mode movements
bindkey -e
bindkey '^Y' autosuggest-accept # Ctrl-y

# pnpm
export PNPM_HOME="/home/coop/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end
export PATH=/usr/local/cuda-13.3/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-13.3/lib64:$LD_LIBRARY_PATH

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - bash)"

eval "$(pyenv virtualenv-init -)"

export CC=/usr/bin/gcc-15
export CXX=/usr/bin/g++-15
export NVCC_CCBIN=/usr/bin/g++-15
