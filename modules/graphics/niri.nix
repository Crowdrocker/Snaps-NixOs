{ config, pkgs, lib, ... }:

{
  # Enable Niri window manager
  services.xserver = {
    enable = false;
  };
  
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Niri configuration directory
  environment.etc."niri/config.kdl" = {
    text = ''
      // WehttamSnaps Niri Configuration
      // Modular Niri config for gaming and productivity
      
      // Output configuration
      output "eDP-1" {
        scale 1.0
        position x=0 y=0
      }
      
      // Layout configuration
      layout {
        gaps 8
        border {
          width 2
          off { color "#8A2BE2" }
          active { color "#00FFFF" }
        }
        
        focus-ring {
          width 2
          active-color "#8A2BE2"
          inactive-color "#0066CC"
        }
      }
      
      // Animations
      animations {
        slow 0.5
        normal 0.2
        fast 0.1
      }
      
      // Workspaces
      workspace 1 { name "Work" }
      workspace 2 { name "Gaming" }
      workspace 3 { name "Development" }
      workspace 4 { name "Media" }
      workspace 5 { name "Chat" }
      
      // Key bindings
      binds {
        // Application launchers
        Mod+Return spawn "kitty"
        Mod+Shift+Return spawn "alacritty"
        Mod+d spawn "rofi -show drun"
        Mod+Shift+d spawn "rofi -show window"
        
        // Web browsers
        Mod+w spawn "firefox"
        Mod+Shift+w spawn "google-chrome-stable"
        
        // File manager
        Mod+e spawn "thunar"
        
        // Gaming shortcuts
        Mod+g spawn "steam"
        Mod+Shift+g spawn "lutris"
        
        // Audio control
        Mod+F1 spawn "pactl set-sink-volume @DEFAULT_SINK@ -5%"
        Mod+F2 spawn "pactl set-sink-volume @DEFAULT_SINK@ +5%"
        Mod+F3 spawn "pactl set-sink-mute @DEFAULT_SINK@ toggle"
        
        // Brightness
        Mod+F5 spawn "brightnessctl set 5%-"
        Mod+F6 spawn "brightnessctl set 5%+"
        
        // Screenshots
        Mod+Print spawn "grim -g &quot;$(slurp)&quot; ~/Pictures/screenshots/$(date +%Y-%m-%d-%H-%M-%S).png"
        Mod+Shift+Print spawn "grim ~/Pictures/screenshots/$(date +%Y-%m-%d-%H-%M-%S).png"
        
        // Window management
        Mod+h move-left
        Mod+j move-down
        Mod+k move-up
        Mod+l move-right
        
        Mod+Shift+h resize-left
        Mod+Shift+j resize-down
        Mod+Shift+k resize-up
        Mod+Shift+l resize-right
        
        Mod+Enter toggle-fullscreen
        Mod+f toggle-floating
        
        // Workspace management
        Mod+1 workspace 1
        Mod+2 workspace 2
        Mod+3 workspace 3
        Mod+4 workspace 4
        Mod+5 workspace 5
        
        Mod+Shift+1 move-to-workspace 1
        Mod+Shift+2 move-to-workspace 2
        Mod+Shift+3 move-to-workspace 3
        Mod+Shift+4 move-to-workspace 4
        Mod+Shift+5 move-to-workspace 5
        
        // System control
        Mod+Shift+q quit
        Mod+Shift+r reload-config
        Mod+Shift+e exit
        
        // Power menu
        Mod+Shift+p spawn "systemctl poweroff"
        Mod+Shift+r spawn "systemctl reboot"
        Mod+Shift+l spawn "swaylock"
        
        // J.A.R.V.I.S. integration
        Mod+j spawn "${./scripts/jarvis-activate.sh}"
      }
      
      // Environment variables
      env {
        MOZ_ENABLE_WAYLAND=1
        QT_QPA_PLATFORM=wayland
        SDL_VIDEODRIVER=wayland
        CLUTTER_BACKEND=wayland
        _JAVA_AWT_WM_NONREPARENTING=1
        XDG_CURRENT_DESKTOP=niri
        XDG_SESSION_TYPE=wayland
      }
      
      // Window rules
      window-rule {
        match app-id="steam"
        open-on-workspace 2
        set-floating false
      }
      
      window-rule {
        match app-id="lutris"
        open-on-workspace 2
        set-floating false
      }
      
      window-rule {
        match app-id="firefox"
        open-on-workspace 1
        set-floating false
      }
      
      window-rule {
        match app-id="discord"
        open-on-workspace 5
        set-floating true
      }
      
      window-rule {
        match app-id="obs"
        open-on-workspace 4
        set-floating false
      }
      
      // Screenshot directory
      screenshot-path "~/Pictures/screenshots"
      
      // Cursor configuration
      cursor {
        xcursor-theme "Adwaita"
        xcursor-size 24
      }
      
      // Background
      background {
        color "#1a1b26"
        image "~/Pictures/wallpapers/wehttamsnaps-default.jpg"
        filter "lanczos3"
      }
    '';
  };

  # Niri desktop file
  environment.etc."xsessions/niri.desktop" = {
    text = ''
      [Desktop Entry]
      Name=Niri
      Comment=WehttamSnaps Niri Desktop
      Exec=niri
      Type=Application
      DesktopNames=niri
    '';
  };

  # Enable display manager
  services.displayManager = {
    enable = true;
    defaultSession = "niri";
  };
}