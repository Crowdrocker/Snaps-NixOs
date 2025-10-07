# WehttamSnaps Audio Configuration
# Advanced PipeWire setup with virtual sinks (Voicemeter-like)

{ config, pkgs, lib, ... }:

{
  # ========================================
  # AUDIO PACKAGES
  # ========================================
  
  environment.systemPackages = with pkgs; [
    # PipeWire tools
    pipewire
    wireplumber
    pavucontrol
    pwvucontrol
    qpwgraph
    helvum
    
    # Audio utilities
    alsa-utils
    pulseaudio  # For pactl commands
    
    # Music players
    spotify
    
    # Sound effects player
    mpg123
    sox
    
    # EasyEffects for audio processing
    easyeffects
  ];

  # ========================================
  # PIPEWIRE CONFIGURATION
  # ========================================
  
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Low latency configuration
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 1024;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 2048;
        };
      };
    };
    
    # Create virtual sinks (like Voicemeter)
    extraConfig.pipewire-pulse = {
      "20-virtual-sinks" = {
        "context.modules" = [
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Game Audio";
              "node.name" = "game_audio";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.name" = "game_audio.output";
                "node.passive" = true;
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Browser Audio";
              "node.name" = "browser_audio";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.name" = "browser_audio.output";
                "node.passive" = true;
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Discord Audio";
              "node.name" = "discord_audio";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.name" = "discord_audio.output";
                "node.passive" = true;
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Music Audio";
              "node.name" = "music_audio";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.name" = "music_audio.output";
                "node.passive" = true;
              };
            };
          }
          {
            name = "libpipewire-module-loopback";
            args = {
              "node.description" = "Stream Output";
              "node.name" = "stream_output";
              "capture.props" = {
                "media.class" = "Audio/Sink";
                "audio.position" = [ "FL" "FR" ];
              };
              "playback.props" = {
                "node.name" = "stream_output.monitor";
                "node.passive" = true;
              };
            };
          }
        ];
      };
    };
  };

  # ========================================
  # AUDIO SCRIPTS
  # ========================================
  
  # Script to route applications to specific sinks
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "audio-router" ''
      #!/usr/bin/env bash
      # Route applications to virtual sinks
      
      case "$1" in
        game)
          pactl move-sink-input "$2" game_audio
          notify-send "Audio Router" "Moved to Game Audio"
          ;;
        browser)
          pactl move-sink-input "$2" browser_audio
          notify-send "Audio Router" "Moved to Browser Audio"
          ;;
        discord)
          pactl move-sink-input "$2" discord_audio
          notify-send "Audio Router" "Moved to Discord Audio"
          ;;
        music)
          pactl move-sink-input "$2" music_audio
          notify-send "Audio Router" "Moved to Music Audio"
          ;;
        *)
          echo "Usage: audio-router {game|browser|discord|music} <sink-input-id>"
          echo "Get sink-input-id with: pactl list short sink-inputs"
          ;;
      esac
    '')
    
    (writeShellScriptBin "audio-status" ''
      #!/usr/bin/env bash
      # Show audio routing status
      
      echo "=== Active Sink Inputs ==="
      pactl list short sink-inputs
      echo ""
      echo "=== Available Sinks ==="
      pactl list short sinks
      echo ""
      echo "=== Tip ==="
      echo "Route audio with: audio-router {game|browser|discord|music} <sink-input-id>"
    '')
    
    (writeShellScriptBin "obs-audio-setup" ''
      #!/usr/bin/env bash
      # Quick OBS audio routing setup
      
      echo "Setting up OBS audio routing..."
      echo ""
      echo "In OBS, add these audio sources:"
      echo "1. Desktop Audio -> game_audio"
      echo "2. Browser Audio -> browser_audio"
      echo "3. Discord Audio -> discord_audio"
      echo "4. Music Audio -> music_audio"
      echo ""
      echo "You can now control each source independently!"
      echo ""
      echo "Open qpwgraph to visualize and configure routing."
    '')
  ];

  # ========================================
  # AUDIO HOTKEYS SCRIPT
  # ========================================
  
  environment.etc."wehttamsnaps/audio-hotkeys.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Audio control hotkeys
      
      case "$1" in
        mute-game)
          pactl set-sink-mute game_audio toggle
          ;;
        mute-browser)
          pactl set-sink-mute browser_audio toggle
          ;;
        mute-discord)
          pactl set-sink-mute discord_audio toggle
          ;;
        mute-music)
          pactl set-sink-mute music_audio toggle
          ;;
        vol-game-up)
          pactl set-sink-volume game_audio +5%
          ;;
        vol-game-down)
          pactl set-sink-volume game_audio -5%
          ;;
        *)
          echo "Unknown command: $1"
          ;;
      esac
    '';
    mode = "0755";
  };

  # ========================================
  # REALTIME AUDIO PERMISSIONS
  # ========================================
  
  security.rtkit.enable = true;
  
  security.pam.loginLimits = [
    { domain = "@audio"; item = "memlock"; type = "-"; value = "unlimited"; }
    { domain = "@audio"; item = "rtprio"; type = "-"; value = "99"; }
    { domain = "@audio"; item = "nice"; type = "-"; value = "-11"; }
  ];

  # ========================================
  # NOISE SUPPRESSION
  # ========================================
  
  # Enable noise suppression for microphone
  services.pipewire.wireplumber.extraConfig = {
    "10-noise-suppression" = {
      "monitor.rules" = [
        {
          matches = [
            { "node.name" = "~alsa_input.*"; }
          ];
          actions = {
            update-props = {
              "audio.rate" = 48000;
              "api.acp.auto-port" = false;
              "api.acp.auto-profile" = false;
            };
          };
        }
      ];
    };
  };
}
