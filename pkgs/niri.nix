# WehttamSnaps Niri Configuration
# Modular Niri setup with J.A.R.V.I.S. theme

{ config, pkgs, lib, ... }:

{
  # Enable Niri
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  # Niri configuration file
  environment.etc."niri/config.kdl".text = ''
    // WehttamSnaps Niri Configuration
    // J.A.R.V.I.S. Themed Setup
    
    // ========================================
    // INPUT CONFIGURATION
    // ========================================
    
    input {
        keyboard {
            xkb {
                layout "us"
            }
            
            repeat-delay 600
            repeat-rate 25
        }

        touchpad {
            tap
            dwt
            natural-scroll
            click-method "clickfinger"
        }

        mouse {
            accel-speed 0.0
            accel-profile "flat"
        }

        focus-follows-mouse
        workspace-auto-back-and-forth
    }

    // ========================================
    // OUTPUT CONFIGURATION
    // ========================================
    
    output "HDMI-A-1" {
        mode "1920x1080@60"
        scale 1.0
        position x=0 y=0
    }

    // ========================================
    // LAYOUT CONFIGURATION
    // ========================================
    
    layout {
        gaps 8
        center-focused-column "never"
        
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }

        default-column-width { proportion 0.5; }
        
        focus-ring {
            width 3
            active-color "#8A2BE2"
            inactive-color "#0066CC"
            
            active-gradient from="#8A2BE2" to="#00FFFF" angle=45
        }
        
        border {
            width 2
            active-color "#8A2BE2"
            inactive-color "#0066CC"
            
            active-gradient from="#8A2BE2" to="#00FFFF" angle=45
        }
    }

    // ========================================
    // CURSOR CONFIGURATION
    // ========================================
    
    cursor {
        xcursor-theme "Bibata-Modern-Classic"
        xcursor-size 24
    }

    // ========================================
    // STARTUP PROGRAMS
    // ========================================
    
    spawn-at-startup "swww" "init"
    spawn-at-startup "swww" "img" "/home/wehttamsnaps/.config/wallpapers/jarvis-wallpaper.jpg"
    spawn-at-startup "quickshell"
    spawn-at-startup "dunst"
    spawn-at-startup "/home/wehttamsnaps/.config/jarvis/jarvis-startup.sh"
    
    // ========================================
    // WINDOW RULES
    // ========================================
    
    window-rule {
        match app-id="^firefox$"
        open-on-workspace "browser"
    }

    window-rule {
        match app-id="^discord$"
        open-on-workspace "chat"
    }

    window-rule {
        match app-id="^steam$"
        open-on-workspace "games"
    }

    window-rule {
        match app-id="^org.inkscape.Inkscape$"
        open-on-workspace "work"
    }

    window-rule {
        match app-id="^gimp"
        open-on-workspace "work"
    }

    window-rule {
        match app-id="^krita$"
        open-on-workspace "work"
    }

    window-rule {
        match title="^OBS"
        open-on-workspace "streaming"
    }

    // Floating windows
    window-rule {
        match app-id="^pavucontrol$"
        default-column-width { fixed 800; }
        open-floating true
    }

    window-rule {
        match app-id="^qpwgraph$"
        default-column-width { fixed 1000; }
        open-floating true
    }

    // ========================================
    // KEYBINDINGS
    // ========================================
    
    binds {
        // Compositor actions
        Mod+Shift+Slash { show-hotkey-overlay; }
        Mod+Q { close-window; }
        Mod+Shift+E { quit; }
        Mod+Shift+P { power-off-monitors; }
        
        // Terminal
        Mod+Return { spawn "kitty"; }
        Mod+Shift+Return { spawn "alacritty"; }
        
        // Launchers
        Mod+D { spawn "fuzzel"; }
        Mod+Space { spawn "rofi" "-show" "drun"; }
        
        // Screenshots
        Print { spawn "grim" "-g" "$(slurp)" "-" "|" "swappy" "-f" "-"; }
        Shift+Print { spawn "grim" "/home/wehttamsnaps/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"; }
        
        // Window management
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        // Window resizing
        Mod+Ctrl+Left  { set-column-width "-10%"; }
        Mod+Ctrl+Right { set-column-width "+10%"; }
        Mod+Ctrl+H     { set-column-width "-10%"; }
        Mod+Ctrl+L     { set-column-width "+10%"; }

        // Fullscreen and floating
        Mod+F { fullscreen-window; }
        Mod+Shift+F { toggle-floating; }
        
        // Workspace navigation
        Mod+1 { focus-workspace 1; }
        Mod+2 { focus-workspace 2; }
        Mod+3 { focus-workspace 3; }
        Mod+4 { focus-workspace 4; }
        Mod+5 { focus-workspace 5; }
        Mod+6 { focus-workspace 6; }
        Mod+7 { focus-workspace 7; }
        Mod+8 { focus-workspace 8; }
        Mod+9 { focus-workspace 9; }

        // Move windows to workspaces
        Mod+Shift+1 { move-column-to-workspace 1; }
        Mod+Shift+2 { move-column-to-workspace 2; }
        Mod+Shift+3 { move-column-to-workspace 3; }
        Mod+Shift+4 { move-column-to-workspace 4; }
        Mod+Shift+5 { move-column-to-workspace 5; }
        Mod+Shift+6 { move-column-to-workspace 6; }
        Mod+Shift+7 { move-column-to-workspace 7; }
        Mod+Shift+8 { move-column-to-workspace 8; }
        Mod+Shift+9 { move-column-to-workspace 9; }

        // Media keys
        XF86AudioRaiseVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%+"; }
        XF86AudioLowerVolume { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "5%-"; }
        XF86AudioMute { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        
        // Gaming mode toggle
        Mod+G { spawn "/home/wehttamsnaps/.config/jarvis/gaming-mode.sh"; }
        
        // Streaming mode toggle
        Mod+Shift+S { spawn "/home/wehttamsnaps/.config/jarvis/streaming-mode.sh"; }
        
        // Power menu
        Mod+Escape { spawn "/home/wehttamsnaps/.config/quickshell/widgets/power-menu/power-menu.sh"; }
        
        // File manager
        Mod+E { spawn "thunar"; }
        
        // Browser
        Mod+B { spawn "firefox"; }
        
        // Custom app launchers
        Mod+Shift+W { spawn "/home/wehttamsnaps/.config/quickshell/widgets/work-launcher/work-launcher.sh"; }
        Mod+Shift+G { spawn "/home/wehttamsnaps/.config/quickshell/widgets/game-launcher/game-launcher.sh"; }
    }

    // ========================================
    // ANIMATIONS
    // ========================================
    
    animations {
        slowdown 1.0
        
        workspace-switch {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        window-open {
            duration-ms 150
            curve "ease-out-cubic"
        }
        
        window-close {
            duration-ms 150
            curve "ease-out-cubic"
        }
        
        window-movement {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
        
        window-resize {
            spring damping-ratio=1.0 stiffness=800 epsilon=0.0001
        }
    }

    // ========================================
    // MISC SETTINGS
    // ========================================
    
    prefer-no-csd
    screenshot-path "/home/wehttamsnaps/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"
    
    hotkey-overlay {
        skip-at-startup
    }
    
    debug {
        render-drm-device "/dev/dri/renderD128"
    }
  '';

  # Enable necessary services for Niri
  systemd.user.services.niri = {
    description = "Niri Wayland Compositor";
    wantedBy = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.niri}/bin/niri";
      Restart = "on-failure";
      RestartSec = 1;
    };
  };
}
