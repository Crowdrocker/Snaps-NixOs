{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    obs-studio
    obs-cli
    obs-vkcapture
    gpu-screen-recorder
    qpwgraph
    pavucontrol
    pipewire
    wireplumber
  ];

  services.pipewire.enable = true;
  services.pipewire.audio.enable = true;
  services.pipewire.jack.enable = true;
  services.pipewire.pulse.enable = true;
}

