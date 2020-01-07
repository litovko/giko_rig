import QtQuick 2.5
import Gyco 1.0

Item {
    id: dashBoard

    property int gaugesize: 180-20 // 20 - поля: два по 10
    property int containerheight: 1080
    property Board rig: null

    state: rig.rigtype
    states: [
        State {
            name: "NPA"
            PropertyChanges {target: npa_pult;   visible: true}
            PropertyChanges {target: power2;   visible: false}
            PropertyChanges {target: power;   visible: true}
            PropertyChanges {target: turns;   visible: false}
//            PropertyChanges {target: row_right;   visible: true}
            PropertyChanges {target: voltage_mgbu;   visible: true}
            PropertyChanges {target: voltage;   visible: false}
            PropertyChanges {target: current_mgbu;   visible: true}
            PropertyChanges {target: current_a;   visible: false}
            PropertyChanges {target: altimetr_mgbu;   visible: false}
            PropertyChanges {target: temperature;   visible: false}
            PropertyChanges {target: temperature_mgbu;   visible: true}
            PropertyChanges {target: pressure;   visible: false}
            PropertyChanges {target: pressure_mgbu;   visible: true}
            PropertyChanges {target: v24dc;   visible: false}
            PropertyChanges {target: v24dc_mgbu;   visible: true}
            PropertyChanges {target: leak;   visible: true}
        }
    ]
    function resetposition() {
        npa_pult.resetposition()
    }

    Component.onCompleted: calculatesize()
    onVisibleChildrenChanged: calculatesize()
    function calculatesize(){
        // ВРЕТ ФУНКЦИЯ СТРАШНО некорректно выдает количество видимых приборов.
        //var num_gauge=flowrow.visibleChildren.length
        var num_gauge=6

        if (state=="mgbu") num_gauge=10 //прописал железно
        if (state=="grab6") num_gauge=7
        if (state=="NPA") num_gauge=8
        var numrows=Math.floor((containerheight-20)/(gaugesize+20))
        numrows=numrows?numrows:num_gauge

        var numcolm=Math.ceil(num_gauge/numrows) //округляем в большую сторону

        numrows=Math.ceil(num_gauge/numcolm)

        dashBoard.width=(numcolm)*(gaugesize+20)
        dashBoard.height=(gaugesize+20)*numrows
    }

//    onStateChanged: {

//        calculatesize()
//        j.lock=false

//    }
    onContainerheightChanged: calculatesize()

    NPA {
        id: npa_pult
        height: 450
        width: 450
        //joystick: j1
        board1: rig1
        board2: rig2
        z:4
        //state: rig.gmod //move, hand
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


            }
            Flow{
              id: flowrow
              spacing: 20
              anchors.fill: parent
              Rectangle {
                  id: bubble
                  color:"transparent";
                  //opacity: 0.5
                  width:  gaugesize;
                  height: gaugesize;
                  objectName: "voltage_mgbu"
                  NPA_bubble {
                      //anchors.fill: parent
                      anchors.fill: parent
                      anchors.margins: 5
                      a1:rig.kren
                      a2:rig.tangag
                      radius: 14
                  }
              }
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

                      value1:  rig.voltage
                      value2:  rig.voltage2
                      value3:  rig.voltage3

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

                      value1:  (rig.ampere/10).toFixed(1)
                      value2:  (rig.ampere2/10).toFixed(1)
                      value3:  (rig.ampere3/10).toFixed(1)
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
                        value: (rig.ampere/10).toFixed(1)
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
                        value: rig.voltage
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
                        value: rig.temperature
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
                        value1: rig.temperature
                        value2: rig.temperature2
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
                        value: (rig.pressure/10).toFixed(1)
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
                        value1: rig.pressure
                        value2: rig.pressure2
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
                        value: (rig.voltage24/10).toFixed(1)
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
                        value1: (rig.voltage24/10).toFixed(1)
                        value2: (rig.voltage24_2/10).toFixed(1)
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
                        value: rig.turns// (rig.turns/100).toFixed()

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
                        value: Math.round(100*(j1.y2axis+127)/254)
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

                        value: 0//(j.key_0||j.lock)*( j.y2axis>0?Math.round(j.y2axis*100/127):-Math.round(j.y2axis*100/127))
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
                        value1: rig.leak
                        value2: rig.leak_voltage
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
                        value: rig.altitude
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

