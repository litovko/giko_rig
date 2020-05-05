import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:npa
    property Board board1:null
    property Board board2:null
    anchors.centerIn: parent
    Settings {
        id:settings
        category: "NPA"
        property alias x_move: npa_move.x
        property alias y_move: npa_move.y
        property alias x_hand: npa_hand.x
        property alias y_hand: npa_hand.y
        property alias x_group: npa_group.x
        property alias y_group: npa_group.y
        property alias x_bubbble: bubble2.x
        property alias y_bubbble: bubble2.y
        property alias state: npa.state
        property real ku : 1
        property real au : 0
        property real kv : 1
        property real av : 0

    }
    function resetposition(){
        bubble2.x=bubble2.y=npa_move.x=npa_move.y=npa_hand.x=npa_hand.y=npa_group.x=npa_group.y=0
    }

    states: [
        State {
            name: "move"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
        },
        State {
            name: "move1"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
        },
        State {
            name: "hand"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
        },
        State {
            name: "hand1"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
        },
        State {
            name: "hand2"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
        },
        State {
            name: "group"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
        }

    ]

    function sel(){ //подсветка движущихся частей
        if (state==="hand") return 1+2+4+16
        if (state==="hand1") return 1+8
        if (state==="hand2") return 1+2
        return 0
    }

    Rectangle{
        anchors.fill: parent
        color: "transparent"
        //opacity: 0.5
        border.color: "transparent"
        radius:10

        NPA_move { //трастеры - движители
            id:npa_move
            width: parent.width
            height: parent.height

            ax1: -board1.ana3 //подрулька
            ax3: board1.ana1 //левый задний движок
            ax2: board1.ana2 //правый задний
            ax4: board2.ana1 //лифт передний
            ax5: board2.ana2 //лифт задний
            brdr: mam.containsMouse
            MouseArea {
                id: mam
                anchors.fill: parent
                hoverEnabled: true
                drag.target: npa_move
                drag.axis: Drag.XAndYAxis
                //drag.minimumX: 0
                //drag.maximumX: container.width - rect.width
            }
        }

        NPA_hand{ //манипулятор
            id:npa_hand
            width: parent.width
            height: parent.height
            //anchors.centerIn: parent
            select: sel()
            position: board2.position
            brdr: mah.containsMouse
            MouseArea {
                id: mah
                anchors.fill: parent
                hoverEnabled: true
                drag.target: npa_hand
                drag.axis: Drag.XAndYAxis
                //drag.minimumX: 0
                //drag.maximumX: container.width - rect.width
            }
            // запястье - поворот M1
            a1left:-board1.pin1*(127)
            a1right:board1.pin0*(127)
            // клешня - захватить и отпустить M2
            a2up: board1.pin2*(127)
            a2down: -board1.pin3*(127)
            // запястье - угол вверх-вниз M3
            a3left: -board1.pin4*127
            a3right:board1.pin5*127
            // локоть - угол вверх-вниз M4
            a4left:-board1.pin6*127
            a4right:board1.pin7*127
            // плечо - угол вверх-вниз M5
            a5left:-board2.pin0*127
            a5right:board2.pin1*127
            // плечо - влево-впраов M6
            a6up: board2.pin3*127
            a6down: -board2.pin2*127
            // раскантовка - угол вверх-вниз M7
            a7left: -board2.pin4*127
            a7right: board2.pin5*127

        }
        NPA_group { //группа поворота камеры лебедки и проч
            id: npa_group
            width: parent.width
            height: parent.height
            //anchors.left: parent.right
            position: board2.position
            cx2: board2.pin7*127-board2.pin6*127 //выращение по часовой стрелке и против
            cx4: board2.ana3 //поворот камеры влево-вправо
            ca:  scale (settings.ku, settings.au, mbus.values[0]) //TODO: сделать масштабирование указатель угла поворота камеры
            cb:  scale (settings.kv, settings.av, mbus.values[1]) //TODO: сделать масштабирование указатель угла вращения камеры
            cool: board2.engine2
            brdr: mag.containsMouse
            MouseArea {
                id: mag
                anchors.fill: parent
                hoverEnabled: true
                drag.target: npa_group
                drag.axis: Drag.XAndYAxis
                //drag.minimumX: 0
                //drag.maximumX: container.width - rect.width
            }
        }
        MyBubble2 {
                    id: bubble2
                    height:300
                    width:300
                    //anchors.horizontalCenter: parent.horizontalCenter
                    //anchors.top: panel.bottom
                    //anchors.verticalCenter: parent.verticalCenter
                    roll: Math.round(rig.kren)
                    pitch: -Math.round(rig.tangag)
                    azimuth: Math.round(rig.altitude)
                    Behavior on azimuth {
                            NumberAnimation { easing.type: Easing.OutCurve; duration: 250 }
                    }
                    Behavior on roll {
                            NumberAnimation { easing.type: Easing.OutQuad; duration: 250 }
                    }
                    Behavior on pitch {
                            NumberAnimation { easing.type: Easing.OutQuad; duration: 250 }
                    }
                    MouseArea {
                        id: mb
                        anchors.fill: parent
                        hoverEnabled: true
                        drag.target: bubble2
                        drag.axis: Drag.XAndYAxis
                        //drag.minimumX: 0
                        //drag.maximumX: container.width - rect.width
                    }
                }
//        MouseArea {
//            id: ma
//            anchors.fill: parent
//            hoverEnabled: true
//            drag.target: npa
//            drag.axis: Drag.XAndYAxis
//            onDoubleClicked: changestate()
//            //drag.minimumX: 0
//            //drag.maximumX: container.width - rect.width
//        }
    }




}

