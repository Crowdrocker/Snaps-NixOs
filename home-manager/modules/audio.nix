{ config, pkgs, ... }:

{
  # === PIPEWIRE AUDIO CONFIGURATION ===
  # This replaces PulseAudio and provides advanced routing like Voicemeter

  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Low latency configuration for gaming
    extraConfig.pipewire = {
      "10-clock-rate" = {
        "context.properties" = {
          "default.clock.rate" = 48000;
          "default.clock.quantum" = 512;
          "default.clock.min-quantum" = 256;
          "default.clock.max-quantum" = 1024;
        };
      };
    };

    # WirePlumber configuration for audio routing
    wireplumber = {
      enable = true;

      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-wehttamsnaps-routing.lua" ''
          -- WehttamSnaps Custom Audio Routing
          -- Similar to Voicemeter - separate audio streams

          -- Create virtual sinks for different sources
          rule = {
            matches = {
              {
                { "node.name", "matches", "alsa_output.*" },
              },
            },
            apply_properties = {
              ["api.alsa.period-size"] = 256,
              ["api.alsa.headroom"] = 1024,
            },
          }

          table.insert(alsa_monitor.rules, rule)
        '')
      ];
    };
  };

  # Audio packages
  environment.systemPackages = with pkgs; [
    # PipeWire tools
    pipewire
    wireplumber

    # Control interfaces
    pavucontrol
    qpwgraph  # Visual patch bay like Voicemeter
    helvum    # Another graph-based patchbay

    # Audio utilities
    playerctl
    pamixer

    # EasyEffects for audio processing
    easyeffects
  ];

  # === QPWGRAPH SETUP SCRIPT ===
  # This creates the routing setup similar to Voicemeter
  environment.etc."xdg/autostart/setup-audio-routing.desktop".text = ''
    [Desktop Entry]
    Name=WehttamSnaps Audio Routing
    Exec=${pkgs.writeShellScript "setup-audio-routing" ''
      #!/usr/bin/env bash

      # Wait for PipeWire to be ready
      sleep 5

      # Create virtual sinks for separation (like Voicemeter)
      ${pkgs.pipewire}/bin/pw-cli create-node adapter \
        '{ factory.name=support.null-audio-sink
           node.name=Games
           node.description="Games Audio"
           media.class=Audio/Sink
           audio.position=FL,FR }'

      ${pkgs.pipewire}/bin/pw-cli create-node adapter \
        '{ factory.name=support.null-audio-sink
           node.name=Browser
           node.description="Browser Audio"
           media.class=Audio/Sink
           audio.position=FL,FR }'

      ${pkgs.pipewire}/bin/pw-cli create-node adapter \
        '{ factory.name=support.null-audio-sink
           node.name=Discord
           node.description="Discord Audio"
           media.class=Audio/Sink
           audio.position=FL,FR }'

      ${pkgs.pipewire}/bin/pw-cli create-node adapter \
        '{ factory.name=support.null-audio-sink
           node.name=Music
           node.description="Spotify/Music"
           media.class=Audio/Sink
           audio.position=FL,FR }'

      # Send notification
      ${pkgs.libnotify}/bin/notify-send "J.A.R.V.I.S. Audio" "Audio routing systems online" -i audio-card
    ''}
    Type=Application
    X-GNOME-Autostart-enabled=true
  '';
}
