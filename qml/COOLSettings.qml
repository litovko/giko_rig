import QtQuick 2.12
import QtQuick.Controls 2.12
//import QtQuick.Window 2.0
//import QtQuick.Controls.Styles 1.4
import Qt.labs.settings 1.0
Item {
    id: coolSettings
    property alias auto: checkBox1.checked
    property alias t_on: comboBox2.currentIndex
    property alias t_off: comboBox3.currentIndex
    property alias text_on: comboBox2.currentText
    property alias text_off: comboBox3.currentText
    Settings{
        category: "cool_settings"
        property alias auto: checkBox1.checked
        property alias t_on: comboBox2.currentIndex
        property alias t_off: comboBox3.currentIndex
    }
    Rectangle {
        id: rec
        anchors.fill: parent
        border.color: "yellow"
        color: "transparent"
        radius: 10
        clip: true

        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "black";
            }

            GradientStop {
                position: 1.00;
                color: "gray";
            }
        }
        opacity: 0.8
        Text {
            id: t
            text: qsTr("[X]")
            font.bold:  true
            font.pointSize: ma.containsMouse?10:8
            color: ma.containsMouse?"yellow":"white"
            anchors { margins: 5;  top: rec.top; left: rec.left}
            MouseArea {
                id:ma
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {coolSettings.visible=false; coolSettings.height=0}
            }
        }
        Column {
            id: clmn
            anchors.fill: parent
            anchors.margins: 20
            spacing: 30

            Label {
                id: label1
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("Автомат")
                font.pointSize: 10
                anchors.left: parent.left
                CheckBox {
                    id: checkBox1
                    y: -12
                    anchors.bottomMargin: -12
                    anchors.leftMargin: -10
                    anchors {left: parent.right; bottom: parent.bottom}
                    indicator.height: 20
                    indicator.width: 20
                }
            }
            Label {
                id: label2
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("t° вкл.")
                font.pointSize: 10
                anchors.left: parent.left
                ComboBox {
                    id: comboBox2
                    y: -12
                    width: 68
                    height: 40
                    anchors.bottomMargin: -12
                    anchors.leftMargin: -20
                    anchors {left: parent.right; bottom: parent.bottom}
                    model: [ 20, 30, 40, 50, 60, 70, 80, 90]
                }
            }
            Label {
                id: label3
                width: 78
                height: 16
                color: "#ffffff"
                text: qsTr("t° откл.")
                font.pointSize: 10
                anchors.left: parent.left
                ComboBox {
                    id: comboBox3
                    y: -12
                    width: 68
                    height: 40
                    anchors.bottomMargin: -12
                    anchors.leftMargin: -20
                    anchors {left: parent.right; bottom: parent.bottom}
                    model: [ 20, 30, 40, 50, 60]
                }
            }

        }


    }
    Behavior on height {
                NumberAnimation {
                    duration: 500
                    easing.type: Easing.OutQuart;
                    easing.amplitude: 0
                    easing.period: 0
                }
            }
}

/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
