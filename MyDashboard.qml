import QtQuick 2.5
import Gyco 1.0

Item {
    id: dashBoard
    property RigModel source
    property int gaugesize: 180-20 // 20 - поля: два по 10
    property int containerheight: 1080

    state: rig.rigtype
    states: [
        State {
            name: "grab2"
            PropertyChanges {target: power2;   visible: false}
            PropertyChanges {target: power;   visible: true}
            PropertyChanges {target: turns;   visible: false}
            PropertyChanges {target: gkgbu_pult;   visible: false}
            PropertyChanges {target: mgbu_pult;   visible: false}
            PropertyChanges {target: row_left;   visible: true}
            PropertyChanges {target: row_right;   visible: true}
            PropertyChanges {target: voltage_mgbu;   visible: false}
            PropertyChanges {target: voltage;   visible: true}
            PropertyChanges {target: current_mgbu;   visible: false}
            PropertyChanges {target: current_a;   visible: true}
            PropertyChanges {target: altimetr_mgbu;   visible: false}
            PropertyChanges {target: temperature;   visible: true}
            PropertyChanges {target: temperature_mgbu;   visible: false}
            PropertyChanges {target: pressure;   visible: true}
            PropertyChanges {target: pressure_mgbu;   visible: false}
            PropertyChanges {target: v24dc;   visible: true}
            PropertyChanges {target: v24dc_mgbu;   visible: false}
            PropertyChanges {target: leak;   visible: false}
        },
        State {
            name: "grab6"
            PropertyChanges {target: power2;   visible: true}
            PropertyChanges {target: power;   visible: true}
            PropertyChanges {target: turns;   visible: false}
            PropertyChanges {target: gkgbu_pult;   visible: false}
            PropertyChanges {target: mgbu_pult;   visible: false}
            PropertyChanges {target: row_left;   visible: true}
            PropertyChanges {target: row_right;   visible: true}
            PropertyChanges {target: voltage_mgbu;   visible: false}
            PropertyChanges {target: voltage;   visible: true}
            PropertyChanges {target: current_mgbu;   visible: false}
            PropertyChanges {target: current_a;   visible: true}
            PropertyChanges {target: altimetr_mgbu;   visible: false}
            PropertyChanges {target: temperature;   visible: true}
            PropertyChanges {target: temperature_mgbu;   visible: false}
            PropertyChanges {target: pressure;   visible: true}
            PropertyChanges {target: pressure_mgbu;   visible: false}
            PropertyChanges {target: v24dc;   visible: true}
            PropertyChanges {target: v24dc_mgbu;   visible: false}
            PropertyChanges {target: leak;   visible: false}
        },
        State {
            name: "gkgbu"
            PropertyChanges {target: gkgbu_pult;   visible: true}
            PropertyChanges {target: mgbu_pult;   visible: false}
            PropertyChanges {target: power2;   visible: false}
            PropertyChanges {target: power;   visible: false}
            PropertyChanges {target: turns;   visible: true}
            PropertyChanges {target: row_left;   visible: false}
            PropertyChanges {target: row_right;   visible: false}
            PropertyChanges {target: voltage_mgbu;   visible: false}
            PropertyChanges {target: voltage;   visible: true}
            PropertyChanges {target: current_mgbu;   visible: false}
            PropertyChanges {target: current_a;   visible: true}
            PropertyChanges {target: altimetr_mgbu;   visible: false}
            PropertyChanges {target: temperature;   visible: true}
            PropertyChanges {target: temperature_mgbu;   visible: false}
            PropertyChanges {target: pressure;   visible: true}
            PropertyChanges {target: pressure_mgbu;   visible: false}
            PropertyChanges {target: v24dc;   visible: true}
            PropertyChanges {target: v24dc_mgbu;   visible: false}
            PropertyChanges {target: leak;   visible: false}
        },
        State {
            name: "mgbu"
            PropertyChanges {target: gkgbu_pult;   visible: false}
            PropertyChanges {target: mgbu_pult;   visible: true}
            PropertyChanges {target: power2;   visible: true}
            PropertyChanges {target: power;   visible: true}
            PropertyChanges {target: turns;   visible: true}
            PropertyChanges {target: row_left;   visible: true}
            PropertyChanges {target: row_right;   visible: true}
            PropertyChanges {target: voltage_mgbu;   visible: true}
            PropertyChanges {target: voltage;   visible: false}
            PropertyChanges {target: current_mgbu;   visible: true}
            PropertyChanges {target: current_a;   visible: false}
            PropertyChanges {target: altimetr_mgbu;   visible: true}
            PropertyChanges {target: temperature;   visible: false}
            PropertyChanges {target: temperature_mgbu;   visible: true}
            PropertyChanges {target: pressure;   visible: false}
            PropertyChanges {target: pressure_mgbu;   visible: true}
            PropertyChanges {target: v24dc;   visible: false}
            PropertyChanges {target: v24dc_mgbu;   visible: true}
            PropertyChanges {target: leak;   visible: true}
        }
    ]
    Component.onCompleted: calculatesize()
    onVisibleChildrenChanged: calculatesize()
    function calculatesize(){

        // ВРЕТ ФУНКЦИЯ СТРАШНО
        //var num_gauge=flowrow.visibleChildren.length
        var num_gauge=6
        if (state=="mgbu") num_gauge=10 //прописал железно
        if (state=="grab6") num_gauge=7
        var numrows=Math.floor((containerheight-20)/(gaugesize+20))
        numrows=numrows?numrows:num_gauge

        var numcolm=Math.ceil(num_gauge/numrows) //округляем в большую сторону

        numrows=Math.ceil(num_gauge/numcolm)

        dashBoard.width=(numcolm)*(gaugesize+20)
        dashBoard.height=(gaugesize+20)*numrows
    }

    onStateChanged: {

        calculatesize()
        j.lock=false

    }
    onContainerheightChanged: calculatesize()
    GKGBU {
        id: gkgbu_pult
        //anchors.centerIn: parent
        height: dashboard.gaugesize+20
        width: dashboard.gaugesize
        joystick: j
        rigmodel: source
        btn0: j.key_1
        btn_lock: j.key_4
        z:4
    }
    MGBU {
        id: mgbu_pult
        //anchors.centerIn: parent
        height: dashboard.gaugesize+48
        width: dashboard.gaugesize+48
        joystick: j
        rigmodel: source
        btn0: j.key_1
        btn_lock: j.key_4 // locker key
        z:4
    }
    MyGauge {
            id: row_left
            val:(j.key_0||j.lock)*j.y1axis
            //anchors.fill: parent
            anchors.bottom: dbr.bottom
            anchors.left: dbr.left
            anchors.bottomMargin: 10
            anchors.leftMargin: 2
            width:6
            height: dashBoard.height-20-width
            color: val>0?"yellow":"lightblue"
            z:3
            //onValChanged: { console.log("MyGauge key0:"+j.key_0); }
        }
    MyGauge {
        id: row_right
            val: gauge_value()
            function gauge_value(){
                //if (!j.ispresent) return 0
                if (dashboard.state==="grab2") return (j.key_0||j.lock)*j.y1axis
                if (dashboard.state==="grab6"||dashboard.state==="mgbu"||dashboard.state==="gkgbu") return (j.key_0||j.lock)*j.y2axis
            }
            function gauge_color(){
                //if (!j.ispresent) return "transparent"
                if (dashboard.state==="grab2") return j.y1axis>0?"yellow":"lightblue"
                if (dashboard.state==="grab6"||dashboard.state==="mgbu"||dashboard.state==="gkgbu") return j.y2axis>0?"yellow":"lightblue"
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
                    if (dashboard.state==="grab6")  j.y2axis=0;
                    j.y1axis=0;
                }

                onPressed: {
                    if ((dashboard.state==="grab6"||dashboard.state==="mgbu")&&(ma.mouseX>width/2))
                         j.y2axis=(ma.pressedButtons&Qt.RightButton?-1:1)*(127- 127*ma.mouseY/r.height)
                    else j.y1axis=(ma.pressedButtons&Qt.RightButton?-1:1)*(127- 127*ma.mouseY/r.height)
                    j.ispresent=false;
                }
                onPositionChanged: {
                    if (ma.pressedButtons&(Qt.LeftButton|Qt.RightButton)&&ma.containsMouse)
                      if ((dashboard.state==="grab6"||dashboard.state==="mgbu")&&(ma.mouseX>width/2)) j.y2axis=(ma.pressedButtons&Qt.RightButton?-1:1)*(127- 127*ma.mouseY/r.height)
                      else    j.y1axis=(ma.pressedButtons&Qt.RightButton?-1:1)*(127- 127*ma.mouseY/r.height)
                    else j.y1axis=0;
                    //console.log("Joy Y:"+j.yaxis+"btn:"+(ma.pressedButtons&(Qt.LeftButton|Qt.RightButton)))

                }
            }
            Flow{
              id: flowrow
              spacing: 20
              anchors.fill: parent


//              add: Transition {
//                      NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
//                      NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
//                  }
//              populate: Transition {
//                      NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
//                      NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
//                  }
//              move: Transition {
//                      NumberAnimation { property: "opacity"; from: 0; to: 1.0; duration: 400 }
//                      NumberAnimation { property: "scale"; from: 0; to: 1.0; duration: 400 }
//                  }

              Rectangle {
                  id: voltage_mgbu
                  color:"transparent";
                  //opacity: 0.5
                  width:  gaugesize;
                  height: gaugesize;
                  objectName: "voltage_mgbu"
                  Pribor3 {
                      width: parent.width-10; height: parent.height-10
                      maximumValue: 600
                      stepSize: 200
                      anchors.centerIn: parent

                      value1:  source.voltage
                      value2:  source.voltage2
                      value3:  source.voltage3

                      centrТext: "V"
                      bottomText: "Вольт"
                      warningThreshold: 500
                      minorTickmarks:3
                      thirdvisible: true
                  }
              }
              Rectangle {
                  id: current_mgbu
                  color:"transparent";
                  //opacity: 0.5
                  width:  gaugesize;
                  height: gaugesize;
                  objectName: "current_mgbu"
                  Pribor3 {
                      width: parent.width-10; height: parent.height-10
                      maximumValue: 50
                      stepSize: 10
                      anchors.centerIn: parent

                      value1:  (source.ampere/10).toFixed(1)
                      value2:  (source.ampere2/10).toFixed(1)
                      value3:  (source.ampere3/10).toFixed(1)
                      centrТext: "А"
                      bottomText: "Ампер"
                      warningThreshold: 30
                      minorTickmarks:3
                      thirdvisible: true
                  }
              }
                Rectangle {
                    id: current_a
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    objectName: "current_a"
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        anchors.centerIn: parent
                        value: (source.ampere/10).toFixed(1)
                        maximumValue: 100
                        warningThreshold: maximumValue*0.9
                        stepSize: 20
                        centrТext: "A"
                        bottomText: "Сила тока"
                        minorTickmarks:5
                    }
                 }
                Rectangle {
                    id: voltage
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    objectName: "voltage"
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 500
                        stepSize: 100
                        anchors.centerIn: parent
                        value: source.voltage
                        centrТext: "V"
                        bottomText: "Напряжение"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks: 5
                    }
                }

                Rectangle {
                    id: temperature
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    objectName: "temperature"
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 120
                        minimunValue: -20
                        stepSize: 20
                        anchors.centerIn: parent
                        value: source.temperature
                        centrТext: "t\u00B0"
                        bottomText: "Темп. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: temperature_mgbu
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor3 {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 120
                        minimunValue: -20
                        stepSize: 20
                        anchors.centerIn: parent
                        value1: source.temperature
                        value2: source.temperature2
                        thirdvisible: false
                        centrТext: "t\u00B0"
                        bottomText: "Темп. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: pressure
                    color:"transparent";
                    //opacity: 0.5
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 200
                        stepSize: 50
                        anchors.centerIn: parent
                        value: (source.pressure/10).toFixed(1)
                        centrТext: "кПа"
                        bottomText: "Давл. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: pressure_mgbu
                    color:"transparent";
                    //opacity: 0.5
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor3 {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 200
                        stepSize: 50
                        anchors.centerIn: parent
                        value1: source.pressure
                        value2: source.pressure2
                        thirdvisible: false
                        centrТext: "кПа"
                        bottomText: "Давл. масла"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: v24dc
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 60
                        stepSize: 10
                        anchors.centerIn: parent
                        value: (source.voltage24/10).toFixed(1)
                        centrТext: "V"
                        bottomText: "Шина 24В"
                        warningThreshold: 49
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: v24dc_mgbu
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor3 {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 60
                        stepSize: 10
                        anchors.centerIn: parent
                        value1: (source.voltage24/10).toFixed(1)
                        value2: (source.voltage24_2/10).toFixed(1)
                        thirdvisible: false
                        centrТext: "V"
                        bottomText: "Шина 24В"
                        warningThreshold: 49
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: turns
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    visible: dashboard.state==="gkgbu"?true:false
                    //onVisibleChanged: calculatesize()
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 900
                        stepSize: 300
                        anchors.centerIn: parent
                        centrТext: "об/мин"
                        value: source.turns// (source.turns/100).toFixed()

                        bottomText: "Обороты"
                        warningThreshold: 800
                        minorTickmarks:5
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

                        value: (j.key_0||j.lock)*( j.y1axis>0?Math.round(j.y1axis*100/127):-Math.round(j.y1axis*100/127))
                        centrТext: "%"
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
                    //onVisibleChanged: calculatesize()
                    Pribor {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 100
                        stepSize: 20
                        anchors.centerIn: parent

                        value: (j.key_0||j.lock)*( j.y2axis>0?Math.round(j.y2axis*100/127):-Math.round(j.y2axis*100/127))
                        centrТext: "%"
                        bottomText: "Мощность2"
                        warningThreshold: maximumValue*0.9
                        minorTickmarks:5
                    }
                }
                Rectangle {
                    id: leak
                    color:"transparent";
                    width:  gaugesize;
                    height: gaugesize;
                    Pribor3 {
                        width: parent.width-10; height: parent.height-10
                        maximumValue: 500
                        stepSize: 100
                        anchors.centerIn: parent
                        value1: source.leak
                        value2: source.leak_voltage
                        thirdvisible: false
                        centrТext: "Z"
                        bottomText: "Изоляция"
                        warningThreshold: maximumValue*0.2
                        minorTickmarks: 5
                    }
                }
                Rectangle {
                    id: altimetr_mgbu
                    color:"transparent";
                    //opacity: 0.5
                    width:  gaugesize;
                    height: gaugesize;
                    Digital {
                        width: parent.width-10; height: parent.height-10
                        value: source.altitude
                        maxvalue: 5000
                        //interval: 100
                        anchors.centerIn: parent
                        anchors.margins: 5
                        digname: "Альтиметр"
                        graphtimer: true
                        digits: 0
                    }
                }
            }
        }
    }
}

