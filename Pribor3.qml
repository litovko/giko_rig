import QtQuick 2.5
import QtQuick.Extras 1.4

import QtQuick.Controls.Styles 1.4

// Прибор с тремя стрелками
Item {
    id:pr
    property real value1 : 0
    property real value2 : 0
    property real value3 : 0
    property real leftAngle: -75
    property real rightAngle: 75
    property real minimunValue: 0
    property real maximumValue: 100
    property string centrТext: "Вольт"
    property string bottomText: "Напряжение"
    property real stepSize: 10
    property real minorTickmarks: 1
    property real warningThreshold: 90
    property bool thirdvisible: true


    CircularGauge {
        id: cg1
        width: parent.width
        height: parent.width
        value: pr.value1
        minimumValue: pr.minimunValue; maximumValue: pr.maximumValue
        style: CircularGaugeStyle {

            //foreground: null
            minimumValueAngle: pr.leftAngle
            maximumValueAngle: pr.rightAngle
            minorTickmarkCount: pr.minorTickmarks
            tickmarkStepSize: pr.stepSize

            needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.10
                            implicitHeight: outerRadius * 1.1
                            antialiasing: true
                            color: "yellow"
                            border.color: "blue"
                            border.width: 2
                            radius: 5
                        }
            tickmark: Rectangle {
                //visible: styleData.value < warningThreshold || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.15
                color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                border.color: "black"
            }
            minorTickmark: Rectangle {
                //visible: styleData.value < warningThreshold || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.06
                color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                border.color: "black"
            }
            tickmarkLabel:  Text {
                            font.pixelSize: Math.max(6, outerRadius * 0.2)
                            text: styleData.value
                            style: Text.Outline
                            color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                            antialiasing: true

                        }

            background: Item {

                Text {
                    id: rpmText
                    font.pixelSize: parent.width/6
                    text: bottomText
                    color: "yellow"
                    style: Text.Outline
                    horizontalAlignment: Text.AlignRight
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.verticalCenter
                    anchors.topMargin: 20
                }
                Text {
                    text: centrТext
                    color: "white"
                    font.pixelSize: parent.width/6
                    style: Text.Outline
                    anchors.top: parent.top
                    anchors.topMargin: parent.height / 4
                    anchors.horizontalCenter: parent.horizontalCenter
                }

                Text {
                    text: value1.toString()
                    //color: "white"
                    color: pr.value1 >= warningThreshold ? "#e34c22" : "yellow"
                    font.pixelSize: parent.width/6
                    style: Text.Outline
                    anchors.top: rpmText.bottom
                    anchors.left:  parent.left
                }
                Text {
                    text: value2.toString()
                    //color: "white"
                    color: pr.value2 >= warningThreshold ? "#e34c22" : "lightgreen"
                    font.pixelSize: parent.width/6
                    style: Text.Outline
                    anchors.top: rpmText.bottom
                    anchors.horizontalCenter: thirdvisible?parent.horizontalCenter:undefined
                    anchors.right: thirdvisible?undefined:parent.right
                }
                Text {
                    text: value3.toString()
                    //color: "white"
                    color: pr.value3 >= warningThreshold ? "#e34c22" : "lightpink"
                    font.pixelSize: parent.width/6
                    style: Text.Outline
                    anchors.top: rpmText.bottom
                    anchors.right: parent.right
                    visible: thirdvisible
                }

            }
        }

        Behavior on value {
                NumberAnimation {
                    duration: 200
                }
            }
    }
    CircularGauge {
        id: cg2
        width: parent.width
        height: parent.width
        value: pr.value2
        minimumValue: pr.minimunValue; maximumValue: pr.maximumValue
        style: CircularGaugeStyle {

            //foreground: null
            minimumValueAngle: pr.leftAngle
            maximumValueAngle: pr.rightAngle
            minorTickmarkCount: pr.minorTickmarks
            tickmarkStepSize: pr.stepSize

            needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.10
                            implicitHeight: outerRadius * 1.1
                            antialiasing: true
                            color: "lightgreen"
                            border.color: "blue"
                            border.width: 2
                            radius: 5
                        }
            tickmark: Rectangle {
                visible: false
                //visible: styleData.value < warningThreshold || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.15
                color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                border.color: "black"
            }
            minorTickmark: Rectangle {
                visible: false
                //visible: styleData.value < warningThreshold || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.06
                color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                border.color: "black"
            }
            tickmarkLabel:  Text {
                            visible: false
                            font.pixelSize: Math.max(6, outerRadius * 0.2)
                            text: styleData.value
                            style: Text.Outline
                            color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                            antialiasing: true

                        }

            background: Canvas {
                visible: false

            }
        }

        Behavior on value {
                NumberAnimation {
                    duration: 200
                }
            }
    }
    CircularGauge {
        id:cg3
        width: parent.width
        height: parent.width
        value: pr.value3
        visible: pr.thirdvisible
        minimumValue: pr.minimunValue; maximumValue: pr.maximumValue
        style: CircularGaugeStyle {

            //foreground: null
            minimumValueAngle: pr.leftAngle
            maximumValueAngle: pr.rightAngle
            minorTickmarkCount: pr.minorTickmarks
            tickmarkStepSize: pr.stepSize

            needle: Rectangle {
                            y: outerRadius * 0.15
                            implicitWidth: outerRadius * 0.10
                            implicitHeight: outerRadius * 1.1
                            antialiasing: true
                            color: "lightpink"
                            border.color: "blue"
                            border.width: 2
                            radius: 5
                        }
            tickmark: Rectangle {
                visible: false
                //visible: styleData.value < warningThreshold || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.15
                color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                border.color: "black"
            }
            minorTickmark: Rectangle {
                visible: false
                //visible: styleData.value < warningThreshold || styleData.value % 10 == 0
                implicitWidth: outerRadius * 0.06
                antialiasing: true
                implicitHeight: outerRadius * 0.06
                color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                border.color: "black"
            }
            tickmarkLabel:  Text {
                            visible: false
                            font.pixelSize: Math.max(6, outerRadius * 0.2)
                            text: styleData.value
                            style: Text.Outline
                            color: styleData.value >= warningThreshold ? "#e34c22" : "yellow"
                            antialiasing: true

                        }

            background: Canvas {
                visible: false
            }
        }

        Behavior on value {
                NumberAnimation {
                    duration: 200
                }
            }
    }
}

