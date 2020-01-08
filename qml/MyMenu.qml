import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4

import QtQuick.Extras 1.4

Item {
    id: menu
    visible: false
    property real itemheight: 100 
    property real itemwidth: 100
    property string command: "Command"
    onVisibleChanged: command="hide menu"
    Rectangle {
        id: body
        color: "transparent"
        anchors.fill: parent
        border.color: "yellow"
        border.width: 3
        radius: 10
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "#888888";
            }
        }

        Flow {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            MyMenuItem {
              width: 120
              height:100
              command: "PROGRAM SETTINGS"
              text: "<p><b>Настройки<br> программы<br>[F11]   [-]<b></p>"
              onButtonClicked:  menu.command=command;
            }
            MyMenuItem {
              width: 120
              height:100
              command: "CAMERA SETTINGS"
              text: "<p><b>Настройки<br> камеры<br>[F10]   [0]<b></p>"
              onButtonClicked:  menu.command=command;
            }
            MyMenuItem {
              width: 120
              height:100
              command: "SET DEFAULT"
              text: "<p><b>Восстановить<br>положение<br>[F8]   [8]<b></p>"
              onButtonClicked:  menu.command=command;
            }

            MyMenuItem {
              width: 120
              height:100
              command: "JOYSTICK SETTINGS"
              text: "<p><b>Настройки<br> джойстика<br>[F9]   [9]<b></p>"
              //onPressedChanged: menu.command=pressed?command:"no command"
              onButtonClicked:  menu.command=command;

            }
            MyMenuItem {
              width: 120
              height:100
              command: "PLAY"
              text: "<p><b>СТАРТ<br> видео<br>[F5]   [5]<b></p>"
              onButtonClicked:  menu.command=command;

            }
            MyMenuItem {
              width: 120
              height:100
              command: "STOP"
              onVisibleChanged:  pressed=false
              text: "<p><b>СТОП<br> видео<br>[F6]   [6]<b></p>"
              onButtonClicked:  menu.command=command;
            }
        }
    }
}
