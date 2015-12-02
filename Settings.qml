import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import QmlVlc 0.1
import Gyco 1.0
Item {
    id: settingsDialog
    visible: true
    property RigCamera cam: null
    property VlcPlayer player: null
    property RigModel rig:null

    Rectangle {
        id: rectangle1
        width: 500
        height: 455
        gradient: Gradient {
            GradientStop {
                position: 1
                color: "#ffffff"
            }

            GradientStop {
                position: 0
                color: "#000000"
            }
        }
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        opacity: 0.8
        border.width: 3
        radius: 10
        z: 0
        border.color: "yellow"



        Label {
            id: lra
            x: 155
            y: 37
            width: 98
            height: 13
            color: "white"
            text: qsTr("Адрес аппарата")
            font.pointSize: 9

            TextField {
                id: rig_address
                x: 104
                y: -3
                width: 96
                height: 20
                text: rig.address
                opacity: 0.8
                placeholderText: qsTr("IP-адрес телегрейфера")
            }
        }


        Button {
            id: ok
            x: 394
            y: 56
            opacity: 0.8
            text: qsTr("Применить")
            tooltip: "Применение указанных настроек программы"
            onClicked: {
                rig.address=rig_address.text
                rig.port=rig_port.text
                cam.address=cam_address0.text
                rig.timer_send_interval=lris1.text
                rig.timer_connect_interval=lris2.text
            }
        }

        Button {
            id: close
            x: 394
            y: 27
            text: qsTr("Закрыть")
            isDefault: true
            opacity: 0.8
            onClicked: {
                settingsDialog.visible=false;
                console.log("Кликнули выход");
            }
        }

        Label {
            id: lca0
            x: 8
            y: 252
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            TextField {
                id: cam_address0
                x: 121
                y: -3
                width: 96
                height: 20
                text: cam.address
                readOnly: false
//                validator: RegExpValidator{
//                    regExp: "^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$";
//                }
                placeholderText: qsTr("IP-адрес видеокамеры")
                opacity: 0.8
            }
            font.pointSize: 9
        }

        Label {
            id: lrp
            x: 155
            y: 66
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Порт аппарата")
            TextField {
                id: rig_port
                x: 104
                y: -3
                width: 96
                height: 20
                text: rig.port
                placeholderText: qsTr("IP-адрес телегрейфера")
                opacity: 0.8
            }
            font.pointSize: 9
        }

        Label {
            id: lca1
            x: 8
            y: 281
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam_address1
                x: 121
                y: -3
                width: 96
                height: 20
                text: cam.address
                opacity: 0.8
                placeholderText: qsTr("IP-адрес видеокамеры")
                readOnly: false
            }
        }

        Label {
            id: lca2
            x: 8
            y: 311
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam_address2
                x: 121
                y: -3
                width: 96
                height: 20
                text: cam.address
                opacity: 0.8
                placeholderText: qsTr("IP-адрес видеокамеры")
                readOnly: false
            }
        }

        Label {
            id: lris1
            x: 39
            y: 93
            width: 214
            height: 13
            color: "#ffffff"
            text: qsTr("Интервал отправки данных, сек/1000")
            font.pointSize: 9
            TextField {
                id: rig_msec1
                x: 220
                y: -3
                width: 96
                height: 20
                text: rig.timer_send_interval
                opacity: 0.8
                placeholderText: qsTr("")
            }
        }

        Label {
            id: lris2
            x: 8
            y: 120
            width: 245
            height: 13
            color: "#ffffff"
            text: qsTr("Интервал попыток подключения, сек/1000")
            font.pointSize: 9
            TextField {
                id: rig_msec2
                x: 251
                y: -3
                width: 96
                height: 20
                text: rig.timer_connect_interval
                opacity: 0.8
                placeholderText: qsTr("")
            }
        }
    }

}
