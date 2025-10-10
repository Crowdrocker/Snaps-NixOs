# WehttamSnaps NixOS Integration Guide
## Misterio77 Template + Gaming Setup

This guide shows you how to integrate your complete WehttamSnaps gaming setup with the Misterio77 NixOS template structure.

## 🎯 What's Been Created

### **Misterio77-Compatible Structure**
- ✅ **flake.nix** - Main configuration with all gaming dependencies
- ✅ **nixos/configuration.nix** - System configuration
- ✅ **home-manager/home.nix** - User configuration  
- ✅ **modules/** - Modular system components
- ✅ **pkgs/** - Custom packages (including J.A.R.V.I.S.)
- ✅ **overlays/** - Package customizations

## 🚀 Migration Steps

### **Step 1: Get the Misterio77 Template**
```bash
# Install git if not already installed
nix-shell -p git

# Create your config directory
cd ~
git init nix-config
cd nix-config

# Enable flakes
export NIX_CONFIG="experimental-features = nix-command flakes"

# Get the template (we're using standard version for full features)
nix flake init -t github:misterio77/nix-starter-configs#standard
```

### **Step 2: Copy WehttamSnaps Configuration**
```bash
# Copy the complete structure
cp -r /workspace/nix-config/* ~/nix-config/

# OR clone directly
git clone https://github.com/Crowdrocker/nix-config.git ~/nix-config
```

### **Step 3: Configure Hardware**
```bash
# Generate your hardware configuration
sudo nixos-generate-config --root /mnt

# Copy to your config
cp /mnt/etc/nixos/hardware-configuration.nix ~/nix-config/nixos/
```

### **Step 4: Update Hardware Configuration**
Edit `~/nix-config/nixos/hardware-configuration.nix` with your actual UUIDs:
```nix
fileSystems."/" = {
  device = "/dev/disk/by-uuid/YOUR-ROOT-UUID";
  fsType = "btrfs";
  options = [ "compress=zstd" "noatime" "ssd" ];
};
```

### **Step 5: Install System**
```bash
# Install NixOS
sudo nixos-install --flake .#snaps-pc --no-root-passwd

# After reboot, apply home-manager
home-manager switch --flake .#wehttamsnaps@snaps-pc
```

## 🎮 Features Comparison

| Feature | Original | Misterio77 Style |
|---------|----------|------------------|
| **Structure** | Modular files | Flake-based |
| **Updates** | Manual rebuild | `nix flake update` |
| **Custom Packages** | Direct import | `pkgs/` directory |
| **Modules** | Separate files | `modules/` directory |
| **Overlays** | Inline | `overlays/` directory |
| **Home Manager** | Separate config | Integrated in flake |

## 📁 File Mapping

### Original → Misterio77 Structure
```
Original Structure              → Misterio77 Structure
├── flake.nix                   → flake.nix (enhanced)
├── hosts/snaps-pc/             → nixos/
│   ├── configuration.nix       → nixos/configuration.nix
│   └── hardware-configuration.nix → nixos/hardware-configuration.nix
├── home-manager/               → home-manager/
│   ├── home.nix               → home-manager/home.nix
│   ├── shell.nix              → modules/home-manager/shell.nix
│   └── themes.nix             → modules/home-manager/themes.nix
├── modules/                    → modules/nixos/ & modules/home-manager/
├── scripts/                    → pkgs/ & scripts/
└── docs/                       → docs/ (moved)
```

## 🔧 Key Differences

### **1. Flake Structure**
```nix
# Original
nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem { ... }

# Misterio77 Style
nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
  modules = [
    ./nixos/configuration.nix
    ./nixos/hardware-configuration.nix
    ./modules/nixos
    home-manager.nixosModules.home-manager
    { home-manager.users.${username} = import ./home-manager/home.nix; }
  ];
};
```

### **2. Home Manager Integration**
```nix
# Original
homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration { ... }

# Misterio77 Style (integrated)
home-manager.users.${username} = import ./home-manager/home.nix;
```

### **3. Custom Packages**
```nix
# Original
environment.systemPackages = with pkgs; [ ... ]

# Misterio77 Style
packages.${system} = {
  jarvis-cli = callPackage ./pkgs/jarvis-cli { };
};
```

## 🎮 Gaming Setup Integration

### **AMD GPU Optimization**
```nix
# In modules/nixos/gaming.nix
hardware.amdgpu = {
  enableGcn = true;
  enableDc = true;
};
```

### **Gaming Packages**
```nix
# In modules/nixos/gaming.nix
programs.steam.enable = true;
environment.systemPackages = with pkgs; [
  steam lutris heroic bottles
  corectrl lact mangohud gamescope
];
```

### **J.A.R.V.I.S. Integration**
```nix
# Custom package in pkgs/jarvis-cli/
environment.systemPackages = [ pkgs.jarvis-cli ];
```

## 📋 Quick Commands

### **System Management**
```bash
# Apply system configuration
sudo nixos-rebuild switch --flake .#snaps-pc

# Apply home-manager
home-manager switch --flake .#wehttamsnaps@snaps-pc

# Update all packages
nix flake update
```

### **Testing**
```bash
# Test system build
nixos-rebuild test --flake .#snaps-pc

# Test home-manager
home-manager build --flake .#wehttamsnaps@snaps-pc
```

### **Development**
```bash
# Enter dev shell
nix develop

# Build custom packages
nix build .#jarvis-cli
```

## 🆘 Troubleshooting

### **Common Issues**

#### **"Permission denied" on install**
```bash
# Ensure you're in the correct directory
cd ~/nix-config
sudo nixos-install --flake .#snaps-pc
```

#### **"User not found" errors**
Check `nixos/configuration.nix` has correct username:
```nix
users.users.wehttamsnaps = {
  isNormalUser = true;
  # ... other settings
};
```

#### **Hardware configuration issues**
```bash
# Regenerate hardware config
sudo nixos-generate-config --root /mnt
cp /mnt/etc/nixos/hardware-configuration.nix ~/nix-config/nixos/
```

## 🎯 Next Steps

### **1. Customization**
- Edit `nixos/configuration.nix` for system changes
- Edit `home-manager/home.nix` for user changes
- Add new packages to appropriate modules

### **2. Adding Games**
- Game launch options in `modules/nixos/gaming.nix`
- Custom scripts in `pkgs/`

### **3. Audio Setup**
- Advanced routing in `modules/nixos/audio.nix`
- OBS configuration in `home-manager/home.nix`

### **4. Branding**
- Wallpapers in `pkgs/wallpapers/`
- Themes in `modules/home-manager/themes.nix`

## 🎉 You're Ready!

Your complete WehttamSnaps gaming workstation is now integrated with the Misterio77 template structure. This gives you:

- **Reproducible builds** with flakes
- **Modular configuration** that's easy to maintain
- **Custom packages** that integrate seamlessly
- **Gaming optimizations** for your RX 580
- **J.A.R.V.I.S. integration** throughout the system

**Happy gaming and streaming! 🎮**