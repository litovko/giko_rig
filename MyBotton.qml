import QtQuick 2.5
import QtQuick.Controls.Styles 1.4
import QtQuick.Controls 1.4
Item {
    id: mb
    property string textOn: "Off";
    property string textOff: "On";
    property string bottomText: "СВЕТ";
    property bool checked: false;

    Column  {
        id: column
        Rectangle
        {
            id: r
            width: mb.width
            height: mb.height/2
            focus:true

            color: "transparent"
            Button {
                id: btn
                onCheckedChanged: {mb.checked=btn.checked}
                checkable: true
                anchors.fill: parent
                style: ButtonStyle {
                    background: Rectangle {
                        implicitWidth: r.width
                        implicitHeight: r.height
                        border.width: btn.pressed ? 3 : 1
                        border.color: btn.pressed ? "white" : "black"
                        radius: r.height*0.25
                        opacity: 0.8
                    }
                    label: Rectangle {
                        implicitWidth: r.width*0.8
                        implicitHeight: r.height*0.8
                        radius:r.height*0.20
                        opacity: btn.pressed? 0.6:0.8;
                        color: btn.checked ? "yellow":"blue"
                        border.color: "white"
                        border.width: btn.pressed ? 0 : 1
                        Text {text: btn.checked ? mb.textOn :mb.textOff;

                            font.pointSize: r.height*0.4;
                            color: btn.checked ? "black":"white";
                            horizontalAlignment: Text.AlignHCenter;
                            verticalAlignment: Text.AlignVCenter;
                            anchors.centerIn: parent
                        }
                    }
                }
            }
        }
        Rectangle {
            id: tr
            width: mb.width
            height: mb.height/2
            anchors.horizontalCenter: column.horizontalCenter
            color: "transparent"
            Text {
                font.bold: true
                text: bottomText
                color: btn.checked ? "yellow":"blue";
                font.pointSize: r.height*0.5;
                horizontalAlignment: Text.AlignHCenter;
                verticalAlignment: Text.AlignVCenter;
                anchors.fill: tr

            }
        }
    }

}

