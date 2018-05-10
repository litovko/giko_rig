import QtQuick 2.0
import QtQuick.Controls 1.4
//import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
Item {
    id: lampsSettings
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
            text: qsTr("X")
            font.bold: true
            font.pointSize: ma.containsMouse?10:8
            color: ma.containsMouse?"yellow":"white"
            anchors { margins: 5;  top: rec.top; left: rec.left}
            MouseArea {
                id:ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {lampsSettings.visible=false; lampsSettings.height=0}
            }
        }
        Column {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 20

            Label {
                id: label1
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Лампа 1")
                font.pointSize: 10
                anchors.left: parent.left
                Slider {
                    width: rec.width/2
                    anchors.left: parent.right
                }
            }
            Label {
                id: label2
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Лампа 2")
                font.pointSize: 10
                anchors.left: parent.left
                Slider {
                    width: rec.width/2
                    anchors.left: parent.right
                }
            }
            Label {
                id: label3
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Лампа 3")
                font.pointSize: 10
                anchors.left: parent.left
                Slider {
                    width: rec.width/2
                    anchors.left: parent.right
                }
            }
            Label {
                id: label4
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Лампа 4")
                font.pointSize: 10
                anchors.left: parent.left
                Slider {
                    width: rec.width/2
                    anchors.left: parent.right
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
