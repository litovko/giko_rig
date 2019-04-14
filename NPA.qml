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
            //PropertyChanges {target: npa; width: 450+50}
            //PropertyChanges {target: coordinate; visible: true}
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
      console.log("oldstate="+state)
        if (state==="hand") {state=rigmodel.gmod="move" }
        else if (state==="move") {state=rigmodel.gmod="hand" }
             else state=rigmodel.gmod="move"
    console.log("newstate="+state)
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

