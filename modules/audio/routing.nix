# Advanced Audio Routing Configuration
# Voicemeter-like setup for Linux using PipeWire

{ config, pkgs, ... }:

{
  # ============================================================================
  # AUDIO ROUTING SETUP
  # ============================================================================
  
  # This configuration creates virtual sinks for separating audio streams
  # Similar to Voicemeter on Windows
  
  # Virtual sinks will be created using qpwgraph or helvum
  # See the audio routing guide in docs/AUDIO_ROUTING.md
  
  environment.etc."pipewire/pipewire.conf.d/virtual-sinks.conf".text = ''
    # Virtual Sinks Configuration
    # These create separate audio channels for different applications
    
    context.objects = [
      # Game Audio Sink
      {
        factory = adapter
        args = {
          factory.name = support.null-audio-sink
          node.name = "game_audio_sink"
          node.description = "Game Audio"
          media.class = "Audio/Sink"
          audio.position = [ FL FR ]
        }
      }
      
      # Browser Audio Sink
      {
        factory = adapter
        args = {
          factory.name = support.null-audio-sink
          node.name = "browser_audio_sink"
          node.description = "Browser Audio"
          media.class = "Audio/Sink"
          audio.position = [ FL FR ]
        }
      }
      
      # Discord Audio Sink
      {
        factory = adapter
        args = {
          factory.name = support.null-audio-sink
          node.name = "discord_audio_sink"
          node.description = "Discord Audio"
          media.class = "Audio/Sink"
          audio.position = [ FL FR ]
        }
      }
      
      # Spotify Audio Sink
      {
        factory = adapter
        args = {
          factory.name = support.null-audio-sink
          node.name = "spotify_audio_sink"
          node.description = "Spotify Audio"
          media.class = "Audio/Sink"
          audio.position = [ FL FR ]
        }
      }
      
      # OBS Audio Sink (for streaming)
      {
        factory = adapter
        args = {
          factory.name = support.null-audio-sink
          node.name = "obs_audio_sink"
          node.description = "OBS Audio"
          media.class = "Audio/Sink"
          audio.position = [ FL FR ]
        }
      }
    ]
  '';
  
  # ============================================================================
  # AUDIO ROUTING SCRIPTS
  # ============================================================================
  
  environment.etc."audio-routing-setup.sh" = {
    text = ''
      #!/usr/bin/env bash
      # Audio Routing Setup Script
      # Run this after logging in to set up audio routing
      
      echo "Setting up WehttamSnaps audio routing..."
      
      # Wait for PipeWire to be ready
      sleep 2
      
      # Create virtual sinks (if not already created by config)
      pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=game_audio_sink node.description="Game Audio" media.class=Audio/Sink audio.position=[FL FR] }' 2>/dev/null
      pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=browser_audio_sink node.description="Browser Audio" media.class=Audio/Sink audio.position=[FL FR] }' 2>/dev/null
      pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=discord_audio_sink node.description="Discord Audio" media.class=Audio/Sink audio.position=[FL FR] }' 2>/dev/null
      pw-cli create-node adapter '{ factory.name=support.null-audio-sink node.name=spotify_audio_sink node.description="Spotify Audio" media.class=Audio/Sink audio.position=[FL FR] }' 2>/dev/null
      
      echo "Virtual sinks created!"
      echo ""
      echo "Now open qpwgraph or pavucontrol to route audio:"
      echo "1. Open qpwgraph: qpwgraph"
      echo "2. Connect each virtual sink to your speakers/headphones"
      echo "3. In each application, select the appropriate sink:"
      echo "   - Steam games → Game Audio"
      echo "   - Firefox → Browser Audio"
      echo "   - Discord → Discord Audio"
      echo "   - Spotify → Spotify Audio"
      echo ""
      echo "For OBS streaming, capture from these sinks individually!"
    '';
    mode = "0755";
  };
  
  # ============================================================================
  # WIREPLUMBER RULES FOR APPLICATION ROUTING
  # ============================================================================
  
  environment.etc."wireplumber/main.lua.d/51-app-routing.lua".text = ''
    -- Automatic application routing rules
    -- Route specific applications to their designated sinks
    
    rule = {
      matches = {
        {
          { "application.name", "matches", "Firefox*" },
        },
      },
      apply_properties = {
        ["node.target"] = "browser_audio_sink",
      },
    }
    
    table.insert(alsa_monitor.rules, rule)
    
    rule = {
      matches = {
        {
          { "application.name", "matches", "discord" },
        },
      },
      apply_properties = {
        ["node.target"] = "discord_audio_sink",
      },
    }
    
    table.insert(alsa_monitor.rules, rule)
    
    rule = {
      matches = {
        {
          { "application.name", "matches", "Spotify" },
        },
      },
      apply_properties = {
        ["node.target"] = "spotify_audio_sink",
      },
    }
    
    table.insert(alsa_monitor.rules, rule)
  '';
}