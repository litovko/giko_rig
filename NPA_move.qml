import QtQuick 2.0
import "./figure.js" as Fig
Item {
    id: npa
    property color linestyle: Qt.rgba(1.0, 0.5, 0.5, 0.5)
    property color linestyle2: Qt.rgba(0.8, 0.8, 1.0, 0.5)
    property color fillstyle_red: Qt.rgba(1.0, 0.0, 0.0, 0.5)
    property color fillstyle_green: Qt.rgba(0.0, 1.0, 0.0, 0.5)
    property color fillstyle_yellow: Qt.rgba(1.0, 1.0, 0.0, 0.7)
    property int ax1:0 //подрулька
    property int ax2:0 //левый
    property int ax3:0 //правый
    property int ax4:0
    property int ax5:0
    property int delta : 5
    onAx1Changed: canvas.requestPaint()
    onAx2Changed: {canvas.requestPaint(); }
    onAx3Changed: canvas.requestPaint()
    onAx4Changed: canvas.requestPaint()
    onAx5Changed: canvas.requestPaint()
    function func(val){
        if (val>delta) return fillstyle_green
        if (Math.abs(val)<delta) return fillstyle_yellow
        return fillstyle_red
    }

    GArrow {
        id: a1left
        anchors.margins: npa.height*0.5/9
        anchors.right: parent.horizontalCenter
        angle: 90
        height: npa.height*8/90
        width: npa.height*8/90
        y: npa.height*18/90
        positive: false
        value: ax1
    }
    GArrow {
        id: a1right
        state:"GREEN"
        anchors.margins: npa.height*0.5/9
        anchors.left: parent.horizontalCenter
        angle: -90
        height: npa.height*8/90
        width: npa.height*8/90
        y: npa.height*18/90
        positive: true
        value:  ax1
    }
    GArrow {
        id: a5down
        anchors.margins: npa.height*0.2/9
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 0
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*16/90
        positive: false
        value:ax2
    }
    GArrow {
        id: a5up
        anchors.margins: npa.height*19/90
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 180
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*16/90
        positive: true
        value:ax2
    }
    GArrow {
        id: a4down
        anchors.margins: npa.height*0.2/9
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 0
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*66/90
        positive: false
        value: ax3
    }
    GArrow {
        id: a4up
        anchors.margins: npa.height*19/90
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 180
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*66/90
        positive: true
        value: ax3
    }
    GArrow {
        id: a2up
        anchors.margins: npa.height*56/90
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 180
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*80/90
        positive: true
    }
    GArrow {
        id: a2down
        anchors.margins: npa.height*46/90
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 0
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*80/90
        positive: false
    }
    GArrow {
        id: a3up
        anchors.margins: npa.height*36/90
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 180
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*80/90
        positive: true
    }
    GArrow {
        id: a3down
        anchors.margins: npa.height*26/90
        //anchors.left: parent.horizontalCenter
        anchors.bottom: parent.bottom
        angle: 0
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.height*80/90
        positive: false
    }
    Canvas {
        id: canvas
        width: parent.width
        height: parent.height
        onPaint: {

            var ctx = getContext('2d')
            ctx.save()
            ctx.clearRect(0, 0, width, height)
            ctx.strokeStyle = linestyle
            ctx.lineWidth = 2
            ctx.fillStyle = fillstyle_yellow
            ctx.translate(width / 2, height / 2)
            //ctx.rotate(el.angle*Math.PI/180)
            ctx.translate(-width / 2, -height / 2)
            ctx.beginPath() // frame of NPA
            var hc=height*6/9
            var y0=height*1/9
            var h1=hc*25/82
            var h2=hc-h1
            var w1=h1*2
            var x0=(width-w1)/2
            ctx.moveTo(x0,hc+y0)
            ctx.lineTo(x0,h1+y0)
            ctx.lineTo(x0+w1,h1+y0)
            ctx.lineTo(x0+w1,hc+y0)
            ctx.lineTo(x0, hc+y0)
            ctx.moveTo(x0+h1, h1+y0)
            ctx.arc(x0+h1, h1+y0, h1,Math.PI,Math.PI*2)

            ctx.stroke()
            ctx.closePath() // frame of NPA
            ctx.beginPath()
            ctx.strokeStyle = linestyle2
//            Fig.line(ctx,width/2, 0, width/2,height-y0)
            ctx.moveTo(width/2, height*5/90) //vertical line
            ctx.lineTo(width/2,height-y0)
            ctx.stroke()
            ctx.closePath()
            var r=h1/5
            var hl2=height*35/90
            Fig.circle(ctx, width/2,y0*1.3+h1/2,r,func(ax1))
            Fig.circle(ctx, width/2,hl2,r,func(ax4))
            ctx.moveTo(width/2+r,hl2)
            ctx.lineTo(width*85/90,hl2)
            ctx.stroke()
            var hl3=height*55/90
            Fig.circle(ctx, width/2,hl3,r,fillstyle_red)
            ctx.moveTo(width/2+r,hl3)
            ctx.lineTo(width*85/90,hl3)
            ctx.stroke()
            var d=height*25/90
            var th=r*2/3
            Fig.circle(ctx, width/2-d,hc+y0+r*1.5,r,func(ax2))
            Fig.circle(ctx, width/2+d,hc+y0+r*1.5,r,func(ax3))
            Fig.text_m(ctx,width/2,0,th,"НОС", "left", "top", linestyle2)  //text_f(ctx,width/2,height-30,30,Math.round(pitch),"center", "middle",Qt.rgba(0.0, 1.0, 0.0, 0.8))
            Fig.text_m(ctx,width/2,height*80/90,th,"КОРМА", "left", "top", linestyle2)
            Fig.text_m(ctx,height*5/90,height*20/90,th,"ЛЕВЫЙ БОРТ", "left", "top", linestyle2)
            Fig.text_m(ctx,height*85/90,height*20/90,th,"ПРАВЫЙ БОРТ", "right", "top", linestyle2)
            Fig.text_m(ctx,height*72/90,height*30/90,th,"ВВЕРХ", "left", "top", linestyle2)
            Fig.text_m(ctx,height*72/90,height*37/90,th,"ВНИЗ", "left", "top", linestyle2)
            Fig.text_m(ctx,height*72/90,height*50/90,th,"ВВЕРХ", "left", "top", linestyle2)
            Fig.text_m(ctx,height*72/90,height*57/90,th,"ВНИЗ", "left", "top", linestyle2)
            Fig.text_m(ctx,height*75/90,height*68/90,th,"ВПЕРЕД", "left", "top", linestyle2)
            Fig.text_m(ctx,height*75/90,height*80/90,th,"НАЗАД", "left", "top", linestyle2)
            Fig.text_m(ctx,height*5/90,height*68/90,th,"ВПЕРЕД", "left", "top", linestyle2)
            Fig.text_m(ctx,height*5/90,height*80/90,th,"НАЗАД", "left", "top", linestyle2)
            ctx.restore()

        }
    }

}
