import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:mgbu
    property RigJoystick joystick:null
    property RigModel rigmodel:null
    property bool btn0:false
    property bool btn_lock:false //button to locking

    Settings {
        id:settings
        category: "MGBU"
        property alias x: mgbu.x
        property alias y: mgbu.y
    }

    state: "drill" //platf,tower,bench,drill
    states: [
        State {
            name: "drill"
            PropertyChanges {target: name;   text: "Бурение"}
            PropertyChanges {target: y1;   text: qsTr("ВРАЩЕНИЕ"); visible: true}
            PropertyChanges {target: y2;   text: qsTr("ХОД-Y"); visible: true}
            PropertyChanges {target: x1;   text: qsTr("ОТВАЛ"); visible: false}
            PropertyChanges {target: bubble; visible: false}
            PropertyChanges {target: coordinate; visible: true}
        },
        State {
            name: "tore"
            PropertyChanges {target: name;   text: "Отрыв"}
            PropertyChanges {target: y1;   text: qsTr("ХОД-Y"); visible: false}
            PropertyChanges {target: y2;   text: qsTr("ХОД-Y"); visible: true}
            PropertyChanges {target: x1;   text: qsTr("КАМЕРА"); visible: false}
            PropertyChanges {target: bubble; visible: false}
            PropertyChanges {target: coordinate; visible: true}
        },
        State {
           name: "tool"
           PropertyChanges {target: name;   text: "Манипулятор"}
           PropertyChanges {target: y1;   text: qsTr("ЗАМОК"); visible: true}
           PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: false}
           PropertyChanges {target: x1;   text: qsTr("СТРЕЛА"); visible: true}
           PropertyChanges {target: bubble; visible: false}
           PropertyChanges {target: coordinate; visible: true}
        },
        State {
            name: "horiz"
            PropertyChanges {target: name;   text: "Горизонтирование"}
            PropertyChanges {target: y1;   text: qsTr("ЛЕВЫЙ"); visible: true}
            PropertyChanges {target: y2;   text: qsTr("ПРАВЫЙ"); visible: true}
            PropertyChanges {target: x1;   text: qsTr("СРЕДНИЙ"); visible: true}
            PropertyChanges {target: bubble; visible: true}
            PropertyChanges {target: coordinate; visible: false}
        }

    ]
    onBtn0Changed: if(visible) changestate();
    onStateChanged: {
        //console.log("mapgmod(state)="+mapgmod(state)+" state="+state)
        rigmodel.gmod=mapgmod(state);
        joystick.lock=false;
        //console.log("rigmodel="+rigmodel.gmod+" state="+state)
    }
    function mapgmod(m){
        if (m==="tore") return "bench"
        if (m==="tool") return "tower"
        if (m==="horiz") return "platf"
        return "drill"
    }

    Component.onCompleted: rigmodel.gmod=mapgmod(state);
    onBtn_lockChanged: {
        if (!joystick.lock&&btn_lock) {
            joystick.lock=true
        }
        else if (joystick.lock&&btn_lock) joystick.lock=false
    }
    transitions: [
            Transition {
                 ColorAnimation { target: s1; duration: 500}
                 ColorAnimation { target: s2; duration: 500}
                 ColorAnimation { target: s3; duration: 500}
                 ColorAnimation { target: s4; duration: 500}
            }
        ]

    function changestate(){
      //console.log("oldstate="+state)
      if (btn0===true) return
      if (state==="drill") state="tore"
      else if (state==="tore") state="tool"
           else if (state==="tool") state="horiz"
                else  state="drill"

    }
    Rectangle {
        id: bubble
        height:300
        width:300
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "black"
        opacity: 0.8
        border.color: "yellow"
        radius: 10
        border.width: 1
        MyBubble2 {
            z: 1
            anchors.margins: 5
            anchors.fill: parent

            roll: rigmodel.tangag
            pitch: rigmodel.kren
        }
    }
    Rectangle {
        id: coordinate
        height:300
        width:300
        anchors.bottom: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"
        opacity: 1
        border.color: "yellow"
        radius: 10
        border.width: 1
        Coordinate {
            id: crd
            z: -1
            anchors.margins: 0
            anchors.fill: parent
            position:  rigmodel.position

        }
    }

    Rectangle {
        id: body
        width: parent.width
        height: parent.height
        color: "transparent"

        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "#aaaaaa";
            }
        }
        border.color: "#3f3f40"
        radius: 6
        border.width: ma.containsMouse?3:1;
        MouseArea {
            id: ma
            anchors.fill: parent
            hoverEnabled: true
            drag.target: mgbu
            drag.axis: Drag.XAndYAxis
            onDoubleClicked: changestate()
            //drag.minimumX: 0
            //drag.maximumX: container.width - rect.width
        }
        Column {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.margins: 10
            spacing: 3


            Row {
                anchors.horizontalCenter: parent.horizontalCenter
  //              anchors.top: parent.top
  //              anchors.margins: 10
                spacing: 3
                Rectangle {
                    id: s1
                    height: 8
                    width: 15
                    color: mgbu.state==="drill"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2

                    ColorAnimation {
                        from: "transparent"
                        to: "yellow"
                        duration: 200
                    }
                }
                Rectangle {
                    id: s2
                    height: 8
                    width: 15
                    color: mgbu.state==="tore"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2
                }
                Rectangle {
                    id: s3
                    height: 8
                    width: 15
                    color: mgbu.state==="tool"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2
                }
                Rectangle {
                    id: s4
                    height: 8
                    width: 15
                    color: mgbu.state==="horiz"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2
                }

            } //Row
            Text{ id: name;
                anchors.horizontalCenter: parent.horizontalCenter;
                color:  "#3f3f40";
                text: state ;
                font.bold: true;
                font.underline: true
                horizontalAlignment: Text.AlignHCenter;
                font.pointSize: 11
            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                AxisVertical {
                       id: y1
                       //anchors.horizontalCenter: parent.horizontalCenter
                       height: 90
                       text: qsTr("ЛЕВАЯ")
                       width: 50

                       value: joystick.y1axis
                       container: false
                }
                AxisVertical {
                       id: y2
                       //anchors.horizontalCenter: parent.horizontalCenter
                       height: 90
                       text: qsTr("ПРАВАЯ")
                       width: 50

                       value: joystick.y2axis
                       container: false
                }
            }//Row
            Text {
                anchors.horizontalCenter: parent.horizontalCenter;
                font.pointSize: 9
                color: joystick.lock?"white":"transparent"
                text: "Блокировка"

            }

            AxisHorizontal {
              id: x1
              anchors.horizontalCenter: parent.horizontalCenter;
              value: -joystick.x1axis
              width: 120
              height: 40
              text: qsTr("ОТВАЛ")
              container: false
            }

      }//Column
    }//body Rectangle
}

