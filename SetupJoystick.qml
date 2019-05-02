import QtQuick 2.12
import QtQuick.Controls 2.4
//import QtQuick.Window 2.0
//import QtQuick.Controls.Styles 1.4
//import QtQuick.Dialogs 1.2
import QmlVlc 0.1
import Gyco 1.0
Item {
    id: joystickDialog
    visible: true
    property RigJoystick joystick:null
    states: [
        State {
            name: "Dialog"
            PropertyChanges { target: rectangle1;  visible: true;}
            PropertyChanges { target: message;  visible: false;}

//            PropertyChanges {
//                target: radioButton1
//                width: 15
//                height: 15
//                padding: 0
//                focusPolicy: Qt.NoFocus
//                autoExclusive: true
//                display: AbstractButton.IconOnly
//
//
//            }

            PropertyChanges {
                target: comboBox1
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox2
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox3
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox4
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox5
                x: 185
                y: 207
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox6
                x: 185
                y: 238
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox7
                x: 185
                y: 271
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox8
                x: 177
                y: 267
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox9
                x: 185
                y: 338
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: comboBox10
                x: 185
                y: 371
                width: 55
                height: 25
                rightPadding: 0
            }

            PropertyChanges {
                target: groupBox1
                width: 464
                height: 416
            }

            PropertyChanges {
                target: label11
                x: 38
                y: 434
            }

        },
        State {
            name: "Message"
            PropertyChanges { target: rectangle1;  visible: false;}
            PropertyChanges { target: message; width: 560; height: 62; radius: 10; anchors.verticalCenterOffset: 0; anchors.horizontalCenterOffset: 0;  visible: true;}

            PropertyChanges {
                target: gradientStop1
                color: "#ffffff"
            }

            PropertyChanges {
                target: button1
                anchors.bottomMargin: 7
            }
        }
    ]
    Component.onCompleted: state= "Dialog"
    Rectangle {
        id: rectangle1
        width: 500
        height: 504
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
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.top: parent.top
        anchors.topMargin: 0
        opacity: 0.8
        border.width: 3
        radius: 10
        visible: true
        z: 0
        border.color: "yellow"

        Button {
            id: b_apply
            x: 363
            y: 15
            width: 100
            height: 28
            text: qsTr("Применить")
            onClicked: {
                joystickDialog.visible=false;
                mainRect.focus=true;
            }
        }

        GroupBox {
            id: groupBox1
            x: 18
            y: 80
            width: 464
            height: 399
            //checked: true
            opacity: 1

            Label {
                id: label1
                x: 8
                y: 8
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
                y: 37
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

                Label {
                    id: label8
                    x: 0
                    y: 205
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Кнопка выбора группы упр.")
                    font.pointSize: 10
                }

                Label {
                    id: label7
                    x: 0
                    y: 172
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Кнопка разблокировки")
                    font.pointSize: 10
                }

                Label {
                    id: label6
                    x: 0
                    y: 137
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Номер оси x2'")
                    font.pointSize: 10
                }

                Label {
                    id: label5
                    x: 0
                    y: 104
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Номер оси x1'")
                    font.pointSize: 10
                }

                Label {
                    id: label4
                    x: 0
                    y: 71
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Номер оси для 'Мощности 2'")
                    font.pointSize: 10
                }

                Label {
                    id: label3
                    x: 0
                    y: 34
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Номер оси для 'Мощности 1'")
                    font.pointSize: 10
                }

                Label {
                    id: label9
                    x: 1
                    y: 236
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Кнопка запуска трансляции")
                    font.pointSize: 10
                }

                Label {
                    id: label10
                    x: 0
                    y: 269
                    width: 172
                    height: 19
                    color: "#ffffff"
                    text: qsTr("Выбор  раскладки экрана")
                    visible: true
                    font.pointSize: 10
                }

                ComboBox {
                    id: comboBox8
                    x: 177
                    y: 269
                    width: 51
                    height: 20
                    visible: true
                    model: ListModel {
                        id: mcomboBox8
                    }
                    onCurrentIndexChanged: {
                        if (!joystick.ispresent) return;
                        if (comboBox5.currentIndex===currentIndex ||
                            comboBox6.currentIndex===currentIndex||
                            comboBox7.currentIndex===currentIndex||
                            comboBox9.currentIndex===currentIndex||
                            comboBox10.currentIndex===currentIndex)
                        {joystickDialog.state="Message"; currentIndex=joystick.key_3_ind; return;}
                        joystick.key_3_ind=currentIndex
                    }
                }

                RadioButton {
                    id: radioButton4
                    x: 250
                    y: 270
                    width: 15
                    height: 15
                    text: qsTr("")
                    visible: true
                    checked: joystick.key_3
                    scale: 1
                    clip: false
//
//
                }





            }

            Slider {
                id: sliderHorizontal1
                x: 244
                y: 69
                width: 200
                height: 22
                from: -127
                value: joystick.y1axis
                to: 127
            }

            ComboBox {
                id: comboBox1
                x: 185
                y: 70
                width: 55
                height: 25
                currentIndex: 0
                model: ListModel {
                    id: mcomboBox1
                }
                onCurrentIndexChanged: {
                    //                    console.log("setJy1"+currentIndex)
                    if (joystick.ispresent) joystick.y1axis_ind=currentIndex
                }
            }

            ComboBox {
                id: comboBox2
                x: 185
                y: 107
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox2
                }
                onCurrentIndexChanged: {
                    //                    console.log("setJy2"+currentIndex)
                    if (joystick.ispresent)joystick.y2axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal2
                x: 244
                y: 106
                width: 200
                height: 22
                value: joystick.y2axis
                from: -127
                to: 127
            }

            ComboBox {
                id: comboBox3
                x: 185
                y: 140
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox3
                }
                onCurrentIndexChanged: {
                    //console.log("setJx1"+currentIndex)
                    if (joystick.ispresent) joystick.x1axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal3
                x: 244
                y: 139
                width: 200
                height: 22
                from: -127
                value: joystick.x1axis
                to: 127
            }

            ComboBox {
                id: comboBox4
                x: 185
                y: 174
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox4
                }
                onCurrentIndexChanged: {
                    //console.log("setJx2"+currentIndex)
                    if (joystick.ispresent) joystick.x2axis_ind=currentIndex
                }
            }

            Slider {
                id: sliderHorizontal4
                x: 244
                y: 173
                width: 200
                height: 22
                from: -127
                value: joystick.x2axis
                to: 127
            }

            ComboBox {
                id: comboBox5
                x: 185
                y: 209
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox5
                }

                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return;
                    if (comboBox6.currentIndex===currentIndex ||
                        comboBox7.currentIndex===currentIndex||
                        comboBox8.currentIndex===currentIndex||
                        comboBox9.currentIndex===currentIndex||
                        comboBox10.currentIndex===currentIndex)
                    {joystickDialog.state="Message"; currentIndex=joystick.key_0_ind; return;}
                    joystick.key_0_ind=currentIndex
                }
            }

            RadioButton {
                id: radioButton1
                x: 258
                y: 211
                width: 15
                height: 15
                text: qsTr("")
                scale: 1
                clip: false
                checked: joystick.key_0


            }

            ComboBox {
                id: comboBox6
                x: 185
                y: 240
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox6
                }

                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return;
                    if (comboBox5.currentIndex===currentIndex ||
                        comboBox7.currentIndex===currentIndex||
                        comboBox8.currentIndex===currentIndex||
                        comboBox9.currentIndex===currentIndex||
                        comboBox10.currentIndex===currentIndex)
                    {joystickDialog.state="Message"; currentIndex=joystick.key_1_ind; return;}
                    joystick.key_1_ind=currentIndex
                }

            }

            RadioButton {
                id: radioButton2
                x: 258
                y: 242
                width: 15
                height: 15
                text: qsTr("")
                clip: false
                scale: 1
                checked: joystick.key_1


            }

            ComboBox {
                id: comboBox7
                x: 185
                y: 273
                width: 51
                height: 20
                model: ListModel {
                    id: mcomboBox7
                }

                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return;
                    if (comboBox5.currentIndex===currentIndex ||
                        comboBox6.currentIndex===currentIndex||
                        comboBox8.currentIndex===currentIndex||
                        comboBox9.currentIndex===currentIndex||
                        comboBox10.currentIndex===currentIndex)
                    {joystickDialog.state="Message"; currentIndex=joystick.key_2_ind; return;}
                    joystick.key_2_ind=currentIndex
                }
            }

            RadioButton {
                id: radioButton3
                x: 258
                y: 275
                width: 15
                height: 15
                text: qsTr("")
                checked: joystick.key_2
                scale: 1
                clip: false


            }
            ComboBox {
                id: comboBox9
                x: 185
                y: 340
                width: 51
                height: 20
                visible: true
                model: ListModel {
                    id: mcomboBox9
                }
                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return;
                    if (comboBox5.currentIndex===currentIndex ||
                        comboBox6.currentIndex===currentIndex||
                        comboBox7.currentIndex===currentIndex||
                        comboBox8.currentIndex===currentIndex||
                        comboBox10.currentIndex===currentIndex)
                    {joystickDialog.state="Message"; currentIndex=joystick.key_4_ind; return;}
                    joystick.key_4_ind=currentIndex
                }
            }

            RadioButton {
                id: radioButton5
                x: 258
                y: 341
                width: 15
                height: 15
                text: qsTr("")
                visible: true
                checked: joystick.key_4
                scale: 1
                clip: false


            }

            ComboBox {
                id: comboBox10
                x: 185
                y: 373
                width: 51
                height: 20
                visible: true
                model: ListModel {
                    id: mcomboBox10
                }
                onCurrentIndexChanged: {
                    if (!joystick.ispresent) return;
                    if (comboBox5.currentIndex===currentIndex ||
                        comboBox6.currentIndex===currentIndex||
                        comboBox7.currentIndex===currentIndex||
                        comboBox8.currentIndex===currentIndex||
                        comboBox9.currentIndex===currentIndex)
                    {joystickDialog.state="Message"; currentIndex=joystick.key_5_ind; return;}
                    joystick.key_5_ind=currentIndex
                }
            }

            RadioButton {
                id: radioButton6
                x: 258
                y: 374
                width: 15
                height: 15
                text: qsTr("")
                checked: joystick.key_5
                visible: true
                clip: false
                scale: 1


            }

            Label {
                id: label12
                x: 8
                y: 374
                width: 172
                height: 19
                color: "#ffffff"
                text: qsTr("Выбор кнопки замедления")
                visible: true
                font.pointSize: 10
            }
        }

        Label {
            id: label0
            x: 24
            y: 55
            width: 231
            height: 19
            color: "#ffffff"
            text: qsTr(joystick.name)
            font.pointSize: 12
            onTextChanged: {
                console.log("Jchanged:"+joystick.name+" axes:"+joystick.axes_number+" ispresent:"+joystick.ispresent)
                for(var ji=1; ji<=joystick.axes_number; ji++) {
                    mcomboBox1.append({text: ji})
                    mcomboBox2.append({text: ji})
                    mcomboBox3.append({text: ji})
                    mcomboBox4.append({text: ji})
                    //console.log("Jax:"+ji)
                }
                for( ji=1; ji<=joystick.buttons_number; ji++) {
                    mcomboBox5.append({text: ji})
                    mcomboBox6.append({text: ji})
                    mcomboBox7.append({text: ji})
                    mcomboBox8.append({text: ji})
                    mcomboBox9.append({text: ji})
                    mcomboBox10.append({text: ji})
                    //console.log("Jbutton:"+ji)
                }
                comboBox1.currentIndex=joystick.y1axis_ind
                comboBox2.currentIndex=joystick.y2axis_ind
                comboBox3.currentIndex=joystick.x1axis_ind
                comboBox4.currentIndex=joystick.x2axis_ind
                comboBox5.currentIndex=joystick.key_0_ind
                comboBox6.currentIndex=joystick.key_1_ind
                comboBox7.currentIndex=joystick.key_2_ind
                comboBox8.currentIndex=joystick.key_3_ind
                comboBox9.currentIndex=joystick.key_4_ind
                comboBox10.currentIndex=joystick.key_5_ind
            }
        }

        Button {
            id: b_apply1
            x: 363
            y: 49
            width: 100
            height: 28
            text: qsTr("Закрыть")
            onClicked: {
                joystickDialog.visible=false;
                mainRect.focus=true;
            }
        }

        Label {
            id: label11
            x: 33
            y: 442
            width: 172
            height: 19
            color: "#ffffff"
            text: qsTr("Выбор кнопки защелки")
            visible: true
            font.pointSize: 10
        }

    }

    Rectangle {
        id: message
        height: 50
        width: 550
        color: "#090808"
        border.width: 2
        border.color: "yellow"
        visible: false
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#090808";
            }
            GradientStop {
                position: 1.00;
                color: "#d8d8f5";
            }
        }
        anchors.centerIn: parent
        Button {
            id: button1
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            text: "OK"
            Text {
                color: "#b4aaf5"
                text: "Этот номер уже назначен, выберите другое значение"
                font.bold: true
                font.pointSize: 14
                anchors.bottom: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
            }
            onClicked: joystickDialog.state="Dialog"
        }

    }

}











/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
