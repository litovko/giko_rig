import QtQuick 2.0


Item {
    id:ctik
    property string text: "Center Y"
    property string color_on: "yellow"
    property string color_off: "gray"
    property string color_off_green: "green"
    state: "OFF"

    states: [
        State { name: "OFF";
             PropertyChanges { target:yy;
                 border.color: "gray";
                 height: parent.height;
                 width: parent.width;
                 color: "transparent"
             }
        },
        State { name: "OFF-GREEN";
             PropertyChanges { target:yy;
                 border.color: "gray";
                 height: parent.height/5;
                 width: parent.width;
                 color: color_off_green
             }
        },


                State { name: "ON";
                    PropertyChanges { target:yy;
                        border.color: "yellow";
                        height: parent.height/5;
                        width: parent.width;
                        color: "yellow"
                    }
                }

    ]


        transitions: Transition {

                ColorAnimation { duration: 250 }

                NumberAnimation {
                    duration: 250
                    properties: "width,height";
                    easing.type: Easing.InOutQuad
                }

            }
    Rectangle {
        id: holder
        anchors.fill: parent
        color: "transparent"
        border.color: "gray"
        border.width: 1
        radius: width/2

        Rectangle {
            id: yy
            height: parent.height/10
            width:  parent.height
            color: "red"
            radius: width
            anchors.verticalCenter: parent.verticalCenter
        }
    }

}

