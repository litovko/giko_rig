import QtQuick 2.12
import QtQuick.Controls 2.12

//import QmlVlc 0.1
import Gyco 1.0
Rectangle {
    id: switcher
    height: parent.height
    width: 120
    border.color: mar.containsMouse? "white" : "gray"
    color: "transparent"
    anchors.left: parent.right
    property bool inv: true
    Text {
        id: ttt
        text: switcher.inv? qsTr("Инвертирована"):qsTr("Неинвертирована")
        font.pointSize: parent.height/2
        color: switcher.inv? "white" : "gray"
        anchors.centerIn: parent
        
    }
    MouseArea {
        id: mar
        anchors.fill: parent
        hoverEnabled: true
        onClicked: switcher.inv=!switcher.inv
    }
}
