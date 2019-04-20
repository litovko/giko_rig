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
    }


    states: [
        State {
            name: "move"
            PropertyChanges {target: npa_move; visible: true}
            PropertyChanges {target: npa_hand; visible: false}
        },
        State {
            name: "hand"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: true}
        },
        State {
            name: "hand1"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: true}
        },
        State {
            name: "hand2"
            PropertyChanges {target: npa_move; visible: false}
            PropertyChanges {target: npa_hand; visible: true}
        }

    ]
    onBtn0Changed: if(visible) changestate();
    onStateChanged: {
        console.log(" state="+state)
        //rigmodel.gmod=state;
        joystick.lock=false;
        console.log("rigmodel="+rigmodel.gmod+" state="+state)
    }

    Component.onCompleted: {state="move"; rigmodel.gmod="move"; console.log("onCompleted state="+state +" gmod:"+ rigmodel.gmod)}
    onBtn_lockChanged: {
        if (!joystick.lock&&btn_lock) {
            joystick.lock=true
        }
        else if (joystick.lock&&btn_lock) joystick.lock=false
    }

    function changestate(){
        if (state==="move") {state=rigmodel.gmod="hand"; return }
        if (state==="hand") {state=rigmodel.gmod="hand1"; return }
        if (state==="hand1") {state=rigmodel.gmod="hand2"; return }
        if (state==="hand2") {state=rigmodel.gmod="move"; return }
        else state=rigmodel.gmod="move"
    }
    function sel(){
        if (state==="hand") return 1+2+4+16
        if (state==="hand1") return 1+8
        if (state==="hand2") return 1+2
    }

    Rectangle{
        anchors.fill: parent
        color:"transparent"
        border.color: "yellow"
        radius:10
        border.width: ma.containsMouse?3:1;
        NPA_move {
            id:npa_move
            anchors.fill: parent
            //visible: true
            ax1: rigmodel.ana1//j.x2axis //влево вправо подрулька
            ax2: rigmodel.ana2//j.y1axis-j.x2axis//((j.x2axis>0)?j.x2axis/2:-j.x2axis/2)   //левый задний движок
            ax3: rigmodel.ana3//j.y1axis+j.x2axis//((j.x2axis>0)?-j.x2axis/2:+j.x2axis/2)   //правый задний движок
            ax4: rigmodel.ana4
        }

        NPA_hand{
            id:npa_hand
            anchors.fill: parent
            select: sel()

            // запястье - поворот
            a1left:rigmodel.ana2*(rigmodel.gmod==="hand1")
            a1right:rigmodel.ana2*(rigmodel.gmod==="hand1")
            // клешня - захватить и отпустить
            a2up: rigmodel.ana4
            a2down: rigmodel.ana4
            // запястье - угол вверх-вниз
            a3left:rigmodel.ana
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

