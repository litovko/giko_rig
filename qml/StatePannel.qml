import QtQuick 2.11
import QtQuick.Window 2.11
import Gyco 1.0
import HYCO 1.0
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
    Onvif{
        id: cam
        address: "192.168.1.168"
        user: "Admin"
        password: "hyco[123]"
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
    Row {
        anchors.right: parent.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.rightMargin: 20
//        anchors.centerIn: parent
        spacing: 10
        MyVolume {
//            anchors.margins: 1
//            anchors.fill: parent
            vol: 0
            width: 80
            height: 40
            onVolChanged: {
                cam.setZoom(vol)
            }
            Component.onCompleted:  cam.getProfiles()
        }
        MyCorners {
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30
            onPressed: {
                if (press)
                    cam.startFocal(-0.1)
                else
                    cam.stopFocal()
            }
        }
        MyCorners {
            anchors.verticalCenter: parent.verticalCenter
            width: 30
            height: 30
            plus: true
            onPressed: {
                if (press)
                    cam.startFocal(0.1)
                else
                    cam.stopFocal()
            }
        }
    }
}
