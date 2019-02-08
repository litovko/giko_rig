import QtQuick 2.5

Item {
    id:axis
    property real value : 0
    property real schale_value : 1
    property real minimunValue: -127
    property real maximumValue: 127
    property string text: "ТЕСТ"
    property real axiswidth: 10
    property bool container: true
    Rectangle {
        visible: container
        width: axis.width
        height: axis.height
        border.color: "blue"
    }
        Rectangle {
            id: scale
            width: axiswidth
            height: axis.height-ty.height
            anchors.horizontalCenter: parent.horizontalCenter
            color: "transparent"

            gradient: Gradient {
                GradientStop {
                    position: 0.00;
                    color: "#111111";
                }
                GradientStop {
                    position: 0.5;
                    color: "#aaaaaa";
                }
                GradientStop {
                    position: 1.00;
                    color: "#111111";
                }
            }
            border.color: ma.containsMouse?"yellow":"#3f3f40"
            radius: 6
            MouseArea {
                        id: ma
                        anchors.fill: parent
                        hoverEnabled: true
                    }
            Rectangle {
               id: runner
               anchors.horizontalCenter: scale.horizontalCenter
               width: scale.width*1.1
               height: width
               color: "#0d04fd"
               border.width: 1
               border.color: "light blue"
               radius: 5
               y: (scale.height/2-runner.height/2)-axis.value*(scale.height-runner.height)/(axis.maximumValue-axis.minimunValue)

            }
        }
        Text {
            id: ty
            color: "#3f3f40"
            anchors.top: scale.bottom
            anchors.horizontalCenter: scale.horizontalCenter
            text: axis.text
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 10
        }

}

