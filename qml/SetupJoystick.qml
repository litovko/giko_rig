import QtQuick 2.12
import QtQuick.Controls 2.12

//import QmlVlc 0.1
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
        if (joystick.ispresent) {
            for (var i=0; i<joystick.buttons_number; i++)
                btnlistmodel.append({"name":joystick.names[i], "ind":joystickDialog.joystick.map(i), "id" : i, "num":i+1})
        }
    }
    onVisibleChanged: if (!visible) {

                          for(var i=0 ; i<btnlistmodel.count; i++){ // записываем  названия кнопок
                              var n = lv.model.get(i).name
                              if (n.length !== 0) {
                                  joystick.set_button_name(i,n)
                              }
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
        MyButton {
            id: b_apply
            x: 508
            y: 64
            width: 80
            height: 50
            text: qsTr("Применить")
            onClicked: {
                fcommand("JOYSTICK SETTINGS")
                mainRect.focus=true;
            }
            font.pointSize: 10
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
//                anchors.margins: 2
                anchors.top:parent.top
                anchors.left: parent.left
                width: 130
                height: 13
                color: "#ffffff"
                text: qsTr("Осей координат:")
                font.pointSize: 14
                anchors.leftMargin: 8
//                anchors.topMargin: 2

                Text {
                    id: t_axnumb
                    anchors.left: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    width: 129
                    height: 13
                    color: "#ffffff"
                    text: joystick.axes_number
                    scale: 1
                    font.pointSize: 14
                }
            }

            Label {
                id: label2
                x: 156
//                anchors.margins: 8
                anchors.top:parent.top
                anchors.right: parent.right
                width: 87
                height: 13
                color: "#ffffff"
                text: qsTr("Кнопок:")
                anchors.rightMargin: 197
                font.pointSize: 14
//                anchors.topMargin: 2
                Text {
                    id: t_axnumb1
                    anchors.left: parent.right
                    anchors.top:parent.top
                    anchors.verticalCenter: parent.verticalCenter
                    width: 129
                    height: 13
                    color: "#ffffff"
                    text: joystick.buttons_number
                    scale: 1
                    font.pointSize: 14
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
                font.pointSize: 14
                MySwitcher {
                    id: switcher4
                    onInvChanged: {
                        joystick.invert[comboBox4.currentIndex] = inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox4
                            onCurrentIndexChanged: {
                                joystick.y2axis_ind = comboBox4.currentIndex
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
                font.pointSize: 14
                MySwitcher {
                    id: switcher3
                    onInvChanged: {
                        joystick.invert[comboBox3.currentIndex] = inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox3
                            onCurrentIndexChanged: {
                                joystick.x2axis_ind = comboBox3.currentIndex
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
                font.pointSize: 14
                MySwitcher {
                    id: switcher2
                    onInvChanged: {
                        joystick.invert[comboBox2.currentIndex] = inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox2
                            onCurrentIndexChanged: {
                                joystick.y1axis_ind = comboBox2.currentIndex
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
                font.pointSize: 14
                MySwitcher {
                    id: switcher1
                    onInvChanged: {
                        joystick.invert[comboBox1.currentIndex]=inv
                        setinvert()
                    }
                    Connections {
                            target: comboBox1
                            onCurrentIndexChanged: {
                                joystick.x1axis_ind = comboBox1.currentIndex
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
                        text: num
                        color: "white"
                        height: parent.height
                        font.pixelSize: height/2
                        verticalAlignment: Text.AlignVCenter
                        width: 20
                    }

                    TextField {
                        id: tx
                        text: name
                        onTextChanged: model.name = text
                        verticalAlignment: Text.AlignVCenter
                        color: hovered?"yellow":"white"
                        width: 150
                        height: parent.height
                        font.pixelSize: height/2
                        placeholderText: qsTr("Имя кнопки")
                        background: Rectangle {
                                  anchors.fill: parent
                                  color: tx.enabled ? "gray" : "black"
                                  border.color: tx.hovered ? "white" : "transparent"
                              }
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
                        font.pointSize: 14
                    }
                }
            }
            Text {
                x:381
                y:2
                text: joystickDialog.joystick.ispresent?"hat: "+joystickDialog.joystick.hats[0]:""
                color: "white"
                font.pointSize: 14
            }

            Slider {
                id: sliderHorizontal1
                x: 246
                y: 33
                width: 200
                height: 22
                from: -127
                value: joystick.x1axis
                to: 127
            }

            ComboBox {
                id: comboBox1
                x: 185
                y: 31
                width: 65
                height: 25
                font.pointSize: 14
                currentIndex: 0
                model: ListModel {
                    id: mcomboBox1
                }
            }

            ComboBox {
                id: comboBox2
                x: 185
                y: 67
                width: 65
                height: 25
                font.pointSize: 14
                model: ListModel {
                    id: mcomboBox2
                }
            }

            Slider {
                id: sliderHorizontal2
                x: 244
                y: 70
                width: 200
                height: 22
                value: joystick.y1axis
                from: -127
                to: 127
            }

            ComboBox {
                id: comboBox3
                x: 185
                y: 102
                width: 65
                height: 25
                font.pointSize: 14
                model: ListModel {
                    id: mcomboBox3
                }
            }

            Slider {
                id: sliderHorizontal3
                x: 246
                y: 103
                width: 200
                height: 22
                from: -127
                value: joystick.x2axis
                to: 127
            }

            ComboBox {
                id: comboBox4
                x: 185
                y: 137
                width: 65
                height: 25
                font.pointSize: 14
                model: ListModel {
                    id: mcomboBox4
                }
            }

            Slider {
                id: sliderHorizontal4
                x: 246
                y: 136
                width: 200
                height: 22
                from: -127
                value: joystick.y2axis
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
                    comboBox1.currentIndex = joystick.x1axis_ind
                    comboBox2.currentIndex = joystick.y1axis_ind
                    comboBox3.currentIndex = joystick.x2axis_ind
                    comboBox4.currentIndex = joystick.y2axis_ind
                    setinvert()
                }
            }

            MyButton {
                id: b_apply1
                x: 478
                y: 31
                width: 80
                height: 50
                font.pointSize: 10
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
