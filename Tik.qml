import QtQuick 2.0

Item {
    id:tik
    property string text: "-50"
    property int textrotate: 0
    property string color_on: "yellow"
    property string color_off: "gray"
    //property alias transform: t.transform
    state: "ON"
    states: [
           State { name: "ON";
             PropertyChanges { target:m; color: color_on; }
             PropertyChanges { target:t; color: color_on; }
             AnchorChanges {
                   target: m
                   anchors.right: parent.right
                   anchors.left: undefined  //remove the left anchor
               }
           },
           State { name: "OFF";
             PropertyChanges { target:m; color: color_off; }
             PropertyChanges { target:t; color: color_off; }
             AnchorChanges {
                   target: m
                   anchors.left: parent.left
                   anchors.right: undefined  //remove the left anchor
               }
        }
       ]
    transitions: Transition {
            // smoothly reanchor m and move into new position
            AnchorAnimation { duration: 100 }

            ColorAnimation {
                duration: 200
            }

        }
    MouseArea {
           id: mouseArea
           anchors.fill: parent
           onClicked: {
               tik.state == 'ON' ? tik.state = "OFF" : tik.state="ON";
               //console.log("state:"+tik.state)
           }

       }
    Rectangle {
        id: cont
        border.color: color_off
        radius: parent.height/4
        width: parent.width
        height: parent.height
        color: "transparent"
        Rectangle {
            id: m
            width: parent.width/2-2
            height: parent.height-2
            anchors.margins: 1
            color:  color_off;
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            radius: parent.width/10

        }
        Text {
            id: t
            color: color_on
            text: qsTr(tik.text)
            font.pointSize: parent.height
            anchors.right:  parent.left
            anchors.verticalCenter: tik.textrotate==0?parent.verticalCenter: parent.bottom
            anchors.margins: parent.width/10
            transform:  Rotation { angle: tik.textrotate }
        }
    }

}
