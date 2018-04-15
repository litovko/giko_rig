import QtQuick 2.5
import Gyco 1.0
import Qt.labs.settings 1.0
Item {
    id:mgbu
    property RigJoystick joystick:null
    property RigModel rigmodel:null
    property bool btn0:false

    Settings {
        category: "MGBU"
        property alias x: body.x
        property alias y: body.y
    }
    state: "drill" //platf,tower,bench,drill
    states: [
        State {
            name: "drill"
            PropertyChanges {target: name;   text: "Бурение"}
            PropertyChanges {target: y1;   text: qsTr("ВРАЩЕНИЕ")}
            PropertyChanges {target: y2;   text: qsTr("ХОД-Y"); visible: true}
            PropertyChanges {target: x1;   text: qsTr("ОТВАЛ"); visible: false}
        },
        State {
            name: "tore"
            PropertyChanges {target: name;   text: "Отрыв"}
            PropertyChanges {target: y1;   text: qsTr("ХОД-Y")}
            PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: false}
            PropertyChanges {target: x1;   text: qsTr("КАМЕРА"); visible: false}
        },
        State {
           name: "tool"
           PropertyChanges {target: name;   text: "Манипулятор"}
           PropertyChanges {target: y1;   text: qsTr("ЗАМОК")}
           PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: false}
           PropertyChanges {target: x1;   text: qsTr("КАРЕТКА"); visible: true}
        },
        State {
            name: "horiz1"
            PropertyChanges {target: name;   text: "Горизонтирование"}
            PropertyChanges {target: y1;   text: qsTr("Аутригер Лев.")}
            PropertyChanges {target: y2;   text: qsTr("ПРАВАЯ"); visible: false}
            PropertyChanges {target: x1;   text: qsTr("КАМЕРА"); visible: true}
        }

    ]
    onBtn0Changed: changestate()
    onStateChanged: rigmodel.gmod=state


    function changestate(){
      if (btn0===true) return
      if (state==="drill") state="tore"
      else if (state==="tore") state="tool"
           else if (state==="tool") state="horiz"
                else  state="drill"

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

