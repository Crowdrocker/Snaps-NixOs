{ config, pkgs, lib, inputs, ... }:

{
  # Enable chaotic-cx packages
  nixpkgs.overlays = [ inputs.chaotic.overlays.default ];

  # Gaming packages
  environment.systemPackages = with pkgs; [
    steam
    steam-run
    steam-original
    gamescope
    gamemode
    mangohud
    protontricks
    lutris
    heroic
    bottles
    wine
    winetricks
    
    # Gaming dependencies
    vulkan-tools
    vulkan-loader
    vulkan-validation-layers
    dxvk
    vkd3d
    
    # AMD GPU tools
    corectrl
    lact
    radeontop
    
    # Performance tools
    goverlay
    gwe
    
    # Benchmarking
    glmark2
    unigine-valley
  ];

  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Gaming firewall rules
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      27015 27016     # Steam and games
      3478 3479       # PlayStation Network
      3659            # Battle.net
      6112            # Blizzard
    ];
    allowedUDPPorts = [
      2456 2457 2458  # Valheim
      27015 27016     # Games
      3478 3479       # PSN
      3659            # Battle.net
      6112            # Blizzard
      8767 27036      # Steam
    ];
  };

  # Gaming udev rules
  services.udev.extraRules = ''
    # Steam Controller
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
    KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"
    
    # Xbox controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02d1", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", MODE="0666"
    
    # PlayStation controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
  '';

  # Enable gamemode
  programs.gamemode.enable = true;

  # AMD GPU optimizations
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.amdgpu = {
    enableGcn = true;
    enableDc = true;
  };

  # Performance tuning
  boot.kernelParams = [
    "amdgpu.ppfeaturemask=0xffffffff"
    "amdgpu.dcdebugmask=0x200"
    "amdgpu.dpm=1"
    "amdgpu.msi=1"
  ];

  # Fan control
  services.fancontrol.enable = true;
}