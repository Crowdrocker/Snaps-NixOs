{ config, pkgs, lib, ... }:

{
  # Enable Steam
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # Steam and gaming tools
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
  ];

  # Gaming-specific udev rules
  services.udev.extraRules = ''
    # Steam Controller
    SUBSYSTEM=="usb", ATTRS{idVendor}=="28de", MODE="0666"
    # Steam Controller in wired mode
    KERNEL=="hidraw*", ATTRS{idVendor}=="28de", MODE="0666"
    # Steam Controller in wireless mode
    KERNEL=="hidraw*", KERNELS=="*28DE:*", MODE="0666"
    
    # Xbox controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="028e", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02d1", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="045e", ATTRS{idProduct}=="02dd", MODE="0666"
    
    # PlayStation controllers
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666"
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666"
  '';

  # Gaming performance optimizations
  systemd.services.gamemode = {
    description = "GameMode daemon";
    serviceConfig = {
      Type = "dbus";
      BusName = "com.feralinteractive.GameMode";
      ExecStart = "${pkgs.gamemode}/bin/gamemoded";
      Restart = "on-failure";
    };
  };

  # Create gaming directories
  systemd.tmpfiles.rules = [
    "d /home/wehttamsnaps/Games 0755 wehttamsnaps users"
    "d /home/wehttamsnaps/.local/share/Steam 0755 wehttamsnaps users"
    "d /home/wehttamsnaps/.local/share/lutris 0755 wehttamsnaps users"
    "d /home/wehttamsnaps/.local/share/heroic 0755 wehttamsnaps users"
  ];
}