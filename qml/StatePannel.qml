import QtQuick 2.11
import QtQuick.Window 2.11
//import QtQuick.Controls 2.5
import Gyco 1.0
import QmlVlc 0.1
//import QtMultimedia 5.5
import Qt.labs.settings 1.0
import QtQuick.Extras 1.4

//import QtQml 2.2

Rectangle {
    id: statePannel
    z: 3
    border.color: "yellow"
    radius: 10
    GradientStop {
        position: 0.00;
        color: "#000000";
    }
    GradientStop {
        position: 1.00;
        color: "transparent";
    }
    opacity: 0.8
    color: "black"
    //width:parent.width
    height: 40
    width: mainRect.width-height
    anchors {
        horizontalCenter: parent.horizontalCenter
        bottom: parent.bottom
        //right: parent.right
        margins: 10
    }
    
    Row {
        spacing: 10
        anchors {
            horizontalCenter: parent.horizontalCenter
            bottom: parent.bottom
            //right: parent.right
            margins: 10
        }
        Text {
            text: "НЕТ ЗАПИСИ!!! - Проверь путь!"
            font.bold: true
            style: Text.Raised
            color: "red"
            font.pointSize: 20
            visible: !onrecord
        }
        Text {
            text: "v"+Qt.application.version+" Тип аппарата:" + "МГМ-7"
            color: "lightblue"
            font.pointSize: 12
        }
        Text {
            text: "Вид:"+mainRect.state.toString()
            color: "lightblue"
            font.pointSize: 12
        }
        
        Text {
            id: t1
            color: "yellow"
            font.pointSize: 12
            visible: cams[0].cameraenabled
            //anchors.centerIn: parent
            text: "Статус видео 1: "+statename(vlcPlayer1.state)
        }
        Text {
            id: t2
            color: "yellow"
            font.pointSize: 12
            visible: cams[1].cameraenabled
            //anchors.centerIn: parent
            text: "Статус видео 2: "+statename(vlcPlayer2.state)
        }
        Text {
            id: t3
            color: "yellow"
            font.pointSize: 12
            visible: cams[2].cameraenabled
            //anchors.centerIn: parent
            text: "Статус видео 3: "+statename(vlcPlayer3.state)
        }
        Text {
            id: t4
            color: "yellow"
            font.pointSize: 12
            visible: cams[3].cameraenabled
            //anchors.centerIn: parent
            text: "Статус видео 4: "+statename(vlcPlayer4.state)
        }
    }
}
