import QtQuick 2.0
import "./figure.js" as Fig
Item {
    id: npa
    property color linestyle: Qt.rgba(1.0, 0.5, 0.5, 0.5)
    property color linestyle2: Qt.rgba(0.8, 0.8, 1.0, 0.8)
    property color fillstyle_red: Qt.rgba(1.0, 0.0, 0.0, 0.5)
    property color fillstyle_green: Qt.rgba(0.0, 1.0, 0.0, 0.5)
    property color fillstyle_yellow: Qt.rgba(1.0, 1.0, 0.0, 0.7)
    property int a1:0
    property int a2:0
    property int radius: 15

    onA1Changed: canvas.requestPaint()
    onA2Changed: canvas.requestPaint()

    Canvas {
        id: canvas
        //anchors.margins: 10
        anchors.fill: parent
        onPaint: {
            var ctx = getContext('2d')
            ctx.save()
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = linestyle2
            ctx.lineWidth = 1
            ctx.fillStyle = fillstyle_yellow
            ctx.translate(width / 2, height / 2)
            ctx.beginPath()
            Fig.text_m(ctx,-width/2+20,0,22,a1, "center", "top", Qt.rgba(1.0, 1.0, 0.0, 0.8))
            Fig.text_m(ctx,0,-width/2+radius,22,a2, "left", "top", Qt.rgba(1.0, 1.0, 0.0, 0.8))
            for (var i=15;i<=90;i+=15){
               var r=Math.sin(i*Math.PI/180)*(width/2-radius)
                Fig.circle(ctx, 0, 0,r,Qt.rgba(0.0, 0.0, 0.0, 0.0))
                if (i===75) continue
                Fig.text_m(ctx,r,0,9,i, "center", "top", Qt.rgba(1.0, 1.0, 0.0, 1.0))
                Fig.text_m(ctx,-r,0,9,i, "center", "bottom", Qt.rgba(1.0, 1.0, 0.0, 1.0))
                }
            var x=Math.sin(a1*Math.PI/180)*(width/2-radius)
            var y=Math.sin(a2*Math.PI/180)*(width/2-radius)
            ctx.beginPath() //внешняя окружность с градиентом
            var grd = ctx.createRadialGradient(0, 0, 0, 0, 0, width/2+radius);
            grd.addColorStop(0, "darkgray");
            grd.addColorStop(1, "transparent");
            ctx.fillStyle=grd
            ctx.strokeStyle = Qt.rgba(1.0, 1.0, 0.0, 0.5)
            ctx.lineWidth = 2
            Fig.circle(ctx, 0, 0,r+radius-1,grd)
            ctx.lineWidth = 1
            ctx.closePath()
            ctx.strokeStyle = linestyle2

            Fig.circle(ctx, x, y,radius,Qt.rgba(1, 0.0, 0.0, 0.5))
            ctx.stroke()
            Fig.circle(ctx, x, y,radius/2,fillstyle_yellow)
            ctx.stroke()
            ctx.strokeStyle = linestyle
            ctx.setLineDash([2, 2]);

            ctx.closePath()
            ctx.beginPath()
            ctx.strokeStyle = Qt.rgba(0.0, 0.0, 0.0, 1.0)
            ctx.moveTo(-width/2,0)
            ctx.lineTo(width/2,0)
            ctx.moveTo(0, -width/2)
            ctx.lineTo(0, width/2,0)
            ctx.stroke()
            ctx.closePath()
            ctx.restore()
        }
    }

}
