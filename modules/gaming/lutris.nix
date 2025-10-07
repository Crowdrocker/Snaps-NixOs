# Lutris Configuration
# For non-Steam games and emulators

{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    lutris
    
    # Wine dependencies
    wine
    wine64
    wineWowPackages.stable
    winetricks
    
    # Additional dependencies
    dxvk
    vkd3d
    
    # Emulators (optional)
    # retroarch
    # pcsx2
    # rpcs3
    # dolphin-emu
  ];

  # ============================================================================
  # LUTRIS CONFIGURATION
  # ============================================================================
  
  # Lutris uses Wine and other runners
  # Configuration is stored in ~/.config/lutris
  
  # ============================================================================
  # WINE CONFIGURATION
  # ============================================================================
  
  environment.sessionVariables = {
    # Wine prefix location
    WINEPREFIX = "$HOME/.wine";
    
    # DXVK cache location
    DXVK_STATE_CACHE_PATH = "/run/media/wehttamsnaps/LINUXDRIVE-1/.dxvk-cache";
    
    # Wine optimizations
    WINE_CPU_TOPOLOGY = "4:4";  # 4 cores, 4 threads
  };
}