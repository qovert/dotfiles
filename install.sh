#!/bin/bash

# Install nerd font 
#cd /tmp
#mkdir ~/.fonts/
#wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
#unzip /tmp/Hack.zip -d ~/.fonts/
#fc-cache -fv

# Dotfiles
touch ~/.pwsh_history
#mkdir ~/.config/powershell/
#git clone https://github.com/qovert/dotfiles.git
#cd dotfiles
ln -sv ~/dotfiles/pwsh_linux ~/.config/powershell/profile.ps1
ln -sv ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sv ~/dotfiles/vimrc ~/.vimrc
ln -sv ~/dotfiles/gitconfig ~/.gitconfig
