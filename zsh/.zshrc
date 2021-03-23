export PATH=$HOME/bin:/usr/local/bin:$PATH:/opt/local/bin:/Users/s3np41k1r1t0/.cargo/bin:$HOME/SageMath
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$PATH:/Library/Java/JavaVirtualMachines/jdk1.8.0_212.jdk/Contents/Home/bin"

export ZSH="/Users/s3np41k1r1t0/.oh-my-zsh"
ZSH_THEME="beerbelly"
#ZSH_THEME="gentoo"

plugins=(git)

source $ZSH/oh-my-zsh.sh

export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

alias vim="/usr/local/bin/nvim -p"
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.config/nvim/init.vim"
alias l="exa "
alias ctf="cd ~/Ctf"
alias home="sudo wg-quick up orc"
alias wake="wakeonlan -i s3np41.ddns.net -p 9 f0:79:59:8c:14:ad"
alias down="sudo wg-quick down orc"
alias ld="lazydocker"
alias lg="lazygit"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
#source /usr/share/fzf/key-bindings.zsh
