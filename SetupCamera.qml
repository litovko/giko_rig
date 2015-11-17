import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import Gyco 1.0
Item {
    id: setupDialog
    visible: true
    property RigCamera cam: null

    Rectangle {
        id: rectangle1
        width: 500
        height: 500
        gradient: Gradient {
            GradientStop {
                position: 1
                color: "#222222"
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
        z: -1
        border.color: "yellow"



        Label {
            id: label2
            x: 8
            y: 37
            width: 67
            height: 13
            color: "white"
            text: qsTr("Камера")

            TextField {
                id: cam_name
                x: 73
                y: -4
                width: 180
                height: 20
                text: "CAM1"
                opacity: 0.8
                placeholderText: qsTr("Text Field")
            }
        }
        Label {
            id: label_stream
            x: 8
            y: 66
            width: 67
            height: 13
            color: "white"
            text: qsTr("Потоков")
            ComboBox {
                id: spinBox_stream
                x: 73
                y: -4
                width: 181
                height: 20
                Component.onCompleted: fill_list_model();
                model: ListModel {
                    id: listStreams
                }
                onCurrentIndexChanged: {
                    cam.videocodec=currentIndex;

                    spinBox_codec.fill_list_model();
                    cam.videocodeccombo=0;
                    spinBox_res.fill_list_model();
                    // включение/выключение страниц потоков
                    switch (currentIndex) {
                    case 0:
                        f2.visible=false;
                        f3.visible=false;
                        break;
                    case 1:
                        f2.visible=true;
                        f3.visible=false;
                        break;
                    case 2:
                        f2.visible=true;
                        f3.visible=true;
                        break;
                    default:
                    }
                }
                function fill_list_model() {

                    var  s=cam.codeclist;
                    var  c=s.substring(s.indexOf(","))
                    var  i = s.indexOf(",");
                    var  strlen=s.length;
                    listStreams.clear();
                    while(i>0){

                        c=s.substring(0,i);
                        s=s.substring(i+1,strlen);
                        listStreams.append({text: c})

                        i = s.indexOf(",");
                        strlen=s.length;

                    }
                    listStreams.append({text: s}) // добавляем последний элемент
                    spinBox_stream.currentIndex=0; //устанавливаем элемент в начало списка
                    cam.videocodec=0;
                    return;
                }
            }
        }

        Label {
            id: label_codec
            x: 8
            y: 95
            width: 67
            height: 13
            color: "#ffffff"
            text: qsTr("Кодеки")
            verticalAlignment: Text.AlignTop

            ComboBox {
                id: spinBox_codec
                x: 73
                y: -7
                width: 182
                height: 20
                model: ListModel {
                        id: listCodec;
                }
                function fill_list_model() {

                    var  s=cam.codeccombolist;
                    var  c=s.substring(s.indexOf(","))
                    var  i = s.indexOf(",");
                    var  strlen=s.length;
                    listCodec.clear();
                    while(i>0){

                        c=s.substring(0,i);
                        s=s.substring(i+1,strlen);
                        listCodec.append({text: c})

                        i = s.indexOf(",");
                        strlen=s.length;

                    }
                    listCodec.append({text: s}) // добавляем последний элемент
                    spinBox_codec.currentIndex=0; //устанавливаем элемент в начало списка
                    cam.videocodeccombo=0;
                    return;
                }
                onCurrentIndexChanged: {
                    //if (currentIndex===0) {
                        cam.videocodeccombo=currentIndex;

                        spinBox_res.fill_list_model();
                    //}
                }
            }
        }
        Label {
            id: label_res
            x: 8
            y: 121
            width: 67
            height: 13
            color: "#ffffff"
            text: qsTr("Детализация")
            ComboBox {
                id: spinBox_res
                x: 73
                y: -7
                width: 182
                height: 20
                model: ListModel {
                        id: listResolution;
                }
                function fill_list_model() {

                    var  s=cam.resolutionlist;
                    var  c=s.substring(s.indexOf(","))
                    var  i = s.indexOf(",");
                    var  strlen=s.length;
                    listResolution.clear();
                    while(i>0){

                        c=s.substring(0,i);
                        s=s.substring(i+1,strlen);
                        listResolution.append({text: c})

                        i = s.indexOf(",");
                        strlen=s.length;

                    }
                    listResolution.append({text: s}) // добавляем последний элемент
                    spinBox_res.currentIndex=0; //устанавливаем элемент в начало списка
                    cam.videocodecres=0;
                    return;
                }
            }
            verticalAlignment: Text.AlignTop
        }

        Row {
            x: 8
            y: 147
            z: 2
            layoutDirection: Qt.LeftToRight
            spacing: 4

            Button {
                id: f1
                text: "Поток 1"
                visible: true
                z: 2
                tooltip: "Настройки первого видеопотока"
                opacity: 0.9
            }

            Button {
                id: f2
                text: "Поток 2"
                visible: false
                z: 3
                opacity: 0.9
                tooltip: "Настройки второго видеопотока"
            }

            Button {
                id: f3
                text: "Поток 3"
                z: 4
                visible: false
                opacity: 0.9
                tooltip: "Настройки третьего видеопотока"
            }
        }


        Button {
            id: ok
            x: 415
            y: 32
            opacity: 0.8
            text: qsTr("Применить")
            tooltip: "Применение указанных настроек камеры"
            onClicked: {
                console.log("Кликнули");
                cam.videopage=true;
            }
        }

        Button {
            id: close
            x: 415
            y: 66
            text: qsTr("Закрыть")
            isDefault: true
            opacity: 0.8
            onClicked: {
                setupDialog.visible=false;
                console.log("Кликнули выход");
            }
        }
    }

}
