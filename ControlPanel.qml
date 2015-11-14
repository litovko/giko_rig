import QtQuick 2.5
import QtQuick.Extras 1.4
import QtQuick.Controls 1.4

import QtQuick.Controls.Styles 1.4
import Gyco 1.0

//Содержит переключатели и лампочки
Item {
    id: controlPanel
    property RigModel source
    property int lampSize:100
    property int fontSize:15

    Rectangle {
        height: parent.height
        width: parent.width
        color: "transparent"
        border.color: "yellow"
        radius: 10
        gradient: Gradient {
            GradientStop {
                position: 0.00;
                color: "#000000";
            }
            GradientStop {
                position: 1.00;
                color: "transparent";
            }
        }
        Rectangle {
            anchors { fill: parent; margins: 10}
            color: "transparent"
            border.color: "white"
            radius: 7
            Row{
                id: row
                spacing: 20
                width: parent.width
                anchors.topMargin: 10
                Component.onCompleted: {
                        for (var item in children) {
                            children[item].anchors.verticalCenter = row.verticalCenter;
                        }
                    }

                MyLamp{
                    id: lamp
                    height: lampSize
                    width: lampSize
                    bottomText:"СВЕТ[F2]"
                    active: source.lamp

                }
                MyLamp{
                    id: pump
                    height: lampSize
                    width: lampSize
                    bottomText:"КАМЕРЫ[F3]"
                    active:source.camera
                }
                MyLamp{
                    id: engine
                    height: lampSize
                    width: lampSize
                    bottomText:"НАСОС[F4]"
                    active:source.engine
                }
                MyLamp{
                    id: connect
                    height: lampSize
                    width: lampSize
                    bottomText:"СВЯЗЬ"
                    active:source.client_connected
                }
                MyLamp{
                    id: data
                    height: lampSize
                    width: lampSize
                    bottomText:"ДАННЫЕ"
                    active:source.good_data
                }
                MyLamp{
                    id: voltage
                    height: lampSize
                    width: lampSize
                    bottomText:"ПИТАНИЕ"
                    active:source.voltage
                }


//                MyGauge {
//                    height: 200
//                    width: 40
//                    bottomText: "Мощн.%"
//                    val: source.joystick

//                }


            }

        }

    }
}

