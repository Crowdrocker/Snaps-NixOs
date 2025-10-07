#!/bin/bash
# PipeWire Audio Routing Setup

# Create virtual sinks for different applications
pactl load-module module-null-sink sink_name=game_out sink_properties=device.description="Game-Audio"
pactl load-module module-null-sink sink_name=discord_out sink_properties=device.description="Discord-Audio"  
pactl load-module module-null-sink sink_name=music_out sink_properties=device.description="Music-Audio"

# Create combined sink for monitoring
pactl load-module module-combine-sink sink_name=combined_out slaves=game_out,discord_out,music_out

echo "Virtual sinks created. Open qpwgraph to route audio."
