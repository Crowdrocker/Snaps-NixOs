# Steam Configuration with Launch Options
# Optimized for AMD RX 580

{ config, pkgs, ... }:

{
  # Steam is enabled in default.nix
  
  # ============================================================================
  # STEAM LAUNCH OPTIONS REFERENCE
  # ============================================================================
  
  # These launch options should be added in Steam's game properties
  # Right-click game → Properties → Launch Options
  
  # Base launch options for AMD GPU:
  # RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
  
  # For games that need Proton-GE:
  # PROTON_USE_WINED3D=1 gamemoderun %command%
  
  # For games with shader compilation issues:
  # DXVK_ASYNC=1 RADV_PERFTEST=gpl gamemoderun %command%
  
  # ============================================================================
  # GAME-SPECIFIC LAUNCH OPTIONS
  # ============================================================================
  
  # These are stored here for reference and can be copied to Steam
  
  environment.etc."steam-launch-options.txt".text = ''
    WehttamSnaps Steam Launch Options
    ================================
    
    Base AMD RX 580 Launch Options:
    RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
    
    ================================
    GAME-SPECIFIC LAUNCH OPTIONS
    ================================
    
    Call of Duty HQ:
    PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
    
    Cyberpunk 2077:
    RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
    Notes: Use Proton-GE for best performance
    
    Fallout 4:
    PROTON_USE_WINED3D=0 DXVK_ASYNC=1 gamemoderun %command%
    Notes: May need steamtinkerlaunch for modding
    
    FarCry 5:
    RADV_PERFTEST=gpl DXVK_ASYNC=1 gamemoderun %command%
    
    Ghost Recon Breakpoint:
    PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
    
    Marvel's Avengers:
    RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
    
    Need for Speed Payback:
    DXVK_ASYNC=1 gamemoderun %command%
    
    Rise of the Tomb Raider:
    RADV_PERFTEST=gpl DXVK_ASYNC=1 gamemoderun %command%
    
    Shadow of the Tomb Raider:
    RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
    
    The First Descendant:
    PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
    Notes: May require Proton-GE
    
    Tom Clancy's The Division:
    DXVK_ASYNC=1 gamemoderun %command%
    
    Tom Clancy's The Division 2:
    PROTON_ENABLE_NVAPI=1 DXVK_ASYNC=1 gamemoderun %command%
    
    Warframe:
    RADV_PERFTEST=gpl DXVK_ASYNC=1 gamemoderun %command%
    
    Watch_Dogs:
    DXVK_ASYNC=1 gamemoderun %command%
    
    Watch_Dogs 2:
    RADV_PERFTEST=gpl DXVK_ASYNC=1 gamemoderun %command%
    
    Watch_Dogs Legion:
    PROTON_ENABLE_NVAPI=1 RADV_PERFTEST=gpl,nggc DXVK_ASYNC=1 gamemoderun %command%
    
    ================================
    ENVIRONMENT VARIABLES EXPLAINED
    ================================
    
    RADV_PERFTEST=gpl,nggc
      - Enables GPL (Graphics Pipeline Library) for faster shader compilation
      - Enables NGGC (Next-Gen Geometry Compiler) for better performance
    
    DXVK_ASYNC=1
      - Enables async shader compilation (reduces stuttering)
    
    PROTON_ENABLE_NVAPI=1
      - Enables NVIDIA API translation (some games need this)
    
    gamemoderun
      - Activates GameMode optimizations
    
    %command%
      - Steam placeholder for the game executable
    
    ================================
    ADDITIONAL TIPS
    ================================
    
    1. For best performance, use Proton-GE (install via ProtonUp-Qt)
    2. Enable MangoHud for performance monitoring: mangohud %command%
    3. For modding, use steamtinkerlaunch: steamtinkerlaunch %command%
    4. Combine options: RADV_PERFTEST=gpl DXVK_ASYNC=1 mangohud gamemoderun %command%
    
    ================================
    TROUBLESHOOTING
    ================================
    
    If a game doesn't launch:
    1. Try removing RADV_PERFTEST
    2. Try different Proton versions
    3. Check ProtonDB for game-specific fixes
    4. Use PROTON_LOG=1 to enable debug logging
  '';

  # ============================================================================
  # STEAM LIBRARY CONFIGURATION
  # ============================================================================
  
  # Create symlink to gaming drive
  system.activationScripts.steamLibrary = ''
    mkdir -p /run/media/wehttamsnaps/LINUXDRIVE-1/SteamLibrary
  '';
}