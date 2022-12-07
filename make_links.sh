#!/usr/bin/env bash

HOME=/home/s3np41k1r1t0

mkdir -p $HOME/.config/nvim

# VIM
ln -s $HOME/dotfiles/nvim/ $HOME/.config/nvim 

# ZSH
ln -s $HOME/dotfiles/zsh/.zshrc $HOME/.zshrc
# ln -s $HOME/dotfiles/zsh/s3np41.zsh-theme $HOME/.oh-my-zsh/custom/themes/

# TMUX
ln -s $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf

# ROFI
ln -s $HOME/dotfiles/rofi $HOME/.config

# i3
ln -s $HOME/dotfiles/i3-gaps $HOME/.config/i3