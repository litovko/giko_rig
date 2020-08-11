import QtQuick 2.0

Item {
    id: coord
    property int xvalue: 0
    property int yvalue: 0
    property int y_axes: 0
    property int position: 0
    property alias backgroundopacity: r.opacity
    property var prev: []
    signal xswitched
    Rectangle {
        id: r
        anchors.fill: parent
        color: "black"
        opacity: 0.6

    }
    //onXvalueChanged: xval()
    //onYvalueChanged: yval()
    onY_axesChanged: yax();
    function  yax() {
        if (y_axes>0 ) state="UP"
        if (y_axes<0 ) state="DOWN"
        //console.log(state)
    }

    function xval() {
        console.log(xvalue)
        if (xvalue&1) {l1.state="ON"; xswitched()} else l1.state="OFF"
        if (xvalue&2) {l2.state="ON"; xswitched()} else l2.state="OFF"
        if (xvalue&4) {l3.state="ON"; xswitched()} else l3.state="OFF"
        if (xvalue&8) {r1.state="ON"; xswitched()} else r1.state="OFF"
        if (xvalue&16) {r2.state="ON"; xswitched()} else r2.state="OFF"
        if (xvalue&32) {r3.state="ON"; xswitched()} else r3.state="OFF"
        if (xvalue&128) {cx.x_on=true; xswitched()} else cx.x_on=false
    }
    function _pr() {
        var s="|"
        for (var i = 0; i < prev.length; i++)
        {
            s=s+prev[i].text+"|"
        }
        console.log(s);
    }

    function change_y(y,v) {
        //console.log("0:");
        //_pr();
        //console.log("T:"+y.text+" st:"+y.state+" val:"+v)
        if (v&&y.state==="ON") return;
        if (v) { y.state="ON";
            for (var i = 0; i < prev.length; i++)
                if (prev[i]===y) prev.splice(i,1);
            //console.log("1:"); _pr();
            return;}
        if (y.state==="ON") {
            y.state="OFF-GREEN";
            prev.push(y,y,y);
            //console.log("2:"); _pr();
            return;
        }
        if (y.state==="OFF-GREEN") {
            if (prev.indexOf(y)>=0) {
                prev.splice(prev.indexOf(y),1);
                //console.log("3:");
                //_pr()
            }
            else  y.state="OFF"; return;
        }
    }
    function yval() {
        change_y(y1,yvalue&1)
        change_y(y2,yvalue&2)
        change_y(y3,yvalue&4)
        change_y(y4,yvalue&8)
        change_y(y5,yvalue&16)
        change_y(y6,yvalue&32)
        change_y(y7,yvalue&64)
        change_y(c,yvalue&128)
        //_pr()
    }

    onPositionChanged: {
        if (xvalue!=position&255) { xvalue=position&255; xval()}
        if (yvalue!=position>>8)  { yvalue=position>>8; yval()}

    }
    Arrow {
        anchors.fill: parent
        state: coord.state
    }

    states: [
        State {
            name: "UP"
            PropertyChanges {
                target: direction
                text: "ВВЕРХ"
            }
        },
        State {
            name: "DOWN"
            PropertyChanges {
                target: direction
                text: "ВНИЗ"
            }
        }
    ]

    Rectangle {
        color: "transparent"
        border.color: "transparent"

        anchors.fill: parent
        Text {
            id: direction
            text: qsTr("<>")
            color: "yellow"
            anchors.margins: 10
            anchors.top: parent.verticalCenter
            anchors.right: parent.right
        }
        Column { //x axis
            id: col
            anchors.centerIn: parent
            spacing: 25
            Tik {
                id: y1
                text:"-50"
                width: 20
                height: 10

            }
            CenterTik_Y {
                id: c
                width: 20
                height:20
                CenterTick {
                    id:cx
                    anchors.fill: parent
                }


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
                        onStateChanged: if (l1.state==="ON") coord.xswitched()

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
                        text:"4"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }
                    Tik {
                        id: r2
                        text:"5"
                        width: 20
                        height: 10
                        transform: Rotation {  angle: -90}
                        textrotate: 90

                    }
                    Tik {
                        id: r3
                        text:"6"
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
