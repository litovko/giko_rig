import QtQuick 2.0
import "./figure.js" as Fig
Item {
    id: npa
    property color linestyle: Qt.rgba(1.0, 0.5, 0.5, 0.5)
    property color linestyle2: Qt.rgba(0.8, 0.8, 1.0, 0.8)
    property color fillstyle_red: Qt.rgba(1.0, 0.0, 0.0, 0.5)
    property color fillstyle_green: Qt.rgba(0.0, 1.0, 0.0, 0.5)
    property color fillstyle_yellow: Qt.rgba(1.0, 1.0, 0.0, 0.7)
    property int position:0
    property int cx1:0 // не используется
    property int cx2:0 // поворот камеры в горизонтальной плоскости
    property int cx3:0 // лебедка
    property int cx4:0 // поворот камеры вокруг своей оси Y2
    property int ca: 0 //индикатор угола поворота камеры -135...135 от нуля наверху
    property bool cool: false
    property alias brdr: b.visible

    onCx1Changed: canvas.requestPaint()
    onCx2Changed: canvas.requestPaint()
    onCx3Changed: canvas.requestPaint()
    onCx4Changed: canvas.requestPaint()
    onCaChanged:  canvas.requestPaint()
    onPositionChanged: canvas.requestPaint()

    function func(val){
        if (val>delta) return fillstyle_green
        if (Math.abs(val)<delta) return fillstyle_yellow
        return fillstyle_red
    }

    Rectangle {
        id: b
        color: "transparent"
        anchors.fill: parent
        border.color: "#FFFF00"
        radius:10
    }

    GArrow {
        id: a1left
        anchors.margins: npa.height*0.5/9
        anchors.right: parent.horizontalCenter
        angle: 90
        height: npa.height*8/90
        width: npa.height*8/90
        y: npa.height*7/90
        positive: false
        value: cx4
    }
    GArrow {
        id: a1right
        anchors.margins: npa.height*0.5/9
        anchors.left: parent.horizontalCenter
        angle: -90
        height: npa.height*8/90
        width: npa.height*8/90
        y: npa.height*7/90
        positive: true
        value:  cx4
    }
    GArrow {//поворот камеры в горизонтальной плоскости
        id: a5down
        anchors.margins: npa.height*25/90
        //anchors.left: parent.horizontalCenter
        anchors.top: parent.top
        angle: 180
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.width*57/90
        positive: false
        value:cx2
    }
    GArrow {
        id: a5up
        anchors.margins: npa.height*25/90
        //anchors.left: parent.horizontalCenter
        anchors.top: parent.top
        angle: 180
        height: npa.height*8/90
        width: npa.height*8/90
        x: npa.width*25/90
        positive: true
        value:cx2
    }
//    GArrow { //лебедка
//        id: a4down
//        anchors.margins: npa.height*8/90
//        anchors.bottom: parent.bottom
//        angle: 0
//        height: npa.height*8/90
//        width: npa.height*8/90
//        x: npa.height*11/90
//        positive: false
//        value: cx3
//    }
//    GArrow {
//        id: a4up
//        anchors.margins: npa.height*25/90
//        anchors.bottom: parent.bottom
//        angle: 180
//        height: npa.height*8/90
//        width: npa.height*8/90
//        x: npa.height*11/90
//        positive: true
//        value: cx3
//    }
//    GArrow {
//        id: a3up
//        anchors.margins: npa.height*25/90
//        anchors.bottom: parent.bottom
//        angle: 180
//        height: npa.height*8/90
//        width: npa.height*8/90
//        x: npa.height*65.3/90
//        positive: true
//        state: cool?"RED":"NOP"
//    }

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
            var hc=height*1/2
            var r0=height*1/12
            var vc=hc-2*r0
            var x0=vc-r0/2-r0/4
            var x1=x0-r0*2
            var th=18
            //ctx.moveTo(nc,hc)
            ctx.strokeStyle = Qt.rgba(1.0, 1.0, 1.0, 0.8)
            Fig.circle(ctx, hc,vc,r0*3/2,Qt.rgba(1.0, 1.0, 1.0, 0.01))
            ctx.strokeStyle = Qt.rgba(1.0, 1.0, 0.0, 0.8)
            Fig.circle(ctx, hc,vc,r0/2,Qt.rgba(1.0, 1.0, 1, 0.8))
            ctx.moveTo(hc,vc-r0/2)
            ctx.lineTo(hc,x0)
            ctx.moveTo(hc-r0/2,x0)
            ctx.lineTo(hc+r0/2,x0)
            ctx.lineTo(hc+r0/2,x0-r0*2)
            ctx.lineTo(hc-r0/2,x0-r0*2)
            ctx.lineTo(hc-r0/2,x0)
            ctx.moveTo(hc-r0/3,x1)
            ctx.lineTo(hc-r0/3,x1-r0*2/3)
            ctx.lineTo(hc+r0/3,x1-r0*2/3)
            ctx.lineTo(hc+r0/3,x1)
            ctx.stroke()
            ctx.closePath()
            var r1=vc-r0*40/100
            var r2=vc-r0*20/100
            var r3=vc-r0*30/100
            ctx.beginPath()
            ctx.moveTo(hc-Math.sin(Math.PI/4)*r1,vc+Math.cos(Math.PI/4)*r1)
            ctx.arc(hc, vc, r1,Math.PI*135/180,2.25*Math.PI)
            ctx.moveTo(hc-Math.sin(Math.PI/4)*r2,vc+Math.cos(Math.PI/4)*r2)
            ctx.arc(hc, vc, r2,Math.PI*135/180,2.25*Math.PI)
            var cax=Math.cos(-Math.PI/2+Math.PI*ca/180)*r3
            var cay=Math.sin(-Math.PI/2+Math.PI*ca/180)*r3
            ctx.strokeStyle = Qt.rgba(1.0, 1.0, 1.0, 0.5)
            ctx.stroke()
            ctx.closePath()
            Fig.circle(ctx,hc+cax, vc+cay, r0/5, fillstyle_yellow)
            Fig.text_m(ctx,hc+2*r0/3,x1+r0/2,th,"1", "left", "top", linestyle2)
            Fig.text_m(ctx,hc+3*r0/3,vc,th,"2", "left", "top", linestyle2)

//            //лебедка
//            ctx.beginPath()
//            ctx.lineWidth = 4
//            ctx.strokeStyle = Qt.rgba(0.6, 0.6, 1.0, 0.8)
            var xl1=width/6
            var wl=width/12
            var yl1=height-2*wl
            var hl=height/8
//            ctx.moveTo(xl1-wl/2,yl1)
//            ctx.lineTo(xl1-wl/2,yl1-hl)
//            ctx.moveTo(xl1+wl/2,yl1)
//            ctx.lineTo(xl1+wl/2,yl1-hl)
//            ctx.moveTo(xl1-wl/2,yl1-hl/5)
//            ctx.lineTo(xl1+wl/2,yl1-hl/5)
//            ctx.moveTo(xl1-wl/2,yl1-hl*4/5)
//            ctx.lineTo(xl1+wl/2,yl1-hl*4/5)
//            ctx.moveTo(xl1+wl/2,yl1-hl/2)
//            ctx.lineTo(xl1+wl/2+wl/4,yl1-hl/2)
//            ctx.stroke()
//            ctx.closePath()
//            Fig.circle(ctx,xl1+wl+wl/4, yl1-hl/2, wl/2, Qt.rgba(0.6, 0.6, 1.0, 0.0))
//            Fig.arrow(ctx,xl1+wl+wl/4,yl1-hl*4/6,wl/4, 0,  Qt.rgba(0.6, 0.6, 1.0, 0.8))
//            Fig.arrow(ctx,xl1+wl+wl/4,yl1-hl*2/6,wl/4, 180, Qt.rgba(0.6, 0.6, 1.0, 0.8))
//            Fig.text_m(ctx,xl1+2*wl,yl1,th,"3", "left", "top", linestyle2)
//            Fig.circle(ctx,xl1+wl+wl/4, yl1-hl*3/2, wl/4, position&4?fillstyle_red:Qt.rgba(1.0, 1.0, 1.0, 0.1))
//            Fig.circle(ctx,xl1+wl+wl/4, yl1+hl/2, wl/4, position&8?fillstyle_red:Qt.rgba(1.0, 1.0, 1.0, 0.1))
            xl1=width*4/6

//            Fig.circle(ctx,xl1+wl+wl/4, yl1-hl/2, wl/2, Qt.rgba(0.6, 0.6, 1.0, 0.0))
//            Fig.circle(ctx,xl1, yl1-hl/2, wl/2, Qt.rgba(0.6, 0.6, 1.0, 0.0))
//            Fig.arrow(ctx,xl1+wl+wl/4,yl1-hl*4/6,wl/4, 0,  Qt.rgba(0.6, 0.6, 1.0, 0.8))
//            Fig.arrow(ctx,xl1+wl+wl/4,yl1-hl*2/6,wl/4, 180, Qt.rgba(0.6, 0.6, 1.0, 0.8))
//            Fig.arrow(ctx,xl1,yl1-hl*4/6,wl/4, 0,  Qt.rgba(0.6, 0.6, 1.0, 0.8))
//            ctx.beginPath()
//            ctx.moveTo(xl1+wl/2,yl1-hl/2)
//            ctx.lineTo(xl1+wl/2+wl/4,yl1-hl/2)
//            ctx.stroke()
//            ctx.closePath()
//            ctx.beginPath()
//            ctx.strokeStyle = fillstyle_red
//            var yy=yl1-hl/2-wl/2
//            ctx.moveTo(xl1,yy)
//            for (var i=0; i<4; i++) {
//              yy=yy-wl/2*7/10
//              ctx.lineTo(xl1-wl/2,yy)
//              ctx.lineTo(xl1+wl/2,yy)
//            }
//            ctx.stroke()
//            ctx.closePath()
            ctx.restore()

        }
    }

}
