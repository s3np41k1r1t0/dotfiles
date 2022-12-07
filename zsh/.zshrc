export ZSH="/home/s3np41k1r1t0/.oh-my-zsh"

# ZSH_THEME="s3np41"
# plugins=(git)

source $ZSH/oh-my-zsh.sh

export EDITOR="nvim"

export FZF_DEFAULT_OPTS="
--info=inline
--height=80%
--multi
--preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
--color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
--prompt='∼ ' --pointer='▶' --marker='✓'
--bind '?:toggle-preview'
--bind 'ctrl-a:select-all'
--bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
--bind 'ctrl-e:execute(echo {+} | xargs -o vim)'
--bind 'ctrl-v:execute(code {+})'
"

alias zshconfig="nvim ~/.zshrc && source ~/.zshrc"
alias vimconfig="nvim ~/.config/nvim/init.vim"
alias tmuxconfig="nvim ~/.tmux.conf"
alias dc="docker-compose"

alias vim="nvim -p"
alias rebuild="sudo nixos-rebuild switch"

# source /home/s3np41k1r1t0/.oh-my-zsh/lib/key-bindings.zsh

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

if [ -z "$(pgrep ssh-agent)" ]; then
    rm -rf /tmp/ssh-*
    eval $(ssh-agent -s) > /dev/null
    ssh-add ~/.ssh/lynx > /dev/null
    ssh-add ~/.ssh/git > /dev/null
else
    export SSH_AGENT_PID=$(pgrep ssh-agent)
    export SSH_AUTH_SOCK=$(find /tmp/ -name "agent.*" 2>/dev/null)
fi

export CHROME_EXECUTABLE="google-chrome-stable"
