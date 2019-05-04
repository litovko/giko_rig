import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:npa
    property RigJoystick joystick:null
    property RigModel rigmodel:null
    property bool btn0:false
    property bool btn_lock:false //button to locking

    Settings {
        id:settings
        category: "NPA"
        property alias x: npa.x
        property alias y: npa.y
        property alias state: npa.state
    }


    states: [
        State {
            name: "move"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: false}
            PropertyChanges {target: npa_group; visible: false}
            PropertyChanges {target: tmod; text: "Движение"}
        },
        State {
            name: "move1"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: false}
            PropertyChanges {target: npa_group; visible: false}
            PropertyChanges {target: tmod; text: "Лифт"}
        },
        State {
            name: "hand"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: false}
            PropertyChanges {target: tmod; text: "Рука-вперед"}
        },
        State {
            name: "hand1"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: false}
            PropertyChanges {target: tmod; text: "Рука-лев/прав"}
        },
        State {
            name: "hand2"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: true}
            PropertyChanges {target: npa_group; visible: false}
            PropertyChanges {target: tmod; text: "Рука-раскантовка"}
        },
        State {
            name: "group"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: false}
            PropertyChanges {target: npa_group; visible: true}
            PropertyChanges {target: tmod; text: "Спец. группа"}
        }

    ]
    onBtn0Changed: if(visible) changestate();
    onStateChanged: {
        console.log(" state="+state)
        rigmodel.gmod=state;
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
        if (state==="move") {state=rigmodel.gmod="move1"; return }
        if (state==="move1") {state=rigmodel.gmod="hand"; return }
        if (state==="hand") {state=rigmodel.gmod="hand1"; return }
        if (state==="hand1") {state=rigmodel.gmod="hand2"; return }
        if (state==="hand2") {state=rigmodel.gmod="group"; return }
        if (state==="group") {state=rigmodel.gmod="move"; return }
        else state=rigmodel.gmod="move"
    }
    function sel(){
        if (state==="hand") return 1+2+4+16
        if (state==="hand1") return 1+8
        if (state==="hand2") return 1+2
        return 0
    }

    Rectangle{
        anchors.fill: parent
        color:"transparent"
        border.color: "yellow"
        radius:10
        border.width: ma.containsMouse?3:1;
        Text {
            id: tmod
            color: "#5b51ca"
            anchors.margins: 5
            anchors.left: parent.left
            anchors.top:parent.top
            text:"text"
            font.bold: true
            font.italic: true
            font.pointSize: 10

        }

        NPA_move {
            id:npa_move
            anchors.fill: parent
            //visible: true
            //ax1: rigmodel.ana1 //влево вправо подрулька
            ax1: rigmodel.ana4*(rigmodel.gmod==="move")+rigmodel.ana1*(rigmodel.gmod!="move") //наворочено из-за пробитого транзистора - перенос с ана1 на ана4
            ax2: rigmodel.ana2 //левый задний движок
            ax3: rigmodel.ana3*(rigmodel.gmod==="move")///правый задний движок
            ax4: rigmodel.ana3*(rigmodel.gmod==="move1")
            ax5: rigmodel.ana4*(rigmodel.gmod==="move1")
        }

        NPA_hand{
            id:npa_hand
            anchors.fill: parent
            select: sel()
            position: rigmodel.position
            // запястье - поворот
            a1left:rigmodel.ana2*(rigmodel.gmod==="hand1")
            a1right:rigmodel.ana2*(rigmodel.gmod==="hand1")
            // клешня - захватить и отпустить
            a2up: rigmodel.ana4
            a2down: rigmodel.ana4
            // запястье - угол вверх-вниз
            a3left:rigmodel.ana3
            a3right:rigmodel.ana3
            // локоть - угол вверх-вниз
            a4left:-rigmodel.ana3
            a4right:-rigmodel.ana3
            // плечо - угол вверх-вниз
            a5left:rigmodel.ana2*((rigmodel.gmod==="hand")||(rigmodel.gmod==="hand2"))
            a5right:rigmodel.ana2*((rigmodel.gmod==="hand")||(rigmodel.gmod==="hand2"))
            // плечо - влево-впраов
            a6up: rigmodel.ana1*(rigmodel.gmod==="hand1")
            a6down: rigmodel.ana1*(rigmodel.gmod==="hand1")
            // раскантовка - угол вверх-вниз
            a7left: rigmodel.ana1*((rigmodel.gmod==="hand")||(rigmodel.gmod==="hand2"))
            a7right:rigmodel.ana1*((rigmodel.gmod==="hand")||(rigmodel.gmod==="hand2"))

        }
        NPA_group {
            id: npa_group
            anchors.fill: parent
            position: rigmodel.position
            cx1: 0
            cx2: rigmodel.ana1
            cx3: rigmodel.ana2
            cx4: rigmodel.ana3
            ca:  rigmodel.ana4
            cool: rigmodel.engine2
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            drag.target: npa
            drag.axis: Drag.XAndYAxis
            onDoubleClicked: changestate()
            //drag.minimumX: 0
            //drag.maximumX: container.width - rect.width
        }
    }




}

