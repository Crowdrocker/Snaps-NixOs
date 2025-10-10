{ config, lib, pkgs, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  # Use GRUB bootloader
  boot.loader = {
    grub = {
      enable = true;
      device = "nodev";
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 10;
    };
    timeout = 3;
  };

  # File systems - update these with your actual UUIDs
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

  # Swap
  swapDevices = [{
    device = "/dev/disk/by-uuid/PUT_YOUR_SWAP_UUID_HERE";
  }];

  # AMD GPU configuration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.amdgpu = {
    enableGcn = true;
    enableDc = true;
  };

  # Enable CPU microcode updates
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  # Power management
  powerManagement.cpuFreqGovernor = lib.mkDefault "performance";

  networking.hostId = "6c61796d"; # Generate with head -c4 /dev/urandom | xxd -p
}