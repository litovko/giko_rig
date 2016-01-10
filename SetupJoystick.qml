import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import QmlVlc 0.1
import Gyco 1.0
Item {
    id: joystickDialog
    visible: true
    property RigJoystick joystick:null

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

        Button {
            id: b_apply
            x: 363
            y: 15
            text: qsTr("Применить")
        }

        GroupBox {
            id: groupBox1
            x: 18
            y: 97
            width: 464
            height: 300
            checked: true
            opacity: 1

            Label {
                id: label1
                x: 8
                y: 34
                width: 87
                height: 13
                color: "#ffffff"
                text: qsTr("Осей координат:")

                Text {
                    id: t_axnumb
                    x: 96
                    y: 0
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
                x: 8
                y: 58
                width: 87
                height: 13
                color: "#ffffff"
                text: qsTr("Кнопок:")
                Text {
                    id: t_axnumb1
                    x: 96
                    y: 0
                    width: 129
                    height: 13
                    color: "#ffffff"
                    text: joystick.buttons_number
                    scale: 1
                    font.pixelSize: 12
                }
            }

            Slider {
                id: sliderHorizontal1
                x: 244
                y: 91
                width: 200
                height: 22
                minimumValue: -127
                value: joystick.y1axis
                maximumValue: 127
            }

            ComboBox {
                id: comboBox1
                x: 185
                y: 92
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox1
                }
                onCurrentIndexChanged: {
                    console.log("setJy1"+currentIndex)
                    if (joystick.ispresent) joystick.y1axis_ind=currentIndex
                }
            }

            ComboBox {
                id: comboBox2
                x: 185
                y: 128
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox2
                }
                onCurrentIndexChanged: {
                    console.log("setJy2"+currentIndex)
                    if (joystick.ispresent)joystick.y2axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal2
                x: 244
                y: 127
                width: 200
                height: 22
                value: joystick.y2axis
                minimumValue: -127
                maximumValue: 127
            }

            ComboBox {
                id: comboBox3
                x: 185
                y: 161
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox3
                }
                onCurrentIndexChanged: {
                    console.log("setJx1"+currentIndex)
                    if (joystick.ispresent) joystick.x1axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal3
                x: 244
                y: 160
                width: 200
                height: 22
                minimumValue: -127
                value: joystick.x1axis
                maximumValue: 127
            }

            ComboBox {
                id: comboBox4
                x: 185
                y: 195
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox4
                }
                onCurrentIndexChanged: {
                    console.log("setJx2"+currentIndex)
                    if (joystick.ispresent) joystick.x2axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal4
                x: 244
                y: 194
                width: 200
                height: 22
                minimumValue: -127
                value: joystick.x2axis
                maximumValue: 127
            }

            ComboBox {
                id: comboBox5
                x: 185
                y: 230
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox5
                }
                onCurrentIndexChanged: {
                    console.log("setJb1" +currentIndex)
                    if (joystick.ispresent) joystick.key_0_ind=currentIndex
                }
            }

            RadioButton {
                id: radioButton1
                x: 258
                y: 232
                text: qsTr("")
                scale: 1.7
                clip: false
                checked: joystick.key_0
            }

            ComboBox {
                id: comboBox6
                x: 185
                y: 261
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox6
                }
                onCurrentIndexChanged: {
                    console.log("setJb2" +currentIndex)
                    if (joystick.ispresent) joystick.key_1_ind=currentIndex
                }
            }

            RadioButton {
                id: radioButton2
                x: 258
                y: 263
                text: qsTr("")
                clip: false
                scale: 1.7
                checked: joystick.key_1
            }
        }

        Label {
            id: label0
            x: 23
            y: 72
            width: 231
            height: 19
            color: "#ffffff"
            text: qsTr(joystick.name)
            font.pointSize: 12
            onTextChanged: {
                console.log("J:changed"+joystick.name+"axes:"+joystick.axes_number+"ispresent:"+joystick.ispresent)
                for(var i=0; i<joystick.axes_number; i++) {
                    mcomboBox1.append({text: i})
                    mcomboBox2.append({text: i})
                    mcomboBox3.append({text: i})
                    mcomboBox4.append({text: i})
                    //console.log("J:"+i)
                }
                for(var i=0; i<joystick.buttons_number; i++) {
                    mcomboBox5.append({text: i})
                    mcomboBox6.append({text: i})

                    console.log("Jbutton:"+i)
                }
                comboBox1.currentIndex=joystick.y1axis_ind
                comboBox2.currentIndex=joystick.y2axis_ind
                comboBox3.currentIndex=joystick.x1axis_ind
                comboBox4.currentIndex=joystick.x2axis_ind
                comboBox5.currentIndex=joystick.key_0_ind
                comboBox6.currentIndex=joystick.key_1_ind
            }
        }

        Button {
            id: b_apply1
            x: 363
            y: 49
            text: qsTr("Закрыть")
        }

        Label {
            id: label3
            x: 34
            y: 195
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Номер оси для 'Мощности 1'")
            font.pointSize: 10
        }

        Label {
            id: label4
            x: 34
            y: 232
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Номер оси для 'Мощности 2'")
            font.pointSize: 10
        }

        Label {
            id: label5
            x: 34
            y: 265
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Номер оси x1'")
            font.pointSize: 10
        }

        Label {
            id: label6
            x: 34
            y: 298
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Номер оси x2'")
            font.pointSize: 10
        }

        Label {
            id: label7
            x: 34
            y: 333
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Номер кнопки 1'")
            font.pointSize: 10
        }

        Label {
            id: label8
            x: 34
            y: 366
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Номер кнопки 2'")
            font.pointSize: 10
        }
        
    }

    
}
