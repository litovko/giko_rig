import QtQuick 2.11
import QtQuick.Controls 1.4
//import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import QmlVlc 0.1
import Gyco 1.0

Item {
    id: setupDialog
    visible: true
    //property RigCamera cam: null
    property list<RigCamera> cam
    property list<VlcPlayer> players
    property int currentcam: 0
//    property int currentplayer: 0
    //antialiasing: false
    onVisibleChanged: spinBox_videomode.currentIndex=cam[currentcam].comby;


    Rectangle {
        id: rectangle1
        width: 500
        height: 547
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
        anchors.topMargin: -36
        opacity: 0.8
        border.width: 3
        radius: 10
        visible: true
        z: 0
        border.color: "yellow"

        TextField {
            id: camurl
            x: 90
            y: 486
            z: 3
            width: 387
            height: 24
            readOnly: true
            text: cam[currentcam].url1
            font.pixelSize: 10
        }

        Label {
            id: label2
            x: 8
            y: 26
            width: 67
            height: 13
            color: "white"
            text: qsTr("Камера")
            font.pointSize: 9

            ComboBox {
                id: cb_cam
                x: 72
                y: 0
                width: 176
                height: 20
                z: 20
                Component.onCompleted: {

                    listCams.append({text: cam[0].title+" ["+cam[0].address+"]"})
                    listCams.append({text: cam[1].title+" ["+cam[1].address+"]"})
                    listCams.append({text: cam[2].title+" ["+cam[2].address+"]"})
                    listCams.append({text: cam[3].title+" ["+cam[3].address+"]"})
                    currentIndex=0
                }
                onVisibleChanged: {
                    listCams.clear()
                    listCams.append({text: cam[0].title+" ["+cam[0].address+"]"})
                    listCams.append({text: cam[1].title+" ["+cam[1].address+"]"})
                    listCams.append({text: cam[2].title+" ["+cam[2].address+"]"})
                    listCams.append({text: cam[3].title+" ["+cam[3].address+"]"})
                }
                model: ListModel {
                    id: listCams
                }
                onCurrentIndexChanged: {currentcam=currentIndex; camurl.text= cam[currentcam].url1}
            }
        }
        Label {
            id: label_stream
            x: 8
            y: 82
            width: 67
            height: 13
            color: "white"
            text: qsTr("Видеорежим")
            font.pointSize: 9
            ComboBox {
                id: spinBox_videomode
                x: 73
                y: -4
                width: 181
                height: 20

                Component.onCompleted: {
                    fill_list_model();
                    currentIndex: cam[currentcam].comby
                }
                model: ListModel {
                    id: listStreams
                }

                function fill_list_model() {

                    var  s=cam[currentcam].combylist;

                    var  c=s.substring(s.indexOf(","))
                    var  i = s.indexOf(",");
                    var  strlen=s.length;
                    listStreams.clear();
                    //console.log("Setup Camera cam"<<currentcam<<".combylist:"+cam[currentcam].combylist)
                    while(i>0){

                        c=s.substring(0,i);
                        s=s.substring(i+1,strlen);
                        listStreams.append({text: c})

                        i = s.indexOf(",");
                        strlen=s.length;

                    }
                    listStreams.append({text: s}) // добавляем последний элемент
                    spinBox_videomode.currentIndex=cam[currentcam].comby;
                    //console.log("Setup Camera  Filllistmodel() cam.comby:"+cam[currentcam].comby+"curindex:"+spinBox_videomode.currentIndex);
                    return;
                }
            }
        }


        Button {
            id: ok
            x: 281
            y: 77
            opacity: 0.8
            text: qsTr("Применить")
            tooltip: "Применение указанных настроек камеры"
            onClicked: {
                //               console.log("Кликнули");
                //console.log("Setup Camera  Comby button clicked");
                players[currentcam].stop();
                cam[currentcam].comby=spinBox_videomode.currentIndex;
                //console.log("Setup Camera  Button Apply clicked, comby:"+cam[currentcam].comby);
                cam[currentcam].videopage=true;
            }
        }

        Button {
            id: close
            x: 411
            y: 16
            width: 75
            height: 34
            text: qsTr("Закрыть")
            isDefault: true
            opacity: 0.8
            onClicked: {
                setupDialog.visible=false;
                mainRect.focus=true;
                console.log("Setup Camera Exit pressed");
            }
        }

        Rectangle {
            id: rectsettings
            x: 20
            y: 175
            width: 466
            height: 305
            radius: 5
            gradient: Gradient {
                GradientStop {
                    position: 0
                    color: "#ffffff"
                }

                GradientStop {
                    position: 0.993
                    color: "#ffffff"
                }

                GradientStop {
                    position: 0.51
                    color: "#000000"
                }

            }
            opacity: 0.8
            z: 1
            border.color: "#f4f400"

            Label {
                id: l1
                x: 8
                y: 12
                width: 122
                height: 17
                color: "#ffffff"
                text: qsTr("Яркость")
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
                font.bold: true
            }

            Label {
                id: l2
                x: 8
                y: 37
                width: 122
                height: 17
                color: "#ffffff"
                text: qsTr("Контрастность")
                font.pointSize: 10
                font.bold: true
            }

            Slider {
                id: s1
                x: 136
                y: 9
                width: 269
                height: 22
                z: 3
                stepSize: 1
                maximumValue: 255
                value: cam[currentcam].brightness
            }

            Slider {
                id: s2
                x: 136
                y: 34
                width: 269
                height: 22
                maximumValue: 255
                z: 3
                value: cam[currentcam].contrast
                stepSize: 1
            }

            Slider {
                id: s3
                x: 136
                y: 63
                width: 269
                height: 22
                maximumValue: 255
                z: 3
                value: cam[currentcam].saturation
                stepSize: 1
            }

            Label {
                id: l3
                x: 8
                y: 66
                width: 122
                height: 17
                color: "#ffffff"
                text: qsTr("Цветность")
                font.pointSize: 10
                font.bold: true
            }

            Label {
                id: l4
                x: 8
                y: 91
                width: 122
                height: 17
                color: "#ffffff"
                text: qsTr("Четкость")
                font.pointSize: 10
                font.bold: true
            }

            Slider {
                id: s4
                x: 136
                y: 89
                width: 269
                height: 22
                maximumValue: 255
                z: 3
                value: cam[currentcam].sharpness
                stepSize: 1
            }

            Label {
                id: l5
                x: 10
                y: 119
                width: 122
                height: 17
                color: "#ffffff"
                text: qsTr("Усиление динамического диапазона")
                font.pointSize: 10
                font.bold: true
            }

            Slider {
                id: s5
                x: 269
                y: 117
                width: 136
                height: 22
                tickmarksEnabled: true
                maximumValue: 3
                z: 3
                value: cam[currentcam].dynrange
                stepSize: 1
            }

            Label {
                id: l6
                x: 8
                y: 229
                width: 187
                height: 17
                color: "#ffffff"
                text: qsTr("Текст - название профиля")

                font.pointSize: 10
                font.bold: true
            }

            TextField {
                id: textField1
                x: 207
                y: 227
                width: 198
                height: 20
                text: cam[currentcam].overlaytext
                //  /[a-zA-Z]/
                validator: RegExpValidator {
                    regExp:  /[a-zA-Z0-9\s-]*/
                }

                placeholderText: qsTr("Профиль")
            }

            Button {
                id: ok1
                x: 131
                y: 265
                text: qsTr("Применить настройки видео")
                clip: false
                tooltip: "Применение указанных настроек видео"
                scale: 1.1
                z: 3
                onClicked: {
                    cam[currentcam].brightness=s1.value;
                    cam[currentcam].contrast=s2.value;
                    cam[currentcam].saturation=s3.value;
                    cam[currentcam].sharpness=s4.value;
                    cam[currentcam].colorkiller=radioDay.checked?1:0;
                    cam[currentcam].img2a=cbwhitebal.currentIndex;
                    cam[currentcam].overlaytext=textField1.text
                    cam[currentcam].videosettings=true;
                }

            }

            ComboBox {
                id: cbwhitebal
                x: 215
                y: 154
                width: 190
                height: 18

                model: ListModel {
                    id: li
                    ListElement { text: "NONE"; color: "Yellow" }
                    ListElement { text: "APPRO"; color: "Green" }
                    ListElement { text: "TI"; color: "Brown" }
                }
                currentIndex: cam[currentcam].img2a
            }

            Label {
                id: l7
                x: 105
                y: 155
                width: 122
                height: 17
                color: "#ffffff"
                text: qsTr("Баланс белого")
                font.pointSize: 10
                font.bold: true
            }

            RadioButton {
                id: radioNight
                x: 25
                y: 187
                width: 55
                height: 17
                scale: 1.5
                onCheckedChanged: {
                    if (checked) radioDay.checked=false
                    else radioDay.checked=true;
                    cam[currentcam].colorkiller=checked?0:1

                    //console.log("Setup Camera  NIGHT=1/DAY=0"+ cam[currentcam].colorkiller);
                }
                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 9
                        //border.color: control.activeFocus ? "yellow" : "gray"
                        border.width: 1
                        Rectangle {
                            anchors.fill: parent
                            visible: control.checked
                            color: control.checked ? "yellow" : "gray"
                            radius: 9
                            anchors.margins: 4
                        }
                    }
                }

            }

            RadioButton {

                id: radioDay

                onCheckedChanged: {

                    if (checked) radioNight.checked=false
                    else radioNight.checked=true;
                    cam[currentcam].colorkiller=checked?1:0
                    //console.log("Setup Camera onCheckedChanged NIGHT=1/DAY=0"+ cam[currentcam].colorkiller);
                }
                Component.onCompleted:  checked=cam[currentcam].colorkiller==0?true:false

                x: 11
                y: 160
                width: 56
                height: 17
                scale: 1.5
                transformOrigin: Item.Left
                rotation: 0
                style: RadioButtonStyle {
                    indicator: Rectangle {
                        implicitWidth: 16
                        implicitHeight: 16
                        radius: 9
                        //border.color: control.activeFocus ? "yellow" : "gray"
                        border.width: 1
                        Rectangle {
                            anchors.fill: parent
                            visible: control.checked
                            color: control.checked ? "yellow" : "gray"
                            radius: 9
                            anchors.margins: 4
                        }
                    }
                }
            }

            Label {
                id: ldn1
                x: 43
                y: 161
                width: 37
                height: 17
                color: "#ffffff"
                text: qsTr("День")
                font.bold: radioDay.checked
            }

            Label {
                id: ldn2
                x: 43
                y: 188
                width: 37
                height: 17
                color: "#fbfbfb"
                text: qsTr("Ночь")
                font.bold: radioNight.checked
            }

            Label {
                id: lb1
                x: 411
                y: 12
                width: 33
                height: 17
                color: "#ffffff"
                text: s1.value
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: lb2
                x: 411
                y: 37
                width: 33
                height: 17
                color: "#ffffff"
                text: s2.value
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: lb3
                x: 411
                y: 66
                width: 33
                height: 17
                color: "#ffffff"
                text: s3.value
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }

            Label {
                id: lb4
                x: 411
                y: 91
                width: 33
                height: 17
                color: "#ffffff"
                text: s4.value
                font.bold: true
                font.pointSize: 10
                verticalAlignment: Text.AlignVCenter
            }
        }

        Label {
            id: label1
            x: 170
            y: 148
            width: 160
            height: 21
            color: "#ffffff"
            text: qsTr("Настройки видео")
            font.pointSize: 10
            z: 3
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        Text {
            id: vlcversion
            x: 100
            y: 520
            width: 218
            height: 19
            text:"Версия библиотек VLC:"+ players[currentcam].vlcVersion
            font.pixelSize: 12
        }

        Button {
            id: time
            x: 82
            y: 114
            width: 110
            height: 23
            text: qsTr("Установить время")
            opacity: 0.8
            tooltip: "Установка текущего времени"
            onClicked: {
                //console.log("Setup Camera SetTime Clicked");
                players[currentcam].stop();
                cam[currentcam].setDateTimesettings();
            }
        }

        Button {
            id: btn_reset
            x: 243
            y: 114
            width: 113
            height: 23
            text: qsTr("Перезапуск камеры")
            tooltip: "Программынй ресет камеры"
            opacity: 0.8
            onClicked: cam[currentcam].send_reset();
        }


    }

    TextField {
        id: cam_name
        x: 13
        y: 452
        width: 70
        height: 20
        text: cam[currentcam].title
        readOnly: true
        opacity: 0.8
        placeholderText: qsTr("Выбранная камера")
    }

}
