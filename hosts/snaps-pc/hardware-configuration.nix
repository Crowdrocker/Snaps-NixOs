{ config, lib, pkgs, modulesPath, username, hostname, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    
    # Use GRUB instead of systemd-boot
    loader = {
      grub = {
        enable = true;
        device = "nodev";
        efiSupport = true;
        useOSProber = true;
        configurationLimit = 10;
        
        # Custom GRUB theme with J.A.R.V.I.S. branding
        theme = pkgs.fetchFromGitHub {
          owner = "vinceliuice";
          repo = "grub2-themes";
          rev = "2024-01-07";
          sha256 = "sha256-1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef";
        };
      };
      timeout = 3;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/PUT_YOUR_ROOT_UUID_HERE";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "ssd" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/PUT_YOUR_BOOT_UUID_HERE";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/PUT_YOUR_HOME_UUID_HERE";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "ssd" ];
  };

  fileSystems."/run/media/wehttamsnaps/LINUXDRIVE-1" = {
    device = "/dev/disk/by-uuid/PUT_YOUR_GAMES_UUID_HERE";
    fsType = "btrfs";
    options = [ "compress=zstd" "noatime" "ssd" ];
  };

  # Enable swap
  swapDevices = [{
    device = "/dev/disk/by-uuid/PUT_YOUR_SWAP_UUID_HERE";
  }];

  # AMD GPU configuration
  hardware = {
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
    };
    
    amdgpu = {
      enableGcn = true;
      enableDc = true;
    };
  };

  # Enable CPU microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power management
  powerManagement = {
    cpuFreqGovernor = lib.mkDefault "performance";
    enable = true;
  };

  networking.hostName = hostname;
}