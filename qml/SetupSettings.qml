import QtQuick 2.11
import QtQuick.Controls 2.4
//import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QmlVlc 0.1
import Gyco 1.0
Item {
    id: settingsDialog
    visible: true
    property list<RigCamera> cam
    property Networker rig:null
    property Board rig_model: null
    onVisibleChanged: { cbj.checked=j.ispresent}
    RegExpValidator{
        id: adr_validator
        regExp: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
    }
    Rectangle {
        id: rectangle1
        width: 500
        height: 480
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


        Button {
            id: ok
            x: 394
            y: 86
            opacity: 0.8
            text: qsTr("Применить")
            //tooltip: "Применение указанных настроек программы"
            onClicked: {
                rig.address=rig_address.text
                rig.port=rig_port.text


                cam[0].address=cam1_address.text
                cam[1].address=cam2_address.text
                cam[2].address=cam3_address.text
                cam[3].address=cam4_address.text
                cam[0].cameraenabled=cb_cam1.checked
                cam[1].cameraenabled=cb_cam2.checked
                cam[2].cameraenabled=cb_cam3.checked
                cam[3].cameraenabled=cb_cam4.checked

                console.log("Setup Settings cb"+cb_cam2.checked+" "+cb_cam3.checked)
                rig.timer_send_interval=parseInt(rig_msec1.text);
                rig.timer_connect_interval=parseInt(rig_msec2.text);
                rig_model.freerun=parseInt(rig_msec3.text);
                rig_model.check_type=cb_check_type.checked;
                rig_model.timer_delay_engine1=free_msec1.text;
                rig_model.timer_delay_engine2=free_msec2.text;
                network_caching=parseInt(netcache.text);
                win.filesize=cbfilesize.currentText
                j.ispresent=cbj.checked
            }
        }

        Button {
            id: close
            x: 394
            y: 27
            text: qsTr("Закрыть")
            flat: false
            highlighted: false
            //isDefault: true
            opacity: 0.8
            onClicked: {
                settingsDialog.visible=false;
                mainRect.focus=true;
                console.log("Setup Settings - Close clicked");
            }
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
                padding: 0
                font.pointSize: 9
                validator: IntValidator{bottom: 1; top: 65535}
                placeholderText: qsTr("IP-адрес телегрейфера")
                opacity: 0.8
            }
            font.pointSize: 9
        }
        Label {
            id: lca0
            x: 88
            y: 187
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            TextField {
                id: cam1_address
                x: 121
                y: -3
                width: 106
                height: 20
                text: cam[0].address
                padding: 0
                font.pointSize: 9
                readOnly: false
                validator: adr_validator
                placeholderText: qsTr("IP-адрес видеокамеры")
                opacity: 0.8
            }
            font.pointSize: 9
        }

        Label {
            id: lca1
            x: 88
            y: 222
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam2_address
                x: 121
                y: -3
                width: 106
                height: 20
                text: cam[1].address
                padding: 0
                font.pointSize: 9
                validator: adr_validator
                opacity: 0.8
                placeholderText: qsTr("IP-адрес видеокамеры")
                readOnly: false
            }
        }

        Label {
            id: lca2
            x: 88
            y: 256
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam3_address
                x: 121
                y: -3
                width: 105
                height: 20
                text: cam[2].address
                padding: 0
                font.pointSize: 9
                validator: adr_validator
                opacity: 0.8
                placeholderText: qsTr("IP-адрес видеокамеры")
                readOnly: false
            }
        }
        Label {
            id: lca3
            x: 88
            y: 290
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam4_address
                x: 121
                y: -3
                width: 105
                height: 20
                text: cam[3].address
                padding: 0
                font.pointSize: 9
                validator: adr_validator
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
                text: rig.timer_send_interval.toString();
                padding: 0
                font.pointSize: 9
                validator: IntValidator{bottom: 15; top: 10000}
                opacity: 0.8
                placeholderText: qsTr("интервал отправки данных в миллисекундах")
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

        Label {
            id: lcache
            x: 88
            y: 328
            width: 109
            height: 13
            color: "#ffffff"
            text: qsTr("Кэш видеопотока, мс")
            TextField {
                id: netcache
                x: 121
                y: -3
                width: 96
                height: 20
                text: network_caching.toString()
                padding: 0
                font.pointSize: 9
                opacity: 0.8
                placeholderText: qsTr("network-cache")
                validator: IntValidator {
                    bottom: 50
                    top: 600
                }
            }
            font.pointSize: 9
        }


        GroupBox {
            id: groupBox1
            x: 13
            y: 379
            width: 479
            height: 51
            title: qsTr("Путь к видеозаписям")
            Text {
                id: tfilepath
                anchors.left: parent.left
                anchors.top: parent.top
                width: 357
                height: 18
                text: win.filepath
                z: 1
                font.pixelSize: 12
            }

            Button {
                id: filepath_dialog
                x: 363
                y: 2
                width: 104
                height: 23
                text: qsTr("Выбор")
                opacity: 0.8
                //tooltip: "Выбор папки для сохранения видео"
                onClicked: {
                    fileDialog.visible=true
                }

                FileDialog {
                    id: fileDialog
                    title: "Выберите каталог для видеозаписей"
                    folder: "file:///"+win.filepath
                    selectFolder: true
                    sidebarVisible : true
                    visible: false
                    onAccepted: {
                        console.log(" Setup Settings You chose: " + Qt.resolvedUrl(fileDialog.fileUrl))

                        win.filepath=fileDialog.fileUrl.toString().substring(8,fileDialog.fileUrl.length)+"/"
                        console.log(" Setup SettingsYou chose: " + win.filepath)
                        fileDialog.visible=false
                    }
                    onRejected: {
                        console.log("Setup Settings Canceled")
                        fileDialog.visible=false
                    }
                    //Component.onCompleted: visible = false
                }
            }

        }

        CheckBox {
            id: cb_cam1
            x: 316
            y: 174
            text: cam[0].title
            clip: false
            scale: 1
            checked: cam[0].cameraenabled
            //onCheckedChanged: cam[0].cameraenabled=checked

        }

        CheckBox {
            id: cb_cam2
            x: 316
            y: 209
            text: cam[1].title
            scale: 1
            checked: cam[1].cameraenabled
            //onCheckedChanged: cam[1].cameraenabled=checked
        }

        CheckBox {
            id: cb_cam3
            x: 315
            y: 243
            text: cam[2].title
            scale: 1
            checked: cam[2].cameraenabled
            //onCheckedChanged: cam[2].cameraenabled=checked
        }
        CheckBox {
            id: cb_cam4
            x: 315
            y: 277
            width: 119
            height: 40
            text: cam[3].title
            scale: 1
            checked: cam[3].cameraenabled
        }

        CheckBox {
            id: cbj
            x: 376
            y: 333
            checked: j.ispresent
            text: qsTr("Джойстик")
        }

        Label {
            id: ltype1
            x: 13
            y: 360
            width: 184
            height: 13
            color: "#ffffff"
            text: qsTr("Размер нарезки видеофалов, Мб")
            font.pointSize: 9
            ComboBox {
                id: cbfilesize
                x: 201
                y: -3
                width: 75
                height: 24
                font.pointSize: 9
                model: [50, 500, 700, 1000, 1200, 4000]
                Component.onCompleted: {
                    currentIndex=0
                    switch (win.filesize){
                    case 50: currentIndex=0; break;
                    case 500: currentIndex=1; break;
                    case 700: currentIndex=2; break;
                    case 1000: currentIndex=3; break;
                    case 1200: currentIndex=4; break;
                    case 4000: currentIndex=5; break;
                    default: currentIndex=0;
                    }
                }

            }
        }

        Label {
            id: lris3
            x: 7
            y: 147
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
            y: 444
            width: 113
            height: 13
            color: "#ffffff"
            text: qsTr("Разгр. двиг-ля1, мс")
            TextField {
                id: free_msec1
                x: 109
                y: -2
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
            y: 444
            width: 108
            height: 13
            color: "#ffffff"
            text: qsTr("Разгр. двиг-ля2, мс")
            TextField {
                id: free_msec2
                x: 109
                y: -2
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
//        ComboBox {
//            id: test
//            x: 0
//            y: 0
//            width: 69
//            height: 20
//            model: [50, 500, 700, 1000, 1200, 4000]
//        }

    }

}



















/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:31;anchors_height:18;anchors_width:357;anchors_x:0;anchors_y:9}
}
##^##*/
