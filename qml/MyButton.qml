import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    id: mb
    property  alias text: t.text
    property string button_border_color: "black"
    property string button_border_color_selected: "white"
    property string button_background_color_selected: "white"
    property alias font: t.font
    signal clicked()
    Rectangle{
        anchors.fill: parent
        border.color: ma.containsMouse? button_border_color_selected:button_border_color
        border.width: ma.containsMouse? 6:1
        radius: 4
        color: ma.containsMouse? button_background_color_selected: "white"
        Text {
            id:t
            anchors.centerIn: parent
        }
        MouseArea {
            id: ma
            anchors.fill: parent
            onClicked: mb.clicked()
            hoverEnabled: true
        }
    }
}
