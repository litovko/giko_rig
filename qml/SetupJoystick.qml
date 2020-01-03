import QtQuick 2.12
import QtQuick.Controls 2.12

import QmlVlc 0.1
import Gyco 1.0
Item {
    id: joystickDialog
    visible: true
    property RigJoystick joystick:null
    property alias text: j_text.text
    property alias btn_apply: b_apply
    property alias btn_close: b_apply1
    property alias rect: rectangle1
    function setinvert() {
        switcher1.inv = joystick.invert[comboBox1.currentIndex]
        switcher2.inv = joystick.invert[comboBox2.currentIndex]
        switcher3.inv = joystick.invert[comboBox3.currentIndex]
        switcher4.inv = joystick.invert[comboBox4.currentIndex]
    }

    ListModel { //список названий кнопок и соответствующих им индексов
        id: btnlistmodel
        Component.onCompleted: {

        }
    }
    ListModel {  //список вариантов выбора кнопок
        id: btnnumberlistmodel
    }
    function fillistmodel(){
        btnlistmodel.clear()
        btnnumberlistmodel.clear()
        print("Joystick fillistmodel: "+ joystick.ispresent +"current: "+ joystick.current)
        if (joystick.ispresent) {
            btnlistmodel.append({"name":"Кнопка  №1", "ind":joystickDialog.joystick.map(0), "id" : 0})
            btnlistmodel.append({"name":"Кнопка  №2", "ind":joystickDialog.joystick.map(1), "id" : 1})
            btnlistmodel.append({"name":"Кнопка  №3", "ind":joystickDialog.joystick.map(2), "id" : 2})
            btnlistmodel.append({"name":"Кнопка  №4", "ind":joystickDialog.joystick.map(3), "id" : 3})
            btnlistmodel.append({"name":"Кнопка  №5", "ind":joystickDialog.joystick.map(4), "id" : 4})
            btnlistmodel.append({"name":"Кнопка  №6", "ind":joystickDialog.joystick.map(5), "id" : 5})
            btnlistmodel.append({"name":"Кнопка  №7", "ind":joystickDialog.joystick.map(6), "id" : 6})
            btnlistmodel.append({"name":"Кнопка  №8", "ind":joystickDialog.joystick.map(7), "id" : 7})
            btnlistmodel.append({"name":"Кнопка  №9", "ind":joystickDialog.joystick.map(8), "id" : 8})
            btnlistmodel.append({"name":"Кнопка №10", "ind":joystickDialog.joystick.map(9), "id" : 9})
            btnlistmodel.append({"name":"Кнопка №11", "ind":joystickDialog.joystick.map(10), "id" : 10})
            btnlistmodel.append({"name":"Кнопка №12", "ind":joystickDialog.joystick.map(11), "id" : 11})
        }
    }

    Rectangle {
        id: rectangle1
        //        width: 500
        //        height: 504
        gradient: Gradient {
            GradientStop {
                id: gradientStop1
                position: 1
                color: "#a6a6a6"
            }

            GradientStop {
                position: 0
                color: "#000000"
            }
        }
        anchors.fill: parent
        opacity: 0.8
        border.width: 1
        radius: 10
        anchors.rightMargin: 0
        anchors.bottomMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        visible: true
        z: 0
        border.color: "yellow"
        Text {
            id: j_text
            text: qsTr("text")
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.margins: 10
            color: "white"
            font.bold: true
            font.pointSize: 20
        }
        Button {
            id: b_apply
            x: 363
            y: 15
            width: 100
            height: 28
            text: qsTr("Применить")
            onClicked: {
                fcommand("JOYSTICK SETTINGS")
                mainRect.focus=true;
            }
        }

        GroupBox {
            id: groupBox1
            x: 18
            y: 80
            width: 464
            height: 399
            opacity: 1

            Label {
                id: label1
                anchors.margins: 8
                anchors.top:parent.top
                anchors.left: parent.left
                width: 87
                height: 13
                color: "#ffffff"
                text: qsTr("Осей координат:")
                anchors.leftMargin: 8
                anchors.topMargin: 2

                Text {
                    id: t_axnumb
                    anchors.left: parent.right
                    anchors.top: parent.top
                    width: 129
                    height: 13
                    color: "#ffffff"
                    text: joystick.axes_number
                    scale: 1
                    font.pixelSize: 12
                }
            }

            Label {
                id: label2
                x: 156
                anchors.margins: 8
                anchors.top:parent.top
                anchors.right: parent.right
                width: 87
                height: 13
                color: "#ffffff"
                text: qsTr("Кнопок:")
                anchors.rightMargin: 197
                anchors.topMargin: 2
                Text {
                    id: t_axnumb1
                    anchors.left: parent.right
                    anchors.top: parent.top
                    width: 129
                    height: 13
                    color: "#ffffff"
                    text: joystick.buttons_number
                    scale: 1
                    font.pixelSize: 12
                }
            }

            Label {
                id: label6
                x: 0
                y: 137
                width: 62
                height: 19
                color: "#ffffff"
                text: qsTr("Ось №4'")
                font.pointSize: 10
                MySwitcher {
                    id: switcher4
                    onInvChanged: {
                        joystick.invert[joystick.x2axis_ind] = inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox4
                            onCurrentIndexChanged: {
                                joystick.x2axis_ind = comboBox4.currentIndex
                                switcher4.inv = joystick.invert[comboBox4.currentIndex]
                            }
                        }
                }
            }

            Label {
                id: label5
                x: 0
                y: 104
                width: 62
                height: 19
                color: "#ffffff"
                text: qsTr("Ось №3")
                font.pointSize: 10
                MySwitcher {
                    id: switcher3
                    onInvChanged: {
                        joystick.invert[comboBox3.currentIndex] = inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox3
                            onCurrentIndexChanged: {
                                joystick.x1axis_ind = comboBox3.currentIndex
                                switcher3.inv = joystick.invert[comboBox3.currentIndex]
                            }
                        }
                }
            }

            Label {
                id: label4
                x: 0
                y: 71
                width: 62
                height: 19
                color: "#ffffff"
                text: qsTr("Ось №2")
                font.pointSize: 10
                MySwitcher {
                    id: switcher2
                    onInvChanged: {
                        joystick.invert[comboBox2.currentIndex] = inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox2
                            onCurrentIndexChanged: {
                                joystick.y2axis_ind = comboBox2.currentIndex
                                switcher2.inv = joystick.invert[comboBox2.currentIndex]
                            }
                        }
                }
            }

            Label {
                id: label3
                x: 0
                y: 34
                width: 62
                height: 19
                color: "#ffffff"
                text: qsTr("Ось №1")
                font.pointSize: 10
                MySwitcher {
                    id: switcher1
                    onInvChanged: {
                        joystick.invert[comboBox1.currentIndex]=inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox1
                            onCurrentIndexChanged: {
                                joystick.y1axis_ind = comboBox1.currentIndex
                                switcher1.inv = joystick.invert[comboBox1.currentIndex]
                            }
                        }
                }
            }
            ListView { // список кнопок
                id: lv
                model: btnlistmodel
                spacing: 10
                x: 0
                y: 200
                width: 300
                height: 150
                z: 2
                ScrollBar.vertical: ScrollBar {
                    contentItem:
                        Rectangle {
                        implicitWidth: 10
                        implicitHeight: lv.height
                        color: "white"
                    }
                    background: Rectangle{
                        implicitWidth: 12
                        implicitHeight: lv.height+2
                        color: "gray"
                    }

                }
                delegate:
                    Row {
                    id: m
                    width: 200
                    height: 26
                    spacing: 5
                    Text {
                        id: tx
                        //anchors.left: parent.left
                        text: name
                        verticalAlignment: Text.AlignVCenter
                        color: "white"
                        width: 150
                        height: parent.height
                        font.pixelSize: height/2
                    }
                    Rectangle {
                        id: r
                        color: joystickDialog.joystick.keys[id]?"yellow":"gray"
                        height: parent.height
                        width: height
                        border.color: "white"

                        radius: height/2
                    }
                    ComboBox{
                        id: delegatecm
                        model: btnnumberlistmodel
                        currentIndex: ind
                        width: 75
                        height: parent.height
                        onCurrentIndexChanged: {
                            joystickDialog.joystick.setmap(id,delegatecm.currentIndex)
                            ind=delegatecm.currentIndex
                        }
                    }
                }
            }
//            Text {
//                x:381
//                y:2
//                text: joystickDialog.joystick.ispresent?"hats: "+joystickDialog.joystick.hats[0]:""
//                color: "white"
//            }

            Slider {
                id: sliderHorizontal1
                x: 246
                y: 33
                width: 200
                height: 22
                from: -127
                value: joystick.y1axis
                to: 127
            }

            ComboBox {
                id: comboBox1
                x: 185
                y: 31
                width: 65
                height: 25
                currentIndex: 0
                model: ListModel {
                    id: mcomboBox1
                }
                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return

                }
            }

            ComboBox {
                id: comboBox2
                x: 185
                y: 67
                width: 65
                height: 25
                model: ListModel {
                    id: mcomboBox2
                }
                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return

                }
            }

            Slider {
                id: sliderHorizontal2
                x: 244
                y: 70
                width: 200
                height: 22
                value: joystick.y2axis
                from: -127
                to: 127
            }

            ComboBox {
                id: comboBox3
                x: 185
                y: 102
                width: 65
                height: 25
                model: ListModel {
                    id: mcomboBox3
                }
                onCurrentIndexChanged: {
                    //console.log("setJx1"+currentIndex)
                    if (!joystick.ispresent) return
                    joystick.x1axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal3
                x: 246
                y: 103
                width: 200
                height: 22
                from: -127
                value: joystick.x1axis
                to: 127
            }

            ComboBox {
                id: comboBox4
                x: 185
                y: 137
                width: 65
                height: 25
                model: ListModel {
                    id: mcomboBox4
                }
                onCurrentIndexChanged: {
                    console.log("setJx2:"+currentIndex)
                    if (joystick.ispresent) return

                }
            }

            Slider {
                id: sliderHorizontal4
                x: 246
                y: 136
                width: 200
                height: 22
                from: -127
                value: joystick.x2axis
                to: 127
            }



            Label {
                id: label0
                x: -12
                y: -35
                width: 231
                height: 19
                color: "#ffffff"
                text: qsTr(joystick.name)
                font.pointSize: 12
                onTextChanged: {
                    console.log("Jchanged:"+joystick.name+" axes:"+joystick.axes_number+" ispresent:"+joystick.ispresent)
                    fillistmodel()
                    for(var ji=1; ji<=joystick.axes_number; ji++) {
                        mcomboBox1.append({text: ji})
                        mcomboBox2.append({text: ji})
                        mcomboBox3.append({text: ji})
                        mcomboBox4.append({text: ji})
                    }
                    for( ji=1; ji<=joystick.buttons_number; ji++) {
                        btnnumberlistmodel.append({text: ji})
                    }
                    comboBox1.currentIndex = joystick.y1axis_ind
                    comboBox2.currentIndex = joystick.y2axis_ind
                    comboBox3.currentIndex = joystick.x1axis_ind
                    comboBox4.currentIndex = joystick.x2axis_ind
                    setinvert()
                }
            }

            Button {
                id: b_apply1
                x: 333
                y: -44
                width: 100
                height: 28
                text: qsTr("Закрыть")
                onClicked: {
                    //joystickDialog.visible=false;
                    fcommand("JOYSTICK SETTINGS")
                    mainRect.focus=true;
                }
            }
        }
    }
}


/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
