#!/usr/bin/env bash
# WehttamSnaps NixOS Interactive Installation Script
# This script helps you set up your NixOS configuration

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Banner
print_banner() {
    echo -e "${PURPLE}"
    cat << "EOF"
    ╦ ╦┌─┐┬ ┬┌┬┐┌┬┐┌─┐┌┬┐╔═╗┌┐┌┌─┐┌─┐┌─┐
    ║║║├┤ ├─┤ │  │ ├─┤│││╚═╗│││├─┤├─┘└─┐
    ╚╩╝└─┘┴ ┴ ┴  ┴ ┴ ┴┴ ┴╚═╝┘└┘┴ ┴┴  └─┘
    
    NixOS Configuration Installer
    Gaming • Streaming • Photography
EOF
    echo -e "${NC}"
}

# Print colored message
print_msg() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Ask yes/no question
ask_yes_no() {
    while true; do
        read -p "$1 (y/n): " yn
        case $yn in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer yes or no.";;
        esac
    done
}

# Check if running as root
check_root() {
    if [ "$EUID" -eq 0 ]; then
        print_error "Please do not run this script as root!"
        exit 1
    fi
}

# Check if NixOS
check_nixos() {
    if [ ! -f /etc/NIXOS ]; then
        print_error "This script must be run on NixOS!"
        exit 1
    fi
}

# Welcome message
welcome() {
    print_banner
    echo -e "${CYAN}Welcome to the WehttamSnaps NixOS Configuration Installer!${NC}"
    echo ""
    echo "This script will help you set up your NixOS system with:"
    echo "  • Niri compositor with Noctalia shell"
    echo "  • Gaming optimizations (AMD RX 580)"
    echo "  • Audio routing (PipeWire)"
    echo "  • J.A.R.V.I.S. theme integration"
    echo "  • Streaming setup (OBS Studio)"
    echo ""
    
    if ! ask_yes_no "Do you want to continue?"; then
        echo "Installation cancelled."
        exit 0
    fi
}

# Check prerequisites
check_prerequisites() {
    print_info "Checking prerequisites..."
    
    # Check for git
    if ! command -v git &> /dev/null; then
        print_warning "Git not found. Installing..."
        nix-shell -p git --run "echo 'Git installed temporarily'"
    fi
    
    # Check for internet connection
    if ! ping -c 1 google.com &> /dev/null; then
        print_error "No internet connection detected!"
        exit 1
    fi
    
    print_msg "Prerequisites check passed"
}

# Backup existing configuration
backup_config() {
    if [ -d /etc/nixos ]; then
        print_info "Backing up existing NixOS configuration..."
        sudo cp -r /etc/nixos /etc/nixos.backup.$(date +%Y%m%d_%H%M%S)
        print_msg "Backup created"
    fi
}

# Clone or update repository
setup_repository() {
    print_info "Setting up configuration repository..."
    
    REPO_DIR="$HOME/nixos-config"
    
    if [ -d "$REPO_DIR" ]; then
        print_warning "Repository already exists at $REPO_DIR"
        if ask_yes_no "Do you want to update it?"; then
            cd "$REPO_DIR"
            git pull
            print_msg "Repository updated"
        fi
    else
        print_info "Cloning repository..."
        git clone https://github.com/Crowdrocker/Snaps-NixOs.git "$REPO_DIR"
        print_msg "Repository cloned"
    fi
    
    cd "$REPO_DIR"
}

# Generate hardware configuration
generate_hardware_config() {
    print_info "Generating hardware configuration..."
    
    sudo nixos-generate-config --show-hardware-config > hosts/snaps-pc/hardware-configuration.nix
    
    print_msg "Hardware configuration generated"
    print_warning "Please review hosts/snaps-pc/hardware-configuration.nix"
    print_warning "Update device paths for your SSDs if needed"
    
    if ask_yes_no "Do you want to edit hardware-configuration.nix now?"; then
        ${EDITOR:-vim} hosts/snaps-pc/hardware-configuration.nix
    fi
}

# Configure user settings
configure_user() {
    print_info "Configuring user settings..."
    
    # Get username
    read -p "Enter your username (default: wehttamsnaps): " username
    username=${username:-wehttamsnaps}
    
    # Get email for git
    read -p "Enter your email for git: " email
    
    # Update home.nix with email
    sed -i "s/your-email@example.com/$email/g" hosts/snaps-pc/home.nix
    
    print_msg "User settings configured"
}

# Set up directories
setup_directories() {
    print_info "Creating required directories..."
    
    # Gaming drive
    sudo mkdir -p /run/media/$USER/LINUXDRIVE-1
    mkdir -p /run/media/$USER/LINUXDRIVE-1/SteamLibrary
    
    # Config directories
    mkdir -p ~/.config/sounds
    mkdir -p ~/.config/jarvis
    mkdir -p ~/.config/scripts/jarvis
    mkdir -p ~/.config/wallpapers
    mkdir -p ~/.config/quickshell
    
    print_msg "Directories created"
}

# Copy scripts
copy_scripts() {
    print_info "Copying J.A.R.V.I.S. scripts..."
    
    chmod +x scripts/jarvis/*.sh
    cp scripts/jarvis/*.sh ~/.config/scripts/jarvis/
    
    print_msg "Scripts copied"
}

# Download J.A.R.V.I.S. sounds
setup_sounds() {
    print_info "Setting up J.A.R.V.I.S. sounds..."
    
    print_warning "Please place your J.A.R.V.I.S. sound files in ~/.config/sounds/"
    print_info "Required files:"
    echo "  • jarvis-startup.mp3"
    echo "  • jarvis-shutdown.mp3"
    echo "  • jarvis-notification.mp3"
    echo "  • jarvis-warning.mp3"
    echo "  • jarvis-gaming.mp3"
    echo "  • jarvis-streaming.mp3"
    
    if ask_yes_no "Have you placed the sound files?"; then
        print_msg "Sound files ready"
    else
        print_warning "You can add sound files later"
    fi
}

# Build configuration
build_config() {
    print_info "Building NixOS configuration..."
    print_warning "This may take 30-60 minutes on first build!"
    
    if ask_yes_no "Do you want to build now?"; then
        print_info "Building configuration (this will take a while)..."
        
        if sudo nixos-rebuild build --flake .#snaps-pc; then
            print_msg "Build successful!"
            
            if ask_yes_no "Do you want to switch to the new configuration?"; then
                print_info "Switching to new configuration..."
                sudo nixos-rebuild switch --flake .#snaps-pc
                print_msg "Configuration activated!"
            else
                print_info "You can switch later with:"
                echo "  cd ~/nixos-config"
                echo "  sudo nixos-rebuild switch --flake .#snaps-pc"
            fi
        else
            print_error "Build failed! Please check the errors above."
            exit 1
        fi
    else
        print_info "You can build later with:"
        echo "  cd ~/nixos-config"
        echo "  sudo nixos-rebuild switch --flake .#snaps-pc"
    fi
}

# Post-installation instructions
post_install() {
    echo ""
    print_msg "Installation complete!"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo "1. Reboot your system: sudo reboot"
    echo "2. At login, select 'Niri' session"
    echo "3. Press Super+H for the welcome app"
    echo "4. Set up audio routing: Super+Shift+A"
    echo "5. Configure Steam library"
    echo ""
    echo -e "${CYAN}Documentation:${NC}"
    echo "• Installation: docs/INSTALLATION.md"
    echo "• Keybindings: docs/KEYBINDINGS.md"
    echo "• Audio Routing: docs/AUDIO_ROUTING.md"
    echo "• Gaming: docs/GAMING.md"
    echo ""
    echo -e "${CYAN}Support:${NC}"
    echo "• Discord: https://discord.gg/nTaknDvdUA"
    echo "• GitHub: https://github.com/Crowdrocker/Snaps-NixOs"
    echo ""
    echo -e "${PURPLE}Enjoy your WehttamSnaps NixOS setup!${NC}"
}

# Main installation flow
main() {
    check_root
    check_nixos
    welcome
    check_prerequisites
    backup_config
    setup_repository
    generate_hardware_config
    configure_user
    setup_directories
    copy_scripts
    setup_sounds
    build_config
    post_install
}

# Run main function
main