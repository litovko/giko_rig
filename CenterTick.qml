import QtQuick 2.0


Item {
    id:ctik
    property bool x_on: false
    property bool y_on: false
    state: "00"
    function st(){
        //console.log(x_on+"  "+y_on)
        if (x_on===y_on && x_on) state="11"
        if (x_on===y_on && !x_on) state="00"
        if (x_on!=y_on && x_on) state="10"
        if (x_on!=y_on && !x_on) state="01"
    }
    onX_onChanged: st()
    onY_onChanged: st()
    states: [
        State { name: "00";
             PropertyChanges { target:xx;
                 border.color: "gray";
                 height: parent.height;
                 width: parent.width;
                 color: "transparent"
             }
             PropertyChanges { target:yy;
                 border.color: "gray";
                 height: parent.height;
                 width: parent.width;
                 color: "transparent"
             }
        },
        State { name: "11";
             PropertyChanges { target:xx;
                 border.color: "yellow";
                 height: parent.height;
                 width: parent.width/5;
                 color: "yellow"
             }
             PropertyChanges { target:yy;
                 border.color: "yellow";
                 height: parent.height/5;
                 width: parent.width;
                 color: "yellow"
             }


        },
        State { name: "01";
            PropertyChanges { target:xx;
                border.color: "gray";
                height: parent.height;
                width: parent.width;
                color: "transparent"
            }
            PropertyChanges { target:yy;
                border.color: "yellow";
                height: parent.height/5;
                width: parent.width;
                color: "yellow"
            }

        },
        State { name: "10";
            PropertyChanges { target:xx;
                border.color: "yellow";
                height: parent.height;
                width: parent.width/5;
                color: "yellow"
            }
            PropertyChanges { target:yy;
                border.color: "gray";
                height: parent.height;
                width: parent.width;
                color: "transparent"
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
            id: xx
            width: parent.width
            height: parent.height
            color: "yellow"
            anchors.horizontalCenter: parent.horizontalCenter
            radius: height
        }
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

