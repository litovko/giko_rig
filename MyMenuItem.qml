import QtQuick 2.5
Item {
    id: menuitem
    property string text: "Item1"
    property string command: "Command"
    property bool pressed: false

    Rectangle {
        id: body
        visible: true
        z:1
        anchors.fill: parent
        color: "lightyellow"

        radius: 6
        Component.onCompleted:  console.log("menu w"+parent.width)

        opacity: ma.pressedButtons& Qt.LeftButton ? 0.4:0.7
        border.color: ma.containsMouse?"yellow":"blue"
        border.width: ma.containsMouse?1:4
        Text {
            text: menuitem.text
            anchors.centerIn: parent
        }

        MouseArea {
            id: ma
            z:3
            anchors.fill: body
            hoverEnabled: true
            acceptedButtons: Qt.LeftButton
            propagateComposedEvents: true
            onPressed: menuitem.pressed=ma.pressed
        }
    }

}
