import QtQuick 2.5
import Gyco 1.0




Item {
    id: dashBoard
    property RigModel source
    property int gaugesize: 180-20 // 20 - поля: два по 10
    property int containerheight: 1080

    state: "grab2"
    states: [
        State {
            name: "grab2"
        //    PropertyChanges {target: dashBoard; width: 180}
        },
        State {
            name: "grab6"
        //    PropertyChanges {target: dashBoard;   width: 360}
        },
        State {
            name: "gkgbu"
        //    PropertyChanges {target: dashBoard;   width: 540}
        }
    ]
    function calculatesize(){
        console.log("Dashboard - recalculate width and height")
        var num_gauge=flowrow.visibleChildren.length
        var numrows=Math.floor(containerheight/(gaugesize+20))
        numrows=numrows?numrows:num_gauge
        var numcolm=Math.ceil(num_gauge/numrows) //округляем в большую сторону
        numrows=Math.ceil(num_gauge/numcolm)
        dashBoard.width=(numcolm)*(gaugesize+20)
        dashBoard.height=(gaugesize+20)*numrows
    }

    onStateChanged: {
        console.log("DashBoard stat:"+state);
        calculatesize()

    }
    onContainerheightChanged: calculatesize()

    MyGauge {
            val:j.y1axis
            //anchors.fill: parent
            anchors.bottom: dbr.bottom
            anchors.left: dbr.left
            anchors.bottomMargin: 10
            anchors.leftMargin: 2
            width:6
            height: dashBoard.height-20-width
            color: j.y1axis>0?"yellow":"lightblue"
            z:3
        }
    MyGauge {
            val: gauge_value()
            function gauge_value(){
                if (dashboard.state==="grab2") return j.y1axis
                if (dashboard.state==="grab6") return j.y2axis
            }
            function gauge_color(){
                if (dashboard.state==="grab2") return j.y1axis>0?"yellow":"lightblue"
                if (dashboard.state==="grab6") return j.y2axis>0?"yellow":"lightblue"
            }
            //anchors.fill: parent
            anchors.bottom: dbr.bottom
            anchors.right: dbr.right
            anchors.bottomMargin: 10
            anchors.rightMargin: 2
            width:6
            height: dashBoard.height-20-width
            color: gauge_color()
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
        border.width: ma.containsMouse?3:1;
        opacity: 0.9

        Rectangle {
            id: r
            anchors { fill: parent; margins: 10}
            color: "transparent"
            border.color: "white"
            border.width: ma.containsMouse?2:1;
            radius: 7
            MouseArea{
                id: ma
                anchors.fill: parent
                hoverEnabled: true
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                onReleased: {
                    j.yaxis=0;
                }

                onPressed: {
                    j.y1axis=(ma.pressedButtons&Qt.RightButton?-1:1)*(127- 127*ma.mouseY/r.height)
                    //console.log("Joy Y:"+j.yaxis)
                    j.ispresent=false;
                }
                onPositionChanged: {
                    if (ma.pressedButtons&(Qt.LeftButton|Qt.RightButton)&&ma.containsMouse)
                    j.y1axis=(ma.pressedButtons&Qt.RightButton?-1:1)*(127- 127*ma.mouseY/r.height)
                    else j.y1axis=0;
                    //console.log("Joy Y:"+j.yaxis+"btn:"+(ma.pressedButtons&(Qt.LeftButton|Qt.RightButton)))

                }
            }
            Flow{
              id: flowrow
              spacing: 20
              anchors.fill: parent


              add: Transition {
                      NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                      NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
                  }
              populate: Transition {
                      NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                      NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
                  }
              move: Transition {
                      NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
                      NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
                  }
                Rectangle {
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        anchors.centerIn: parent
                        value: source.ampere
                        maximumValue: 100
                        warningThreshold: maximumValue*0.9
                        stepSize: 20
                        centerТext: "A"
                        bottomText: "Сила тока"
                        minorTickmarks:10
                    }
                 }
                Rectangle {
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 500
                        stepSize: 100
                        anchors.centerIn: parent
                        value: source.voltage
                        centerТext: "V"
                        bottomText: "Напряжение"
                        warningThreshold: 450
                        minorTickmarks: 50
                    }
                }
                Rectangle {
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 120
                        minimunValue: -20
                        stepSize: 20
                        anchors.centerIn: parent
                        value: source.temperature
                        centerТext: "t\u00B0"
                        bottomText: "Темп. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    color:"transparent";
                    //opacity: 0.5
                    width:  gaugesize;
                    height: gaugesize;
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
                Rectangle {
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 60
                        stepSize: 10
                        anchors.centerIn: parent
                        value: source.voltage24
                        centerТext: "V"
                        bottomText: "Шина 24В"
                        warningThreshold: 49
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    visible: dashboard.state==="gkgbu"?true:false
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 10
                        stepSize: 2
                        anchors.centerIn: parent
                        value: source.turns
                        centerТext: "x100"
                        bottomText: "Обороты"
                        warningThreshold: 9
                        minorTickmarks:1
                    }
                }
                Rectangle {
                    id: power
                    color:"transparent";
                    //opacity: 0.5
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 100
                        stepSize: 20
                        anchors.centerIn: parent

                        value: j.y1axis>0?Math.round(j.y1axis*100/127):-Math.round(j.y1axis*100/127)
                        centerТext: "%"
                        bottomText: "Мощность"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: power2
                    color:"transparent";
                    //opacity: 0.5
                    width:  gaugesize;
                    height: gaugesize;
                    visible: dashboard.state==="grab6"
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 100
                        stepSize: 20
                        anchors.centerIn: parent

                        value: j.y2axis>0?Math.round(j.y2axis*100/127):-Math.round(j.y2axis*100/127)
                        centerТext: "%"
                        bottomText: "Мощность2"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }

            }
        }
    }
}

