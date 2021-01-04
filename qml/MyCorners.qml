import QtQuick 2.15

Item {
    id: my
    property color linecolor: "yellow"
    property color fillcolor: "#000500"
    property int linewidth : 3
    property int  gap: 6
    property int rad: 4
    property bool plus: false
    signal hover(bool hover)
    signal pressed (bool press)
    function drawcorner(ctx, x, y, h, w, a){

        ctx.translate(x, y)
        ctx.rotate(a * Math.PI / 180);
        ctx.moveTo(0, h)
        ctx.lineTo(0, rad)
        ctx.arcTo(0,  0, rad,  0, rad);
        ctx.lineTo(w, 0)

        ctx.stroke();
    }
    MouseArea {
        id: ma
        anchors.fill: parent
        hoverEnabled: true
        onContainsMouseChanged: {
            hover(containsMouse)
            c.requestPaint()
        }
        onPressed: {
            my.pressed(true)
            c.requestPaint()
        }
        onReleased: {
            my.pressed(false)
            c.requestPaint()
        }
    }
    Rectangle {
        anchors.fill: parent
        radius: rad
        color: fillcolor
        opacity: ma.pressed?0.5:0.7
    }

    Canvas {
        id: c
        anchors.fill: parent
        onPaint: {
            var ctx = getContext("2d");
            ctx.save();
            ctx.reset();
            ctx.lineWidth = linewidth//+2*ma.containsMouse
            ctx.strokeStyle = linecolor
            ctx.lineCap = "round"

            var ww=width-linewidth
            var hh=height-linewidth
            var g = gap+gap*ma.containsMouse/3
            var r =
            ctx.moveTo(width/3, height/2)
            ctx.lineTo(2*width/3, height/2)
            if (plus){
                ctx.moveTo(width/2, height/3)
                ctx.lineTo(width/2, 2*height/3)
            }
            ctx.globalAlpha = ma.pressed?0.5:1
            ctx.translate(linewidth/2, linewidth/2)
            drawcorner(ctx, 0, 0, (hh-g)/2, (ww-g)/2, 0)
            drawcorner(ctx, ww, 0, (hh-g)/2, (ww-g)/2, 90)
            drawcorner(ctx, ww, hh, (hh-g)/2, (ww-g)/2, 90+90)
            drawcorner(ctx, 0, hh, (hh-g)/2, (ww-g)/2, 90+90+90)

            ctx.stroke();

            ctx.restore();
        }
    }
}
