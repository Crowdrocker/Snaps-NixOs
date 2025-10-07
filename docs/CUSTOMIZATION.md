# WehttamSnaps Customization Guide

Make this configuration truly yours!

## Table of Contents
1. [Theming](#theming)
2. [Keybindings](#keybindings)
3. [Workspaces](#workspaces)
4. [Window Rules](#window-rules)
5. [Animations](#animations)
6. [Wallpapers](#wallpapers)
7. [Quickshell Widgets](#quickshell-widgets)

---

## Theming

### Change Color Scheme

Your current theme uses violet-to-cyan gradient. To change:

#### Niri Colors

Edit `~/.config/niri/layout.kdl`:

```kdl
layout {
    focus-ring {
        # Change active window color
        active-color "#YOUR_COLOR"
        
        # Change inactive window color
        inactive-color "#YOUR_COLOR"
        
        # Or use gradient
        active-gradient from="#COLOR1" to="#COLOR2" angle=45
    }
    
    border {
        # Change border colors
        active-color "#YOUR_COLOR"
        inactive-color "#YOUR_COLOR"
    }
}
```

**Popular Color Schemes:**

**Catppuccin Mocha:**
```kdl
active-color "#89b4fa"      # Blue
inactive-color "#45475a"    # Gray
```

**Gruvbox:**
```kdl
active-color "#d79921"      # Orange
inactive-color "#3c3836"    # Dark gray
```

**Nord:**
```kdl
active-color "#88c0d0"      # Cyan
inactive-color "#3b4252"    # Dark blue
```

**Dracula:**
```kdl
active-color "#bd93f9"      # Purple
inactive-color "#44475a"    # Gray
```

#### GTK Theme

Edit `hosts/snaps-pc/home.nix`:

```nix
gtk = {
    theme = {
        name = "YOUR_THEME_NAME";
        package = pkgs.YOUR_THEME_PACKAGE;
    };
};
```

**Available Themes:**
- `tokyonight-gtk-theme` (current)
- `catppuccin-gtk`
- `gruvbox-gtk-theme`
- `nord-gtk-theme`
- `dracula-theme`

#### Terminal Colors

Edit `hosts/snaps-pc/home.nix`:

```nix
programs.kitty = {
    theme = "YOUR_THEME_NAME";
    
    # Or custom colors
    settings = {
        foreground = "#YOUR_COLOR";
        background = "#YOUR_COLOR";
        cursor = "#YOUR_COLOR";
    };
};
```

**Popular Terminal Themes:**
- Tokyo Night (current)
- Catppuccin
- Gruvbox
- Nord
- Dracula

### Change Fonts

Edit `hosts/snaps-pc/configuration.nix`:

```nix
fonts = {
    packages = with pkgs; [
        # Add your preferred fonts
        (nerdfonts.override { fonts = [ "YOUR_FONT" ]; })
    ];
    
    fontconfig = {
        defaultFonts = {
            monospace = [ "YOUR_FONT" ];
            sansSerif = [ "YOUR_FONT" ];
        };
    };
};
```

**Popular Fonts:**
- JetBrainsMono Nerd Font (current)
- FiraCode Nerd Font
- Hack Nerd Font
- Meslo Nerd Font
- CascadiaCode Nerd Font

---

## Keybindings

### Modify Existing Keybindings

Edit `~/.config/niri/keybinds.kdl`:

```kdl
binds {
    # Change terminal keybinding
    Mod+Return { spawn "kitty"; }
    # Change to:
    Mod+T { spawn "kitty"; }
    
    # Add new keybinding
    Mod+B { spawn "firefox"; }
}
```

### Add Custom Keybindings

```kdl
binds {
    # Launch specific application
    Mod+P { spawn "gimp"; }
    
    # Run custom script
    Mod+Shift+X { spawn "~/.config/scripts/my-script.sh"; }
    
    # Multiple commands
    Mod+Shift+D { spawn "sh" "-c" "command1 && command2"; }
}
```

### Keybinding Best Practices

1. **Use Mod (Super) key** for main shortcuts
2. **Use Mod+Shift** for related actions
3. **Use Mod+Ctrl** for advanced features
4. **Keep it memorable** - use logical keys (B for Browser, E for Editor)
5. **Document your changes** in KEYBINDINGS.md

### Common Keybinding Patterns

```kdl
# Application launchers
Mod+Letter { spawn "app"; }

# Window management
Mod+Shift+Letter { move-window-action; }

# Workspace switching
Mod+Number { focus-workspace N; }

# System controls
Mod+Shift+Letter { system-action; }
```

---

## Workspaces

### Customize Workspace Layout

Current layout:
1. General/Terminal
2. Browser
3. Communication
4. Photography
5. Gaming
6. Streaming
7-8. (Available)
9. Music

### Change Workspace Assignments

Edit `~/.config/niri/window-rules.kdl`:

```kdl
# Move application to different workspace
window-rule {
    match app-id="firefox"
    open-on-workspace 2  # Change this number
}
```

### Add More Workspaces

Niri supports unlimited workspaces! Just use them:

```kdl
binds {
    # Add workspace 10
    Mod+0 { focus-workspace 10; }
    Mod+Shift+0 { move-column-to-workspace 10; }
}
```

### Workspace Naming (Visual)

While Niri doesn't have built-in workspace names, you can:
1. Document workspace purposes in comments
2. Use consistent workspace numbers
3. Create a reference card

---

## Window Rules

### Add Custom Window Rules

Edit `~/.config/niri/window-rules.kdl`:

#### Float Specific Windows

```kdl
window-rule {
    match app-id="YOUR_APP"
    open-floating true
    default-column-width { fixed 800; }
}
```

#### Set Default Size

```kdl
window-rule {
    match app-id="YOUR_APP"
    default-column-width { proportion 0.5; }  # 50% of screen
}
```

#### Open on Specific Workspace

```kdl
window-rule {
    match app-id="YOUR_APP"
    open-on-workspace 5
}
```

#### Open Maximized

```kdl
window-rule {
    match app-id="YOUR_APP"
    open-maximized true
}
```

#### Custom Opacity

```kdl
window-rule {
    match app-id="YOUR_APP"
    opacity 0.9
}
```

### Find Application IDs

To find an app's ID:

```bash
# Method 1: Use niri
niri msg windows

# Method 2: Launch app and check
# The app-id is usually the executable name
```

---

## Animations

### Customize Animation Speed

Edit `~/.config/niri/animations.kdl`:

```kdl
animations {
    # Make animations faster
    window-open {
        duration-ms 150  # Default: 200
    }
    
    # Make animations slower
    workspace-switch {
        duration-ms 400  # Default: 300
    }
}
```

### Change Animation Curves

```kdl
animations {
    window-open {
        curve "ease-out-expo"  # Snappy
        # or
        curve "ease-in-out-cubic"  # Smooth
        # or
        curve "linear"  # Constant speed
    }
}
```

**Available Curves:**
- `linear` - Constant speed
- `ease-out-cubic` - Fast start, slow end
- `ease-in-cubic` - Slow start, fast end
- `ease-in-out-cubic` - Slow start and end
- `ease-out-expo` - Very snappy
- `ease-in-expo` - Very smooth

### Disable Animations

```kdl
animations {
    # Set duration to 0 to disable
    window-open {
        duration-ms 0
    }
}
```

---

## Wallpapers

### Add Wallpapers

1. **Copy wallpapers** to `~/.config/wallpapers/`

2. **Set default wallpaper** in `~/.config/niri/startup.kdl`:

```kdl
spawn-at-startup {
    command [ "swww" "img" "~/.config/wallpapers/YOUR_WALLPAPER.jpg" 
              "--transition-type" "fade" ]
}
```

### Change Wallpaper Dynamically

```bash
# Change wallpaper
swww img ~/.config/wallpapers/new-wallpaper.jpg --transition-type fade

# Random wallpaper
swww img ~/.config/wallpapers/$(ls ~/.config/wallpapers/ | shuf -n 1)
```

### Wallpaper Rotation Script

Create `~/.config/scripts/rotate-wallpaper.sh`:

```bash
#!/usr/bin/env bash
# Rotate wallpapers every 30 minutes

WALLPAPER_DIR="$HOME/.config/wallpapers"

while true; do
    WALLPAPER=$(ls "$WALLPAPER_DIR" | shuf -n 1)
    swww img "$WALLPAPER_DIR/$WALLPAPER" --transition-type fade
    sleep 1800  # 30 minutes
done
```

Make executable and add to startup:
```bash
chmod +x ~/.config/scripts/rotate-wallpaper.sh
```

Add to `~/.config/niri/startup.kdl`:
```kdl
command [ "~/.config/scripts/rotate-wallpaper.sh" ]
```

### Transition Effects

Available transitions:
- `fade` - Smooth fade
- `wipe` - Wipe across screen
- `grow` - Grow from center
- `outer` - Grow from edges
- `random` - Random effect

---

## Quickshell Widgets

### Customize Existing Widgets

Quickshell widgets are in `home/programs/quickshell/widgets/`

#### Modify Widget Appearance

Edit widget QML files:

```qml
// Change colors
Rectangle {
    color: "#YOUR_COLOR"
}

// Change size
width: 400  // Change this
height: 300  // Change this

// Change font
Text {
    font.family: "YOUR_FONT"
    font.pixelSize: 16
}
```

#### Modify Widget Behavior

```qml
// Change button action
MouseArea {
    onClicked: {
        // Your custom action
        Qt.quit()
    }
}
```

### Create New Widgets

1. **Create widget file**: `~/.config/quickshell/widgets/my-widget.qml`

2. **Basic widget template**:

```qml
import QtQuick 2.15
import QtQuick.Controls 2.15

Window {
    id: root
    width: 400
    height: 300
    visible: true
    title: "My Widget"
    
    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        
        Text {
            anchors.centerIn: parent
            text: "Hello, World!"
            color: "#c0caf5"
            font.pixelSize: 24
        }
    }
}
```

3. **Launch widget**:

```bash
quickshell ~/.config/quickshell/widgets/my-widget.qml
```

### Widget Ideas

- **System Monitor**: CPU, RAM, GPU usage
- **Weather Widget**: Current weather
- **Calendar**: Upcoming events
- **Todo List**: Task manager
- **Music Player**: Spotify controls
- **Notes**: Quick notes widget

---

## Advanced Customization

### Custom Scripts

Create scripts in `~/.config/scripts/`:

```bash
#!/usr/bin/env bash
# Example: Toggle dark/light mode

if [ -f ~/.config/theme-mode ]; then
    MODE=$(cat ~/.config/theme-mode)
else
    MODE="dark"
fi

if [ "$MODE" = "dark" ]; then
    # Switch to light
    echo "light" > ~/.config/theme-mode
    # Apply light theme commands here
else
    # Switch to dark
    echo "dark" > ~/.config/theme-mode
    # Apply dark theme commands here
fi
```

### Custom Startup Applications

Edit `~/.config/niri/startup.kdl`:

```kdl
spawn-at-startup {
    # Add your applications
    command [ "YOUR_APP" ]
    
    # With arguments
    command [ "YOUR_APP" "--arg1" "--arg2" ]
    
    # Run script
    command [ "~/.config/scripts/my-script.sh" ]
}
```

### Custom Environment Variables

Edit `~/.config/niri/environment.kdl`:

```kdl
environment {
    # Add custom variables
    MY_VARIABLE "value"
    
    # Override existing
    EDITOR "YOUR_EDITOR"
}
```

---

## Applying Changes

### Niri Configuration

After editing Niri configs:

```bash
# Reload configuration
# Press: Mod+Shift+R
# Or:
niri msg reload-config
```

### NixOS Configuration

After editing NixOS configs:

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#snaps-pc
```

### Home Manager Configuration

After editing home.nix:

```bash
cd ~/nixos-config
sudo nixos-rebuild switch --flake .#snaps-pc
# Home Manager is integrated, so this rebuilds everything
```

---

## Backup Your Customizations

### Git Workflow

```bash
cd ~/nixos-config

# Check what changed
git status
git diff

# Commit changes
git add .
git commit -m "Customized theme and keybindings"

# Push to GitHub
git push origin main
```

### Create Branches for Experiments

```bash
# Create experimental branch
git checkout -b experimental-theme

# Make changes
# ...

# If you like it, merge to main
git checkout main
git merge experimental-theme

# If you don't like it, just switch back
git checkout main
```

---

## Customization Checklist

- [ ] Choose color scheme
- [ ] Select fonts
- [ ] Customize keybindings
- [ ] Organize workspaces
- [ ] Set window rules
- [ ] Adjust animations
- [ ] Add wallpapers
- [ ] Customize widgets
- [ ] Create custom scripts
- [ ] Document changes
- [ ] Backup to Git

---

## Resources

- **Niri Wiki**: https://github.com/YaLTeR/niri/wiki
- **Quickshell Docs**: https://quickshell.outfoxxed.me/docs/
- **Color Schemes**: https://github.com/mbadolato/iTerm2-Color-Schemes
- **Nerd Fonts**: https://www.nerdfonts.com/
- **Wallpapers**: https://unsplash.com/, https://wallhaven.cc/

---

**Make it yours!** 🎨

For more help, join the Discord: https://discord.gg/nTaknDvdUA