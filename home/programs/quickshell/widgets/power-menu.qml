// WehttamSnaps Power Menu Widget
// System power options

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: powerMenu
    width: 400
    height: 350
    visible: true
    title: "WehttamSnaps Power Menu"
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
        border.color: "#FF69B4"
        border.width: 2
        
        // Close button
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (mouse.x > parent.width - 40 && mouse.y < 40) {
                    powerMenu.close()
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
                text: "Power Menu"
                color: "#c0caf5"
                font.pixelSize: 28
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Subtitle
            Text {
                text: "What would you like to do?"
                color: "#FF69B4"
                font.pixelSize: 14
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Spacer
            Item { Layout.fillHeight: true }
            
            // Power Options
            ColumnLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter
                Layout.fillWidth: true
                
                // Lock
                PowerButton {
                    text: "Lock"
                    icon: "🔒"
                    description: "Lock screen"
                    command: "swaylock"
                    color: "#0066CC"
                }
                
                // Logout
                PowerButton {
                    text: "Logout"
                    icon: "🚪"
                    description: "End session"
                    command: "niri msg action quit"
                    color: "#8A2BE2"
                }
                
                // Suspend
                PowerButton {
                    text: "Suspend"
                    icon: "💤"
                    description: "Sleep mode"
                    command: "systemctl suspend"
                    color: "#00FFFF"
                }
                
                // Reboot
                PowerButton {
                    text: "Reboot"
                    icon: "🔄"
                    description: "Restart system"
                    command: "systemctl reboot"
                    color: "#FFD700"
                }
                
                // Shutdown
                PowerButton {
                    text: "Shutdown"
                    icon: "⚡"
                    description: "Power off"
                    command: "~/.config/scripts/jarvis/shutdown.sh"
                    color: "#FF0000"
                }
            }
            
            // Spacer
            Item { Layout.fillHeight: true }
            
            // Footer
            Text {
                text: "Press ESC to cancel"
                color: "#565f89"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "Escape"
        onActivated: powerMenu.close()
    }
}

// Helper component
component PowerButton: Rectangle {
    property string text: ""
    property string icon: ""
    property string description: ""
    property string command: ""
    property color color: "#8A2BE2"
    
    width: 340
    height: 50
    color: buttonArea.containsMouse ? Qt.lighter(parent.color, 1.2) : "#24283b"
    radius: 10
    border.color: buttonArea.containsMouse ? parent.color : "#414868"
    border.width: 2
    Layout.alignment: Qt.AlignHCenter
    
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            console.log("Executing: " + parent.command)
            Qt.quit()
        }
    }
    
    RowLayout {
        anchors.fill: parent
        anchors.margins: 15
        spacing: 15
        
        Text {
            text: parent.parent.icon
            font.pixelSize: 24
            Layout.alignment: Qt.AlignVCenter
        }
        
        ColumnLayout {
            spacing: 2
            Layout.fillWidth: true
            
            Text {
                text: parent.parent.parent.text
                color: "#c0caf5"
                font.pixelSize: 16
                font.bold: true
            }
            
            Text {
                text: parent.parent.parent.description
                color: "#565f89"
                font.pixelSize: 11
            }
        }
    }
}