import QtQuick 2.0

Item {
    property int xvalue: 0
    property int yvalue: 0
    property alias backgroundopacity: r.opacity
    Rectangle {
        id: r
        anchors.fill: parent
        color: "black"
        opacity: 0.6

    }
    onXvalueChanged: {
        //console.log(xvalue)
        if (xvalue&1) l1.state="ON"; else l1.state="OFF"
        if (xvalue&2) l2.state="ON"; else l2.state="OFF"
        if (xvalue&4) l3.state="ON"; else l3.state="OFF"
        if (xvalue&8) r1.state="ON"; else r1.state="OFF"
        if (xvalue&16) r2.state="ON"; else r2.state="OFF"
        if (xvalue&32) r3.state="ON"; else r3.state="OFF"
        if (xvalue&64) c.state="ON"; else c.state="OFF"
    }
    onYvalueChanged: {
        if (xvalue&1) y1.state="ON"; else y1.state="OFF"
        if (xvalue&2) y2.state="ON"; else y2.state="OFF"
        if (xvalue&4) y3.state="ON"; else y3.state="OFF"
        if (xvalue&8) y4.state="ON"; else y4.state="OFF"
        if (xvalue&16) y5.state="ON"; else y5.state="OFF"
        if (xvalue&32) y6.state="ON"; else y6.state="OFF"
        if (xvalue&64) y7.state="ON"; else y7.state="OFF"
    }
    Component.onCompleted: {
        l1.state="OFF"
        l2.state="OFF"
        l3.state="OFF"
        r1.state="OFF"
        r2.state="OFF"
        r3.state="OFF"
        y1.state="OFF"
        y2.state="OFF"
        y3.state="OFF"
        y4.state="OFF"
        y5.state="OFF"
        y6.state="OFF"
        y7.state="OFF"
        c.state="OFF"

    }

    Rectangle {
        color: "transparent"
        border.color: "transparent"

        anchors.fill: parent
        Column { //x axis
            anchors.centerIn: parent
            spacing: 25
            Tik {
                id: y1
                text:"-50"
                width: 20
                height: 10

            }
            Tik {
                id: c
                text:"0"
                width: 20
                height: 12
                Row {
                    anchors.right: c.left
                    anchors.top:  c.top
                    anchors.margins: 20
                    spacing: 15
                    Tik {
                        id: l1
                        text:"1"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }
                    Tik {
                        id: l2
                        text:"2"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }
                    Tik {
                        id: l3
                        text:"3"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }

                }
                Row {
                    anchors.left: c.right
                    anchors.top:  c.top
                    anchors.margins: 20
                    spacing: 15
                    Tik {
                        id: r1
                        text:"1"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }
                    Tik {
                        id: r2
                        text:"2"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }
                    Tik {
                        id: r3
                        text:"3"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }

                }
            }
            Tik {
                id: y2
                text:"50"
                width: 20
                height: 10

            }
            Tik {
                id: y3
                text:"100"
                width: 20
                height: 10

            }
            Tik {
                id: y4
                text:"200"
                width: 20
                height: 10

            }
            Tik {
                id: y5
                text:"400"
                width: 20
                height: 10

            }
            Tik {
                id: y6
                text:"600"
                width: 20
                height: 10

            }
            Tik {
                id: y7
                text:"1000"
                width: 20
                height: 10

            }

        }

    }
}
