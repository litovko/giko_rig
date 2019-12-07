import QtQuick 2.0

Item {
    id: dig
    property int digits: 1
    property real value: 0
    property alias maxvalue: g.maxvalue
    property alias digname: t1.text
    property alias interval: g.interval
    property alias graphtimer: g.graphtimer
    property int linewidth: 2
    property int graphtype: 2
    function line(c, x1,y1,x2,y2, color,lw) 

    {
        c.save();
        c.strokeStyle = color
        c.lineWidth = lw
        c.beginPath()
        c.lineCap="butt"
        c.moveTo(x1,y1);
        c.lineTo(x2,y2);
        c.stroke();
        c.restore();
    }
    Rectangle {
        id: r
        z:-1
        anchors.fill: parent
        color: "black"
        opacity: 0.6

    }

    MouseArea{
        anchors.fill:parent
        onClicked: {
            graphtype=graphtype===1?2:1

        }
    }

    Rectangle {
        color: "transparent"
        border.color: "transparent"
        border.width: 1
        anchors.fill: parent
        Column {
            anchors.centerIn: parent
            spacing: height/3
            Text {
                id: t1
                font.pointSize: dig.height/8
                color: "yellow"
                anchors.horizontalCenter: parent.horizontalCenter

            }
            Text {
                id:t2
                text: (value).toFixed(digits)
                font.pointSize: dig.height/8
                color: "yellow"
                anchors.horizontalCenter: parent.horizontalCenter
                Rectangle {
                    z:-1
                    anchors { centerIn: parent; margins: 0 }
                    width: dig.width-5
                    height: t2.height+2


                    color: "transparent"
                    opacity: 1
                    border.color: "yellow"

                }
            }

        }
    }
    Dinagraph{
        id: g
        z:-1
        anchors.fill: parent
        value: dig.value
        graphtype: dig.graphtype
        fill: true
        fillcolor: "gray"
        linecolor: "white"
        fillopaque: 1
    }
}
