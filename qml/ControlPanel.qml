import QtQuick 2.5
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4
import Qt.labs.settings 1.0
import QtQuick.Controls.Styles 1.4
import Gyco 1.0
//Содержит переключатели и лампочки
Item {
    id: controlPanel
    property Board source
    property Networker net
    property list<RigCamera> cam
    property int lampSize:100
    property int fontSize:15
    property RigJoystick j1
    property RigJoystick j2
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
                    active: rig1.lamp_switch
                    command: "LAMP"
                    command3: "LAMPS"
                    text: "Правая кн. мышки - меню управления яркостью фонарей"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: cam_onoff
                    height: lampSize
                    width: lampSize
                    bottomText:"КАМЕРЫ[F3]"
                    active:source.camera
                    command: "CAMERA ON"
                    command3: "CAMSET"
                    text: "Правая кн. мышки - меню включения питания камер"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: engine1
                    height: lampSize
                    width: lampSize
                    bottomText:"НАСОС[F4]"
                    error: rig0.pins[1]
                    active:rig0.pins[0]
                    command: "ENGINE1"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
               MyLamp{
                    visible: source.rigtype==="mgbu"
                    id: engine2
                    height: lampSize
                    width: lampSize
                    bottomText:"НАСОС2[F7]"
                    error: source.free_engine2
                    active:source.engine2
                    command: "ENGINE2"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
//               MyLamp{
//                   visible: source.rigtype==="NPA"
//                   id: cooling
//                   height: lampSize
//                   width: lampSize
//                   bottomText:"ОХЛАЖД[F7]"
//                   error: source.free_engine2
//                   active:source.engine2
//                   command: "COOLING"
//                   command3: "COOLSET"
//                   onLampClicked: controlPanel.lampClicked(lamp_command)
//               }
//                MyLamp{
//                    id: engine3
//                    visible: source.rigtype==="mgbu"
//                    height: lampSize
//                    width: lampSize
//                    bottomText:"ПРОМЫВКА[П]"
//                    active:source.pump
//                    command: "PUMP"
//                    onLampClicked: controlPanel.lampClicked(lamp_command)
//                }
                MyLamp{
                    id: manip
                    visible: source.rigtype==="NPA"
                    height: lampSize
                    width: lampSize
                    bottomText:"МАНИП[П]"
                    active:source.pump
                    command: "MANIP"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: connect
                    height: lampSize
                    width: lampSize
                    bottomText:"СВЯЗЬ"
                    active:net.client_connected
                    command: "RECONNECT"
                    text: "При клике на лампочку происходит реконнект к аппарату"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: data
                    height: lampSize
                    width: lampSize
                    bottomText:"ДАННЫЕ"
                    active: rig0.good_data
                }
                MyLamp{
                    id: data_modbus
                    height: lampSize
                    width: lampSize
                    bottomText:"ДАННЫЕ Ш"
                    active:mbus.good_data
                    command: "MODBUS RECONNECT"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: voltage
                    height: lampSize
                    width: lampSize
                    bottomText:"ПИТАНИЕ"
                    active:source.voltage
                }
                MyLamp{
                    id: j_lock
                    height: lampSize
                    width: lampSize
                    bottomText:"РАЗБЛ1"
                    text: "Горит при нажатии на курок джойстика"
                    active: j1.keys[0]
                }
                MyLamp{
                    id: camera1
                    height: lampSize
                    width: lampSize
                    bottomText:cam[0].title
                    active:cam[0].camerapresent
                    error: cam[0].onrequest
                    visible: cam[0].cameraenabled
                    command: "LAYOUT_CAM1"
                    command2: "PLAY1"
                    command3: "STOP1"
                    text: "Левая кн. мышки - изображение на весь экран. Правая - стоп. Двойной клик - запуск"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: camera2
                    height: lampSize
                    width: lampSize
                    bottomText:cam[1].title
                    visible: cam[1].cameraenabled
                    active:cam[1].camerapresent
                    error: cam[1].onrequest
                    command: "LAYOUT_CAM2"
                    command2: "PLAY2"
                    command3: "STOP2"
                    text: "Левая кн. мышки - изображение на весь экран. Правая - стоп. Двойной клик - запуск"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: camera3
                    height: lampSize
                    width: lampSize
                    bottomText:cam[2].title
                    active:cam[2].camerapresent
                    visible: cam[2].cameraenabled
                    error: cam[2].onrequest
                    command: "LAYOUT_CAM3"
                    command2: "PLAY3"
                    command3: "STOP3"
                    text: "Левая кн. мышки - изображение на весь экран. Правая - стоп. Двойной клик - запуск"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }
                MyLamp{
                    id: camera4
                    height: lampSize
                    width: lampSize
                    bottomText:cam[3].title
                    active:cam[3].camerapresent
                    visible: cam[3].cameraenabled
                    error: cam[3].onrequest
                    command: "LAYOUT_CAM4"
                    command2: "PLAY4"
                    command3: "STOP4"
                    text: "Левая кн. мышки - изображение на весь экран. Правая - стоп. Двойной клик - запуск"
                    onLampClicked: controlPanel.lampClicked(lamp_command)
                }

            }

        }

    }
}

