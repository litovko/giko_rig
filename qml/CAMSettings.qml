import QtQuick 2.0
import QtQuick.Controls 1.4
//import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0
import Gyco 1.0
Item {
    id: camSettings
    property alias cam1: checkBox1.checked
    property alias cam2: checkBox2.checked
    property alias cam3: checkBox3.checked
    property alias cam4: checkBox4.checked
//    property list<RigCamera> cam
    Settings{
        category: "CAM_settings"
        property alias cam1: checkBox1.checked
        property alias cam2: checkBox2.checked
        property alias cam3: checkBox3.checked
        property alias cam4: checkBox4.checked
    }
    Rectangle {
        id: rec
        anchors.fill: parent
        border.color: "yellow"
        color: "transparent"
        radius: 10
        clip: true

        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "black";
            }

            GradientStop {
                position: 1.00;
                color: "gray";
            }
        }
        opacity: 0.8
        Text {
            id: t
            text: qsTr("[X]")
            font.bold:  true
            font.pointSize: ma.containsMouse?10:8
            color: ma.containsMouse?"yellow":"white"
            anchors { margins: 5;  top: rec.top; left: rec.left}
            MouseArea {
                id:ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {camSettings.visible=false; camSettings.height=0}
            }
        }
        Column {
            id: clmn
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Label {
                id: label1
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Камера 1")
                font.pointSize: 10
                anchors.left: parent.left
//                visible: cam[0].cameraenabled
                CheckBox {
                    id: checkBox1
                    anchors {left: parent.right; bottom: parent.bottom}
                }
            }
            Label {
                id: label2
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Камера 2")
                font.pointSize: 10
                anchors.left: parent.left
//                visible: cam[1].cameraenabled
                CheckBox {
                    id: checkBox2
                    anchors {left: parent.right; bottom: parent.bottom}
                }
            }
            Label {
                id: label3
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Камера 3")
                font.pointSize: 10
                anchors.left: parent.left
//                visible: cam[2].cameraenabled
                CheckBox {
                    id: checkBox3
                    anchors {left: parent.right; bottom: parent.bottom}
                }
            }
            Label {
                id: label4
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Камера 4")
                font.pointSize: 10
                anchors.left: parent.left
//                visible: cam[3].cameraenabled
                CheckBox {
                    id: checkBox4
                    anchors {left: parent.right; bottom: parent.bottom}
                }
            }
        }


    }
    Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutQuart;
                    easing.amplitude: 0
                    easing.period: 0
                }
            }
}
