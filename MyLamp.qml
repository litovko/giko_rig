import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
Item {
    id: lamp
    property bool active: false
    property string bottomText: "ЛАМПЫ[F2]"
    property int fontSize: 12
    property bool error: false
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
                active: lamp.active
                width: lamp.height/3
                height: lamp.height/3
                color: !error?"yellow":"lightgray"
                anchors.horizontalCenter: column.horizontalCenter
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
    }
}
