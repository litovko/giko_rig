import QtQuick 2.5
import QtQuick.Window 2.2
import Gyco 1.0

Window {
    visible: true
    RigModel {
        id: rig
        pressure:   100
        oiltemp:    20
        address:  "localhost"

    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.AllButtons
        onClicked: {
            if (mouse.button == Qt.RightButton){
                   console.log(rig.server_connected?"black":"white");
                   console.log(rig.server_ready?"black":"white");
                   rig.pressure=111  ;
            }
            else
                   Qt.quit();
        }
    }
    Rectangle{
        width: 20
        height: 20
        color: rig.server_ready?"black":"white"
        border.color: "black"
        anchors.top: parent.top
    }
    Rectangle{
        width: 20
        height: 20
        color: rig.server_connected?"black":"white"
        border.color: "black"
        anchors.bottom: parent.bottom
    }

    Text {
        id: txt
        text:  "pressure "+rig.pressure + "server:" + rig.server_connected===true?"connected":"no connection"// + " " + rig.server_ready
        anchors.centerIn: parent
    }
}

