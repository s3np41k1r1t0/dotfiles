export PATH=$PATH:$HOME/.bin:/opt/local/bin:$HOME/.cargo/bin

export ZSH="/Users/s3np41k1r1t0/.oh-my-zsh"
#ZSH_THEME="beerbelly"
ZSH_THEME="gentoo"

plugins=(git)

#export LC_CTYPE=en_US.UTF-8
#export LC_ALL=en_US.UTF-8

source $ZSH/oh-my-zsh.sh

alias vim="/usr/local/bin/nvim -p"
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.config/nvim/init.vim"
alias l="exa"
alias ld="lazydocker"
alias lg="lazygit"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#source /usr/share/fzf/key-bindings.zsh
