#!/bin/bash
# Steam Game Launch Optimizations

# Cyberpunk 2077
CYBERPUNK_OPTS="gamemoderun %command% --launcher-skip"

# Fallout 4  
FALLOUT_OPTS="gamemoderun %command%"

# The Division 2
DIVISION_OPTS="gamemoderun %command%"

# Apply to Steam games
echo "Set these launch options in Steam:"
echo "Cyberpunk 2077: $CYBERPUNK_OPTS"
echo "Fallout 4: $FALLOUT_OPTS" 
echo "The Division 2: $DIVISION_OPTS"
