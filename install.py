#!/usr/bin/python3

import sys,shutil,os
from os.path import join as join_dir

paths = {"iterm2":"~/.iterm2", \
         "i3-gaps":"~/.i3","polybar":"~/.config/polybar","rofi":"~/.config/rofi","alacritty":"~/.config/alacritty","nitrogen":"~/.config/nitrogen", \
         "doom-emacs":"~/.doom.d","nvim":"~/.config/nvim","zsh/.zshrc":"~/.zshrc","tmux":"~/.tmux","tmux/.tmux.conf":"~/.tmux.conf"}

HOME = os.path.expanduser("~")

for k in paths.keys():
    paths[k] = paths[k].replace("~",HOME)

macos = ["iterm2"]
linux = ["i3-gaps","polybar","rofi","alacritty","nitrogen"]
common = ["doom-emacs","nvim","zsh/.zshrc","tmux","tmux/.tmux.conf"]


def welp():
    print("Usage: ./update.py <install,update> <macos,linux,common>")
    exit(1)

def install(src,dst):
    if os.path.exists(dst):
        backup = dst+"_backup"
        os.rename(dst,backup)

    if os.path.isdir(src):
        shutil.copytree(src,dst)
    elif os.path.exists(src):
        shutil.copyfile(src,dst)
    else:
        raise

def do_install(choice):
    for path in globals()[choice]:
        src = join_dir(os.getcwd(),path)
        dst = join_dir(HOME,paths[path])
        install(src,dst)

def do_install_by_choice(choice):
    if not (choice == "macos" or choice == "linux"):
        welp()
    if not os.path.exists(join_dir(HOME,".config")):
        os.mkdir(join_dir(HOME,".config"))
    do_install(choice)
    do_install("common")

def do_update(choice):
    if not (choice == "macos" or choice == "linux"):
        welp()
    pass

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(len(sys.argv))
        welp()

    if sys.argv[1] == "install":
        do_install_by_choice(sys.argv[2])
    elif sys.argv[1] == "update":
        do_update(sys.argv[2])
    else:
        print(sys.argv)
        welp()


"""
MACOS
iterm2

LINUX
i3-gaps
polybar
rofi
alacritty
nitrogen

COMMON
doom emacs
nvim
zsh
tmux
"""

"""
INSTALL LIST GENTOO
zsh
fzf
i3-gaps
polybar
rofi
emacs + doom
neovim
tmux
tar
docker
libvirt
alacritty
virt-manager
python
perl
lua
go
rust-bin
git
spotify
ffmpeg
htop, iftop
openresolv
ufw
discord-bin
zoom
gdb
binutils
firefox-bin
google-chrome
GROUPS: audio, docker, kvm, libvirt, openvpn, qemu, sshd, video
"""
