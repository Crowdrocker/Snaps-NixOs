# Hardware Configuration for WehttamSnaps PC
# Intel i5-4430 + AMD RX 580 + 16GB DDR3 RAM
# Generated hardware configuration - customize as needed

{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ============================================================================
  # BOOT CONFIGURATION
  # ============================================================================
  
  boot.initrd.availableKernelModules = [ 
    "xhci_pci"      # USB 3.0
    "ehci_pci"      # USB 2.0
    "ahci"          # SATA
    "usb_storage"   # USB storage
    "sd_mod"        # SD card
    "sr_mod"        # CD/DVD
  ];
  
  boot.initrd.kernelModules = [ "amdgpu" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # ============================================================================
  # FILESYSTEMS
  # ============================================================================
  
  # Root filesystem (120GB SSD for Linux)
  fileSystems."/" = {
    device = "/dev/disk/by-label/nixos"; # Adjust this to your actual device
    fsType = "ext4";
    options = [ "noatime" "nodiratime" ]; # Performance optimization
  };

  # Boot partition (EFI)
  fileSystems."/boot" = {
    device = "/dev/disk/by-label/boot"; # Adjust this to your actual device
    fsType = "vfat";
  };

  # Gaming/Files drive (1TB SSD)
  fileSystems."/run/media/wehttamsnaps/LINUXDRIVE-1" = {
    device = "/dev/disk/by-label/LINUXDRIVE-1"; # Adjust this to your actual device
    fsType = "ext4";
    options = [ "noatime" "nodiratime" "user" "exec" ];
  };

  # ============================================================================
  # SWAP CONFIGURATION
  # ============================================================================
  
  # Swap file (recommended for 16GB RAM)
  swapDevices = [{
    device = "/swapfile";
    size = 8192; # 8GB swap
  }];

  # ZRAM for better memory compression
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50; # Use 50% of RAM for ZRAM
  };

  # ============================================================================
  # CPU CONFIGURATION
  # ============================================================================
  
  # Intel i5-4430 (Haswell, 4 cores, 4 threads)
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  
  # CPU frequency scaling
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  # ============================================================================
  # GPU CONFIGURATION
  # ============================================================================
  
  # AMD RX 580 configuration
  services.xserver.videoDrivers = [ "amdgpu" ];
  
  # AMD GPU power management
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.gpu_recovery=1"
  ];

  # ============================================================================
  # NETWORKING
  # ============================================================================
  
  # Ethernet interface (adjust to your actual interface name)
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s25.useDHCP = lib.mkDefault true;

  # ============================================================================
  # SYSTEM ARCHITECTURE
  # ============================================================================
  
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}