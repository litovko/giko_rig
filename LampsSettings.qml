import QtQuick 2.0

Item {
    id: lampsSettings
    Rectangle {
        anchors.fill: parent
        border.color: "yellow"
        color: "transparent"
        radius: 10
        Row{
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: 30
            anchors.margins: 10
            spacing: 20
            Tik{
                rotation: -90
                text: "Л1"
                textrotate: 90
                width: 30
                height: 20

            }
            Tik{
                rotation: 90
                text: "Л2"
                width: 10
                height: 20
            }
            Tik{
                rotation: 90
                text: "Л3"
                width: 10
                height: 20
            }
            Tik{
                rotation: 90
                text: "Л4"
                width: 10
                height: 20
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
