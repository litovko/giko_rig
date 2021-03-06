import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QmlVlc 0.1
import Gyco 1.0
Item {
    id: settingsDialog
    visible: true
    property list<RigCamera> cam
    property RigModel rig:null
    onVisibleChanged: { cbj.checked=j.ispresent}
    RegExpValidator{
        id: adr_validator
        regExp: /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
    }
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

            GradientStop {
                position: 0.401
                color: "#ffffff"
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
                validator: adr_validator
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


                cam[0].address=cam1_address.text
                cam[1].address=cam2_address.text
                cam[2].address=cam3_address.text
                cam[0].cameraenabled=cb_cam1.checked
                cam[1].cameraenabled=cb_cam2.checked
                cam[2].cameraenabled=cb_cam3.checked
                //win.cam2index=cb_cam2.checked?2:0
                //win.cam3index=cb_cam3.checked?3:0
                //cb_cam1.checked=true;
                //win.cam1index=cb_cam1.checked?1:0

                console.log("Setup Settings cb"+cb_cam2.checked+" "+cb_cam3.checked)
                rig.timer_send_interval=parseInt(rig_msec1.text);
                rig.timer_connect_interval=parseInt(rig_msec2.text);
                rig.freerun=parseInt(rig_msec3.text);
                rig.check_type=cb_check_type.checked;
                network_caching=parseInt(netcache.text);
                filesize=cbfilesize.currentText
                j.ispresent=cbj.checked
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
                validator: IntValidator{bottom: 1; top: 65535}
                placeholderText: qsTr("IP-адрес телегрейфера")
                opacity: 0.8
            }
            font.pointSize: 9
        }
        Label {
            id: lca0
            x: 88
            y: 223
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            TextField {
                id: cam1_address
                x: 121
                y: -3
                width: 96
                height: 20
                text: cam[0].address
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
            y: 252
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam2_address
                x: 121
                y: -3
                width: 96
                height: 20
                text: cam[1].address
                validator: adr_validator
                opacity: 0.8
                placeholderText: qsTr("IP-адрес видеокамеры")
                readOnly: false
            }
        }
        
        Label {
            id: lca2
            x: 88
            y: 282
            width: 98
            height: 13
            color: "#ffffff"
            text: qsTr("Адрес видеокамеры")
            font.pointSize: 9
            TextField {
                id: cam3_address
                x: 121
                y: -3
                width: 96
                height: 20
                text: cam[2].address
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
                validator: IntValidator{bottom: 30000; top: 600000}
                opacity: 0.8
                placeholderText: qsTr("Интервал попыток подключения в миллисекундах")
            }
        }

        Label {
            id: lcache
            x: 88
            y: 311
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
            y: 397
            width: 479
            height: 33
            title: qsTr("Путь к видеозаписям")

            Text {
                id: tfilepath
                x: 0
                y: -5
                width: 421
                height: 14
                text: win.filepath
                textFormat: Text.AutoText
                horizontalAlignment: Text.AlignHCenter
                enabled: false
                font.pixelSize: 12
            }

            Button {
                id: filepath_dialog
                x: 427
                y: -10
                width: 44
                height: 23
                text: qsTr("Выбор")
                opacity: 0.8
                tooltip: "Выбор папки для сохранения видео"
                onClicked: {
                    fileDialog.visible=true
                }

                FileDialog {
                    id: fileDialog
                    title: "Выберите каталог для видеозаписей"
                    folder: "file:///"+win.filepath
                    selectFolder: true
                    sidebarVisible : true
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
                    Component.onCompleted: visible = false
                }
            }

        }

        CheckBox {
            id: cb_cam1
            x: 333
            y: 221
            text: cam[0].title
            clip: false
            scale: 1
            checked: cam[0].cameraenabled
            //onCheckedChanged: cam[0].cameraenabled=checked

        }

        CheckBox {
            id: cb_cam2
            x: 333
            y: 250
            text: cam[1].title
            scale: 1
            checked: cam[1].cameraenabled
            //onCheckedChanged: cam[1].cameraenabled=checked
        }

        CheckBox {
            id: cb_cam3
            x: 333
            y: 280
            text: cam[2].title
            scale: 1
            checked: cam[2].cameraenabled
            //onCheckedChanged: cam[2].cameraenabled=checked
        }

        CheckBox {
            id: cbj
            x: 387
            y: 374
            checked: j.ispresent
            text: qsTr("Джойстик")
        }

        Label {
            id: ltype
            x: 26
            y: 181
            width: 78
            height: 13
            color: "#ffffff"
            text: qsTr("Тип аппарата")
            font.pointSize: 9

            ComboBox {
                id: cbtype
                x: 89
                y: -4
                width: 180
                height: 20
                Component.onCompleted: currentIndex = curindex()
                function curindex() {
                    console.debug("Setup Settings Settings curindex:"+rig.rigtype+"Текст:"+currentText)
                    if (rig.rigtype==="grab2") return 0;
                    if (rig.rigtype==="grab6") return 1;
                    if (rig.rigtype==="gkgbu") return 2;
                    return 0;
                }
                function curtype(){
                    console.log("Setup Settings Settings curtype"+currentText)
                    if (currentIndex==1) return "grab6";
                    if (currentIndex==2) return "gkgbu";
                    return "grab2";
                }
                onCurrentIndexChanged: rig.rigtype=curtype()
                model: ["Двухлепестковый - grab2", "Шестилепестковый - grab6", "ГКГБУ - gkgbu" ]
                //currentIndex: curindex()
            }
        }

        Label {
            id: ltype1
            x: 13
            y: 373
            width: 184
            height: 13
            color: "#ffffff"
            text: qsTr("Размер нарезки видеофалов, Мб")
            font.pointSize: 9
            ComboBox {
                id: cbfilesize
                x: 201
                y: -3
                width: 69
                height: 20
                model: [500, 700, 1000, 1200]
                Component.onCompleted: {
                    currentIndex=0
                    switch (win.filesize){
                    case 500: currentIndex=0; break;
                    case 700: currentIndex=1; break;
                    case 1000: currentIndex=2; break;
                    case 1200: currentIndex=3; break;
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
                text: rig.freerun
                validator: IntValidator {
                    top: 100
                    bottom: 0
                }
                opacity: 0.8
                placeholderText: qsTr("Свободный ход клапанов в процентах")
            }
            font.pointSize: 9
        }

        CheckBox {
            id: cb_check_type
            x: 310
            y: 179
            text: qsTr("Автоопределение")
            checked: rig.check_type
            visible: true
        }

    }
    
}
