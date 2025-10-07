// WehttamSnaps Game Launcher Widget
// Quick access to gaming platforms

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: gameLauncher
    width: 500
    height: 450
    visible: true
    title: "WehttamSnaps Game Launcher"
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
        border.color: "#00FFFF"
        border.width: 2
        
        // Close button
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (mouse.x > parent.width - 40 && mouse.y < 40) {
                    gameLauncher.close()
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
        
        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 30
            spacing: 20
            
            // Title
            Text {
                text: "Game Launcher"
                color: "#c0caf5"
                font.pixelSize: 28
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Subtitle
            Text {
                text: "Gaming Platforms & Tools"
                color: "#00FFFF"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Spacer
            Item { Layout.fillHeight: true }
            
            // Application Grid
            GridLayout {
                columns: 2
                rowSpacing: 15
                columnSpacing: 15
                Layout.alignment: Qt.AlignHCenter
                
                // Steam
                GameButton {
                    text: "Steam"
                    icon: "🎮"
                    description: "Game Library"
                    command: "steam"
                }
                
                // Lutris
                GameButton {
                    text: "Lutris"
                    icon: "🕹️"
                    description: "Game Manager"
                    command: "lutris"
                }
                
                // Heroic
                GameButton {
                    text: "Heroic"
                    icon: "🎯"
                    description: "Epic & GOG"
                    command: "heroic"
                }
                
                // Spotify
                GameButton {
                    text: "Spotify"
                    icon: "🎵"
                    description: "Music"
                    command: "spotify"
                }
                
                // Discord
                GameButton {
                    text: "Discord"
                    icon: "💬"
                    description: "Voice Chat"
                    command: "discord"
                }
                
                // OBS
                GameButton {
                    text: "OBS"
                    icon: "📡"
                    description: "Streaming"
                    command: "obs"
                }
            }
            
            // Spacer
            Item { Layout.fillHeight: true }
            
            // Gaming Mode Button
            Rectangle {
                width: 300
                height: 50
                color: gamingModeArea.containsMouse ? "#2a2b3d" : "#24283b"
                radius: 10
                border.color: gamingModeArea.containsMouse ? "#FF69B4" : "#414868"
                border.width: 2
                Layout.alignment: Qt.AlignHCenter
                
                MouseArea {
                    id: gamingModeArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    
                    onClicked: {
                        console.log("Activating Gaming Mode")
                        // Execute gaming mode script
                        Qt.quit()
                    }
                }
                
                RowLayout {
                    anchors.centerIn: parent
                    spacing: 10
                    
                    Text {
                        text: "🚀"
                        font.pixelSize: 24
                    }
                    
                    Text {
                        text: "Activate Gaming Mode"
                        color: "#FF69B4"
                        font.pixelSize: 16
                        font.bold: true
                    }
                }
            }
            
            // Footer
            Text {
                text: "Press ESC to close • Mod+Shift+G for Gaming Mode"
                color: "#565f89"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "Escape"
        onActivated: gameLauncher.close()
    }
}

// Helper component
component GameButton: Rectangle {
    property string text: ""
    property string icon: ""
    property string description: ""
    property string command: ""
    
    width: 200
    height: 80
    color: buttonArea.containsMouse ? "#2a2b3d" : "#24283b"
    radius: 10
    border.color: buttonArea.containsMouse ? "#00FFFF" : "#414868"
    border.width: 2
    
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            console.log("Launching: " + parent.command)
            Qt.quit()
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15
        
        Text {
            text: parent.parent.icon
            font.pixelSize: 32
            Layout.alignment: Qt.AlignVCenter
        }
        
        ColumnLayout {
            spacing: 5
            Layout.fillWidth: true
            
            Text {
                text: parent.parent.parent.text
                color: "#c0caf5"
                font.pixelSize: 18
                font.bold: true
            }
            
            Text {
                text: parent.parent.parent.description
                color: "#565f89"
                font.pixelSize: 12
            }
        }
    }
}