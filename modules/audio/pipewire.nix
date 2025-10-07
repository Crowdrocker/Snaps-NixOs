# PipeWire Configuration
# Low-latency audio setup

{ config, pkgs, ... }:

{
  # Disable PulseAudio
  hardware.pulseaudio.enable = false;
  
  # Enable PipeWire
  services.pipewire = {
    enable = true;
    
    # Enable ALSA support
    alsa = {
      enable = true;
      support32Bit = true;
    };
    
    # Enable PulseAudio compatibility
    pulse.enable = true;
    
    # Enable JACK support
    jack.enable = true;
    
    # ========================================================================
    # PIPEWIRE CONFIGURATION
    # ========================================================================
    
    extraConfig.pipewire = {
      "context.properties" = {
        # Sample rate
        "default.clock.rate" = 48000;
        "default.clock.allowed-rates" = [ 44100 48000 96000 ];
        
        # Buffer size (lower = less latency, higher = less CPU)
        "default.clock.quantum" = 1024;
        "default.clock.min-quantum" = 512;
        "default.clock.max-quantum" = 2048;
      };
      
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.min.req" = "512/48000";
            "pulse.default.req" = "1024/48000";
            "pulse.max.req" = "2048/48000";
            "pulse.min.quantum" = "512/48000";
            "pulse.max.quantum" = "2048/48000";
          };
        }
      ];
    };
    
    # ========================================================================
    # PIPEWIRE-PULSE CONFIGURATION
    # ========================================================================
    
    extraConfig.pipewire-pulse = {
      "context.properties" = {
        "log.level" = 2;
      };
      
      "context.modules" = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "server.address" = [ "unix:native" ];
          };
        }
      ];
      
      "stream.properties" = {
        "node.latency" = "1024/48000";
        "resample.quality" = 4;
      };
    };
    
    # ========================================================================
    # WIREPLUMBER CONFIGURATION
    # ========================================================================
    
    wireplumber = {
      enable = true;
      
      extraConfig = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
  };
  
  # ========================================================================
  # BLUETOOTH AUDIO
  # ========================================================================
  
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    
    settings = {
      General = {
        Enable = "Source,Sink,Media,Socket";
        Experimental = true;
      };
    };
  };
  
  services.blueman.enable = true;
}