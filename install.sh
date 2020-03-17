#!/bin/bash

# Install msft repos
cd /tmp
wget -q https://packages.microsoft.com/config/ubuntu/18.04/packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

# Nextcloud ppa
sudo add-apt-repository ppa:nextcloud-devs/client
sudo apt-get update

# Enable the "universe" repositories
sudo add-apt-repository universe

sudo apt update

# install pkgs
pkg_list=( "git" "fonts-powerline" "tmux" "speedtest-cli" "htop"
	"remmina" "remmina-plugin-rdp" "remmina-plugin-secret" "remmina-plugin-spice"
	"nmap" "screen" "powershell" "vim" "tilix" "chromium-browser" "curl" "neofetch"
	"wireshark" "virtualbox" "virtualbox-guest-utils" "virtualbox-guest-dkms"
	"virtualbox-guest-x11" "vagrant-sshfs" "vagrant-lxc" "vagrant-digitalocean"
	"powerline" "vim-airline" "apt-transport-https" )

apt install -y "${pkg_list[@]}"

# Install nerd font 
cd /tmp
mkdir ~/.fonts/
wget -q https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Hack.zip
unzip /tmp/Hack.zip -d ~/.fonts/
fc-cache -fv

# Dotfiles
touch ~/.pwsh_history
mkdir ~/.config/powershell/
#git clone https://github.com/qovert/dotfiles.git
#cd dotfiles
ln -sv ~/dotfiles/pwsh_linux ~/.config/powershell/profile.ps1
ln -sv ~/dotfiles/tmux.conf ~/.tmux.conf
ln -sv ~/dotfiles/vimrc ~/.vimrc
ln -sv ~/dotfiles/gitconfig ~/.gitconfig
