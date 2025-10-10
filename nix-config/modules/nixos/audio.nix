{ config, pkgs, lib, inputs, ... }:

{
  # Enable PipeWire
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
    
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
  ];

  # Audio routing configuration
  systemd.user.services.jarvis-audio = {
    description = "J.A.R.V.I.S. Audio Service";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash ${../scripts/jarvis-audio.sh}";
    };
  };
}