#!/bin/bash

# =============================================================================
# Arch Linux Setup Script
# =============================================================================
# This script automates the initial setup for an Arch Linux installation,
# including system updates, directory creation, package installation,
# and basic service configuration.
# =============================================================================

# Exit immediately if a command exits with a non-zero status
set -e

# --- Configuration ---
DIRECTORIES=(
    "$HOME/Downloads"
    "$HOME/Images"
    "$HOME/develop"
)

# Packages to be installed via pacman
PACMAN_PACKAGES=(
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
    jq
    gawk
    openssh
    git
    base-devel
    sddm
    imv
    thunar
    amd-ucode
    wofi
    ttf-jetbrains-mono-nerd
    nwg-bar
    man-db
    grim
    slurp
    waybar
)

# --- Functions ---

# Informational messages
log() {
    echo -e "\n[INFO] $1"
}

# Update the system package database and upgrade all packages
update_system() {
    log "Updating system packages..."
    sudo pacman -Syyuu --noconfirm
}

# Create standard user directories
create_directories() {
    log "Creating base directories..."
    for dir in "${DIRECTORIES[@]}"; do
        if [ ! -d "$dir" ]; then
            mkdir -p "$dir"
            echo "Created: $dir"
        fi
    done
}

# Install official repository packages
install_pacman_packages() {
    log "Installing pacman packages..."
    sudo pacman -S --needed --noconfirm "${PACMAN_PACKAGES[@]}"
}

# Install yay (AUR Helper) if not already present
install_yay() {
    if ! command -v yay &> /dev/null; then
        log "Installing yay (AUR helper)..."
        local temp_dir
        temp_dir=$(mktemp -d)
        git clone https://aur.archlinux.org/yay.git "$temp_dir"
        pushd "$temp_dir" > /dev/null
        makepkg -si --noconfirm
        popd > /dev/null
        rm -rf "$temp_dir"
    else
        log "yay is already installed, skipping installation."
    fi
}

# Install packages from the Arch User Repository (AUR)
install_aur_packages() {
    log "Installing AUR packages..."
    yay -S vscodium-bin --noconfirm
}

# Enable essential system services
configure_services() {
    log "Configuring system services..."
    # Enable SDDM for graphical login
    sudo systemctl enable sddm
}

# Change the default shell to ZSH
setup_zsh() {
    if [[ "$SHELL" != "/bin/zsh" ]]; then
        log "Changing default shell to zsh..."
        chsh -s /bin/zsh
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ~/powerlevel10k
        echo 'source ~/powerlevel10k/powerlevel10k.zsh-theme' >>~/.zshrc
    else
        log "ZSH is already the default shell."
    fi
}

# Optional: Generate SSH key
# This is commented out by default as it requires user interaction/specific details.
generate_ssh_key() {
    # log "Generating SSH key..."
    # ssh-keygen -t ed25519 -C "clevanilson.contato@gmail.com"
    :
}

# --- Main Execution ---

main() {
    update_system
    create_directories
    install_pacman_packages
    install_yay
    install_aur_packages
    configure_services
    setup_zsh
    
    log "Setup complete! Please reboot your system to apply all changes."
}

# Execute main function
main "$@"
