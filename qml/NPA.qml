import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:npa
    property RigJoystick joystick:null
    property Board board0:null
    property bool btn0:false
    property bool btn_lock:false //button to locking
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
        property alias state: npa.state
    }


    states: [
        State {
            name: "move"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Движение"}
        },
        State {
            name: "move1"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Лифт"}
        },
        State {
            name: "hand"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Рука-вперед"}
        },
        State {
            name: "hand1"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Рука-лев/прав"}
        },
        State {
            name: "hand2"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Рука-раскантовка"}
        },
        State {
            name: "group"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Спец. группа"}
        }

    ]
    onBtn0Changed: if(visible) changestate();
    onStateChanged: {
        console.log(" state="+state)
        board0.gmod=state;
        joystick.lock=false;
//        console.log("rigmodel="+rigmodel.gmod+" state="+state)
    }

//    Component.onCompleted: {state="move"; rigmodel.gmod="move"; console.log("onCompleted state="+state +" gmod:"+ rigmodel.gmod)}
    onBtn_lockChanged: {
        if (!joystick.lock&&btn_lock) {
            joystick.lock=true
        }
        else if (joystick.lock&&btn_lock) joystick.lock=false
    }

    function changestate(){
        if (btn0===true) return
        if (state==="move") {state=board0.gmod="move1"; return }
        if (state==="move1") {state=board0.gmod="hand"; return }
        if (state==="hand") {state=board0.gmod="hand1"; return }
        if (state==="hand1") {state=board0.gmod="hand2"; return }
        if (state==="hand2") {state=board0.gmod="group"; return }
        if (state==="group") {state=board0.gmod="move"; return }
        else state=board0.gmod="move"
    }
    function sel(){ //подсветка движущихся частей
        if (state==="hand") return 1+2+4+16
        if (state==="hand1") return 1+8
        if (state==="hand2") return 1+2
        return 0
    }
//    Rectangle {
//        id: rectangle_background
//        anchors.fill: parent
//        color: "black"
//        opacity: 0.6
//        border.color: "transparent"
//        radius:10
//    }

    Rectangle{
        anchors.fill: parent
        color: "transparent"
        //opacity: 0.5
        border.color: "transparent"
        radius:10
        //border.width: ma.containsMouse?3:1;
//        Text {
//            id: tmod
//            color: "#5b51ca"
//            anchors.margins: 5
//            anchors.left: parent.left
//            anchors.top:parent.top
//            text:"text"
//            font.bold: true
//            font.italic: true
//            font.pointSize: 10

//        }

        NPA_move { //трастеры - движители
            id:npa_move
            //anchors.fill: parent
            width: parent.width
            height: parent.height
            //anchors.right: parent.left
            //visible: true
            //ax1: rigmodel.ana1 //влево вправо подрулька
            ax1: -board0.ana4*(board0.gmod==="move")+board0.ana1*(board0.gmod!="move") //наворочено из-за пробитого транзистора - перенос с ана1 на ана4
            ax3: board0.ana2 //левый задний движок
            ax2: board0.ana3*(board0.gmod==="move")///правый задний движок
            ax4: -board0.ana3*(board0.gmod==="move1")
            ax5: -board0.ana4*(board0.gmod==="move1")
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
            position: board0.position
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
            // запястье - поворот
            a1left:board0.ana2*(board0.gmod==="hand1")
            a1right:board0.ana2*(board0.gmod==="hand1")
            // клешня - захватить и отпустить
            a2up: board0.ana4
            a2down: board0.ana4
            // запястье - угол вверх-вниз
            a3left:board0.ana3
            a3right:board0.ana3
            // локоть - угол вверх-вниз
            a4left:-board0.ana3
            a4right:-board0.ana3
            // плечо - угол вверх-вниз
            a5left:board0.ana2*((board0.gmod==="hand")||(board0.gmod==="hand2"))
            a5right:board0.ana2*((board0.gmod==="hand")||(board0.gmod==="hand2"))
            // плечо - влево-впраов
            a6up: board0.ana1*(board0.gmod==="hand1")
            a6down: board0.ana1*(board0.gmod==="hand1")
            // раскантовка - угол вверх-вниз
            a7left: board0.ana1*((board0.gmod==="hand")||(board0.gmod==="hand2"))
            a7right:board0.ana1*((board0.gmod==="hand")||(board0.gmod==="hand2"))

        }
        NPA_group { //группа поворота камеры лебедки и проч
            id: npa_group
            width: parent.width
            height: parent.height
            //anchors.left: parent.right
            position: board0.position
            cx1: 0
            cx2: board0.ana1
            cx3: board0.ana2
            cx4: board0.ana3
            ca:  board0.ana4
            cool: board0.engine2
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

