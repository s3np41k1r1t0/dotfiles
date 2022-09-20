#!/usr/bin/env bash


HOME=/home/s3np41k1r1t0

mkdir -p $HOME/.config/nvim
ln -s $HOME/dotfiles/nvim/init.vim $HOME/.config/nvim/init.vim 
ln -s $HOME/dotfiles/nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json 
ln -s $HOME/dotfiles/tmux/.tmux.conf $HOME/.tmux.conf
