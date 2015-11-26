import QtQuick 2.5
import Gyco 1.0


Item {
    id: dashBoard
    property RigModel source

    MyGauge {
            val:j.yaxis
            //anchors.fill: parent
            anchors.bottom: dbr.bottom
            anchors.left: dbr.left
            anchors.bottomMargin: 10
            anchors.leftMargin: 2
            width:6
            height: dashBoard.height-20-width

            z:3
        }
    MyGauge {
            val:j.yaxis
            //anchors.fill: parent
            anchors.bottom: dbr.bottom
            anchors.right: dbr.right
            anchors.bottomMargin: 10
            anchors.rightMargin: 2
            width:6
            height: dashBoard.height-20-width

            z:3
        }
    Rectangle{
        id: dbr
        height: dashBoard.height
        width: dashBoard.width
        color: "transparent"
        radius: 10
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "transparent";
            }
        }
        border.color: "yellow"
        opacity: 0.9
        Rectangle {
            id: r
            anchors { fill: parent; margins: 10}
            color: "transparent"
            border.color: "white"
            radius: 7
            Column{
            spacing: 20

                Rectangle {
                    color:"transparent";
                    width: r.width;
                    height: r.width ;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        anchors.centerIn: parent
                        value: source.ampere
                        maximumValue: 10
                        warningThreshold: maximumValue*0.9
                        stepSize: 2
                        centerТext: "0.1A"
                        bottomText: "Ток"
                        minorTickmarks:5
                    }
                 }
                Rectangle {
                    color:"transparent";
                    width: r.width;
                    height: r.width ;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 50
                        anchors.centerIn: parent
                        value: source.voltage
                        centerТext: "V"
                        bottomText: "Напряжение"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    color:"transparent";
                    width: r.width;
                    height: r.width ;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 120
                        minimunValue: -20
                        stepSize: 20
                        anchors.centerIn: parent
                        value: source.temperature
                        centerТext: "t"
                        bottomText: "Темп. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    color:"transparent";
                    //opacity: 0.5
                    width: r.width;
                    height: r.width ;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 200
                        stepSize: 50
                        anchors.centerIn: parent
                        value: source.pressure
                        centerТext: "кПа"
                        bottomText: "Давл. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:3
                    }
                }

            }
        }
    }
}

