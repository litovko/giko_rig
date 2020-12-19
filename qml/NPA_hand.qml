import QtQuick 2.5
import QtGraphicalEffects 1.0
import "./figure.js" as Fig

Item {
    id: hand
    property alias gmod: gm.text
    property real a1: 20
    property real a2: -80
    property real a3: 120
    property real a4: -60
    property real a5: 20
    property real l1: 50
    property real l2: 80
    property real l3: 80
    property real l4: 80
    property real l5: 40
    readonly property point p0: "100,220"
    property point p1: "0,0"
    property point p2: "0,0"
    property point p3: "0,0"
    property point p4: "0,0"
    property point p5: "0,0"
    property string c1: "yellow" //обычный
    property string c2: "red"   // выбранный
    property string c3: "transparent" //каркас
    property string c4: "lightgray" //каркас выбранный
    readonly property real r: 5; //радиус точек
    readonly property real d: 3; //зазоры
    property int select: 14
    property int position:0
    property bool pos_rask: false
    property bool pos_home: false
    property alias a6up: a6up.value
    property alias a6down: a6down.value
    property alias a7up: a7up.value
    property alias a7down: a7down.value
    property alias a2up: a2up.value // эажим схвата
    property alias a2down: a2down.value
    property alias a5up: a5up.value
    property alias a5down: a5down.value
    property alias a3left: a3left.value //поворот всего манипулятора
    property alias a3right: a3right.value

    property alias a4left: a4left.value
    property alias a4right: a4right.value
    property alias a1left: a1left.value  //поворот Схвата
    property alias a1right: a1right.value
    property color a1color:"blue"
    property color a2color:"blue"
    property color a3color:"blue"
    property color a4color:"blue"
    property color a5color:"blue"
    property color a6color:"blue"
    property color a7color:"blue"
    property bool brdr: true
//    onA1Changed:   canvas.requestPaint()
//    onA2Changed:   canvas.requestPaint()
//    onA3Changed:   canvas.requestPaint()
//    onA4Changed:   canvas.requestPaint()
//    onA5Changed:   canvas.requestPaint()
//    onL1Changed:   canvas.requestPaint()
//    onL2Changed:   canvas.requestPaint()
//    onL3Changed:   canvas.requestPaint()
//    onL4Changed:   canvas.requestPaint()
//    onL5Changed:   canvas.requestPaint()
//    onSelectChanged: canvas.requestPaint()
    onPositionChanged: {
        pos_rask=position&1
        pos_home=position&2
    }

    Rectangle {
        id: b
        color: "black"
        anchors.fill: parent
        opacity: 0.5
        border.color: brdr?"#FFFF00":"transparent"
        radius:10

    }

    Image {
        id: im
        anchors.centerIn: parent
        width: parent.width
        height: 80
        source: "../skin/mgm7_2.svg"
        ColorOverlay{
                anchors.fill: parent
                source: parent
                color:"yellow"
                antialiasing: true
            }
    }


    GArrow {
        id: a1left
        x: parent.width-100
        linestyle: a1color
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2-140
        positive: false
    }
    GArrow {
        id: a1right
        x: parent.width-60
        linestyle: a1color
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2-140

        positive: true
    }
    GArrow {
        id: a6up
        linestyle: a6color
        anchors.margins: 30
        angle: 180
        height: hand.height*7/90
        width: hand.height*7/90
        x: 225
        y: parent.height/2-70
        positive: true
    }
    GArrow {
        id: a6down
        linestyle: a6color
        anchors.margins: 30
        angle: 0
        height: hand.height*7/90
        width: hand.height*7/90
        x: 225
        y: parent.height/2+30
        positive: false
    }
    GArrow {
        id: a7up
        linestyle: a7color
        anchors.margins: 30
        angle: 180
        height: hand.height*7/90
        width: hand.height*7/90
        x: 100
        y: parent.height/2-70
        positive: true
    }
    GArrow {
        id: a7down
        linestyle: a7color
        anchors.margins: 30
        angle: 0
        height: hand.height*7/90
        width: hand.height*7/90
        x: 100
        y: parent.height/2+30
        positive: false
    }
//    GArrow {
//        id: a7left
//        angle: 90
//        height: hand.height*7/90
//        width: hand.height*7/90
//        y: p0.y+2*height
//        x: p0.x-width-3
//        positive: false
//    }



//    GArrow {
//        id: a7right
//        angle: -90
//        height: hand.height*7/90
//        width: hand.height*7/90
//        y: p0.y+2*height
//        x: p0.x+3
//        positive: true
//    }
    GArrow {
        id: a5up
        linestyle: a5color
        angle: 0
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2+30

        x: parent.width-145
        positive: false
    }
    GArrow {
        id: a5down
        linestyle: a5color
        angle: 180
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2-70
        x: parent.width-145
        positive: true
    }
    GArrow {
        id: a4left
        linestyle: a4color
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2+ 60
        x: parent.width-118
        positive: false
    }
    GArrow {
        id: a4right
        linestyle: a4color
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2+ 60
        x: parent.width-78
        positive: true
    }
    GArrow {
        id: a3right
        linestyle: a3color
        angle: -90
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2-140
        x: 85
        positive: true
    }
    GArrow {
        id: a3left
        linestyle: a3color
        angle: 90
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2-140
        x: 45
        positive: false
    }
    GArrow {
        id: a2up
        linestyle: a2color
        angle: 180
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2-70
        x: parent.width - 50
        positive: true
    }
    GArrow {
        id: a2down
        linestyle: a2color
        angle: 0
        height: hand.height*7/90
        width: hand.height*7/90
        y: parent.height/2 + 30
        x: parent.width - 50
        positive: false
    }
    Text {
        id: gm
        color: "white"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
        anchors.margins: 20
    }
}
