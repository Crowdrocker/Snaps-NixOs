import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Widget {
    width: 300
    height: 200
    
    Rectangle {
        anchors.fill: parent
        color: "#1a1b26"
        opacity: 0.9
        radius: 10
        border.color: "#ff69b4"
        border.width: 2
        
        Column {
            anchors.centerIn: parent
            spacing: 10
            
            Text {
                text: "GAMING LAUNCHER"
                color: "#00ffff"
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Grid {
                columns: 2
                spacing: 10
                
                Button {
                    text: "Steam"
                    onClicked: Process.startDetached("steam")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
                
                Button {
                    text: "Lutris"
                    onClicked: Process.startDetached("lutris")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
                
                Button {
                    text: "Heroic"
                    onClicked: Process.startDetached("heroic")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
                
                Button {
                    text: "OBS"
                    onClicked: Process.startDetached("obs")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
            }
        }
    }
}
