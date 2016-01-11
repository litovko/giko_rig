import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Gyco 1.0
Item {
    id: help
    visible: true
    property RigJoystick joystick:null
    Rectangle {
        id: rectangle1
        width: 500
        height: 455
        gradient: Gradient {
            GradientStop {
                position: 1
                color: "#ffffff"
            }
            
            GradientStop {
                position: 0
                color: "#000000"
            }
        }
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        opacity: 0.8
        border.width: 3
        radius: 10
        z: 0
        border.color: "yellow"

    }
}
