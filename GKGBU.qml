import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:gkgbu
    property RigJoystick joystick:null
    property RigModel rigmodel:null
    property bool btn0:false
    property bool btn_lock:false //button to lock
    property bool lock: false

    Settings {
        category: "GKGBU"
        property alias x: body.x
        property alias y: body.y
    }
    state: "platf" //platf,tower,bench,drill
    states: [
        State {
            name: "platf"
            PropertyChanges {target: name;   text: "Платформа"}
            PropertyChanges {target: y1;   text: qsTr("ЛЕВАЯ")}
            PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: true}
            PropertyChanges {target: x1;   text: qsTr("ОТВАЛ"); visible: true}
        },
        State {
           name: "tower"
           PropertyChanges {target: name;   text: "Башня"}
           PropertyChanges {target: y1;   text: qsTr("СТРЕЛА")}
           PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: false}
           PropertyChanges {target: x1;   text: qsTr("БАШНЯ"); visible: true}
        },
        State {
            name: "bench"
            PropertyChanges {target: name;   text: "Станок"}
            PropertyChanges {target: y1;   text: qsTr("УГОЛ СТАНКА")}
            PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: false}
            PropertyChanges {target: x1;   text: qsTr("КАМЕРА"); visible: true}
        },
        State {
            name: "drill"
            PropertyChanges {target: name;   text: "Бурение"}
            PropertyChanges {target: y1;   text: qsTr("ОБОРОТЫ")}
            PropertyChanges {target: y2;   text: qsTr("ПОДАЧА"); visible: true}
            PropertyChanges {target: x1;   text: qsTr("КАМЕРА"); visible: false}
        }
    ]
    onBtn0Changed: changestate()
    onStateChanged: rigmodel.gmod=state
    onBtn_lockChanged: {
        if (!lock&&j.key_0) lock=true
        if (lock&&j.key_0) lock=false
    }

    function changestate(){
      if (btn0===true) return
      if (state==="platf") state="tower"
      else if (state==="tower") state="bench"
           else if (state==="bench") state="drill"
                else state="platf"
    }
    Rectangle {
        id: body
        width: parent.width
        height: parent.height
        color: "transparent"
        //onXChanged: console.log("X:"+x)
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
            drag.target: parent
            drag.axis: Drag.XAndYAxis
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
                    color: gkgbu.state==="platf"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2
                }
                Rectangle {
                    id: s2
                    height: 8
                    width: 15
                    color: gkgbu.state==="tower"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2
                }
                Rectangle {
                    id: s3
                    height: 8
                    width: 15
                    color: gkgbu.state==="bench"? "yellow":"transparent"
                    border.color: "#3f3f40"
                    radius:2
                }
                Rectangle {
                    id: s4
                    height: 8
                    width: 15
                    color: gkgbu.state==="drill"? "yellow":"transparent"
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
                       //height: gkgbu.height*0.60
                       value: joystick.y1axis
                       container: false
                }
                AxisVertical {
                       id: y2
                       //anchors.horizontalCenter: parent.horizontalCenter
                       height: 90
                       text: qsTr("ПРАВАЯ")
                       width: 50
                       //height: gkgbu.height*0.60
                       value: joystick.y2axis
                       container: false
                }
            }//Row
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

