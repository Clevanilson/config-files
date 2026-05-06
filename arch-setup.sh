#!/bin/zsh

echo "Updating system"

sudo pacman -Syyuu --noconfirm

echo "Installing steam"

sudo pacman -Syu steam --noconfirm

echo "Installing yay"

sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd

echo "installing brave"

yay -S brave-bin --noconfirm

echo "Creating develop dir"

mkdir develop

ssh-keygen -t ed25519 -C "clevanilson.contato@gmail.com"

yay -S vscodium-bin

sudo pacman -S linux618-nvidia-open
