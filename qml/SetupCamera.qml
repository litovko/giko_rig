import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
Item {
    id: setupCamera
    visible: true
    property list<MyCamera> cam
    property int currentcam: 0
    width: 500
    height: 547
    Rectangle {
        id: rectangle1

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
        anchors.fill: parent
        opacity: 0.8
        border.width: 3
        radius: 10
        visible: true
        z: 0
        border.color: "yellow"
        Column {
            spacing: 10
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: 20
            MyButton {
                id: ok
                width: 80
                height: 50
                //            opacity: 0.8
                text: qsTr("Применить")
                onClicked: {
                    cam[0].media = cam1_media.text
                    cam[0].address = cam1_address.text
                    cam[0].port = cam1_port.text
                    checke_tcp.interval = interval.text
                    win.filesize=cbfilesize.currentText
                    setupCamera.visible=false;
                    mainRect.focus=true;
                }
            }
            MyButton {
                id: close
                width: 80
                height: 50
                text: qsTr("Закрыть")
                onClicked: {
                    setupCamera.visible=false;
                    mainRect.focus=true;
                }
            }
        }
        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins:  20
            spacing: 20
            Label {
                id: check_camera
                width: 180
                height: 13
                color: "#ffffff"
                text: qsTr("Интервал проверки камеры, мс:")
                font.pointSize: 9
                TextField {
                    id: interval
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 100
                    height: 20
                    text: checke_tcp.interval
                    padding: 0
                    font.pointSize: 9
                    opacity: 0.8
                    placeholderText: qsTr("миллисекунды")
                    validator: IntValidator {
                        bottom: 5000
                        top: 60000
                    }
                }
            }
            Label {
                id: lca0
                width: 180
                height: 20
                color: "#ffffff"
                text: qsTr("Адрес видеокамеры "+cam[0].name +":")
                font.pointSize: 9
                TextField {
                    id: cam1_address
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 120
                    height: 25
                    text: cam[0].address
                    font.pointSize: 9
                    readOnly: false
                    validator: adr_validator
                    placeholderText: qsTr("IP-адрес видеокамеры")
                    opacity: 0.8
                    CheckBox {
                        id: cb_cam1
                        anchors.left: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 20
                        text: cam[0].name
                        checked: cam[0].cameraenabled
                        onCheckedChanged: cam[0].cameraenabled=checked
                    }

                }
            }
            Label {
                id: cam_port
                width: 180
                height: 20
                color: "#ffffff"
                text: qsTr("Порт видеокамеры  "+cam[0].name +":")
                font.pointSize: 9
                TextField {
                    id: cam1_port
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 120
                    height: 25
                    text: cam[0].port
                    font.pointSize: 9
                    readOnly: false
                    validator: IntValidator {bottom: 1001; top: 65535;}
                    placeholderText: qsTr("IP-порт видеокамеры")
                    opacity: 0.8
                }
            }
            Label {
                id: meliastream
                width: 140
                height: 20
                color: "#ffffff"
                text: qsTr("Медиапоток: ")
                font.pointSize: 9
                TextField {
                    id: cam1_media
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 300
                    height: 25
                    text: cam[0].media
                    font.pointSize: 9
                    readOnly: false
                    placeholderText: qsTr("RTSP медиапоток ") // /PSIA/Streaming/channels/2?videoCodecType=H.264
                    opacity: 0.8
                }
            }
            Label {
                id: fpath
                width: 140
                height: 20
                color: "#ffffff"
                text: qsTr("Папка для видео: ")
                font.pointSize: 9
                MyButton {
                    id: filepath_dialog
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 80
                    height: 23
                    text: qsTr("Сменить")
                    opacity: 0.8
                    onClicked: {
                        fileDialog.visible=true
                    }
                    TextField {
                        id: vpath
                        width: 240
                        height: parent.height
                        anchors.left: parent.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.margins: 10
                        text: win.filepath
                        font.pointSize: 9
                        readOnly: true
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
            Label {
                id: file_size
                width: 200
                height: 20
                color: "#ffffff"
                text: qsTr("Размер нарезки видеофалов, Мб")
                font.pointSize: 9
                ComboBox {
                    id: cbfilesize
                    width: 75
                    height: 24
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
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
        }
    }
}


