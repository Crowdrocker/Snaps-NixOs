#!/bin/bash

# WehttamSnaps NixOS Gaming & Workstation Setup Script
# This script helps set up a complete NixOS system for gaming and productivity

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color

# Configuration
REPO_URL="https://github.com/Crowdrocker/Snaps-NixOS.git"
USERNAME="wehttamsnaps"
HOSTNAME="snaps-pc"
CONFIG_DIR="/etc/nixos"
HOME_CONFIG_DIR="/home/$USERNAME/.config"

# Functions
log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')] $1${NC}"
}

warn() {
    echo -e "${YELLOW}[WARNING] $1${NC}"
}

error() {
    echo -e "${RED}[ERROR] $1${NC}"
}

info() {
    echo -e "${BLUE}[INFO] $1${NC}"
}

check_root() {
    if [[ $EUID -ne 0 ]]; then
        error "This script must be run as root"
        exit 1
    fi
}

check_nixos() {
    if [[ ! -f /etc/NIXOS ]]; then
        error "This script is designed for NixOS only"
        exit 1
    fi
}

detect_hardware() {
    info "Detecting hardware..."
    
    # CPU detection
    CPU_VENDOR=$(grep -m1 "vendor_id" /proc/cpuinfo | awk '{print $3}')
    CPU_MODEL=$(grep -m1 "model name" /proc/cpuinfo | cut -d':' -f2 | sed 's/^ *//')
    
    # GPU detection
    if lspci | grep -i "nvidia" >/dev/null 2>&1; then
        GPU_VENDOR="nvidia"
        GPU_MODEL=$(lspci | grep -i "vga.*nvidia" | cut -d':' -f3-)
    elif lspci | grep -i "amd" >/dev/null 2>&1; then
        GPU_VENDOR="amd"
        GPU_MODEL=$(lspci | grep -i "vga.*amd" | cut -d':' -f3-)
    elif lspci | grep -i "intel" >/dev/null 2>&1; then
        GPU_VENDOR="intel"
        GPU_MODEL=$(lspci | grep -i "vga.*intel" | cut -d':' -f3-)
    else
        GPU_VENDOR="unknown"
        GPU_MODEL="unknown"
    fi
    
    log "Detected CPU: $CPU_VENDOR - $CPU_MODEL"
    log "Detected GPU: $GPU_VENDOR - $GPU_MODEL"
}

update_system() {
    log "Updating system packages..."
    nixos-rebuild switch --upgrade
}

install_base_packages() {
    log "Installing base packages..."
    
    # Install essential packages
    nix-env -iA nixos.git
    nix-env -iA nixos.curl
    nix-env -iA nixos.wget
    nix-env -iA nixos.vim
    nix-env -iA nixos.htop
    nix-env -iA nixos.neofetch
    
    log "Base packages installed successfully"
}

setup_flakes() {
    log "Setting up Nix flakes..."
    
    # Enable flakes
    mkdir -p /etc/nix
    cat > /etc/nix/nix.conf << EOF
experimental-features = nix-command flakes
auto-optimise-store = true
substituters = https://cache.nixos.org/ https://chaotic-nyx.cachix.org
trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/np++1Zm9xH2Hf1VXIKz1iNfZ5bCN4=
EOF
    
    log "Nix flakes configured"
}

clone_config() {
    log "Cloning configuration repository..."
    
    # Create backup of existing config
    if [[ -d "$CONFIG_DIR" ]]; then
        mv "$CONFIG_DIR" "${CONFIG_DIR}.backup.$(date +%Y%m%d_%H%M%S)"
        warn "Existing configuration backed up"
    fi
    
    # Clone repository
    git clone "$REPO_URL" "$CONFIG_DIR"
    
    log "Configuration repository cloned"
}

setup_user() {
    log "Setting up user configuration..."
    
    # Create user if it doesn't exist
    if ! id "$USERNAME" &>/dev/null; then
        useradd -m -G wheel,audio,video,games -s /bin/zsh "$USERNAME"
        passwd "$USERNAME"
        log "User $USERNAME created"
    else
        info "User $USERNAME already exists"
    fi
    
    # Set up home directory
    mkdir -p "/home/$USERNAME/.config"
    chown -R "$USERNAME:$USERNAME" "/home/$USERNAME/.config"
}

configure_git() {
    log "Configuring Git..."
    
    sudo -u "$USERNAME" git config --global user.name "Crowdrocker"
    sudo -u "$USERNAME" git config --global user.email "berksapexlegends@gmail.com"
    sudo -u "$USERNAME" git config --global init.defaultBranch "main"
    sudo -u "$USERNAME" git config --global pull.rebase true
    
    log "Git configured"
}

setup_hardware_config() {
    log "Setting up hardware configuration..."
    
    # Generate hardware configuration
    nixos-generate-config --root /
    
    # Copy to config directory
    cp /etc/nixos/hardware-configuration.nix "$CONFIG_DIR/hosts/$HOSTNAME/"
    
    log "Hardware configuration updated"
}

install_gaming_packages() {
    log "Installing gaming packages..."
    
    # Install Steam and gaming tools
    nix-env -iA nixos.steam
    nix-env -iA nixos.lutris
    nix-env -iA nixos.heroic
    nix-env -iA nixos.gamescope
    nix-env -iA nixos.gamemode
    nix-env -iA nixos.mangohud
    
    # Install AMD GPU tools
    if [[ "$GPU_VENDOR" == "amd" ]]; then
        nix-env -iA nixos.corectrl
        nix-env -iA nixos.lact
        log "AMD GPU tools installed"
    fi
    
    log "Gaming packages installed"
}

setup_audio() {
    log "Setting up audio configuration..."
    
    # Install audio tools
    nix-env -iA nixos.pavucontrol
    nix-env -iA nixos.qpwgraph
    nix-env -iA nixos.helvum
    
    # Enable PipeWire
    systemctl --user enable pipewire.service
    systemctl --user enable wireplumber.service
    
    log "Audio setup complete"
}

setup_jarvis() {
    log "Setting up J.A.R.V.I.S. integration..."
    
    # Create J.A.R.V.I.S. directories
    sudo -u "$USERNAME" mkdir -p "/home/$USERNAME/.config/jarvis/sounds"
    sudo -u "$USERNAME" mkdir -p "/home/$USERNAME/.config/jarvis/scripts"
    
    # Copy J.A.R.V.I.S. scripts
    cp "${CONFIG_DIR}/scripts/jarvis-cli.sh" "/home/$USERNAME/.config/jarvis/scripts/"
    chmod +x "/home/$USERNAME/.config/jarvis/scripts/jarvis-cli.sh"
    
    # Create symlink for easy access
    ln -sf "/home/$USERNAME/.config/jarvis/scripts/jarvis-cli.sh" "/usr/local/bin/jarvis"
    
    log "J.A.R.V.I.S. integration complete"
}

configure_desktop() {
    log "Configuring desktop environment..."
    
    # Install desktop packages
    nix-env -iA nixos.niri
    nix-env -iA nixos.kitty
    nix-env -iA nixos.alacritty
    
    # Create desktop directories
    sudo -u "$USERNAME" mkdir -p "/home/$USERNAME/Desktop"
    sudo -u "$USERNAME" mkdir -p "/home/$USERNAME/Pictures/wallpapers"
    sudo -u "$USERNAME" mkdir -p "/home/$USERNAME/Pictures/screenshots"
    
    log "Desktop configuration complete"
}

rebuild_system() {
    log "Rebuilding system with new configuration..."
    
    cd "$CONFIG_DIR"
    nixos-rebuild switch --flake .#"$HOSTNAME"
    
    log "System rebuilt successfully"
}

create_gaming_shortcuts() {
    log "Creating gaming shortcuts..."
    
    # Create gaming directory
    sudo -u "$USERNAME" mkdir -p "/home/$USERNAME/Games"
    
    # Create desktop shortcuts
    cat > "/home/$USERNAME/Desktop/gaming-mode.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Gaming Mode
Comment=Activate gaming mode
Exec=/home/$USERNAME/.config/jarvis/scripts/jarvis-cli.sh gaming
Icon=applications-games
Terminal=false
Categories=Game;
EOF
    
    cat > "/home/$USERNAME/Desktop/work-mode.desktop" << EOF
[Desktop Entry]
Type=Application
Name=Work Mode
Comment=Activate work mode
Exec=/home/$USERNAME/.config/jarvis/scripts/jarvis-cli.sh work
Icon=applications-system
Terminal=false
Categories=System;
EOF
    
    chmod +x "/home/$USERNAME/Desktop"/*.desktop
    
    log "Gaming shortcuts created"
}

setup_flatpak() {
    log "Setting up Flatpak..."
    
    # Install Flatpak
    nix-env -iA nixos.flatpak
    
    # Add Flathub repository
    sudo -u "$USERNAME" flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    
    # Install Flatpak applications
    sudo -u "$USERNAME" flatpak install -y flathub com.valvesoftware.Steam
    sudo -u "$USERNAME" flatpak install -y flathub net.lutris.Lutris
    sudo -u "$USERNAME" flatpak install -y flathub com.heroicgameslauncher.hgl
    
    log "Flatpak setup complete"
}

print_success() {
    log "Installation complete!"
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                   Installation Complete!                     ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Your WehttamSnaps NixOS setup is ready!${NC}"
    echo ""
    echo -e "${YELLOW}Next steps:${NC}"
    echo "1. Reboot your system: ${GREEN}sudo reboot${NC}"
    echo "2. Login with your user: ${GREEN}$USERNAME${NC}"
    echo "3. Run J.A.R.V.I.S.: ${GREEN}jarvis help${NC}"
    echo "4. Configure your preferences"
    echo ""
    echo -e "${PURPLE}Enjoy your gaming and productivity setup!${NC}"
}

# Main installation process
main() {
    log "Starting WehttamSnaps NixOS setup..."
    
    check_root
    check_nixos
    detect_hardware
    update_system
    setup_flakes
    clone_config
    setup_user
    configure_git
    setup_hardware_config
    install_gaming_packages
    setup_audio
    setup_jarvis
    configure_desktop
    create_gaming_shortcuts
    setup_flatpak
    rebuild_system
    print_success
}

# Handle command line arguments
case "${1:-}" in
    --help|-h)
        echo "WehttamSnaps NixOS Gaming & Workstation Setup Script"
        echo ""
        echo "Usage: $0 [OPTIONS]"
        echo ""
        echo "Options:"
        echo "  --help, -h     Show this help message"
        echo "  --update       Update existing configuration"
        echo "  --gaming       Install gaming-specific packages only"
        echo "  --work         Install work-specific packages only"
        echo ""
        exit 0
        ;;
    --update)
        log "Updating existing configuration..."
        cd "$CONFIG_DIR"
        nix flake update
        nixos-rebuild switch --flake .#"$HOSTNAME"
        exit 0
        ;;
    --gaming)
        install_gaming_packages
        exit 0
        ;;
    --work)
        configure_desktop
        exit 0
        ;;
    *)
        main
        ;;
esac
