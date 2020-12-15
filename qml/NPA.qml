import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:npa
    property Board board0:null
    property Board board1:null
    //    property Board board2:null
    anchors.centerIn: parent
    Settings {
        id:settings
        category: "NPA"
        //        property alias x_move: npa_move.x
        //        property alias y_move: npa_move.y
        property alias x_hand: npa_hand.x
        property alias y_hand: npa_hand.y
        //        property alias x_group: npa_group.x
        //        property alias y_group: npa_group.y
        property alias x_bubbble: bubble2.x
        property alias y_bubbble: bubble2.y
        property alias state: npa.state
        property real ku : 1
        property real au : 0
        property real kv : 1
        property real av : 0

    }
    function resetposition(){
        bubble2.x=bubble2.y=npa_hand.x=npa_hand.y=0
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
        border.color: "transparent"

        NPA_hand{ //манипулятор
            id:npa_hand
            width: parent.width
            height: parent.height
            //anchors.centerIn: parent
            select: sel()
            position: board1.position
            brdr: mah.containsMouse
            gmod: board1.gmod
            MouseArea {
                id: mah
                anchors.fill: parent
                hoverEnabled: true
                drag.target: npa_hand
                drag.axis: Drag.XAndYAxis
                //drag.minimumX: 0
                //drag.maximumX: container.width - rect.width
            }
            //  запястье - поворот M1
            a1left: board1.ana2
            a1right:board1.ana2
            // клешня - захватить и отпустить M2
            a2up:   board1.ana1
            a2down: board1.ana1
            //            // манипулятор - поворот
            a3left: board1.ana3
            a3right:board1.ana3
            //            // кисть 2Г - угол
            a4left:-board0.pin2*127
            a4right:board0.pin3*127
            //            // плечо - 3Г
            a5left:-board1.pin2*127
            a5right:board1.pin3*127
            //            // плечо - 4Г
            a6up: board0.pin4*127
            a6down: -board0.pin5*127
            // плечо - 5Г
            a7up: board0.pin6*127
            a7down: -board0.pin7*127
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

    }




}

