import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
import QtQuick.Extras 1.4
Item {
    id: g
    property string bottomText: "Мощность";
    property int minimumValue: 0
    property int maximumValue: 100
    property int val: 0;
    Column  {
        id: column
        Rectangle
        {
            id: r
            width: g.width
            height: g.height*0.9

            color: "transparent"
            Gauge {
                id: gg
                value: val
                anchors.fill: parent
                minimumValue: g.minimumValue
                maximumValue: g.maximumValue
                minorTickmarkCount:1
                style: GaugeStyle {
                    valueBar: Rectangle {
                                    color: "blue"
                                    implicitWidth: 28
                                }

                    foreground :Item {
                        implicitHeight: 5
                        implicitWidth: 10
                        Rectangle {
                            color: "yellow"
                            y: valuePosition<implicitHeight?parent.height-implicitHeight: parent.height-valuePosition
                            opacity: 0.8
                            implicitWidth: 28
                            implicitHeight: 5
                        }
                    }
                                tickmark: Item {
                                    implicitWidth: 10
                                    implicitHeight: 2

                                    Rectangle {
                                        x: control.tickmarkAlignment === Qt.AlignLeft
                                            || control.tickmarkAlignment === Qt.AlignTop ? parent.implicitWidth : -28
                                        width: 28
                                        height: parent.height
                                        color: "#ffffff"
                                    }
                                }

                                minorTickmark: Item {
                                    implicitWidth: 10
                                    implicitHeight: 1

                                    Rectangle {
                                        x: control.tickmarkAlignment === Qt.AlignLeft
                                            || control.tickmarkAlignment === Qt.AlignTop ? parent.implicitWidth : -28
                                        width: 28
                                        height: parent.height
                                        color: "#ffffff"
                                    }
                                }
                }
            }
        }
        Rectangle {
            id: tr
            width: g.width
            height: g.height*0.1
            anchors.horizontalCenter: column.horizontalCenter
            color: "transparent"
            Text {
                font.bold: true
                text: bottomText
                color: "yellow"
                font.pointSize: tr.height*0.5;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                anchors.fill: tr

            }
        }
    }

}

