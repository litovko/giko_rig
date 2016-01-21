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
                color: "#ffffff";
            }
        }

        Flow {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20
            MyMenuItem {
              width: 100
              height:100
              text: "NUMBER 1"
            }
        }

//        MouseArea {
//            anchors.fill: parent
//            hoverEnabled: true
//            onContainsMouseChanged: body.border.width=containsMouse?3:1
//              propagateComposedEvents:true
//        }


    }
}
