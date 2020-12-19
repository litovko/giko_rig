import QtQuick 2.11
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
Item {
    id: lamp
    property alias active: i.active
    property string bottomText: "ЛАМПЫ[F2]"
    property int fontSize: 12
    property bool error: false
    property string command: "Command"
    property string command2: "command2"
    property string command3: "command3"
    signal lampClicked(string lamp_command)
    property string text: ""
    MouseArea {
        id: ma
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked:  {
            if (mouse.button===Qt.LeftButton) {
                                lampClicked(command)
            }
            else lampClicked(command3)
        }
        onDoubleClicked: lampClicked(command2)
        hoverEnabled: true
    }

    Rectangle {
        color: "transparent"
        anchors.margins: 20
        width: lamp.width
        height:  lamp.height
        Column{
            id:column
            anchors.centerIn: parent
            StatusIndicator {
                id: i

                width: lamp.height/3
                height: lamp.height/3
                color: !error?"yellow":"lightgray"
                anchors.horizontalCenter: column.horizontalCenter
                Rectangle {
                    anchors.fill: parent
                    color:"transparent"
                    border.color: ma.containsMouse?"yellow":"transparent"
                    radius: 10
                }
            }


            Rectangle {
                id: tr
                width: lamp.width
                height: lamp.height/2
                anchors.horizontalCenter: column.horizontalCenter
                color: "transparent"
                Text {
                    text: lamp.bottomText;
                    font.pointSize: lamp.fontSize
                    //fontSizeMode: Text.Fit
                    color: !error?"yellow":"lightgray"
                    horizontalAlignment: Text.AlignHCenter;
                    verticalAlignment: Text.AlignVCenter;
                    anchors.fill:  parent
                }
            }
        }
        Text {
            id: tooltip
            color: "white"
            text: lamp.text
            font.bold: true
            font.pointSize: 10
            visible: ma.containsMouse
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.bottom:  parent.top
            anchors.left: parent.horizontalCenter
        }
    }
}