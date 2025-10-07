// WehttamSnaps Work Launcher Widget
// Quick access to photography and design tools

import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Window {
    id: workLauncher
    width: 500
    height: 400
    visible: true
    title: "WehttamSnaps Work Launcher"
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
        border.color: "#8A2BE2"
        border.width: 2
        
        // Close button
        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (mouse.x > parent.width - 40 && mouse.y < 40) {
                    workLauncher.close()
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
                text: "Work Launcher"
                color: "#c0caf5"
                font.pixelSize: 28
                font.bold: true
                Layout.alignment: Qt.AlignHCenter
            }
            
            // Subtitle
            Text {
                text: "Photography & Design Tools"
                color: "#8A2BE2"
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
                
                // GIMP
                AppButton {
                    text: "GIMP"
                    icon: "🎨"
                    description: "Photo Editing"
                    command: "gimp"
                }
                
                // Krita
                AppButton {
                    text: "Krita"
                    icon: "🖌️"
                    description: "Digital Painting"
                    command: "krita"
                }
                
                // Inkscape
                AppButton {
                    text: "Inkscape"
                    icon: "✏️"
                    description: "Vector Graphics"
                    command: "inkscape"
                }
                
                // Darktable
                AppButton {
                    text: "Darktable"
                    icon: "📸"
                    description: "RAW Processing"
                    command: "darktable"
                }
                
                // Discord
                AppButton {
                    text: "Discord"
                    icon: "💬"
                    description: "Communication"
                    command: "discord"
                }
                
                // File Manager
                AppButton {
                    text: "Files"
                    icon: "📁"
                    description: "File Manager"
                    command: "thunar"
                }
            }
            
            // Spacer
            Item { Layout.fillHeight: true }
            
            // Footer
            Text {
                text: "Press ESC to close"
                color: "#565f89"
                font.pixelSize: 12
                Layout.alignment: Qt.AlignHCenter
            }
        }
    }
    
    // Component for application buttons
    Component {
        id: appButtonComponent
        
        Rectangle {
            id: button
            width: 200
            height: 80
            color: buttonArea.containsMouse ? "#2a2b3d" : "#24283b"
            radius: 10
            border.color: buttonArea.containsMouse ? "#8A2BE2" : "#414868"
            border.width: 2
            
            property string text: ""
            property string icon: ""
            property string description: ""
            property string command: ""
            
            MouseArea {
                id: buttonArea
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                
                onClicked: {
                    // Launch application
                    Qt.createQmlObject('import QtQuick 2.15; Timer { interval: 100; running: true; onTriggered: Qt.quit() }', button)
                    // Execute command (this would need proper implementation)
                    console.log("Launching: " + parent.command)
                }
            }
            
            RowLayout {
                anchors.fill: parent
                anchors.margins: 15
                spacing: 15
                
                // Icon
                Text {
                    text: button.icon
                    font.pixelSize: 32
                    Layout.alignment: Qt.AlignVCenter
                }
                
                // Text
                ColumnLayout {
                    spacing: 5
                    Layout.fillWidth: true
                    
                    Text {
                        text: button.text
                        color: "#c0caf5"
                        font.pixelSize: 18
                        font.bold: true
                    }
                    
                    Text {
                        text: button.description
                        color: "#565f89"
                        font.pixelSize: 12
                    }
                }
            }
        }
    }
    
    // Keyboard shortcuts
    Shortcut {
        sequence: "Escape"
        onActivated: workLauncher.close()
    }
}

// Helper component
component AppButton: Rectangle {
    property string text: ""
    property string icon: ""
    property string description: ""
    property string command: ""
    
    width: 200
    height: 80
    color: buttonArea.containsMouse ? "#2a2b3d" : "#24283b"
    radius: 10
    border.color: buttonArea.containsMouse ? "#8A2BE2" : "#414868"
    border.width: 2
    
    MouseArea {
        id: buttonArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        
        onClicked: {
            // Launch application (implement proper command execution)
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