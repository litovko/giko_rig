import QtQuick 2.5
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import QtQuick.Controls.Styles 1.4
import Gyco 1.0

//Содержит переключатели и лампочки
Item {
    id: controlPanel
    property RigModel source
    property list<RigCamera> cam
    property int lampSize:100
    property int fontSize:15
    signal lampClicked(string cp_command)
    width: row.width+row.spacing
    Settings {
        category: "ControlPanel"
        property alias x: controlPanel.x
        property alias y: controlPanel.y
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        drag.target: controlPanel
        drag.axis: Drag.XAndYAxis
    }
    Rectangle {
        anchors.fill: parent
        color: "transparent"
        border.color: "yellow"
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
        Rectangle {
            anchors { fill: parent; margins: 10}
            color: "transparent"
            border.color: "white"
            radius: 7
            Row{
                id: row
                spacing: 20
                //width: parent.width
                anchors.topMargin: 10
                Component.onCompleted: {
                        for (var item in children) {
                            children[item].anchors.verticalCenter = row.verticalCenter;
                        }
                    }

                MyLamp{
                    id: lamp
                    height: lampSize
                    width: lampSize
                    bottomText:"СВЕТ[F2]"
                    active: source.lamp
                    command: "LAMPS"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: cam_onoff
                    height: lampSize
                    width: lampSize
                    bottomText:"КАМЕРЫ[F3]"
                    active:source.camera
                    command: "CAMSET"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: engine1
                    height: lampSize
                    width: lampSize
                    bottomText:"НАСОС1[F4]"
                    active:source.engine
                    command: "ENGINE1"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: engine2
                    height: lampSize
                    width: lampSize
                    bottomText:"НАСОС2"
                    active:source.engine2
                    command: "ENGINE2"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: engine3
                    height: lampSize
                    width: lampSize
                    bottomText:"ПРОМЫВКА"
                    active:source.pump
                    command: "PUMP"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: connect
                    height: lampSize
                    width: lampSize
                    bottomText:"СВЯЗЬ"
                    active:source.client_connected
                }
                MyLamp{
                    id: data
                    height: lampSize
                    width: lampSize
                    bottomText:"ДАННЫЕ"
                    active:source.good_data
                }
                MyLamp{
                    id: voltage
                    height: lampSize
                    width: lampSize
                    bottomText:"ПИТАНИЕ"
                    active:source.voltage
                }
                MyLamp{
                    id: camera1
                    height: lampSize
                    width: lampSize
                    bottomText:cam[0].title
                    active:cam[0].camerapresent
                    error: cam[0].onrequest
                    command: "LAYOUT"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: camera2
                    height: lampSize
                    width: lampSize
                    bottomText:cam[1].title

                    active:cam[1].camerapresent
                    visible: cam[1].index
                    error: cam[1].onrequest
                }
                MyLamp{
                    id: camera3
                    height: lampSize
                    width: lampSize
                    bottomText:cam[2].title
                    active:cam[2].camerapresent
                    visible: cam[2].index
                    error: cam[2].onrequest
                }
                MyLamp{
                    id: camera4
                    height: lampSize
                    width: lampSize
                    bottomText:cam[3].title
                    active:cam[2].camerapresent
                    visible: cam[3].index
                    error: cam[3].onrequest
                }

            }

        }

    }
}

