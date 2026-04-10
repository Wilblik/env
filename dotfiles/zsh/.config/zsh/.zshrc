# ==========================================
# ENV
# ==========================================

# Force gemini CLI to use true color
export COLORTERM=truecolor

# Home cleanup
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_BIN_HOME="$HOME/.local/bin"

export GOBIN="$XDG_BIN_HOME"

[[ -d "$XDG_STATE_HOME/zsh" ]] || mkdir -p "$XDG_STATE_HOME/zsh"
export HISTFILE="$XDG_STATE_HOME/zsh/history"
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg

# Preferred editor
export EDITOR="nvim"
export VISUAL="emacsclient -nc"

# Add programs to PATH
export PATH="$PATH:$XDG_BIN_HOME:$HOME/.config/emacs/bin:$HOME/.dotnet/tools" #:$XDG_DATA_HOME/cargo/bin"

# Enable Powerlevel10k instant prompt
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ==========================================
# OH MY ZSH
# ==========================================

# Manual installation
export ZSH="$XDG_DATA_HOME/ohmyzsh"

# Plugins
plugins=(
    git
    vi-mode 
    zsh-autosuggestions
    zsh-syntax-highlighting
)

# Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Command execution time stamp shown in the history command output
HIST_STAMPS="dd.mm.yyyy"

# Controls whether the cursor style is changed when switching vi modes
VI_MODE_SET_CURSOR=true

source $ZSH/oh-my-zsh.sh

# ==========================================
# ALIASES
# ==========================================

# Protects against stupid mistakes :)
alias rm='rm -I'

# List
alias ls='ls --color=auto'
alias la='ls -A'
alias ll='ls -lAh'
alias l='ls'
alias l.="ls -A | egrep '^\.'"
alias lg='ls | grep'
alias llg='ls -lAh | grep'
alias lag='ls -A | grep'

# Package management
alias yas='yay -S'
alias yasu='yay -Syu'
alias yar='yay -Rsn'
alias yaq='yay -Qi'
alias yaqi='yay -Q --info'
alias yac='yay -Yc'
alias yaf='yay -Fy'

# Colorize the grep command output for ease of use (good for log files)
alias grep='grep --color=auto'

# Readable output for df
alias df='df -h'

# Get the error messages from journalctl
alias jctle="journalctl -p 3 -xb"

# Extractor for all kinds of archives
ex ()
{
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1   ;;
      *.tar.gz)    tar xzf $1   ;;
      *.bz2)       bunzip2 $1   ;;
      *.rar)       unrar x $1   ;;
      *.gz)        gunzip $1    ;;
      *.tar)       tar xf $1    ;;
      *.tbz2)      tar xjf $1   ;;
      *.tgz)       tar xzf $1   ;;
      *.zip)       unzip $1     ;;
      *.Z)         uncompress $1;;
      *.7z)        7z x $1      ;;
      *.deb)       ar x $1      ;;
      *.tar.xz)    tar xf $1    ;;
      *.tar.zst)   tar xf $1    ;;
      *)           echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# ==========================================
# END
# ==========================================

# Load Powerlevel10k configuration from XDG compliant path
[[ ! -f "$XDG_CONFIG_HOME/zsh/.p10k.zsh" ]] || source "$XDG_CONFIG_HOME/zsh/.p10k.zsh"
