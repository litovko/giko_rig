import QtQuick 2.12
import QtQuick.Controls 2.12
//import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Gyco 1.0
//import HYCO 1.0
Item {
    id: settingsDialog
    visible: true
    property Networker rig:null
    property Board rig_model: null
    //    onVisibleChanged: { cbj.checked=j.ispresent}
    RegExpValidator{
        id: adr_validator
        regExp: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
    }
    Rectangle {
        id: rectangle1
        anchors.fill: parent
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        opacity: 0.8
        border.width: 3
        radius: 10
        gradient: Gradient {
            GradientStop {
                position: 0
                color: "#000000"
            }

            GradientStop {
                position: 1
                color: "#aaaaaa"
            }
        }
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
                width: 111
                height: 20
                text: rig.address
                padding: 0
                font.pointSize: 9
                validator: adr_validator
                opacity: 0.8
                placeholderText: qsTr("IP-адрес телегрейфера")
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
                text: rig.timer_connect_interval.toString()
                padding: 0
                font.pointSize: 9
                validator: IntValidator{bottom: 30000; top: 600000}
                opacity: 0.8
                placeholderText: qsTr("Интервал попыток подключения в миллисекундах")
            }
        }
        MyButton {
            id: ok
            anchors.right: parent.right
            anchors.margins: 20
            y: 86
            width: 80
            height: 50
            //            opacity: 0.8
            text: qsTr("Применить")
            onClicked: {
                rig.address=rig_address.text
                rig.port=rig_port.text

                rig.timer_send_interval=parseInt(rig_msec1.text);
                rig.timer_connect_interval=parseInt(rig_msec2.text);
                rig_model.freerun=parseInt(rig_msec3.text);
                rig_model.check_type=cb_check_type.checked;
                rig_model.timer_delay_engine1=free_msec1.text;
                rig_model.timer_delay_engine2=free_msec2.text;
                //                network_caching=parseInt(netcache.text);

                j.ispresent=cbj.checked
                settingsDialog.visible=false;
                mainRect.focus=true;
            }
        }

        MyButton {
            id: close
            anchors.right: parent.right
            anchors.margins: 20
            y: 27
            width: 80
            height: 50
            text: qsTr("Закрыть")
            onClicked: {
                settingsDialog.visible=false;
                mainRect.focus=true;
            }
        }


        Label {
            id: lrp
            x: 155
            y: 66
            width: 98
            height: 13
            color: "#ffffff"
            font.pointSize: 9
            text: qsTr("Порт аппарата")
            TextField {
                id: rig_port
                x: 104
                y: -3
                width: 96
                height: 20
                text: rig.port
                padding: 0
                font.pointSize: 9
                validator: IntValidator{bottom: 1; top: 65535}
                placeholderText: qsTr("IP-адрес телегрейфера")
                opacity: 0.8
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
                text: rig.timer_send_interval.toString();
                padding: 0
                font.pointSize: 9
                validator: IntValidator{bottom: 15; top: 10000}
                opacity: 0.8
                placeholderText: qsTr("интервал отправки данных в миллисекундах")
            }
        }



        Label {
            id: lris3
            x: 7
            y: 150
            width: 245
            height: 13
            color: "#ffffff"
            text: qsTr("Свободный ход клапана, %")
            horizontalAlignment: Text.AlignRight
            TextField {
                id: rig_msec3
                x: 251
                y: -3
                width: 96
                height: 20
                text: rig_model.freerun
                padding: 0
                font.pointSize: 9
                validator: IntValidator {
                    top: 100
                    bottom: 0
                }
                opacity: 0.8
                placeholderText: qsTr("Свободный ход клапанов в процентах")
            }
            font.pointSize: 9
        }

        Label {
            id: lris4
            x: 8
            y: 180
            width: 113
            height: 13
            color: "#ffffff"
            text: qsTr("Разгр. двиг-ля1, мс")
            TextField {
                id: free_msec1
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 96
                height: 20
                text: rig_model.timer_delay_engine1
                padding: 0
                font.pointSize: 9
                validator: IntValidator {
                    bottom: 0
                    top: 100000
                }
                placeholderText: qsTr("время разгрузки первого двиг-ля в миллисекундах")
                opacity: 0.8
            }
            font.pointSize: 9
        }

        Label {
            id: lris5
            x: 235
            y: 180
            width: 108
            height: 13
            color: "#ffffff"
            text: qsTr("Разгр. двиг-ля2, мс")
            TextField {
                id: free_msec2
                anchors.left: parent.right
                anchors.verticalCenter: parent.verticalCenter
                width: 96
                height: 20
                text: rig_model.timer_delay_engine2
                padding: 0
                font.pointSize: 9
                validator: IntValidator {
                    bottom: 0
                    top: 100000
                }
                placeholderText: qsTr("время разгрузки второго двиг-ля в миллисекундах")
                opacity: 0.8
            }
            font.pointSize: 9
        }
    }

}


