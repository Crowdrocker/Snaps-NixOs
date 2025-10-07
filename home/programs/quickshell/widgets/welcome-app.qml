// WehttamSnaps Welcome App
// First-time user guide and quick reference

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: welcomeApp
    width: 700
    height: 600
    visible: true
    title: "Welcome to WehttamSnaps NixOS"
    color: "transparent"
    flags: Qt.FramelessWindowHint | Qt.WindowStaysOnTopHint
    
    // Center on screen
    x: (Screen.width - width) / 2
    y: (Screen.height - height) / 2
    
    // Background
    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        radius: 15
        border.width: 3
        
        // Gradient border
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: "#8A2BE2" }
            GradientStop { position: 1.0; color: "#00FFFF" }
        }
        
        // Inner content area
        Rectangle {
            anchors.fill: parent
            anchors.margins: 3
            color: "#1a1b26"
            radius: 12
            
            // Close button
            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (mouse.x > parent.width - 40 && mouse.y < 40) {
                        welcomeApp.close()
                    }
                }
            }
            
            Text {
                anchors.top: parent.top
                anchors.right: parent.right
                anchors.margins: 15
                text: "✕"
                color: "#c0caf5"
                font.pixelSize: 20
                font.bold: true
            }
            
            ScrollView {
                anchors.fill: parent
                anchors.margins: 30
                clip: true
                
                ColumnLayout {
                    width: parent.width
                    spacing: 20
                    
                    // Header
                    ColumnLayout {
                        spacing: 10
                        Layout.fillWidth: true
                        
                        Text {
                            text: "Welcome to WehttamSnaps"
                            color: "#c0caf5"
                            font.pixelSize: 32
                            font.bold: true
                            Layout.alignment: Qt.AlignHCenter
                        }
                        
                        Text {
                            text: "Your NixOS Gaming & Streaming Setup"
                            color: "#8A2BE2"
                            font.pixelSize: 16
                            Layout.alignment: Qt.AlignHCenter
                        }
                    }
                    
                    // Divider
                    Rectangle {
                        height: 2
                        Layout.fillWidth: true
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#8A2BE2" }
                            GradientStop { position: 1.0; color: "#00FFFF" }
                        }
                    }
                    
                    // Quick Start Section
                    SectionHeader { text: "🚀 Quick Start" }
                    
                    InfoText {
                        text: "• Press <b>Super+D</b> to open app launcher\n" +
                              "• Press <b>Super+W</b> for work apps\n" +
                              "• Press <b>Super+G</b> for gaming apps\n" +
                              "• Press <b>Super+Shift+G</b> to activate gaming mode\n" +
                              "• Press <b>Super+Shift+T</b> to activate streaming mode"
                    }
                    
                    // Workspaces Section
                    SectionHeader { text: "🗂️ Workspaces" }
                    
                    InfoText {
                        text: "• <b>Workspace 1</b>: General/Terminal\n" +
                              "• <b>Workspace 2</b>: Browser\n" +
                              "• <b>Workspace 3</b>: Communication (Discord)\n" +
                              "• <b>Workspace 4</b>: Photography (GIMP, Krita)\n" +
                              "• <b>Workspace 5</b>: Gaming (Steam, Lutris)\n" +
                              "• <b>Workspace 6</b>: Streaming (OBS)\n" +
                              "• <b>Workspace 9</b>: Music (Spotify)"
                    }
                    
                    // Essential Keybindings
                    SectionHeader { text: "⌨️ Essential Keybindings" }
                    
                    GridLayout {
                        columns: 2
                        columnSpacing: 20
                        rowSpacing: 10
                        Layout.fillWidth: true
                        
                        KeybindItem { key: "Super+Return"; action: "Terminal" }
                        KeybindItem { key: "Super+Q"; action: "Close window" }
                        KeybindItem { key: "Super+F"; action: "Fullscreen" }
                        KeybindItem { key: "Super+1-9"; action: "Switch workspace" }
                        KeybindItem { key: "Super+A"; action: "Audio mixer" }
                        KeybindItem { key: "Super+Shift+A"; action: "Audio routing" }
                    }
                    
                    // Gaming Section
                    SectionHeader { text: "🎮 Gaming" }
                    
                    InfoText {
                        text: "• Launch Steam: <b>Super+G</b> → Steam\n" +
                              "• Activate gaming mode: <b>Super+Shift+G</b>\n" +
                              "• Monitor performance: <b>Super+Escape</b> (btop)\n" +
                              "• GPU monitor: <b>Super+Shift+Escape</b> (nvtop)"
                    }
                    
                    // Audio Section
                    SectionHeader { text: "🎵 Audio Routing" }
                    
                    InfoText {
                        text: "• Open audio routing: <b>Super+Shift+A</b>\n" +
                              "• Open audio mixer: <b>Super+A</b>\n" +
                              "• Virtual sinks: Game, Browser, Discord, Spotify\n" +
                              "• Perfect for streaming with OBS!"
                    }
                    
                    // Resources Section
                    SectionHeader { text: "📚 Resources" }
                    
                    InfoText {
                        text: "• Documentation: ~/nixos-config/docs/\n" +
                              "• Keybindings: docs/KEYBINDINGS.md\n" +
                              "• Gaming guide: docs/GAMING.md\n" +
                              "• Audio guide: docs/AUDIO_ROUTING.md\n" +
                              "• Discord: https://discord.gg/nTaknDvdUA"
                    }
                    
                    // Quick Actions
                    SectionHeader { text: "⚡ Quick Actions" }
                    
                    RowLayout {
                        spacing: 10
                        Layout.alignment: Qt.AlignHCenter
                        
                        ActionButton {
                            text: "Keybindings"
                            icon: "⌨️"
                            command: "xdg-open ~/nixos-config/docs/KEYBINDINGS.md"
                        }
                        
                        ActionButton {
                            text: "Gaming Guide"
                            icon: "🎮"
                            command: "xdg-open ~/nixos-config/docs/GAMING.md"
                        }
                        
                        ActionButton {
                            text: "Discord"
                            icon: "💬"
                            command: "xdg-open https://discord.gg/nTaknDvdUA"
                        }
                    }
                    
                    // Footer
                    Rectangle {
                        height: 2
                        Layout.fillWidth: true
                        Layout.topMargin: 20
                        gradient: Gradient {
                            orientation: Gradient.Horizontal
                            GradientStop { position: 0.0; color: "#8A2BE2" }
                            GradientStop { position: 1.0; color: "#00FFFF" }
                        }
                    }
                    
                    Text {
                        text: "Press ESC to close • Press Super+H to reopen"
                        color: "#565f89"
                        font.pixelSize: 12
                        Layout.alignment: Qt.AlignHCenter
                        Layout.bottomMargin: 10
                    }
                }
            }
        }
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "Escape"
        onActivated: welcomeApp.close()
    }
}

// Helper components
component SectionHeader: Text {
    property string text: ""
    text: parent.text
    color: "#00FFFF"
    font.pixelSize: 20
    font.bold: true
    Layout.topMargin: 10
}

component InfoText: Text {
    property string text: ""
    text: parent.text
    color: "#c0caf5"
    font.pixelSize: 14
    wrapMode: Text.WordWrap
    Layout.fillWidth: true
    textFormat: Text.RichText
}

component KeybindItem: RowLayout {
    property string key: ""
    property string action: ""
    spacing: 10
    
    Rectangle {
        width: 150
        height: 30
        color: "#24283b"
        radius: 5
        border.color: "#414868"
        border.width: 1
        
        Text {
            anchors.centerIn: parent
            text: parent.parent.key
            color: "#8A2BE2"
            font.pixelSize: 12
            font.family: "monospace"
        }
    }
    
    Text {
        text: parent.action
        color: "#c0caf5"
        font.pixelSize: 13
    }
}

component ActionButton: Rectangle {
    property string text: ""
    property string icon: ""
    property string command: ""
    
    width: 150
    height: 50
    color: buttonArea.containsMouse ? "#2a2b3d" : "#24283b"
    radius: 8
    border.color: buttonArea.containsMouse ? "#8A2BE2" : "#414868"
    border.width: 2
    
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            console.log("Opening: " + parent.command)
        }
    }
    
    ColumnLayout {
        anchors.centerIn: parent
        spacing: 5
        
        Text {
            text: parent.parent.icon
            font.pixelSize: 20
            Layout.alignment: Qt.AlignHCenter
        }
        
        Text {
            text: parent.parent.text
            color: "#c0caf5"
            font.pixelSize: 12
            Layout.alignment: Qt.AlignHCenter
        }
    }
}