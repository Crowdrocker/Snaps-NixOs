# WehttamSnaps Audio Module
# PipeWire configuration with advanced routing

{ config, pkgs, lib, ... }:

{
  imports = [
    ./pipewire.nix
    ./routing.nix
  ];

  # ============================================================================
  # AUDIO PACKAGES
  # ============================================================================
  
  environment.systemPackages = with pkgs; [
    # PipeWire control
    pavucontrol       # Volume control GUI
    qpwgraph          # PipeWire graph editor
    helvum            # Alternative graph editor
    
    # Audio utilities
    playerctl         # Media player control
    pamixer           # CLI volume control
    
    # Audio production (optional)
    # ardour
    # audacity
    
    # Sound effects
    mpv               # For playing J.A.R.V.I.S. sounds
  ];

  # ============================================================================
  # REALTIME AUDIO
  # ============================================================================
  
  security.rtkit.enable = true;
  
  # Allow users in audio group to use realtime scheduling
  security.pam.loginLimits = [
    {
      domain = "@audio";
      type = "-";
      item = "rtprio";
      value = "95";
    }
    {
      domain = "@audio";
      type = "-";
      item = "memlock";
      value = "unlimited";
    }
    {
      domain = "@audio";
      type = "-";
      item = "nice";
      value = "-19";
    }
  ];
}