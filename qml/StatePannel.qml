import QtQuick 2.11
import QtQuick.Window 2.11
import Gyco 1.0
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4

Rectangle {
    id: statePannel
    z: 3
    border.color: "yellow"
    radius: 10
    GradientStop {
        position: 0.00;
        color: "#000000";
    }
    GradientStop {
        position: 1.00;
        color: "transparent";
    }
    opacity: 0.8
    color: "black"
    //width:parent.width
    height: 40
    width: mainRect.width-height
    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        //right: parent.right
        margins: 10
    }
    
    Row {
        spacing: 10
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            //right: parent.right
            margins: 10
        }

        Text {
            text: "v"+Qt.application.version+" Тип аппарата:" + "МГМ-7 Статус камеры " + cams[0].name + ":" + cams[0].cam.state
            color: "lightblue"
            font.pointSize: 12
        }

    }
}
