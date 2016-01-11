import QtQuick 2.5

Item {
    id:axis
    property real value : 0
    property real minimunValue: -127
    property real maximumValue: 127
    Rectangle {
        id: scale
        width: axis.width
        height: parent.height
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
        border.color: "#3f3f40"
        radius: 6
        Rectangle {
           id: runner
           anchors.horizontalCenter: scale.horizontalCenter
           width: scale.width*1.1
           height: width
           color: "#0d04fd"
           border.width: 1
           border.color: "light blue"
           radius: 5
           y: (axis.height/2-runner.height/2)-axis.value*(axis.height-runner.height)/(axis.maximumValue-axis.minimunValue)
           //    axis.value/(axis.maximumValue-axis.minimumValue)
           //y: axis.value
           onYChanged: console.log(y+",,,"+axis.value)
        }
    }
}

