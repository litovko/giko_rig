import QtQuick 2.5

Item {
    id:axis
    property real value : 0
    property real minimunValue: -127
    property real maximumValue: 127
    property string text: "ТЕСТ"
    property real axiswidth: 10
    property bool container: true
    //Component.onCompleted: height = axis.height+ty.height
    Rectangle {
        id: canvas
        visible: container
        width: axis.width
        height: axis.height
        border.color: "blue"
        //rotation: 90
    }
    Axis {
        width: axiswidth
        height: axis.width
        transformOrigin: Item.Center
        rotation: 90
        anchors.horizontalCenter: parent.horizontalCenter
        y: -height/2+axis.height/2-axiswidth
        //anchors.left: parent.top
        value: axis.value
    }


    Text {
        id: ty
        color: "#3f3f40"
        //anchors.top: scale.bottom
        anchors.horizontalCenter: axis.horizontalCenter
        text: axis.text
        y: axis.height/2
        horizontalAlignment: Text.AlignHCenter
        font.pointSize: 10
    }


}

