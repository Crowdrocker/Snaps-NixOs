{ config, pkgs, lib, ... }:

{
  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    
    # Extra packages
    extraPackages = with pkgs; [
      wireplumber
      pipewire-alsa
      pipewire-pulse
      pipewire-jack
    ];
  };

  # Audio tools
  environment.systemPackages = with pkgs; [
    pavucontrol
    qpwgraph
    helvum
    pulsemixer
    alsa-utils
    alsa-plugins
    alsa-tools
    sox
    ffmpeg
    espeak-ng
    speech-dispatcher
    flite
  ];

  # J.A.R.V.I.S. sound integration
  systemd.user.services.jarvis-sounds = {
    description = "J.A.R.V.I.S. Sound Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${./scripts/jarvis-sounds.sh}";
    };
  };

  # Audio routing configuration
  environment.etc."pipewire/pipewire.conf.d/10-jarvis.conf" = {
    text = ''
      # J.A.R.V.I.S. audio routing configuration
      context.modules = [
        { name = libpipewire-module-loopback
          args = {
            node.description = "J.A.R.V.I.S. Audio Loopback"
            capture.props = {
              node.name = "jarvis-input"
              media.class = "Audio/Source"
            }
            playback.props = {
              node.name = "jarvis-output"
              media.class = "Audio/Sink"
            }
          }
        }
      ]
    '';
  };
}