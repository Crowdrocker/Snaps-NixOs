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
        border.color: "#8a2be2"
        border.width: 2
        
        Column {
            anchors.centerIn: parent
            spacing: 10
            
            Text {
                text: "WORK LAUNCHER"
                color: "#00ffff"
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            Grid {
                columns: 2
                spacing: 10
                
                Button {
                    text: "GIMP"
                    onClicked: Process.startDetached("gimp")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
                
                Button {
                    text: "Inkscape"
                    onClicked: Process.startDetached("inkscape") 
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
                
                Button {
                    text: "Krita"
                    onClicked: Process.startDetached("krita")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
                
                Button {
                    text: "Discord"
                    onClicked: Process.startDetached("discord")
                    background: Rectangle {
                        color: "#8a2be2"
                        radius: 5
                    }
                }
            }
        }
    }
}
