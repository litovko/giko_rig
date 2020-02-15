import QtQuick 2.11
import QtQuick.Window 2.11
//import QtQuick.Controls 2.5
import Gyco 1.0
import QmlVlc 0.1
//import QtMultimedia 5.5
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4

//import QtQml 2.2
Rectangle {
    id: joystick_setup
    border.color: "yellow"
    border.width: 3
    gradient: Gradient {
        GradientStop {
            id: gradientStop1
            position: 1
            color: "#a6a6a6"
        }

        GradientStop {
            position: 0
            color: "#000000"
        }
    }
    color: "black"
    width: 1040
    height: 550
    radius: 10
    anchors.centerIn: parent
    anchors.margins: 0
    visible: false    
    SetupJoystick {
        id: joysetup
        text: "Джойстик 1 - движение"
        width: 500
        height: 500

        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        joystick: j1

        rect.border.width: 0
    }
    SetupJoystick {
        id: joysetup2
        text: "Джойстик 2 - манипулятор"
        width: 500
        height: 500
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 10
        btn_apply.visible: false
        btn_close.visible: false
        joystick: j2
        rect.border.width: 0
    }
    
}
