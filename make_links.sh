#!/bin/env bash


HOME=/home/$USER

case $1 in
	"docker")
		HOME=/root
		;;
esac

ln -s `pwd`/nvim/init.vim $HOME/.config/nvim/init.vim 
ln -s `pwd`/nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json 
ln -s `pwd`/tmux/.tmux.conf $HOME/.tmux.conf
