import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.0
import QtQuick.Controls.Styles 1.4
import QtQuick.Dialogs 1.2
import Gyco 1.0
Item {
    id: help
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
        Text{
            color: "#fffb03"
            anchors.margins: 10
            anchors.fill: parent
            text: 'КРАТКАЯ СПРАВКА\n'+
                  '[F1]   или [1] - Подсказка - данное окно\n'+
                  '[F2]   или [2] - Включить прожекторы\n'+
                  '[F3]   или [3] - Включить видеокамеры\n'+
                  '[F4]   или [4] - Включить двигатель насоса\n'+
                  '[F5]   или [5] - Запуск трансляции видео\n'+
                  '[F6]   или [6] - Остановка трансляции видео\n'+
                  '[F8]   или [8] - Переключение типа аппарата\n'+
                  '[F9]   или [9] - Окно настроек джойстика\n'+
                  '[F10] или [0] - Окно настроек камеры\n'+
                  '[F11] или [_] - Окно настроек программы\n'+
                  '[F12] или [=] - Полноэкранный режим\n'+
                  ' \n'+
                  '"Правая кнопка мышы" - Меню\n'
            font.bold: true
            font.pointSize: 15
            styleColor: "#fbf702"
        }

    }
}
