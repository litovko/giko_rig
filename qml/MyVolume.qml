import QtQuick 2.15

Item {
    id: my
    property int vol: 0
    property color fillcolor: "yellow"
    property color linecolor: "black"
    property int linewidth : 1
    property int rad: 5
    property bool lines : true

    onVolChanged: {
        c.requestPaint()
//        print (vol)
    }
    MouseArea {
        id: mm
        onPressedChanged: c.requestPaint()
        anchors.fill: parent
        onReleased: {
            print(mouseX)
            vol=1000*mouseX/(mm.width)
            rect.x=vol*(mm.width-rect.width)/1000
        }
    }
//    Rectangle {
//        color: "gray"
//        anchors.fill: parent
//    }

    Rectangle {
        id: rect
        y: width/2
        height: my.height-width
        width: 10
        border.color: linecolor
        border.width: linewidth
        opacity: ma.pressed?0.8:1
        radius: rad
        gradient: Gradient {
            GradientStop {
                position: -0.20;
                color: linecolor;
            }
            GradientStop {
                position: 1.00;
                color: fillcolor;
            }
        }
        color: fillcolor
        z: 2
        Component.onCompleted: x=vol*(my.width-rect.width)/1000
        MouseArea {
            id: ma
            onPressedChanged: c.requestPaint()
            anchors.fill: parent
            hoverEnabled: true
            drag.target: rect
            drag.axis: Drag.XAxis
            drag.maximumX: my.width-rect.width
            drag.minimumX: 0
            onReleased: vol=1000*rect.x/(my.width-rect.width)
            onClicked: {
                vol=1000*x/(my.width-rect.width)
                if (vol<0) vol=0
                rect.x=vol*(my.width-rect.width)/1000

            }
        }
    }

    Canvas {
        id: c
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            var med = c.height/2
            var mp = med*2/3
            //            var my = med*2/3
            ctx.save();
            ctx.reset();
            var grd = ctx.createLinearGradient(0, 0, 0, 50);
            grd.addColorStop(0.8, fillcolor);
            grd.addColorStop(0, linecolor);
            ctx.fillStyle = grd //fillcolor
            ctx.globalAlpha = ma.pressed?0.8:1
            ctx.lineWidth = linewidth
            ctx.strokeStyle = fillcolor

            ctx.moveTo(0, med+rad)
            ctx.beginPath()
            ctx.lineTo(0, med+rad)
            ctx.arcTo(0,  med, rad,  med,rad);
            ctx.lineTo(c.width-rad, med-mp)
            ctx.arcTo(c.width, med-mp, c.width, med-mp+rad,rad);
            ctx.lineTo(c.width, med+mp-rad)
            ctx.arcTo(c.width,  med+mp, c.width-rad,  med+mp,rad);
            ctx.lineTo(rad, med + mp)
            ctx.arcTo(0,  med+mp, 0,  med+mp-rad,rad);
            ctx.closePath();
            ctx.fill();
            ctx.stroke();
            if(lines) {
                ctx.moveTo(0, c.height)
                ctx.lineTo(c.width,c.height)
                ctx.strokeStyle = fillcolor
                ctx.moveTo(0, 0)
                ctx.lineTo(c.width,0)
                ctx.stroke();
            }
            ctx.restore();
        }
    }
}
