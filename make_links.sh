#!/bin/env bash


HOME=/home/$USER

mkdir -p $HOME/.config/nvim
ln -s `pwd`/nvim/init.vim $HOME/.config/nvim/init.vim 
ln -s `pwd`/nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json 
ln -s `pwd`/tmux/.tmux.conf $HOME/.tmux.conf
